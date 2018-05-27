//
//  BackgroundView.swift
//  HackArt
//
//  Created by Tomasz Lizer on 27/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

class BackgroundView: BasicView {
    
    let image: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = #imageLiteral(resourceName: "god")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func initialize() {
        self.backgroundColor = UIColor.black
//        self.insertSubview(image, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = self.bounds
    }
    
}
