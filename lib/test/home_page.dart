// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Event Handling Example'),
        ),
        body: const Center(
          child: KeyHandlingWidget(),
        ),
      ),
    );
  }
}

class KeyHandlingWidget extends StatefulWidget {
  const KeyHandlingWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KeyHandlingWidgetState createState() => _KeyHandlingWidgetState();
}

class _KeyHandlingWidgetState extends State<KeyHandlingWidget> {
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
     
      onKey: (FocusNode node, RawKeyEvent event) {
        setState(() {
          if (event is RawKeyDownEvent) {
            _pressedKeys.add(event.logicalKey);
          } else if (event is RawKeyUpEvent) {
            _pressedKeys.remove(event.logicalKey);
          }
        });
        return KeyEventResult.handled;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Press keys to see their states:'),
            ..._pressedKeys.map((key) => Text(key.debugName ?? key.keyLabel)),
          ],
        ),
      ),
    );
  }
}
