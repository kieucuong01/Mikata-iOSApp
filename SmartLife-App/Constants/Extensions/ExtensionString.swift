//
//  String+MD5.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/23/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import CommonCrypto

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true

        default: return false
        }
    }

    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension String {
    /**
     Get the MD5 hash of this String
     
     - returns: MD5 hash of this String
     */
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(format: hash as String)
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    var isValidEmail : Bool{
        // MARK: - Check string format
        var isValid : Bool = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: self) == false {
            //Mail is wrong format
            isValid = false
        }
        return isValid
    }

    var isKanjiWhiteSpace: Bool {
        var result: Bool = false
        if self.isEmpty == true { result = true }
        else {
            let regEx = "^[ァ-ヾ]+$"
            let predicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", regEx)
            result = predicate.evaluate(with: self)
        }
        return result
    }

    var isAlphanumericWithWhiteSpace: Bool {
        var result: Bool = false
        if self.isEmpty == true { result = true }
        else {
            let regEx: String = "[a-zA-Z0-9\\s]+"
            let predicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", regEx)
            result = predicate.evaluate(with: self)
        }
        return result
    }

    var isAlphanumeric: Bool {
        var result: Bool = false
        if self.isEmpty == true { result = true }
        else {
            let regEx: String = "[a-zA-Z0-9]+"
            let predicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", regEx)
            result = predicate.evaluate(with: self)
        }
        return result
    }

    var containsEmoji: Bool {
        return self.unicodeScalars.contains { $0.isEmoji }
    }
}
