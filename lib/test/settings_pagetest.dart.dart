// import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import 'package:video_encryption/test/progress_controllertest.dart';


// class SettingsPageTest extends StatefulWidget {
//   const SettingsPageTest({super.key});

//   @override
//   State<SettingsPageTest> createState() => _SettingsPageTestState();
// }

// class _SettingsPageTestState extends State<SettingsPageTest> {

// Future<void> printDeviceUniqueIddplus() async {

//   String? deviceUniqueId = await getDeviceUniqueId();
//   print("Device Unique ID: $deviceUniqueId");
// }

// Future<String?> getDeviceUniqueIdplus() async {
//   var deviceInfo = DeviceInfoPlugin();

//   if (Platform.isAndroid) {
//     var androidInfo = await deviceInfo.androidInfo;
//     return androidInfo.id; // Use Android ID as unique ID
//   } else if (Platform.isIOS) {
//     var iosInfo = await deviceInfo.iosInfo;
//     return iosInfo.identifierForVendor; // Use identifierForVendor as unique ID
//   } else if (Platform.isWindows) {
//     var windowsInfo = await deviceInfo.windowsInfo;
//     return windowsInfo.deviceId; // Use deviceId as unique ID
//   } else if (Platform.isMacOS) {
//     var macInfo = await deviceInfo.macOsInfo;
//     return macInfo.systemGUID; // Use systemGUID as unique ID
//   } else if (Platform.isLinux) {
//     var linuxInfo = await deviceInfo.linuxInfo;
//     return linuxInfo.machineId; // Use machineId as unique ID
//   } else {
//     return "Unknown Device";
//   }
// }


// Future<void> printDeviceUniqueId() async {
//   String deviceUniqueId = await getDeviceUniqueId();
//   print("Device Unique ID: $deviceUniqueId with uuid");
// }

// Future<String> getDeviceUniqueId() async {
//   final prefs = await SharedPreferences.getInstance();
//   const key = 'device_unique_id';
//   String? deviceUniqueId = prefs.getString(key);

//   if (deviceUniqueId == null) {
//     var uuid = const Uuid();
//     deviceUniqueId = uuid.v4();
//     await prefs.setString(key, deviceUniqueId);
//   }

//   return deviceUniqueId;
// }



// @override
//   void initState() {
//    printDeviceUniqueIddplus();
//    printDeviceUniqueId();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProgressControllerTest progressController = Get.put(ProgressControllerTest());

//     return Scaffold(
//       appBar: AppBar(title: Text('Settings')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _showMyDialog();
//             // Simulate some process
//             Future.delayed(Duration(seconds: 1), () {
//               progressController.updateProgress(0.5); // Update progress to 50%
//             });
//             Future.delayed(Duration(seconds: 2), () {
//               progressController.updateProgress(1.0); // Update progress to 100%
//             });
//           },
//           child: Text('Show Dialog'),
//         ),
//       ),
//     );
//   }

//   Future<void> _showMyDialog() async {
//     return showDialog<void>(
//       context: Get.context!,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return GetBuilder<ProgressControllerTest>(
//           builder: (controller) {
//             return AlertDialog(
//               title: const Text('Progress'),
//               content: Obx(() {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     LinearProgressIndicator(value: controller.progress.value),
//                     SizedBox(height: 20),
//                     Text('${(controller.progress.value * 100).toStringAsFixed(1)}% completed'),
//                   ],
//                 );
//               }),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('Close'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
