import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_encryption/constants/constants.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/controllers/files/files.dart';
import 'package:video_encryption/controllers/tray_controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class RunCommand extends GetxController {
  SettingsStorage storage = SettingsStorage();
  FilePath c = Get.put(FilePath());
  final TrayController controller = Get.put(TrayController());
  RxDouble progress = 0.0.obs;
  bool isCompressing = false; // Flag to track compression state
  Process? currentProcess; // Reference to the current compression process

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      getfilesList();
    });
  }

  void cancelCompression() {
    if (currentProcess != null) {
      currentProcess!.kill(); // Kill the current process
      isCompressing = false; // Reset the flag
      progress.value = 0.0; // Reset progress
      controller.stopIconFlashing(); // Stop the tray icon flashing
      MyNotification.showNotification('Compression cancelled', isError: true);
    }
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

  void getfilesList() async {
    final originalDirectory = Directory(c.originalFolderPath.value);
    final completedDirectory = Directory(c.completedFolderPath.value);
    final videoExtensions = ['.mp4', '.mkv', '.flv'];

    if (!originalDirectory.existsSync() || !completedDirectory.existsSync()) {
      return;
    }

    // Get the current list of video files in the original folder
    List<File> currentFiles = originalDirectory
        .listSync()
        .where((item) =>
            item is File &&
            videoExtensions.contains(extension(item.path).toLowerCase()))
        .cast<File>()
        .toList();

    // Maintain a list of previously seen files
    List<File> previousFiles = List<File>.from(c.originalFiles);

    // Update the originalFiles list
    c.originalFiles.value = currentFiles;

    // Process only new files
    for (var fileVideo in currentFiles) {
      if (!previousFiles.contains(fileVideo)) {
        addNewVideo(fileVideo.path);
      }
    }

    // Start compressing if not already compressing and there are videos to compress
    if (!c.isCanceled.value && c.tobecompressedvideospath.isNotEmpty) {
      startCompressing();
    }
  }

  void addNewVideo(String videoPath) async {
    final fileVideo = File(videoPath);
    final completedDirectory = Directory(c.completedFolderPath.value);

    if (!fileVideo.existsSync()) {
      return;
    }

    // Check if the file already exists in the completed directory
    final specificPathFile =
        File(join(completedDirectory.path, basename(fileVideo.path)));
    if (specificPathFile.existsSync() ||
        c.tobecompressedvideospath
            .any((element) => element['path'] == fileVideo.path)) {
      return;
    }

    // Get the file size in bytes
    final fileSizeInBytes = fileVideo.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    // Skip files with size 0 MB or greater than 5 GB (5120 MB)
    if (fileSizeInMB == 0 || fileSizeInMB > 5120) {
      return;
    }

    var listVideoDuration = await _getVideoDuration(fileVideo.path) / 60.0;

    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    storage.appendFileInfo(
        c.infoFilePath,
        basename(fileVideo.path),
        fileVideo.path,
        fileSizeInMB.toStringAsFixed(1),
        listVideoDuration.toStringAsFixed(2),
        c.completedFolderPath.value,
        c.compressedFolderPath.value,
        "false",
        now.toString());

    // Store the video details
    final videoDetails = {
      'type': extension(fileVideo.path).replaceFirst('.', ''),
      'name': basename(fileVideo.path),
      'path': fileVideo.path,
      'sizeMB': fileSizeInMB.toStringAsFixed(1),
      'duration': listVideoDuration.toStringAsFixed(2),
    };

    c.tobecompressedvideospath.add(videoDetails);
  }

  Future<File> get _localFolderFile async {
    final path = await _localPath;
    return File('$path/video_names.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void startCompressing() async {
    if (isCompressing) return; // Prevent re-entrance if already compressing

    isCompressing = true;

    List<String> videosToCompress = c.tobecompressedvideospath
        .map((video) => video["path"].toString())
        .toList();

    final compressedFolderPath = Directory(c.compressedFolderPath.value);

    for (var video in videosToCompress) {
      video = video.replaceAll(r'\', r'/');
      final file = File(video);
      final compressedFilePath =
          File(join(compressedFolderPath.path, basename(video)));

      if (await compressedFilePath.exists()) {
        continue;
      }

      bool isWriting = await _isFileStillBeingWritten(file);
      if (!isWriting) {
        c.currentCompressingVide.value = video.replaceAll(r'\', r'/');

        bool success = await compressVideo(
            video, c.compressedFolderPath.value, c.fps.value, c.bit.value);

        if (success) {
          MyNotification.showNotification('Compression succeeded for $video');
          storage.updateVideoStatus(
              c.infoFilePath, c.currentCompressingVide.value, 'true');
          c.tobecompressedvideospath.remove(video);
          c.allcompressedvideospath.add(video.replaceAll(r'\', r'/'));
        } else {
          MyNotification.showNotification('Compression failed for $video',
              isError: true);
        }
      }
    }

    isCompressing = false; // Reset the flag when done
  }

  Future<bool> compressVideo(String originalFilePath, String compressedFilePath,
      String fps, String bit) async {
    try {
      String ffmpegPath = 'assets/ffmpeg/ffmpeg.exe';
      var totalVideoDuration = await _getVideoDuration(originalFilePath);

      final outputFilePath =
          join(compressedFilePath, basename(originalFilePath));

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
      currentProcess = process; // Store the process reference
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
        await moveFile(originalFilePath, c.completedFolderPath.value);
        return true; // Indicate success
      } else {
        return false; // Indicate failure
      }
    } catch (e) {
      MyNotification.showNotification('Failed to execute command: $e',
          isError: true);
      progress.value = 0.0; // Reset progress value
      return false; // Indicate failure
    } finally {
      controller.stopIconFlashing();
      currentProcess = null; // Clear the process reference
    }
  }

  Future<int> _getVideoDuration(String filePath) async {
    String ffmpegPath = 'assets/ffmpeg/ffmpeg.exe';

    int totalVideoDuration = 1;
    final result =
        await Process.run(ffmpegPath, ['-i', filePath, '-hide_banner']);
    RegExp regExp = RegExp(r"Duration: (\d+):(\d+):([\d\.]+)");
    Match? match = regExp.firstMatch(result.stderr);
    if (match != null) {
      int hours = int.parse(match.group(1)!);
      int minutes = int.parse(match.group(2)!);
      double seconds = double.parse(match.group(3)!);
      totalVideoDuration = hours * 3600 + minutes * 60 + seconds.toInt();
    }
    return totalVideoDuration;
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

  Future<String> getVideoThumbnail(String videoPath) async {
    final directory = await getTemporaryDirectory();

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          150, // specify the height of the thumbnail, keep the aspect ratio
      quality: 75, // specify the quality of the thumbnail
    );

    return thumbnailPath!;
  }
}
