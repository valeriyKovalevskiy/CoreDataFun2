//
//  UIColor+Ext.swift
//  CoreDataFun2
//
//  Created by Valeriy Kovalevskiy on 8/3/20.
//  Copyright © 2020 Valeriy Kovalevskiy. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    class func color(withData data:Data) -> UIColor {
         return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }

    func encode() -> Data {
         return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
