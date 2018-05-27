//
//  PaintingButtons.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

class PaintingButtons: OpacityControl {
    
    private var imageView: UIImageView = {
        let img: UIImageView = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    override func initialize() {
        self.addSubview(imageView)
        self.layer.cornerRadius = CGFloat(2)
        self.backgroundColor = .clear
        addImageViewConstraints()
    }
    
    private func addImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
}
