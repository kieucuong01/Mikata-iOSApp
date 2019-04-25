//
//  ExtensionNSDate.swift
//  SmartTablet
//
//  Created by thanhlt on 7/17/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//
import UIKit

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 + TimeInterval(9.0 * 3600.0))
    }
}
