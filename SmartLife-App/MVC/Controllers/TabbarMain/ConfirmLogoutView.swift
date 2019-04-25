//
//  ConfirmLogoutView.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/28/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Firebase

protocol ConfirmLogoutViewDelegate: class {
    func callLogout()
}

class ConfirmLogoutView: UIView {
    weak var delegate: ConfirmLogoutViewDelegate? = nil
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var foregroundView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT))
        view.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#1A0E02").withAlphaComponent(0.5)
        return view
    }()
    
    var viewContent: UIView = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view = UIView(frame: CGRect(x: 20 * scale , y: 170 * scale, width: 278 * scale, height: 166 * scale))
        view.backgroundColor = .white
        return view
    }()
    
    var buttonDecline: UIBorderButton = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let button = UIBorderButton (frame: CGRect(x: 29 * scale, y: 95 * scale, width: 108 * scale, height: 43 * scale))
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
        button.setTitle(NSLocalizedString("common_button_cancel", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(ConfirmLogoutView.clickedButtonCancel(sender:) ), for: .touchUpInside)
        
        return button
    }()
    
    var buttonAccept: UIColorButton = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let button = UIColorButton (frame: CGRect(x: 142 * scale, y: 95 * scale, width: 108 * scale, height: 43 * scale))
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
        button.setTitle(NSLocalizedString("common_button_ok", comment: ""), for: .normal)
        
        button.addTarget(self, action: #selector(ConfirmLogoutView.clickedButtonAccept(sender:) ), for: .touchUpInside)
        return button
    }()
    
    var titleLabel :UILabel = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel (frame: CGRect(x: 0 * scale, y: 36 * scale, width: 278 * scale, height: 50 * scale ))
        label.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
        label.textColor = grayColor
        label.text = NSLocalizedString("alert_view_setting_label_logout", comment: "text log out")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        self.addSubview(self.foregroundView)
        self.addSubview(self.viewContent)
        self.viewContent.addSubview(self.titleLabel)
        self.viewContent.addSubview(self.buttonAccept)
        self.viewContent.addSubview(self.buttonDecline)
    }
    
    func changeToShowConfirmView() {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGOUT_SUCCESSFULL, eventName: nil)

        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.buttonAccept.isHidden = true
        self.buttonDecline.isHidden = true
        self.viewContent.frame = CGRect(x: 34 * scale , y: 170 * scale, width: 252 * scale, height: 148 * scale)
        self.titleLabel.text = NSLocalizedString("alert_view_setting_label_logout_success", comment: "")
        self.titleLabel.center = CGPoint(x: self.viewContent.frame.width / 2.0, y: self.viewContent.frame.height / 2.0)
    }
    
    @objc func clickedButtonCancel(sender: Any?) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGOUT_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_LOGOUT_ACTION_CANCEL)

        self.isHidden = true
    }

    @objc func clickedButtonAccept(sender: Any?) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGOUT_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_LOGOUT_ACTION_OK)

        // Sign out Firebase
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        } catch {
            print("Unknown error.")
        }

        //Call api logout to server
        self.callAPIUnregisterPush()

        // Sign out
        self.changeToShowConfirmView()
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            // Remove saved email, password
            UserDefaults.standard.removeObject(forKey: kUserDefaultAccessToken)
            UserDefaults.standard.removeObject(forKey: kUserDefaultUserId)
            UserDefaults.standard.removeObject(forKey: kUserDefaultUserListLastMessageId)
            UserDefaults.standard.synchronize()

            // Pop to LoginVC
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let navigationVC: UINavigationController = appDelegate.window?.rootViewController as? UINavigationController {
                    for vc in navigationVC.viewControllers {
                        if (vc is LoginViewController) == true {
                            self.delegate?.callLogout()
                            navigationVC.popToViewController(vc, animated: true)
                            break
                        }
                    }
                }
            }
        }
    }

    // MARK: - Call API

    func callAPIUnregisterPush() {

        if let token = Messaging.messaging().fcmToken {
            let params: [String: Any] = [
                "regid": token
            ]
            //        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
            APIBase.shareObject.callAPIUnregisterPush(params: params) { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                } else {
                    // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
                }

                //            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
            }
        }
    }

}
