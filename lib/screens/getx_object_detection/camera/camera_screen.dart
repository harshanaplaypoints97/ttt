import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';
import 'package:third_eye/screens/getx_object_detection/scan_controller.dart';
import 'package:third_eye/widgets/app_bar.dart';

class CameraScreen extends StatefulWidget {
  final bool isBlinded;
  const CameraScreen({Key key, this.isBlinded}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
  void dispose() {
    super.dispose();
  }

  bool focus = false;
  bool focusChangeable = false;
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ScanController>(() => ScanController());
    final Size size = MediaQuery.of(context).size;

    return GetX<ScanController>(builder: (controller) {
      //controller.cameraAccessed.value ? () {} : Navigator.pop(context);

      String lable = "";
      return Scaffold(
        appBar: customAppBar(
            onPressed: () {
              navigator.pop(context);
            },
            focus: focus,
            size: size,
            title: "Object Detector",
            backBtnSpeakText: controller.isBlinded.value
                ? "Back To menu"
                : "Scan around to detect Objects. Back Button, double tap to activate"),
        body: Semantics(
          focused: true,
          onDidGainAccessibilityFocus: () async {
            setState(() {
              focus = true;
              focusChangeable = true;
            });
            /*  controller.cameraAccessed.value
                ? SemanticsService.announce(
                    "Object Detector, Scan around to detect Objects",
                    TextDirection.ltr)
                : () {
                    SemanticsService.announce(
                        "camera access Required", TextDirection.ltr);
                  }; */
            if (controller.cameraAccessed.value == true) {
              SemanticsService.announce(
                  "Object Detector, Scan around to detect Objects",
                  TextDirection.ltr);
            } else {
              SemanticsService.announce(
                  "camera access Required", TextDirection.ltr);
            }
            controller.focused.value = true;
          },
          onDidLoseAccessibilityFocus: () {
            controller.focused.value = false;
            controller.tts.stop();
            setState(() {
              focusChangeable = false;
            });
          },
          child: Stack(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.height,
                child: controller.isInitialized
                    ? CameraPreview(controller.cameraController)
                    : const Center(
                        child: ExcludeSemantics(
                          child: Text("Camera Access Required"),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
