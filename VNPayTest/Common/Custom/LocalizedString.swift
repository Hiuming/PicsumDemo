//
//  LocalizedString.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import Foundation
internal func LocalizedString(_ key: String, comment: String?) -> String {
    struct Static {
        static let bundle = Bundle(identifier: "tets.app.VNPayTest")!
    }
    return NSLocalizedString(key, bundle: Static.bundle, comment: comment ?? "")
}
