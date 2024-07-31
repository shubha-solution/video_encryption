import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:video_encryption/constants/constants.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/controllers/files/files.dart';
import 'package:video_encryption/controllers/tray_controller.dart';

class RunCommand extends GetxController {
  SettingsStorage storage = SettingsStorage();
  FilePath c = Get.put(FilePath());
  final TrayController controller = Get.put(TrayController());

  RxDouble progress = 0.0.obs;
  int totalVideoDuration = 1; // To prevent division by zero
  bool isCompressing = false; // Flag to track compression state

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      getfileslist();
    });
  }

  Future<bool> _isFileStillBeingWritten(File file) async {
    try {
      int initialSize = file.lengthSync();
      await Future.delayed(const Duration(seconds: 3));
      int newSize = file.lengthSync();
      return initialSize != newSize;
    } catch (e) {
      print('Error checking file size: $e');
      return false; // Indicate that the file is not being written to, or handle differently based on your use case
    }
  }

  void getfileslist() {
    final originalDirectory = Directory(c.originalFolderPath.value);
    final completedDirectory = Directory(c.completedFolderPath.value);

    final videoExtensions = ['.mp4', '.mkv', '.flv'];

    if (!originalDirectory.existsSync() || !completedDirectory.existsSync()) {
      return;
    }

    final originalFiles = originalDirectory
        .listSync()
        .where((item) => item is File && videoExtensions.contains(extension(item.path).toLowerCase()))
        .toList();

    for (var file in originalFiles) {
      final specificPathFile = File(join(completedDirectory.path, basename(file.path)));
      if (!specificPathFile.existsSync() && !c.tobecompressedvideospath.contains(file.path)) {
        c.tobecompressedvideospath.add(file.path);
      }
    }

    // Start compressing if not already compressing and there are videos to compress
    if (!isCompressing && c.tobecompressedvideospath.isNotEmpty) {
      startCompressing();
    }
  }

  void startCompressing() async {
    isCompressing = true;
    List<String> videosToCompress = List.from(c.tobecompressedvideospath);

    for (var video in videosToCompress) {
      video = video.replaceAll(r'\', r'/');

      final file = File(video);
      bool isWriting = await _isFileStillBeingWritten(file);
      if (!isWriting) {
        c.currentCompressingVide.value = video;
        print(video);
        bool success = await compressVideo(video, c.compressedFolderPath.value, c.fps.value, c.bit.value);

        if (success) {
          // Remove the file from the original folder after successful compression
          await file.delete();
          c.tobecompressedvideospath.remove(video);
        } else {
          print('Compression failed, consider handling rollback');
        }
      }
    }

    isCompressing = false; // Reset the flag when done
  }

  Future<bool> compressVideo(String originalFilePath, String compressedFilePath, String fps, String bit) async {
    try {
      String ffmpegPath = 'assets/ffmpeg/ffmpeg.exe';
      await _getVideoDuration(ffmpegPath, originalFilePath);

      final outputFilePath = join(compressedFilePath, basename(originalFilePath));
      print("${outputFilePath} Output folder");

      List<String> arguments = [
        '-i',
        originalFilePath,
        '-b:v',
        '${bit}k',
        '-r',
        fps,
        outputFilePath,
      ];
      final process = await Process.start(ffmpegPath, arguments);
      final completer = Completer<void>();

      controller.startIconFlashing();

      process.stderr.transform(utf8.decoder).listen((data) {
        RegExp regExp = RegExp(r"time=(\d+):(\d+):([\d\.]+)");
        Match? match = regExp.firstMatch(data);
        if (match != null) {
          int hours = int.parse(match.group(1)!);
          int minutes = int.parse(match.group(2)!);
          double seconds = double.parse(match.group(3)!);
          int currentTime = hours * 3600 + minutes * 60 + seconds.toInt();
          double percentage = (currentTime / totalVideoDuration);
          progress.value = percentage;
        }
      });

      int exitCode = await process.exitCode;
      progress.value = 0.0; // Reset progress value
      completer.complete();

      if (exitCode == 0) {
        // Move the file after successful compression
        String movedFilePath = await moveFile(outputFilePath, c.completedFolderPath.value);
        if (movedFilePath.isNotEmpty) {
          storage.savevideonamejson("Sample.mp4");
          MyNotification.showNotification('Compression and move succeeded');
          
          return true; // Indicate success
        } else {
          MyNotification.showNotification('Move failed', isError: true);
          return false; // Indicate failure
        }
      } else {
        MyNotification.showNotification('Compression failed', isError: true);
        return false; // Indicate failure
      }
    } catch (e) {
      MyNotification.showNotification('Failed to execute command: $e', isError: true);
      progress.value = 0.0; // Reset progress value
      return false; // Indicate failure
    } finally {
      controller.stopIconFlashing();
    }
  }

  Future<void> _getVideoDuration(String ffmpegPath, String filePath) async {
    final result = await Process.run(ffmpegPath, ['-i', filePath, '-hide_banner']);
    RegExp regExp = RegExp(r"Duration: (\d+):(\d+):([\d\.]+)");
    Match? match = regExp.firstMatch(result.stderr);
    if (match != null) {
      int hours = int.parse(match.group(1)!);
      int minutes = int.parse(match.group(2)!);
      double seconds = double.parse(match.group(3)!);
      totalVideoDuration = hours * 3600 + minutes * 60 + seconds.toInt();
    }
  }

  Future<String> moveFile(String sourcePath, String destinationPath) async {
    String fullDestinationPath = join(destinationPath, basename(sourcePath));
    try {
      final file = File(sourcePath);
      if (await file.exists()) {
        final destinationDirectory = Directory(dirname(fullDestinationPath));
        if (!await destinationDirectory.exists()) {
          await destinationDirectory.create(recursive: true);
        }
        await file.rename(fullDestinationPath);
        print('File moved to $fullDestinationPath');
        return fullDestinationPath;
      } else {
        print('Source file does not exist.');
        return ''; // Indicate failure
      }
    } catch (e) {
      print('Error moving file: $e');
      return ''; // Indicate failure
    }
  }
}
