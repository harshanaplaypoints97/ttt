//
//  ViewController.swift
//  Yolov8-RealTime-iOS
//
//  Created by 間嶋大輔 on 2023/05/29.
//

import UIKit
import AVFoundation
import Vision

class MoneyDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate,AVSpeechSynthesizerDelegate {
    
    var captureSession = AVCaptureSession()
    var previewView = UIImageView()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var videoOutput:AVCaptureVideoDataOutput!
    var frameCounter = 0
    var frameInterval = 1
    var videoSize = CGSize.zero
    let colors:[UIColor] = {
        var colorSet:[UIColor] = []
        for _ in 0...80 {
            let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
            colorSet.append(color)
        }
        return colorSet
    }()
    let ciContext = CIContext()
    var classes:[String] = []
    let speechSynthesizer = AVSpeechSynthesizer()
    var isBusy = false;
    let swiftScreenChannel: FlutterMethodChannel = {
            let controller = UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController
            return FlutterMethodChannel(name: "com.example.flutter_app/swift_screen", binaryMessenger: controller.binaryMessenger)
        }()
    
    lazy var yoloRequest:VNCoreMLRequest! = {
        do {
            let model = try best10Aug().model
            guard let classes = model.modelDescription.classLabels as? [String] else {
                fatalError()
            }
            self.classes = classes
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            return request
        } catch let error {
            fatalError("mlmodel error.")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynthesizer.delegate = self;
        checkCameraAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(screenDidTurnOff), name: UIScreen.didDisconnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenDidTurnOn), name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidLock), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidUnlock), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    @objc func screenDidTurnOff() {
        print("Screen turned off")
        dismiss(animated: true, completion: nil)
        swiftScreenChannel.invokeMethod("closed", arguments: nil)
    }
    
    @objc func screenDidTurnOn() {
        print("Screen turned on")

    }
    
    @objc func deviceDidLock() {
        print("Device locked")
        dismiss(animated: true, completion: nil)
        swiftScreenChannel.invokeMethod("closed", arguments: nil)
    }
    
    @objc func deviceDidUnlock() {
        print("Device unlocked")
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // User has authorized camera access
            setupVideo()
        case .notDetermined: // User hasn't decided yet, request access
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                  
                    DispatchQueue.main.async {
                        self.setupVideo()
                        self.toggleFlashLight(on: true) // Turn on flashlight
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setupVideoer()
                        self.toggleFlashLight(on: false)
                    }
                }
            }
        case .denied, .restricted: // User has denied or restricted camera access
            setupVideoer()
            self.toggleFlashLight(on: false);
            
            
            
        @unknown default:
            fatalError("Unknown camera authorization status")
        }
    }
    func checkCameraforflash() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // User has authorized camera access
            
            self.toggleFlashLight(on: true)
        case .notDetermined: // User hasn't decided yet, request access
            self.toggleFlashLight(on: false)
            //
        case .denied, .restricted: // User has denied or restricted camera access
            
            self.toggleFlashLight(on: false);
        @unknown default:
            fatalError("Unknown camera authorization status")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIAccessibility.isVoiceOverRunning{} else {speech("Money Detector, Please position the bank notes infront of the camera")}
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
        checkCameraforflash()
    }
    override func viewDidDisappear(_ animated: Bool) {
        swiftScreenChannel.invokeMethod("closed", arguments: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        captureSession.stopRunning()
        dismiss(animated: true, completion: nil)
        toggleFlashLight(on: false);
    }
    
    @objc private func closeButtonTapped() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        captureSession.stopRunning()
        dismiss(animated: true, completion: nil)
        swiftScreenChannel.invokeMethod("closed", arguments: nil)
    }
    func toggleFlashLight(on:Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            if(on) {device.torchMode = AVCaptureDevice.TorchMode.on} else{device.torchMode = AVCaptureDevice.TorchMode.off}
            device.unlockForConfiguration()
        } catch {
            print("Error: Failed to toggle flash light")
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isBusy=false;
    }
    
    func speech(_ text: String) {
        let speechUtterance = AVSpeechUtterance(string:text )
        speechUtterance.rate = 0.57
        speechUtterance.pitchMultiplier = 0.8
        speechUtterance.postUtteranceDelay = 0.2
        speechUtterance.volume = 0.8
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set the desired language
        speechSynthesizer.speak(speechUtterance)
    }
    
    
    func setupVideoer(){
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = .black
        view.addSubview(backgroundView)
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.accessibilityLabel="back button"
        backButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        view.addSubview(navigationBar)
        navigationBar.barTintColor=UIColor.red /*init(displayP3Red: 255, green: 237, blue: 28, alpha: 36)*/
        let navigationItem = UINavigationItem(title: "Money Detector")
        navigationItem.accessibilityLabel = "Money Detector. To Continue, Camera Access Required"
        navigationBar.setItems([navigationItem], animated: true)
        navigationItem.rightBarButtonItem = backButton
        let centeredLabel = UILabel()
        centeredLabel.textColor = .white
        centeredLabel.isAccessibilityElement = false
        centeredLabel.text = "Camera Access Required"
        centeredLabel.textAlignment = .center
        centeredLabel.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.width)
        backgroundView.addSubview(centeredLabel)
    }
    
    func setupVideo(){
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = .black
        view.addSubview(backgroundView)
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.accessibilityLabel="back button"
        backButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        view.addSubview(navigationBar)
        navigationBar.barTintColor=UIColor.red /*init(displayP3Red: 255, green: 237, blue: 28, alpha: 36)*/
        let navigationItem = UINavigationItem(title: "Money Detector")
        navigationItem.accessibilityLabel = "Money Detector, Please position the bank notes infront of the camera"
        navigationBar.setItems([navigationItem], animated: true)
        navigationItem.rightBarButtonItem = backButton
        
        previewView.frame = CGRect(x: 0, y: navigationBar.frame.height, width:view.bounds.width, height:view.bounds.height - navigationBar.frame.height)
        view.addSubview(previewView)
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        let device=AVCaptureDevice.default(for: AVMediaType.video);
        
        
        let deviceInput = try! AVCaptureDeviceInput(device: device!)
        captureSession.addInput(deviceInput)
        videoOutput = AVCaptureVideoDataOutput()
        
        let queue = DispatchQueue(label: "VideoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        if let videoConnection = videoOutput.connection(with: .video) {
            if videoConnection.isVideoOrientationSupported {
                videoConnection.videoOrientation = .portrait
            }
        }
        
        captureSession.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func detection(pixelBuffer: CVPixelBuffer) -> UIImage? {
        do {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([yoloRequest])
            guard let results = yoloRequest.results as? [VNRecognizedObjectObservation] else {
                return nil
            }
            var detections:[Detection] = []
            for result in results {
                let flippedBox = CGRect(x: result.boundingBox.minX, y: 1 - result.boundingBox.maxY, width: result.boundingBox.width, height: result.boundingBox.height)
                let box = VNImageRectForNormalizedRect(flippedBox, Int(videoSize.width), Int(videoSize.height))
                
                guard let label = result.labels.first?.identifier as? String,
                      let colorIndex = classes.firstIndex(of: label) else {
                    return nil
                }
                let detection = Detection(box: box, confidence: result.confidence, label: label, color: colors[colorIndex])
                detections.append(detection)
                print(detection.label , detection.confidence)
                if(detection.confidence>=0.9 )
                {
                    if(!isBusy){
                        speech(detection.label!);
                        isBusy=true;}
                }
            }
            
            let drawImage = drawRectsOnImage(detections, pixelBuffer)
            return drawImage
            
        } catch let error {
            print(error)
            return nil
        }
        
    }
    
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        guard let cgContext = CGContext(data: nil,
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(size.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCounter += 1
        if videoSize == CGSize.zero {
            guard let width = sampleBuffer.formatDescription?.dimensions.width,
                  let height = sampleBuffer.formatDescription?.dimensions.height else {
                fatalError()
            }
            videoSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        if frameCounter == frameInterval {
            frameCounter = 0
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            guard let drawImage = detection(pixelBuffer: pixelBuffer) else {
                return
            }
            DispatchQueue.main.async {
                self.previewView.image = drawImage
            }
        }
        
    }
}

struct Detection {
    let box:CGRect
    let confidence:Float
    let label:String?
    let color:UIColor
}



