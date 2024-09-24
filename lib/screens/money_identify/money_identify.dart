import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class MoneyIdentify extends StatefulWidget {
  final bool isBlinded;
  const MoneyIdentify({
    Key key,
    this.isBlinded,
  }) : super(key: key);

  @override
  State<MoneyIdentify> createState() => _MoneyIdentifyState();
}

class _MoneyIdentifyState extends State<MoneyIdentify> {
  final platform = const MethodChannel('com.example.flutter_app/swift_screen');
  bool focus = false;
  bool focusChangeable = false;
  final levels = [
    '0.1',
    "0.2",
    "0.3",
    "0.4",
    "0.5",
    "0.6",
    "0.65",
    "0.7",
    "0.75",
    "0.8",
    "0.85",
    "0.9",
    "0.95",
    "0.98",
  ];
  @override
  void initState() {
    _openSwiftScreen();
    super.initState();
  }

  Future<void> _openSwiftScreen() async {
    try {
      await platform.invokeMethod('openSwiftScreen');
    } on PlatformException catch (e) {
      print('Failed to open Swift screen: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: NativeCameraView());
  }
}

class NativeCameraView extends StatelessWidget {
  const NativeCameraView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your platform-specific code using MethodChannel or other approaches to integrate the Swift camera view
    // Replace this with your own implementation of the Swift camera view
    return const UiKitView(viewType: 'NativeCameraView');
  }
}
