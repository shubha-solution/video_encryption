import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/colorpage.dart';

class RunCommandTest extends GetxController {
  RxDouble progress = 0.0.obs;
  int totalVideoDuration = 1; // To prevent division by zero
  String originalFolderPath = '';
  String compressedFolderPath = '';
  String bit = "";
  String fps = "";
  bool isCompressing = false; // Flag to track compression state

  @override
  void onInit() {
    super.onInit();
    // Start monitoring the folder
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!isCompressing) {
        print("check new folder calling");
        checkForNewFiles();
      }
    });
  }

  void checkForNewFiles() {
    final originalDirectory = Directory(originalFolderPath);
    final compressedDirectory = Directory(compressedFolderPath);

    final originalFiles =
        originalDirectory.listSync().whereType<File>().toList();
    final compressedFilesList =
        compressedDirectory.listSync().whereType<File>().toList();

    final compressedFileNames =
        compressedFilesList.map((file) => basename(file.path)).toSet();

    for (var file in originalFiles) {
      if (!compressedFileNames.contains(basename(file.path))) {
        isCompressing = true; // Set flag to indicate compression is in progress
        compressVideo(file.path, compressedFolderPath, fps, bit);
        print('CompressVideo calling for ${file.path}');
        break; // Start compressing one file and exit the loop
      }
    }
  }

  void showNotification(String message, {bool isError = false}) {
    showSimpleNotification(
      Text(message),
      background: isError ? Colors.red : ColorPage.darkblue,
    );
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

      process.exitCode.then((code) {
        if (code == 0) {
          showNotification('Compression succeeded');
        } else {
          showNotification('Compression failed', isError: true);
        }
        isCompressing = false; // Reset flag when compression is done
        completer.complete();
      });

      await completer.future;
    } catch (e) {
      showNotification('Failed to execute command: $e', isError: true);
      isCompressing = false; // Reset flag in case of error
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
}
