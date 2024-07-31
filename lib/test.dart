import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class FilePath extends GetxController {
  RxString originalFolderPath = ''.obs;
  RxString compressedFolderPath = ''.obs;
  RxString bit = "".obs;
  RxString fps = "".obs;
  RxBool cloud = false.obs;
  RxBool compress = false.obs;
  RxBool shutdown = false.obs;

  RxList<String> tobecompressedvideospath = <String>[].obs;
  RxString currentCompressingVide = "".obs;
}

class RunCommand extends GetxController {
  final FilePath c = Get.put(FilePath());
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
    // Implement your video compression logic here
    // Update `progress` as needed
  }

  Future<void> _getVideoDuration(String ffmpegPath, String filePath) async {
    // Implement video duration extraction logic
  }

  void _closeDialogIfOpen() {
    if (isDialogOpen) {
      Navigator.of(Get.context!).pop();
      isDialogOpen = false;
    }
  }

  Widget buildVideoList() {
    return Obx(() {
      return ListView.builder(
        itemCount: c.tobecompressedvideospath.length,
        itemBuilder: (context, index) {
          String videoPath = c.tobecompressedvideospath[index];
          bool isCurrentlyCompressing = videoPath == c.currentCompressingVide.value;
          bool isCompressed = !c.tobecompressedvideospath.contains(videoPath);
          Color tileColor = isCompressed ? Colors.green : Colors.white;
          
          return ListTile(
            title: Text(basename(videoPath)),
            subtitle: isCurrentlyCompressing
                ? LinearProgressIndicator(value: progress.value)
                : null,
            tileColor: tileColor,
          );
        },
      );
    });
  }
}

class VideoCompressorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Video Compressor")),
        body: RunCommand().buildVideoList(),
      ),
    );
  }
}


