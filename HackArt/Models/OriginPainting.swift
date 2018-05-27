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
    
    let painting: Painting
    let title: String
    let author: String
    let tags: [Tag]
    let identifier: String

    static func create() -> [OriginPainting] {
        return [
          OriginPainting(
            painting: Painting(name: "Witkacy", image: #imageLiteral(resourceName: "Bitmap"), backgroundIamge: #imageLiteral(resourceName: "wit_bg")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.slonko],
            identifier: "witkacy"
          ),
          OriginPainting(
            painting: Painting(name: nil, image: #imageLiteral(resourceName: "sredniowiecze")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.smutek],
            identifier: "sredniowiecze"
          ),
          
          OriginPainting(
            painting: Painting(name: nil, image: #imageLiteral(resourceName: "radość")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.radosc],
            identifier: "swiniak"
          ),
          OriginPainting(
            painting: Painting(name: "przepiorki", image: #imageLiteral(resourceName: "przepiorki")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.przepiorka],
            identifier: "przepiorki"
          ),
          OriginPainting(
            painting: Painting(name: nil, image: #imageLiteral(resourceName: "smutek")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.smutek],
            identifier: "smutek"
          ),
          OriginPainting(
            painting: Painting(name: nil, image: #imageLiteral(resourceName: "spokój")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.spokoj],
            identifier: "spokój"
          ),
        ]
//        return [OriginPainting(image: UIImage(named: "0017.jpg")!, description: "Przepiórki tatatat", tags: [Tag.przepiorka, Tag.spokoj], identifier: "przepiorki")]
    }
    
}


fileprivate let witBackgrounds: [UIImage] = [#imageLiteral(resourceName: "wit_bg")]

