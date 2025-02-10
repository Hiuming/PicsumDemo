//
//  BaseTableViewCell.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//


import UIKit
class BaseTableViewCell: UITableViewCell {
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        if let name = NSStringFromClass(self).components(separatedBy: ".").last {
            return name
        }
        return String(describing: self)
    }
}
