import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';

class SettingsStorage {
  final FilePath _getfilePath = Get.put(FilePath());
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/settings.json');
  }

  Future<Object> readSettings() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      // print('$contents json content');
      var jsondata = jsonDecode(contents);
      _getfilePath.originalFolderPath.value = jsondata["originalFilePath"];
      _getfilePath.compressedFolderPath.value = jsondata["encryptedFilePath"];

      _getfilePath.fps.value = jsondata["fps"];
      _getfilePath.bit.value = jsondata["bit"];
      _getfilePath.cloud.value = jsondata["cloud"];
      _getfilePath.compress.value = jsondata["compress"];
      _getfilePath.shutdown.value = jsondata["shutdown"];

      return 0;
    } catch (e) {
      // If encountering an error, return 0
      return 1;
    }
  }

  Future<File> writeSettings(
    String originalFilePath,
    String encryptedFilePath,
    String fps,
    String bit,
    bool cloud,
    bool compress,
    bool shutdown,
  ) async {
    originalFilePath = originalFilePath.replaceAll(r'\', r'/');
    encryptedFilePath = encryptedFilePath.replaceAll(r'\', r'/');

    final file = await _localFile;

    // Write the file
    return file.writeAsString(
        '{"originalFilePath": "$originalFilePath","encryptedFilePath": "$encryptedFilePath","fps": "$fps","bit": "$bit","cloud":$cloud,"compress":$compress,"shutdown":$shutdown}');
  }
}
