import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/config.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController with WidgetsBindingObserver {
  final RxBool _isInitialized = RxBool(false);

  RxBool isBlinded = RxBool(false);
  RxBool cameraAccessed = RxBool(true);
  RxBool speaking = RxBool(false);
  RxBool focused = RxBool(false);
  final RxBool _isBusy = RxBool(false);
  FlutterTts tts = FlutterTts();
  CameraController _cameraController;
  List<CameraDescription> _cameras;
  RxString readText = RxString("");
  String model = "assets/models/open600_model.tflite";
  String label = "assets/models/open600_labels.txt";
  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;
  AppLifecycleState _lifecycleState;
  AppLifecycleState get lifecycleState => _lifecycleState;
  RxString confidence = RxString("0.45");
  PermissionStatus cameraStatus;

  bool isVibrationSupported;
  Future<void> isVibratable() async {
    isVibrationSupported = await Vibrate.canVibrate;
  }

  Future<void> _initTFLite() async {
    await Tflite.loadModel(
      model: model,
      labels: label,
      numThreads: 1, // defaults to 1
      isAsset:
          true, // defaults to true, set to false to load resources outside assets
      useGpuDelegate:
          false, // defaults to false, set to true to use GPU delegate
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _lifecycleState = state;
    if (_lifecycleState == AppLifecycleState.resumed) {
      if (_isInitialized.value == true && cameraAccessed.value == true) {
        !isBlinded.value ? tts.speak("Scan around to detect Objects") : () {};
        lifecycleState == AppLifecycleState.resumed
            ? _cameraController.setFlashMode(FlashMode.torch)
            : () {};
        isBlinded.value
            ? _cameraController.startImageStream((image) {
                if (speaking.value) return;
                if (!focused.value) return;
                if (_isBusy.value) return;
                _objectRecognitionBlind(image);
              })
            : _cameraController.startImageStream((image) {
                if (speaking.value) return;
                if (_isBusy.value) return;
                _objectRecognitionNormal(image);
              });
      }
    } else if (_lifecycleState == AppLifecycleState.paused) {
      tts.stop();
      _cameraController.setFlashMode(FlashMode.off);
      print("off");

      _cameraController.stopImageStream();
    }
    update();
  }

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
              // cameraAccessed.value = false;
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

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isBlinded.value = prefs.getBool("blinded");

    /* isBlinded.value == true
        ? () {}
        : cameraAccessed.value
            ? tts.speak("Scan around to detect Objects")
            : () {}; */
  }

  Future<void> _objectRecognitionNormal(CameraImage img) async {
    _isBusy.value = true;
    var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        numResultsPerClass: 1,
        imageMean: 127.5, // defaults to 127.5
        imageStd: 127.5, // defaults to 127.5
        rotation: 90, // defaults to 90, Android only
        threshold: 0.1, // defaults to 0.1
        asynch: true // defaults to true
        );
    if (recognitions != null &&
        recognitions.isNotEmpty &&
        speaking.value == false) {
      print(recognitions[0]['confidenceInClass']);
      double cc = double.parse(confidence.value);
      if (recognitions[0]['confidenceInClass'] >= cc) {
        isVibrationSupported ? Vibrate.feedback(FeedbackType.warning) : () {};
        readText.value = recognitions[0]['detectedClass'].toString();
        await tts.speak(readText.value);

        _isBusy.value = false;
      } else {
        _isBusy.value = false;
      }
    } else {
      _isBusy.value = false;
    }
  }

  Future<void> _objectRecognitionBlind(CameraImage img) async {
    _isBusy.value = true;
    var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        numResultsPerClass: 1,
        imageMean: 127.5, // defaults to 127.5
        imageStd: 127.5, // defaults to 127.5
        rotation: 90, // defaults to 90, Android only
        threshold: 0.1, // defaults to 0.1
        asynch: true // defaults to true
        );
    if (recognitions != null &&
        recognitions.isNotEmpty &&
        speaking.value == false) {
      print(recognitions[0]['confidenceInClass']);
      if (recognitions[0]['confidenceInClass'] >= 0.3) {
        //Vibrate.feedback(FeedbackType.warning);
        readText.value = recognitions[0]['detectedClass'].toString();
        if (focused.value) {
          await tts.speak(readText.value).whenComplete(() => () {
                _isBusy.value = false;
              });
        } else {
          _isBusy.value = false;
        }
        _isBusy.value = false;
      } else {
        _isBusy.value = false;
      }
    } else {
      _isBusy.value = false;
    }
  }

  @override
  void dispose() {
    Tflite.close();
    tts.stop();
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
    tts.setStartHandler(() {
      speaking.value = true;
    });
    tts.setCompletionHandler(() {
      speaking.value = false;
    });
    checkUser();
    _lifecycleState = AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    // checkCameraPermission();
    initCamera();
    _initTFLite();
    super.onInit();
  }
}
