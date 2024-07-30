import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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

    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (c.compress.isTrue && !isCompressing) {
        getfileslist();
        startCompressing();
      }
    });
  }

  Future<bool> _isFileStillBeingWritten(File file) async {
    int initialSize = file.lengthSync();
    await Future.delayed(const Duration(seconds: 3));
    int newSize = file.lengthSync();
    return initialSize != newSize;
  }

  void getfileslist() {
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
        c.tobecompressedvideospath.add(file.path);
      }
    }
  }

void startCompressing() async {
  List<String> videosToCompress = List.from(c.tobecompressedvideospath);

  for (var video in videosToCompress) {
    final file = File(video);
    bool isWriting = await _isFileStillBeingWritten(file);
    if (!isWriting) {
      isCompressing = true;
      c.currentCompressingVide.value = video;
      await compressVideo(file.path, c.compressedFolderPath.value, c.fps.value, c.bit.value);
      isCompressing = false;
      c.tobecompressedvideospath.remove(video); // Safe to modify the original list now

      if (c.tobecompressedvideospath.isEmpty) {
        break; // Exit loop if no more videos are left
      }
    }
  }
}


  Future<void> compressVideo(String originalFilePath, String encryptedFilePath,
      String fps, String bit) async {
    try {
      String ffmpegPath = 'assets/ffmpeg/ffmpeg.exe';
      await _getVideoDuration(ffmpegPath, originalFilePath);

      final outputFilePath = join(encryptedFilePath, basename(originalFilePath));
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

      process.exitCode.then((code) {
        if (code == 0) {
          MyNotification.showNotification('Compression succeeded');
        } else {
          MyNotification.showNotification('Compression failed', isError: true);
        }
        progress.value = 0.0; // Reset progress value
        completer.complete();
      });

      await completer.future;
      controller.stopIconFlashing();
    } catch (e) {
      MyNotification.showNotification('Failed to execute command: $e', isError: true);
      progress.value = 0.0; // Reset progress value
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

  void _closeDialogIfOpen() {
    if (isDialogOpen) {
      Navigator.of(Get.context!).pop();
      isDialogOpen = false;
    }
  }
}
