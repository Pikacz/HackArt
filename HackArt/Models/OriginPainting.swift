//
//  OriginPainting.swift
//  HackArt
//
//  Created by Mateusz Orzoł on 26.05.2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

enum Tag: String {
    
    case przepiorka = "Przepiorka"
    case slonko = "Słonko"
    case snieg = "Śnieg"
    case radosc = "Radość"
    case smutek = "Smutek"
    case spokoj = "Spokój"
}

struct OriginPainting {
    
    let image: UIImage
    let description: String
    let tags: [Tag]
    let identifier: String

    static func create() -> [OriginPainting] {
        return [OriginPainting(image: UIImage(named: "0017.jpg")!, description: "Przepiórki tatatat", tags: [Tag.przepiorka, Tag.spokoj], identifier: "przepiorki")]
    }
    
}

