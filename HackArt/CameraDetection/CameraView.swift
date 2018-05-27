//
//  CameraView.swift
//  HackArt
//
//  Created by Mateusz Orzoł on 26.05.2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import Foundation
import UIKit

class CameraView: UIView {
    
    public var livePreview: UIView!
    public var photo: UIImage!
    private var photoImageView: UIImageView!
    
    //private var cameraMask: CameraMask!
    //private var infoLabel: BasicLabel!
    
    //private var deviceRotationView: DeviceRotationView!
    
    var isDeviceRotationCorrect = false
    var isFaceCorrect = false
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = self.bounds
        livePreview.frame = self.bounds
    }
    
    func initialize() {
        self.setBounds()
        //self.createDeviceRotationView()
    }
    
    func setBounds() {
        self.createImageView()
        self.createLivePreview()
    }
    
    private func createImageView() {
        let screenFrame =  self.bounds  //UIScreen.main.bounds
        self.photoImageView = UIImageView(frame: screenFrame)
        self.photoImageView.contentMode = .scaleAspectFit
        self.addSubview(self.photoImageView)
    }
    
    private func createLivePreview() {
        let screenFrame = self.bounds  //UIScreen.main.bounds
        self.livePreview = UIView(frame: screenFrame)
        print(livePreview.frame)
        self.addSubview(self.livePreview)
        
        //self.createMask()
    }
    
    //    private func createMask() {
    //        self.cameraMask = CameraMask()
    //        self.cameraMask.frame = UIScreen.main.bounds
    //        self.layer.addSublayer(self.cameraMask)
    //    }
    
    //    private func createInfoLabel() {
    //        self.infoLabel = BasicLabel()
    //        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
    //        self.infoLabel.numberOfLines = 0
    //        self.infoLabel.textAlignment = .center
    //        self.infoLabel.layer.cornerRadius = 6
    //        self.infoLabel.layer.borderColor = ColorProvider.white.cgColor
    //        self.infoLabel.layer.borderWidth = 3
    //        self.infoLabel.layer.backgroundColor =
    //            ColorProvider.white.withAlphaComponent(0.5).cgColor
    //
    //        self.addSubview(self.infoLabel)
    //
    //        let views: [String: UIView] = ["infoLabel": self.infoLabel,
    //                                       "bottomView": self.bottomView]
    //
    //        var constraints: [NSLayoutConstraint] = []
    //
    //        let verticalConstraints = NSLayoutConstraint.constraints(
    //            withVisualFormat: "V:[infoLabel(50)]-[bottomView]",
    //            options: [],
    //            metrics: nil,
    //            views: views)
    //        constraints.append(contentsOf: verticalConstraints)
    //
    //        let horizontalConstraints = NSLayoutConstraint.constraints(
    //            withVisualFormat: "H:|-64-[infoLabel]-64-|",
    //            options: [],
    //            metrics: nil,
    //            views: views)
    //        constraints.append(contentsOf: horizontalConstraints)
    //
    //        NSLayoutConstraint.activate(constraints)
    //    }
    
    //    private func createDeviceRotationView() {
    //        self.deviceRotationView = DeviceRotationView()
    //        self.deviceRotationView.translatesAutoresizingMaskIntoConstraints = false
    //        self.addSubview(self.deviceRotationView)
    //
    //        let views: [String: UIView] = ["deviceRotationView": self.deviceRotationView,
    //                                       "topView": self.topView]
    //
    //        var constraints: [NSLayoutConstraint] = []
    //
    //        let metrics = ["width": 100,
    //                       "height": 90]
    //
    //        let verticalConstraints = NSLayoutConstraint.constraints(
    //            withVisualFormat: "V:[topView]-[deviceRotationView(height)]",
    //            options: [],
    //            metrics: metrics,
    //            views: views)
    //        constraints.append(contentsOf: verticalConstraints)
    //
    //        let horizontalConstraints = NSLayoutConstraint.constraints(
    //            withVisualFormat: "H:[deviceRotationView(width)]-|",
    //            options: [],
    //            metrics: metrics,
    //            views: views)
    //        constraints.append(contentsOf: horizontalConstraints)
    //
    //        NSLayoutConstraint.activate(constraints)
    //    }
    
    // MARK: Actions
    
    public func change(infoText: String, infoColor: UIColor) {
        //        self.infoLabel.text = infoText
        //        self.infoLabel.textColor = infoColor
        //        self.cameraMask.changeMaskColor(infoColor)
    }
    
    public func changeTakePhotoButtonEnabled(_ isEnabled: Bool) {
        self.isFaceCorrect = isEnabled
    }
    
    public func addPhoto(_ photo: UIImage?) {
        self.photo = photo
        self.photoImageView.image = photo
        self.livePreview.isHidden = true
    }
    
    public func removePhoto() {
        self.photo = nil
        self.photoImageView.image = nil
        self.livePreview.isHidden = false
    }
    
}

public enum CameraMode {
    
    case livePreview
    case photoPreview
    
}
