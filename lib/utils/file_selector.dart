import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

class FileSelector {
  static Future<String?> selectDirectory() async {
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final String? selectedDirectory = await getDirectoryPath();
      return selectedDirectory;
    } else {
      // Directory selection is not supported on this platform
      return null;
    }
  }
}
