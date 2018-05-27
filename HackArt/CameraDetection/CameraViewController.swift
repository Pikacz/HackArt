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
    private var delay: Timer?
    private var tag: Tag?
    private var finished: Bool = false
    weak var flow: CameraViewControllerFlow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Camera
        self.view.backgroundColor = UIColor.white
        tag = nil
        finished = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view = cameraView
        camera.requestCameraAccess()
        camera.delegate = self
        camera.startCapturing()
        delay = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(starFinding), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera.stopCapturing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        camera.configurePreviewLayer(frame: cameraView.livePreview.bounds)
        cameraView.livePreview.layer.addSublayer(camera.previewLayer)
    }
    
    // MARK: - Helpers
    
    private func found(tag: Tag?) {
        print(tag)
        print(self.tag)
        guard let tag = tag else {
            self.timer?.invalidate()
            timer = nil
            return }
        if let currentTag = self.tag {
            if currentTag == tag {
                return
            } else {
                self.tag = tag
                timer?.invalidate()
                if tag  == .radosc {
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
                } else {
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
                }
            }
        } else {
            self.tag = tag
            timer?.invalidate()
            if tag  == .radosc {
                self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
            }        }
    }
    
    @objc private func timerFinished() {
        finished = true
        timer = nil
        guard let tag = self.tag else { return }
        flow?.didFound(tag: tag)
    }
    
    @objc private func starFinding() {
        finished = false
        delay?.invalidate()
        delay = nil
    }
}

extension CameraViewController: CameraDelegate {
    
    func findFace(in faceFeature: CIFaceFeature?, cleanAperture: CGRect, orientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) {
        guard !finished else { return }
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
            found(tag: tag)
            return }
        print("\(faceFeature.bounds)")
        print("\(faceFeature.hasSmile)")
        
                if faceFeature.leftEyeClosed && faceFeature.rightEyeClosed {
                    tag = Tag.smutek
                    found(tag: tag)
                    print("lew i prawe zakmniete")
                    return
                }
//        if faceFeature.leftEyeClosed {
//            print("lewe oko")
//            tag = Tag.przepiorka
//            found(tag: Tag.przepiorka)
//            return
//        }
//
//        if faceFeature.rightEyeClosed {
//            print("prawe oko")
//            tag = Tag.slonko
//            found(tag: Tag.slonko)
//            return
//        }
        if faceFeature.hasSmile {
            print("usmiech")
            tag = Tag.radosc
            found(tag: tag)
            return
        }
//        } else {
//            print("smutek")
//            tag = Tag.smutek
//            found(tag: tag)
//            return
//        }
    }
    
}
