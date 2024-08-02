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

  Future<File> get _localFolderFile async {
    final path = await _localPath;
    return File('$path/video_names.json');
  }

void appendFileInfo(
  String fileInfoPath,
  String fileName,
  String originalVideoPath,
  String sizeMB,
  String duration,
  String completedPath,
  String compressedPath,
  String status,
  String compressDate,
) {
  // Map to hold all data structured by date
  Map<String, dynamic> jsonData = {};

  // Create a File object for the info file
  final infoFile = File(fileInfoPath);

  // Read existing file content if it exists
  if (infoFile.existsSync()) {
    String content = infoFile.readAsStringSync();
    if (content.isNotEmpty) {
      // Parse existing JSON data into the jsonData map
      jsonData = jsonDecode(content);
    }
  } else {
    // Create the file and any necessary directories if it doesn't exist
    infoFile.createSync(recursive: true);
  }

  // Ensure the 'videos' list exists in jsonData
  if (!jsonData.containsKey('videos') || jsonData['videos'] is! List) {
    jsonData['videos'] = [];
  }

  // Create a map with the new file information
  final Map<String, dynamic> fileInfo = {
    'Name': fileName,
    'Path': originalVideoPath.replaceAll(r'\', r'/'), // Normalize path separators
    'Size': '$sizeMB MB', // Size as a string with unit
    'Duration': duration,
    'CompletedPath': completedPath,
    'CompressedPath': compressedPath,
    'Status': status,
    'CompressDate': compressDate,
  };

  // Add the video information to the 'videos' list
  jsonData['videos'].add(fileInfo);

  // Convert the updated map to a JSON string
  final String updatedContent = jsonEncode(jsonData);

  // Write the JSON string to the file
  infoFile.writeAsStringSync(updatedContent);
}


void readHistoryVideos(String fileInfoPath) {
  // Create a File object for the info file
  final infoFile = File(fileInfoPath);

  try {
    // Check if the file exists
    if (infoFile.existsSync()) {
      // Read the file content as a string
      String content = infoFile.readAsStringSync();

      // Ensure the content is not empty
      if (content.isNotEmpty) {
        // Parse the JSON content
        Map<String, dynamic> jsonData = jsonDecode(content);

        // Check if the 'videos' key exists and is a list
        if (jsonData.containsKey('videos') && jsonData['videos'] is List) {
          // Extract the list of videos
          _getfilePath.videos.value = List<Map<String, dynamic>>.from(jsonData['videos']);

          // Print the first video name
          if (_getfilePath.videos.isNotEmpty) {
            // print(_getfilePath.videos[0]['Name']);
          } else {
            print('No videos found.');
          }
        } else {
          print('Invalid JSON format: "videos" key not found or is not a list.');
        }
      } else {
        print('File is empty.');
      }
    } else {
      print('File does not exist.');
    }
  } catch (e) {
    print('An error occurred while reading the file: $e');
  }
}



void updateVideoStatus(String fileInfoPath, String videoPath, String newStatus) {
  // Create a File object for the info file
  final infoFile = File(fileInfoPath);
  try {
    // Check if the file exists
    if (infoFile.existsSync()) {
      // Read the file content as a string
      String content = infoFile.readAsStringSync();

      // Ensure the content is not empty
      if (content.isNotEmpty) {
        // Parse the JSON content
        Map<String, dynamic> jsonData = jsonDecode(content);

        // Check if the 'videos' key exists and is a list
        if (jsonData.containsKey('videos') && jsonData['videos'] is List) {
          // Extract the list of videos
          List<Map<String, dynamic>> videos = List<Map<String, dynamic>>.from(jsonData['videos']);

          // Find the video with the matching path
          bool videoFound = false;
          for (var video in videos) {
            if (video['Path'] == videoPath.replaceAll(r'\', r'/')) {
              // Update the status of the matching video
              video['Status'] = newStatus;
              videoFound = true;
              break;
            }
          }

          if (videoFound) {
            // Convert the updated map to a JSON string
            final String updatedContent = jsonEncode(jsonData);

            // Write the JSON string to the file
            infoFile.writeAsStringSync(updatedContent);
            print('Video status updated successfully.');
          } else {
            print('No matching video found.');
          }
        } else {
          print('Invalid JSON format: "videos" key not found or is not a list.');
        }
      } else {
        print('File is empty.');
      }
    } else {
      print('File does not exist.');
    }
  } catch (e) {
    print('An error occurred while updating the video status: $e');
  }
}

}
