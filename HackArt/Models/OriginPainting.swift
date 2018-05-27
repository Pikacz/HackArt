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
            painting: Painting(name: nil, image: #imageLiteral(resourceName: "sredniowiecze")),
            title: "Wit",
            author: "Wit",
            tags: [Tag.snieg],
            identifier: "sredniowiecze"
          ),
          OriginPainting(
            painting: Painting(name: "Witkacy", image: #imageLiteral(resourceName: "Bitmap")),
            title: "Kompozycja fantastyczna",
            author: "Witkiewicz, Stanisław Ignacy",
            tags: [Tag.slonko],
            identifier: "witkacy"
          ),
          OriginPainting(
            painting: Painting(name: "Swinka", image: #imageLiteral(resourceName: "radość")),
            title: "Zabawka na kiju \"Świnka\"",
            author: "Kurzątkowski, Jan",
            tags: [Tag.radosc],
            identifier: "swiniak"
          ),
          OriginPainting(
            painting: Painting(name: "przepiorki", image: #imageLiteral(resourceName: "przepiorki")),
            title: "Kuropatwy na śniegu",
            author: "Chełmoński, Józef",
            tags: [Tag.przepiorka],
            identifier: "przepiorki"
          ),
          OriginPainting(
            painting: Painting(name: "Roztrzelanie", image: #imageLiteral(resourceName: "smutek")),
            title: "Roztrzelanie",
            author: "Wróblewski, Andrzej",
            tags: [Tag.smutek],
            identifier: "smutek"
          )
        ]
    }
    
}

