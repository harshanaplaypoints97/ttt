import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/config.dart';

class MoneyScanner extends GetxController with WidgetsBindingObserver {
  final RxBool _isInitialized = RxBool(false);

  RxBool isBlinded = RxBool(false);
  RxBool speaking = RxBool(false);
  RxBool focused = RxBool(false);
  final RxBool _isBusy = RxBool(false);
  FlutterTts tts = FlutterTts();
  CameraController _cameraController;
  List<CameraDescription> _cameras;
  RxString readText = RxString("");
  //String model = "assets/models/best_float32.tflite";
  String model = "assets/models/first_20_round_best_float32.tflite";
  String label = "assets/models/money_lable.txt";
  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;
  AppLifecycleState _lifecycleState;
  AppLifecycleState get lifecycleState => _lifecycleState;
  RxString confidence = RxString("0.98");

  Future<void> _initTFLite() async {
    await Tflite.loadModel(
        model: model,
        labels: label,
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _lifecycleState = state;
    if (_lifecycleState == AppLifecycleState.resumed) {
      if (_isInitialized.value == true) {
        lifecycleState == AppLifecycleState.resumed
            ? _cameraController.setFlashMode(FlashMode.torch)
            : () {};
        isBlinded.value
            ? _cameraController.startImageStream((image) {
                if (!focused.value) return;
                if (_isBusy.value) return;
                _objectRecognitionBlind(image);
              })
            : _cameraController.startImageStream((image) {
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
    _cameraController = CameraController(_cameras[0], cameraQuality);

    await _cameraController.initialize().then((_) {
      _isInitialized.value = true;
      didChangeAppLifecycleState(AppLifecycleState.resumed);
      update();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
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

    isBlinded.value == true
        ? () {}
        : tts.speak("Please position the Banknotes in front of the camera");
  }

  Future<void> _objectRecognitionNormal(CameraImage img) async {
    _isBusy.value = true;
    var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        model: "YOLO",
        numResultsPerClass: 1,
        imageMean: 0, // defaults to 127.5
        imageStd: 255.0, // defaults to 127.5
        threshold: 0.3, // defaults to 0.1
        asynch: true // defaults to true
        );
    if (recognitions != null &&
        recognitions.isNotEmpty &&
        speaking.value == false) {
      (recognitions[0]['confidenceInClass']);
      print(recognitions[0]['confidenceInClass']);
      if (recognitions[0]['confidenceInClass'] >= confidence) {
        Vibrate.feedback(FeedbackType.warning);
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
        model: "YOLO",
        numResultsPerClass: 1,
        imageMean: 0, // defaults to 127.5
        imageStd: 255.0, // defaults to 127.5
        threshold: 0.3, // defaults to 0.1
        asynch: true // defaults to true
        );
    if (recognitions != null && recognitions.isNotEmpty) {
      print(recognitions[0]['confidenceInClass']);
      if (recognitions[0]['confidenceInClass'] >= confidence) {
        //Vibrate.feedback(FeedbackType.warning);
        readText.value = recognitions[0]['detectedClass'].toString();
        focused.value
            ? SemanticsService.announce(readText.value, TextDirection.rtl)
            : () {};

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
    tts.setStartHandler(() {
      speaking.value = true;
    });
    tts.setCompletionHandler(() {
      speaking.value = false;
    });
    checkUser();
    _lifecycleState = AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    _initTFLite();
    super.onInit();
  }
}
