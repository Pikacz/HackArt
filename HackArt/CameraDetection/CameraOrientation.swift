//
//  CameraOrientation.swift
//  HackArt
//
//  Created by Mateusz Orzoł on 26.05.2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import Foundation

public enum CameraOrientation: Int {
    
    /// 0th row is at the top, and 0th column is on the left (THE DEFAULT)
    case PHOTOS_EXIF_0ROW_TOP_0COL_LEFT    = 1
    /// 0th row is at the top, and 0th column is on the right.
    case PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT = 2
    /// 0th row is at the bottom, and 0th column is on the right.
    case PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT = 3
    /// 0th row is at the bottom, and 0th column is on the left.
    case PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT = 4
    /// 0th row is on the left, and 0th column is the top.
    case PHOTOS_EXIF_0ROW_LEFT_0COL_TOP = 5
    /// 0th row is on the right, and 0th column is the top.
    case PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP = 6
    /// 0th row is on the right, and 0th column is the bottom.
    case PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM = 7
    /// 0th row is on the left, and 0th column is the bottom.
    case PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM = 8
    
}
