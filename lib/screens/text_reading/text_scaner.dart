import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';
import 'package:third_eye/screens/text_reading/text_scan_controller.dart';
import 'package:third_eye/widgets/app_bar.dart';

class TextCameraScreen extends StatefulWidget {
  const TextCameraScreen({Key key}) : super(key: key);

  @override
  State<TextCameraScreen> createState() => _TextCameraScreenState();
}

class _TextCameraScreenState extends State<TextCameraScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  bool focus = false;
  bool focused = false;
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<TextScanController>(() => TextScanController());
    final Size size = MediaQuery.of(context).size;
    return GetX<TextScanController>(builder: (controller) {
      return Scaffold(
          appBar: customAppBar(
              onPressed: () {
                navigator.pop(context);
              },
              focus: focus,
              size: size,
              title: "Text Detector",
              backBtnSpeakText: "Back to menu"),
          body: Semantics(
            button: false,
            focused: true,
            /* label: focused
                ? controller.cameraAccessed.value == true
                    ? "Text Detector. Device will vibrate when detected text, Double tap to read."
                    : ""
                : "", */

            /* focused
                ? controller.cameraAccessed.value == false
                    ? ""
                    : "Text Detector. Device will vibrate when detected texts, Double tap to read."
                : "", */
            onDidGainAccessibilityFocus: () {
              controller.isFocused.value = true;
              setState(() {
                focus = true;
                focused = true;
              });
              /*  controller.cameraAccessed.value == true
                  ? SemanticsService.announce(
                      "Text Detector,  tap to read Detected text.",
                      TextDirection.ltr)
                  : () {
                      SemanticsService.announce(
                          "camera access Required", TextDirection.ltr);
                    }; */
              if (controller.cameraAccessed.value == true) {
                SemanticsService.announce(
                    "Text Detector, Double tap to read Detected text.",
                    TextDirection.ltr);
              } else {
                SemanticsService.announce(
                    "camera access Required", TextDirection.ltr);
              }
            },
            onDidLoseAccessibilityFocus: () {
              controller.isFocused.value = false;
              setState(() {
                focused = false;
              });
            },
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: GestureDetector(
                onTap: () {
                  controller.readingText.isEmpty
                      ? controller.readText = "No Text"
                      : controller.readText = controller.readingText;
                  controller.speak();
                },
                child: controller.isInitialized
                    ? CameraPreview(controller.cameraController)
                    : const ExcludeSemantics(
                        child: Center(
                          child: Text(
                            "Camera Access required",
                          ),
                        ),
                      ),
              ),
            ),
          ));
    });
  }
}
