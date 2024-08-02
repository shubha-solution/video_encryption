import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoThumbnailExample extends StatefulWidget {
  @override
  _VideoThumbnailExampleState createState() => _VideoThumbnailExampleState();
}

class _VideoThumbnailExampleState extends State<VideoThumbnailExample> {
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final String videoPath = 'C:\Users\HP\Downloads\videos\output.mp4'; // Replace with your video path
    final Directory tempDir = await getTemporaryDirectory();

    final String? thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 150,
      quality: 75,
    );

    setState(() {
      _thumbnailPath = thumbnailPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Thumbnail Example'),
      ),
      body: Center(
        child: _thumbnailPath != null
            ? Image.file(File(_thumbnailPath!))
            : CircularProgressIndicator(),
      ),
    );
  }
}
