//
//  GlobalMethod.swift
//  SmartTablet
//
//  Created by thanhlt on 7/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Repro

class GlobalMethod {
    // MARK: - Constants
    static let mainWindow: UIWindow? = UIApplication.shared.delegate?.window as? UIWindow
    static let screenSize: CGRect = UIScreen.main.bounds
    static let isWideScreen: Bool = GlobalMethod.screenSize.height >= 568.0
    static let displayScale: CGFloat = GlobalMethod.screenSize.width / 320.0

    // Fonts
    static let mainFont: UIFont = UIFont.systemFont(ofSize: 15.0 * GlobalMethod.displayScale)

    // Get top padding
    static func getTopPadding() -> CGFloat {
        var topPadding: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                topPadding = max(appDelegate.window?.safeAreaInsets.top ?? 0.0, 20.0)
            }
        }
        return topPadding
    }

    // Get bottom padding
    static func getBottomPadding() -> CGFloat {
        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                bottomPadding = max(appDelegate.window?.safeAreaInsets.bottom ?? 0.0, 0.0)
            }
        }
        return bottomPadding
    }

    // Get date string from miliseconds
    static func getStringDate(from milisecondsDouble: Double?) -> String? {
        if let miliseconds: Double = milisecondsDouble {
            let seconds: Double = miliseconds / 1000.0
            let date: Date = Date(timeIntervalSince1970: seconds)
            let secondsFromNow: Double = date.timeIntervalSinceNow
            let dateFormatter: DateFormatter = DateFormatter()

            let secondsOneDay: Double = 24.0 * 60 * 60
            // Less than one day
            if abs(secondsFromNow) <= secondsOneDay {
                dateFormatter.dateFormat = NSLocalizedString("Global_Hour_Format", comment: "")
            }
                // Less than two day
            else if abs(secondsFromNow) <= (secondsOneDay * 2.0) {
                return NSLocalizedString("Global_Yesterday_String", comment: "")
            }
                // Less than one week
            else if abs(secondsFromNow) <= (secondsOneDay * 7.0) {
                dateFormatter.dateFormat = NSLocalizedString("Global_Weekday_Format", comment: "")
            }
                // Still in this year
            else if GlobalMethod.isDateOfThisYear(of: date) == true {
                dateFormatter.dateFormat = NSLocalizedString("Global_DayInThisYear_Format", comment: "")
            }
                // Not in this year
            else {
                dateFormatter.dateFormat = NSLocalizedString("Global_DayNotInThisYear_Format", comment: "")
            }

            let dateString: String = dateFormatter.string(from: date)
            return dateString
        }
        else {
            return nil
        }
    }

    //Get date string with format
    static func getStringDateFromTime(time: Double?, with formatDate: String) -> String {
        if let miliseconds: Double = time {
            let seconds: Double = miliseconds / 1000.0
            let date: Date = Date(timeIntervalSince1970: seconds)
            let formatter: DateFormatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = formatDate
            return formatter.string(from: date)
        }
        else { return "-" }
    }

    // Check date in this year
    static func isDateOfThisYear(of date: Date) -> Bool {
        let myCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let yearOfDate: Int = myCalendar.component(Calendar.Component.year, from: date)
        let yearOfToday: Int = myCalendar.component(Calendar.Component.year, from: Date())
        return (yearOfDate == yearOfToday)
    }

    /*
     * Created by: hoangnn
     * Description: Sent event to Repro
     */
    static func sendEventToRepro(screenName: String?, eventName: String?) {
        var event: String = ""

        // Check screen name
        if screenName != nil { event = screenName! }

        // Check event name
        if eventName != nil { event = event + " " + eventName! }

        // Check event
        if event != "" {
            print("Event:", event)
            Repro.track(event, properties: nil)
        }
    }

    /*
     * Created by: hoangnn
     * Description: Show alert full
     */
    static func showAlert(_ alertMessage: String, in viewController: UIViewController? = nil, completion: (() -> Void)? = nil) {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            // Init alert
            let alertController: UIAlertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                completion?()
            }))

            // Show alert
            if viewController != nil { viewController?.present(alertController, animated: true, completion: nil) }
            else { appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil) }
        }
    }

    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func getCurrentTimeStamp(with offset:Int) -> Int {
        let time = Date().timeIntervalSince1970
        print("Time : \(Int(time))")
        
        return Int(time)
        
    }
    
    static func getAttributeString(fromString string:String, withDictionary1 dict1:[NSAttributedStringKey:Any], onRange1 range1:NSRange,
                                                withDictionary2 dict2:[NSAttributedStringKey:Any], onRange2 range2:NSRange) -> NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: string)
        attribute.addAttributes(dict1, range: range1)
        attribute.addAttributes(dict2, range: range2)
        return attribute
    }

    // MARK: - MBProgressHUD

    /*
     * Created by: hoangnn
     * Description: Show MBProgressHUD
     */
    static func showMBProgressHUD(view: UIView?) -> MBProgressHUD? {
        // Check nil
        if view != nil {
            return MBProgressHUD.showAdded(to: view!, animated: true)
        }
        else {
            // Show for window
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                if appDelegate.window != nil {
                    return MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
                }
            }
        }
        return nil
    }

    /*
     * Created by: hoangnn
     * Description: Hide all MBProgressHUD
     */
    static func hideAllMBProgressHUD(view: UIView?) {
        // Check nil
        if view != nil {
            MBProgressHUD.hide(for: view!, animated: true)
        }
        else {
            // Hide for window
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                if appDelegate.window != nil {
                    MBProgressHUD.hide(for: appDelegate.window!, animated: true)
                }
            }
        }
    }

    // Check url
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

}
