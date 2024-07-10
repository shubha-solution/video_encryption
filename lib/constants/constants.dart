import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:video_encryption/components/colorpage.dart';

class MyNotification {
  static void showNotification(String message, {bool isError = false}) {
    showSimpleNotification(
      Text(message),
      background: isError ? Colors.red : ColorPage.darkblue,
    );
  }
}
  Future<String> getUDID() async {
    String udid = await FlutterUdid.udid;
    return udid;
  }
