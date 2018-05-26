//
//  CameraViewController.swift
//  HackArt
//
//  Created by Mateusz Orzoł on 26.05.2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol CameraViewControllerFlow: class {
    func didFound(tag: Tag)
}

class CameraViewController: UIViewController {
    
    private var camera = Camera()
    private let cameraView: CameraView = CameraView()
    private var timer: Timer?
    private var tag: Tag?
    weak var flow: CameraViewControllerFlow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Camera
        self.view.backgroundColor = UIColor.white
        self.view = cameraView
        camera.requestCameraAccess()
        camera.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.startCapturing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        camera.configurePreviewLayer(frame: cameraView.livePreview.bounds)
        cameraView.livePreview.layer.addSublayer(camera.previewLayer)
    }
    
    // MARK: - Helpers
    
    private func found(tag: Tag?) {
        guard let tag = tag else {
            self.timer?.invalidate()
            timer = nil
            return }
        if let currentTag = self.tag {
            return
        } else {
            self.tag = tag
            timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func timerFinished() {
        timer = nil
        guard let tag = self.tag else { return }
        flow?.didFound(tag: tag)
    }
}

extension CameraViewController: CameraDelegate {
    
    func findFace(in faceFeature: CIFaceFeature?, cleanAperture: CGRect, orientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) {
        var tag: Tag? = nil
        defer {
            found(tag: tag)
        }
        guard let faceFeature = faceFeature else {
            //            if faceAction != .noFace {
            //                DispatchQueue.main.async {
            //                }
            //            }
            tag = nil
            print("nie ma japy");
            return }
        print("\(faceFeature.bounds)")
        print("\(faceFeature.hasSmile)")
        
        if faceFeature.leftEyeClosed && faceFeature.rightEyeClosed {
            tag = Tag.spokoj
            print("lew i prawe zakmniete")
            return
        }
        
        //            if faceFeature.leftEyeClosed {
        //                print("lewe oko")
        //                faceAction = .rightEyeBlink
        //                guard faceControl else { return }
        //                tetrisManager.moveShapeRight()
        //                return
        //            }
        //
        //            if faceFeature.rightEyeClosed {
        //                print("prawe oko")
        //                faceAction = .leftEyeBlink
        //                guard faceControl else { return }
        //                tetrisManager.moveShapeLeft()
        //                return
        //            }
        if faceFeature.hasSmile {
            print("usmiech")
            tag = Tag.radosc
            return
        } else {
            print("smutek")
            tag = Tag.smutek
            return
        }
    }
    
}
