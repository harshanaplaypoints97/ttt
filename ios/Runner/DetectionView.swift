//
//  DetectionView.swift
//  Runner
//
//  Created by M1 512 on 2023-08-21.
//

import UIKit
import AVFoundation
import CoreML
import Vision


class DetectionViewModel: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate,AVSpeechSynthesizerDelegate{
    
    private var captureSession: AVCaptureSession!
      private var previewLayer: AVCaptureVideoPreviewLayer!
      private var detectionRequest: VNCoreMLRequest!
      private var classes: [String] = []
     var isBusy = false;
     let speechSynthesizer = AVSpeechSynthesizer()
    var previewView = UIImageView()
  
    
 
    
    
    func speech(_ text: String) {
        let speechUtterance = AVSpeechUtterance(string:text )
        speechUtterance.rate = 0.57
        speechUtterance.pitchMultiplier = 0.8
        speechUtterance.postUtteranceDelay = 0.2
        speechUtterance.volume = 0.8
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set the desired language
        speechSynthesizer.speak(speechUtterance)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraAuthorization()
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
                      //  self.toggleFlashLight(on: true) // Turn on flashlight
                    }
                } else {
                    DispatchQueue.main.async {
                      //  self.setupVideoer()
                        //self.toggleFlashLight(on: false)
                    }
                }
            }
       // case .denied, .restricted: // User has denied or restricted camera access
           // setupVideoer()
           // self.toggleFlashLight(on: false);
            
            
            
        @unknown default:
            fatalError("Unknown camera authorization status")
        }
    }
    
    func setupVideo(){
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill

            captureSession.startRunning()

            // Load your Core ML model
            do {
                let model = try best10Aug().model
                guard let classes = model.modelDescription.classLabels as? [String] else {
                    fatalError()
                }
                self.classes = classes
                let vnModel = try VNCoreMLModel(for: model)
                detectionRequest = VNCoreMLRequest(model: vnModel) { request, error in
                    guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
                    var detections:[Detections] = []
                    for result in results {
                        // Process detection results
                        // You can access detected objects and their bounding boxes from `result`
                        // Also, you can map the recognized classes to your available classes using `self.classes`
                        
                        guard let label = result.labels.first?.identifier as? String
                              else {
                            return
                        }
                        let detections = Detections( confidence: result.confidence, label: label)
//                        detections.append(detections)
                        print(detections.label , detections.confidence)
                        if(detections.confidence>=0.9 )
                        {
                            if(!self.isBusy){
                                self.speech(detections.label!);
                                self.isBusy=true;}
                        }
                    }
                }
            } catch let error {
                fatalError("Error loading or setting up Core ML model: \(error)")
            }

            // Set up video capture output
            let videoCaptureOutput = AVCaptureVideoDataOutput()
            videoCaptureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(videoCaptureOutput)

        } catch {
            print(error.localizedDescription)
        }
    }

      func startCapture(on view: UIView) {
          previewLayer.frame = view.frame
          view.layer.addSublayer(previewLayer)
      }

      // AVCaptureVideoDataOutputSampleBufferDelegate method
      func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
          guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

          let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
          do {
              try requestHandler.perform([detectionRequest])
          } catch {
              print(error.localizedDescription)
          }
         
      }
}
struct Detections {
    let confidence:Float
    let label:String?
}
