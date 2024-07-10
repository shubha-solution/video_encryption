import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tray Manager Example'),
        ),
        body: const Center(
          child: Text('Right-click the tray icon to see the context menu.'),
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
      case 'show_window':
        windowManager.show();
        break;
      case 'hide_window':
        windowManager.hide();
        break;
      case 'quit':
        windowManager.close();
        break;
    }
  }
}
