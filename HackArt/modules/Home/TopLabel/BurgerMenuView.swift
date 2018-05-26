//
//  BurgerMenuView.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//


import UIKit

fileprivate let profileIconName: String = "BurgerMenu"

class ProfileButtonView: OpacityControl {
    
    private let profileImage: UIImageView = {
        let img: UIImageView = UIImageView(image: UIImage(named: profileIconName))
        img.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return img
    }()
    
    override func initialize() {
        super.initialize()
        setView()
    }
    
    
    private func setView() {
        self.frame = profileImage.bounds
        profileImage.center = self.center
        self.addSubview(profileImage)
        
//        self.backgroundColor = .green
    }
    
}

