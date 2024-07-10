// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:video_encryption/test/video_compressor.dart';

// class FileMonitor extends ChangeNotifier {
//   late String _inputDirectory;
//   late String _outputDirectory;

//   void setInputDirectory(String path) {
//     _inputDirectory = path;
//     notifyListeners();
//   }

//   void setOutputDirectory(String path) {
//     _outputDirectory = path;
//     notifyListeners();
//   }

//   void startMonitoring(int fps, int bitrate) {
//     Directory(_inputDirectory).watch().listen((event) {
//       if (event.type == FileSystemEvent.create && event.isDirectory == false) {
//         final filePath = event.path;
//         compressVideo(filePath, fps, bitrate);
//       }
//     });
//   }

//   void compressVideo(String filePath, int fps, int bitrate) async {
//     final outputFilePath = join(_outputDirectory, basename(filePath));
//     final compressor = VideoCompressor();
//     await compressor.compressVideo(
//       filePath,
//       outputFilePath,
//       fps,
//       bitrate,
//     );
//   }
// }
