import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/controllers/tray_controller.dart';
import 'package:video_encryption/routes/routes.dart';
import 'package:video_encryption/test/main.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
    // Set packageName parameter to support MSIX.
    // packageName: 'dev.leanflutter.examples.launchatstartupexample',
  );

  // await launchAtStartup.enable();
  // await launchAtStartup.disable();

  final FilePath getfilePath = Get.put(FilePath());
  getfilePath.shutdown.value = !await launchAtStartup.isEnabled();

  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(900, 500);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Windows Encryptor 1.0.0";
    win.show();
  });

  TrayManager.instance.setIcon('assets/tray_icon_original.ico');
  TrayManager.instance.setContextMenu(Menu(
    items: [
      MenuItem(key: 'hide_window', label: 'Hide Window'),
      MenuItem(key: 'show_window', label: 'Show Window'),
      MenuItem.separator(),
      MenuItem(key: 'progress', label: 'Progress'),
      MenuItem(key: 'settings', label: 'Settings'),
      MenuItem.separator(),
      MenuItem(key: 'exit', label: 'Exit'),
    ],
  ));

  TrayManager.instance.addListener(MyTrayListener());

  // String osVersion = Platform.operatingSystemVersion;
  // print(osVersion);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetMaterialApp(
        onInit: () {
          Get.put(TrayController());
        },
        getPages: RoutesClass.routes,
        initialRoute: RoutesClass.login,
      // home: VideoListScreen(),

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorPage.darkblue),
          useMaterial3: true,
        ),
      ),
    );
  }
}

class MyTrayListener extends TrayListener {
  @override
  void onTrayIconRightMouseDown() {
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'hide_window':
        windowManager.hide();
        break;
      case 'show_window':
        windowManager.show();
        break;
      case 'progress':
        Get.toNamed(RoutesClass.getprogress());
        break;
      case 'settings':
        Get.toNamed(RoutesClass.getsettings());
        break;
      case 'exit':
        windowManager.close();
        break;
    }
  }
}
