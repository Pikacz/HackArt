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
            title: "Kompozycja fantastyczna",
            author: "Witkiewicz, Stanisław Ignacy",
            tags: [Tag.slonko],
            identifier: "witkacy"
          ),
          OriginPainting(
            painting: Painting(name: "Swinka", image: #imageLiteral(resourceName: "radosc")),
            title: "Zabawka na kiju \"Świnka\"",
            author: "Kurzątkowski, Jan",
            tags: [Tag.radosc],
            identifier: "swiniak"
            ),
          OriginPainting(
            painting: Painting(name: "przepiorki", image: #imageLiteral(resourceName: "przepiorki"), backgroundIamge: randBird()),
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
          ),
          OriginPainting(
            painting: Painting(name: "Sredniowiecze", image: #imageLiteral(resourceName: "sredniowiecze")),
            title: "Duptyk rodzinny Winterfeldów",
            author: "",
            tags: [Tag.smutek],
            identifier: "sredniowiecze"
            )
        ]
    }
}

fileprivate let birdsBgs: [UIImage] = [#imageLiteral(resourceName: "przep_bg1"), #imageLiteral(resourceName: "przep_bg2")]

fileprivate func randBird() -> UIImage {
  let r = arc4random()
  let idx = r % 2
  return birdsBgs[Int(idx)]
}

