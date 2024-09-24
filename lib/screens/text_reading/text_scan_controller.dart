import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/config.dart';

class TextScanController extends GetxController with WidgetsBindingObserver {
  final RxBool _isInitialized = RxBool(false);

  RxBool isBlinded = RxBool(false);
  RxBool talkBackEnabled = RxBool(false);
  RxBool cameraAccessed = RxBool(true);
  RxBool isFocused = RxBool(false);
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.chinese);
  RxBool speaking = RxBool(false);
  final RxBool _isBusy = RxBool(false);
  FlutterTts tts = FlutterTts();
  CameraController _cameraController;
  List<CameraDescription> _cameras;
  String readingText = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2
  String readText = '';
  String language;
  String languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String voice;
  bool isVibrationSupported;
  Future<void> isVibratable() async {
    isVibrationSupported = await Vibrate.canVibrate;
  }

  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  AppLifecycleState _lifecycleState;

  AppLifecycleState get lifecycleState => _lifecycleState;

  int imageCount = 0;
  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController =
        CameraController(_cameras[0], cameraQuality, enableAudio: false);

    await _cameraController.initialize().then((_) {
      _isInitialized.value = true;
      didChangeAppLifecycleState(AppLifecycleState.resumed);
      update();
    }).catchError((Object e) {
      cameraAccessed.value = false;
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            _isInitialized.value = false;
            if (isBlinded.value) {
              SemanticsService.announce(
                  "To Continue, camera Access Required.", TextDirection.rtl);
            } else {
              Get.snackbar("Access Required", "Camera Access required");
            }
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            // Handle access errors here.
            _isInitialized.value = false;
            if (isBlinded.value) {
              SemanticsService.announce(
                  "To Continue, camera Access Required.", TextDirection.rtl);
            } else {
              SemanticsService.announce(
                      "To Continue camera Access Required", TextDirection.rtl)
                  .whenComplete(() {
                cameraAccessed.value = false;
              });
            }
            // openAppSettings();
            break;
          case 'CameraAccessRestricted':
            // Handle access errors here.
            Get.snackbar(
                "Camera Access Required", "Camera access is restricted.");
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    update();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _lifecycleState = state;
    if (_lifecycleState == AppLifecycleState.resumed) {
      if (_isInitialized.value == true && cameraAccessed.value == true) {
        !isBlinded.value
            ? tts.speak("Text Detector,  tap to read Detected text. ")
            : () {};
        lifecycleState == AppLifecycleState.resumed
            ? _cameraController.setFlashMode(FlashMode.torch)
            : () {};
        _cameraController.startImageStream((image) {
          if (_isBusy.value) return;
          if (speaking.value) return;

          isBlinded.value
              ? isFocused.value
                  ? _processCameraImage(image)
                  : () {}
              : _processCameraImage(image);
        });
      }
    } else if (_lifecycleState == AppLifecycleState.paused) {
      tts.stop();
      _cameraController.setFlashMode(FlashMode.off);
      _cameraController.stopImageStream();
    }
    update();
  }

  void speak() {
    tts.stop();
    tts.setVolume(volume);
    if (languageCode != null) {
      tts.setLanguage(languageCode);
    }
    tts.setPitch(pitch);
    tts.speak(readText);
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_isInitialized.value) return;
    if (_isBusy.value) return;
    _isBusy.value = true;

    final recognizedText = await _textRecognizer.processImage(inputImage);
    recognizedText.text.isNotEmpty
        ? isVibrationSupported
            ? Vibrate.feedback(FeedbackType.selection)
            : () {}
        : () {
            _isBusy.value = false;
          };
    Vibrate.feedback(FeedbackType.impact);
    readingText = recognizedText.text;

    _isBusy.value = false;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final imageRotation = InputImageRotationValue.fromRawValue(
        _cameraController.description.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    processImage(inputImage);
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isBlinded.value = prefs.getBool("blinded");
  }

  @override
  void dispose() {
    _isInitialized.value = false;
    super.dispose();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    tts.stop();
    super.onClose();
  }

  @override
  void onInit() {
    isVibratable();
    Semantics(
      excludeSemantics: true,
    );
    checkUser();
    initCamera();
    _lifecycleState = AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);

    super.onInit();
  }
}
