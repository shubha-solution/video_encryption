import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/constants/constants.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/controllers/tray_controller.dart';

class RunCommand extends GetxController {
  FilePath c = Get.put(FilePath());
  final TrayController controller = Get.put(TrayController());

  RxDouble progress = 0.0.obs;
  int totalVideoDuration = 1;  // To prevent division by zero
  bool isCompressing = false; // Flag to track compression state
  bool isDialogOpen = false; // Flag to track if dialog is open

  @override
  void onInit() {
    super.onInit();
    // Start monitoring the folder

    Timer.periodic( const Duration(seconds: 10), (timer) {
      if (c.compress.isTrue) {
        if (!isCompressing) {
          getfileslist();
          checkForNewFiles();
        }
      }
    });
  }

  Future<bool> _isFileStillBeingWritten(File file) async {
    int initialSize = file.lengthSync();
    await Future.delayed(const Duration(seconds: 3));
    int newSize = file.lengthSync();
    return initialSize != newSize;
  }

getfileslist() {
  final originalDirectory = Directory(c.originalFolderPath.value);
    final compressedDirectory = Directory(c.compressedFolderPath.value);

    final originalFiles =
        originalDirectory.listSync().whereType<File>().toList();
    final compressedFilesList =
        compressedDirectory.listSync().whereType<File>().toList();

    final compressedFileNames =
        compressedFilesList.map((file) => basename(file.path)).toSet();

    for (var file in originalFiles) {
      if (!compressedFileNames.contains(basename(file.path))) {
    
    
   
         c.tobecompressedvideospath.add(file.path.toString());
        
        
      }
    }
    
}

  void checkForNewFiles() async {
    print("${c.tobecompressedvideospath} file List");
    final originalDirectory = Directory(c.originalFolderPath.value);
    final compressedDirectory = Directory(c.compressedFolderPath.value);

    final originalFiles =
        originalDirectory.listSync().whereType<File>().toList();
    final compressedFilesList =
        compressedDirectory.listSync().whereType<File>().toList();

    final compressedFileNames =
        compressedFilesList.map((file) => basename(file.path)).toSet();

    for (var file in originalFiles) {
      if (!compressedFileNames.contains(basename(file.path))) {
        bool isWriting = await _isFileStillBeingWritten(file);
        if (!isWriting) {
          isCompressing =
              true; // Set flag to indicate compression is in progress
          compressVideo(file.path, c.compressedFolderPath.value, c.fps.value,
              c.bit.value);
          break; // Start compressing one file and exit the loop
        }
      }
    }
    // _closeDialogIfOpen();
  }

  Future<void> compressVideo(String originalFilePath, String encryptedFilePath,
      String fps, String bit) async {
    try {
      // Full path to the ffmpeg executable
      String ffmpegPath = 'assets/ffmpeg/ffmpeg.exe';

      // Get video duration using FFmpeg
      await _getVideoDuration(ffmpegPath, originalFilePath);

      // The ffmpeg command and its arguments
      final outputFilePath =
          join(encryptedFilePath, basename(originalFilePath));
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

      // Show the progress dialog
      // if (!isDialogOpen) {
      //   _showMyDialog(progress, basename(originalFilePath), originalFilePath);
      // }
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
      },
      );

      process.exitCode.then((code) {
        if (code == 0) {
          MyNotification.showNotification('Compression succeeded');
        } else {
          MyNotification.showNotification('Compression failed', isError: true);
        }
        isCompressing = false; // Reset flag when compression is done
        // _closeDialogIfOpen();
        progress.value = 0.0; // Reset progress value
        completer.complete();
      });

      await completer.future;
      controller.stopIconFlashing();
    } catch (e) {
      MyNotification.showNotification('Failed to execute command: $e',
          isError: true);
      isCompressing = false; // Reset flag in case of error
      // _closeDialogIfOpen();
      progress.value = 0.0; // Reset progress value
    }
  }

  Future<void> _getVideoDuration(String ffmpegPath, String filePath) async {
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
  }

  Future<void> _showMyDialog(
      RxDouble progress, String filename, String filepath) async {
    isDialogOpen = true; // Mark dialog as open
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(filename),
          content: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(20),
                    minHeight: 10,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorPage.darkblue,
                    ),
                    value: progress.value),
                const SizedBox(height: 5),
                Text('${(progress.value * 100).toStringAsFixed(0)} %'),
                const SizedBox(height: 20),
                Text('Path: $filepath'),
              ],
            );
          },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                _close();
              },
            ),
          ],
        );
      },
    );
  }

  void _close() {
    Navigator.of(Get.context!).pop();
    isDialogOpen = false; // Mark dialog as closed
  }

  void _closeDialogIfOpen() {
    if (isDialogOpen) {
      Navigator.of(Get.context!).pop();
      isDialogOpen = false; // Mark dialog as closed
    }
  }
}
