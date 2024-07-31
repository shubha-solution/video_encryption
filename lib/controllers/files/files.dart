import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // For formatting the date
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
      _getfilePath.completedFolderPath.value = jsondata["completedFilePath"];
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
    String completedFilePath,
    String encryptedFilePath,
    String fps,
    String bit,
    bool cloud,
    bool compress,
    bool shutdown,
  ) async {
    originalFilePath = originalFilePath.replaceAll(r'\', r'/');
    completedFilePath = completedFilePath.replaceAll(r'\', r'/');
    encryptedFilePath = encryptedFilePath.replaceAll(r'\', r'/');

    final file = await _localFile;

    // Write the file
    return file.writeAsString(
        '{"originalFilePath": "$originalFilePath","completedFilePath": "$completedFilePath","encryptedFilePath": "$encryptedFilePath","fps": "$fps","bit": "$bit","cloud":$cloud,"compress":$compress,"shutdown":$shutdown}');
  }

  Future<File> get _localfolderFile async {
    final path = await _localPath;
    return File('$path/video_names.json');
  }

  Future<File> savevideonamejson(String videoName) async {
    final file = await _localfolderFile;

    // Get current date in YYYY-MM-DD format
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Read the existing file contents
    String fileContent;
    Map<String, dynamic> jsonData;

    if (await file.exists()) {
      fileContent = await file.readAsString();
      jsonData = json.decode(fileContent) as Map<String, dynamic>;
    } else {
      // If file doesn't exist, initialize an empty map
      jsonData = {};
    }

    // Check if the date already exists in the JSON data
    if (jsonData.containsKey(currentDate)) {
      // Add the videoName to the existing list for this date
      List<dynamic> videoNames = jsonData[currentDate] as List<dynamic>;
      if (!videoNames.contains(videoName)) {
        videoNames.add(videoName);
      }
    } else {
      // Create a new list with the videoName if date doesn't exist
      jsonData[currentDate] = [videoName];
    }

    // Write the updated JSON data back to the file
    return file.writeAsString(json.encode(jsonData));
  }
}
