
//  ImageCached.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.

import Foundation
import UIKit
class ImageCached {
    static let shared = NSCache<NSString, UIImage>()
}
