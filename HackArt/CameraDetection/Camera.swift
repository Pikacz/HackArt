//
//  Camera.swift
//  HackArt
//
//  Created by Mateusz Orzoł on 26.05.2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import AVFoundation
import CoreImage

public protocol CameraDelegate: class {
    
    func findFace(in faceFeature: CIFaceFeature?,
                  cleanAperture: CGRect,
                  orientation: UIDeviceOrientation,
                  cameraPosition: AVCaptureDevice.Position)
    
}

public class Camera: NSObject {
    
    public weak var delegate: CameraDelegate?
    
    public var previewLayer = AVCaptureVideoPreviewLayer()
    fileprivate var faceDetector: CIDetector?
    private lazy var captureSession = AVCaptureSession()
    private lazy var videoDataOutput = AVCaptureVideoDataOutput()
    private var stillImageOutput: AVCapturePhotoOutput?
    fileprivate var currentDevicePosition: AVCaptureDevice.Position = .front
    private var currentDevice: AVCaptureDevice?
    private var lastZoom: CGFloat = 1.0
    private var videoDataOutputQueue: DispatchQueue?
    
    public override init() {
        super.init()
        self.createFaceDetector()
        self.configureLivePreview(forDevicePositon: self.currentDevicePosition)
    }
    
    private func createFaceDetector() {
        self.faceDetector = CIDetector(ofType: CIDetectorTypeFace,
                                       context: nil,
                                       options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
    }
    
    public func requestCameraAccess() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    print("> User allowed (now) access to camera")
                } else {
                    print("> User not allowed (now) access to camera")
                }
            }
        case .authorized:
            print("> User allowed (previously) access to camera")
        case .denied, .restricted:
            print("> User not allowed (previously) access to camera")
        }
    }
    
    public func configurePreviewLayer(frame: CGRect) {
        self.previewLayer.frame = frame
    }
    
    public func switchCamera() {
        self.currentDevicePosition = self.currentDevicePosition == .back ? .front : .back
        self.configureInput(forPosition: self.currentDevicePosition)
    }
    
    public func startCapturing() {
        if !self.captureSession.isRunning {
                    //    self.configureLivePreview(forDevicePositon: self.currentDevicePosition)
            self.createFaceDetector()
            self.captureSession.startRunning()
        }
    }
    
    public func stopCapturing() {
        if self.captureSession.isRunning {
            
            //            if let inputs = self.captureSession.inputs as? [AVCaptureInput] {
            //                for input in inputs {
            //                    self.captureSession.removeInput(input)
            //                }
            //            }
            //            if let outputs = self.captureSession.outputs as? [AVCaptureOutput] {
            //                for output in outputs {
            //                    self.captureSession.removeOutput(output)
            //                }
            //            }
            
            self.captureSession.stopRunning()
            self.faceDetector = nil
        }
    }
    
//    func savePhoto(representation: PhotoRepresentation, completion: @escaping (_ image: UIImage?, _ success: Bool) -> ()) {
//
//        guard let videoConnection = self.stillImageOutput?.connection(with: AVMediaType.video)
//            else {
//                completion(nil, false)
//                return
//        }
//
//        var capturedImage: UIImage?
//
//        self.stillImageOutput?.
//        self.stillImageOutput?.captureStillImageAsynchronously(from: videoConnection) { sampleBuffer, error in
//
//            guard let sampleBuffer = sampleBuffer
//                else {
//                    completion(capturedImage, capturedImage != nil)
//                    return
//            }
//
//            switch representation {
//            case .jpeg: // Not working
//
//                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer) {
//                    let image = UIImage(data: imageData)
//                    capturedImage = image
//                }
//
//            case .png:
//
//                guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//                    else {
//                        completion(capturedImage, capturedImage != nil)
//                        return
//                }
//
//                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//                let context = CIContext(options: nil)
//                let rect = CGRect(x: 0,
//                                  y: 0,
//                                  width: CVPixelBufferGetWidth(pixelBuffer),
//                                  height: CVPixelBufferGetHeight(pixelBuffer))
//                if let imageRef = context.createCGImage(ciImage, from: rect) {
//                    let image = UIImage(cgImage: imageRef,
//                                        scale: 1.0,
//                                        orientation: .right)
//                    capturedImage = image
//                }
//
//            }
//
//            completion(capturedImage, capturedImage != nil)
//
//        }
//
//    }
    
    private func configureLivePreview(forDevicePositon position: AVCaptureDevice.Position) {
        self.configureInput(forPosition: position)
        self.configureOutput()
        self.configurePreviewLayer()
        self.setupAVCapture()
    }
    
    private func configureInput(forPosition position: AVCaptureDevice.Position) {
        self.captureSession.beginConfiguration()
        if let currentInput = self.captureSession.inputs.first as? AVCaptureInput {
            self.captureSession.removeInput(currentInput)
        }
        
        self.currentDevice = self.getDevice(withPosition: position)
        
        do {
            let newInput = try AVCaptureDeviceInput(device: self.currentDevice!)
            if self.captureSession.canAddInput(newInput) {
                self.captureSession.addInput(newInput)
            }
        } catch {
            print("> Error in creating device input")
        }
        
        self.captureSession.commitConfiguration()
    }
    
    func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard self.currentDevicePosition == .back else { return }
        let device = self.currentDevice
        
        var zoomFactor = pinch.scale * self.lastZoom
        
        // If the pinching has ended, update prevZoomFactor.
        // Note that we set the limit at 1, because zoom factor cannot be less than 1 or the setting device.videoZoomFactor will crash
        if pinch.state == .ended {
            self.lastZoom = zoomFactor >= 1 ? zoomFactor : 1
        }
        
        do {
            try device?.lockForConfiguration()
            defer { device?.unlockForConfiguration() }
            
            if let maxZoom = device?.activeFormat.videoMaxZoomFactor {
                print(">>>> zoom \(zoomFactor) /// \(maxZoom)")
                if zoomFactor <= 1.6 {
                    device?.videoZoomFactor = zoomFactor >= 1 ? zoomFactor : 1
                } else {
                    print("Unable to set zoom factor, because max is \(device?.activeFormat.videoMaxZoomFactor)")
                }
            }
        } catch {
            print("Unable to set zoom")
        }
    }
    
    private func getDevice(withPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if let singleDevice = device as? AVCaptureDevice,
                singleDevice.position == position {
                return singleDevice
            }
        }
        return nil
    }
    
    private func configureOutput() {
        self.captureSession.beginConfiguration()
        

        
        self.stillImageOutput = AVCapturePhotoOutput()
        if self.captureSession.canAddOutput(self.stillImageOutput!) {
            self.captureSession.addOutput(self.stillImageOutput!)
        } else {
            print("> Error in taking photo")
        }
        let photoSettings : AVCapturePhotoSettings!
        photoSettings = AVCapturePhotoSettings(rawPixelFormatType: kCVPixelFormatType_14Bayer_RGGB, processedFormat: [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA])
        //        self.stillImageOutput?.photoSettingsForSceneMonitoring = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
//        self.stillImageOutput?.outputSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
//        if self.captureSession.canAddOutput(self.stillImageOutput!) {
//            self.captureSession.addOutput(self.stillImageOutput!)
//        } else {
//            print("> Error in taking photo")
//        }
        for currentOutput in self.captureSession.outputs {
            if let output = currentOutput as? AVCapturePhotoOutput {
                self.captureSession.removeOutput(output)
            }
        }
        self.captureSession.commitConfiguration()
    }
    
    private func configurePreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.connection?.videoOrientation = .portrait
    }
    
    private func setupAVCapture() {
        self.videoDataOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        self.videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        if self.captureSession.canAddOutput(self.videoDataOutput) {
            self.captureSession.addOutput(self.videoDataOutput)
        }
        
        self.videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true
    }
    
    fileprivate func exif(forOrientation orientation: UIDeviceOrientation) -> Int {
        let exifOrientation: Int
        
        switch orientation {
        case .portraitUpsideDown:  // Oriented vertically, home button on the top
            exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM.rawValue
        case .landscapeLeft:  // Oriented horizontally, home button on the right
            if self.currentDevicePosition == .front {
                exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT.rawValue
            } else {
                exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_TOP_0COL_LEFT.rawValue
            }
        case .landscapeRight: // Oriented horizontally, home button on the left
            if self.currentDevicePosition == .front {
                exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_TOP_0COL_LEFT.rawValue
            } else {
                exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT.rawValue
            }
        case .portrait: // Oriented vertically, home button on the bottom
            exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP.rawValue
        default:
            exifOrientation = CameraOrientation.PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP.rawValue
        }
        
        return exifOrientation
    }
    
}

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer,
                              options: attachments as? [String: AnyObject])
        
        let currentDeviceOrientation = UIDevice.current.orientation
        let imageOptions: [String: Any] = [CIDetectorImageOrientation: self.exif(forOrientation: currentDeviceOrientation), CIDetectorSmile: true, CIDetectorEyeBlink: true]
        let features = self.faceDetector?.features(in: ciImage, options: imageOptions)
        
        let fDesc: CMFormatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)!
        let cleanAperture = CMVideoFormatDescriptionGetCleanAperture(fDesc, false)
        
        if let faceFeature = features?.first as? CIFaceFeature {
            DispatchQueue.main.async {
                self.delegate?.findFace(in: faceFeature,
                                        cleanAperture: cleanAperture,
                                        orientation: currentDeviceOrientation,
                                        cameraPosition: self.currentDevicePosition)
            }
        } else {
            self.delegate?.findFace(in: nil,
                                    cleanAperture: cleanAperture,
                                    orientation: currentDeviceOrientation,
                                    cameraPosition: self.currentDevicePosition)
        }
    }

}

public enum PhotoRepresentation {
    
    case jpeg
    case png
    
}

