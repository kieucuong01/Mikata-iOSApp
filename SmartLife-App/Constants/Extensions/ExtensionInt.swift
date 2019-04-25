//
//  ExtensionInt.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/23/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import Foundation

extension Int {
    func convertToStringDecimalFormat() -> String {
        var stringConverted: String = "0"
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber: String = numberFormatter.string(from: NSNumber(value: self)) {
            stringConverted = formattedNumber
        }
        return stringConverted
    }
}
