//
//  BottomButtons.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

class BottomButton: OpacityControl {
   
    private let label: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        lbl.textColor = UIColor.app.white
        return lbl
    }()
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    override func initialize() {
        setView()
        self.addSubview(label)
        
        addLabelConstraints()
    }
    
    private func setView() {
        self.layer.cornerRadius = CGFloat(5)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.app.darkSkyBlue
    }
    
    private func addLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
    }
    
}
