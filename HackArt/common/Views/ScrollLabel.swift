//
//  ScrollLabel.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit


class ScrollLabel: BasicScrollView {
    
    private var layoutedFor: CGRect?
    let label: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        
        return label
    }()
    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            calculateContentSize()
        }
    }

    
    override func initialize() {
        addSubview(label)
    }
    
    
    private func calculateContentSize() {
        label.preferredMaxLayoutWidth = bounds.width
        contentSize = label.intrinsicContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard label.frame != layoutedFor else { return }
        calculateContentSize()
        
        label.frame = CGRect(origin: CGPoint.zero, size: contentSize)
        layoutedFor = label.frame
    }
}

