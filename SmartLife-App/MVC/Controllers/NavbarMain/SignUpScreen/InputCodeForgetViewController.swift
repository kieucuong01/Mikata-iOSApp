//
//  InputCodeForgetViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/18/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import MessageUI

class InputCodeForgetViewController: BaseViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var mTrailingConstraintTextFieldPassword: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabelPassword: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintTextFieldPassword: NSLayoutConstraint!

    @IBOutlet weak var mLabelNoticeSentCode: UILabel!
    @IBOutlet weak var mLabelNoticeContact: UILabel!

    @IBOutlet weak var mLabelSentCode: UILabel!
    @IBOutlet weak var mTextFieldSentCode: UITextField!
    @IBOutlet weak var mButtonNext: UIButton!

    // Expand Click
    @IBOutlet weak var fieldCodeContainerView: UIView!
    var fieldCodeContainerTapGesture: UITapGestureRecognizer? = nil

    var emailCurrent:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFontForViews()
        self.setConstraintForViews()
        self.setLanguageForView()
        self.setPropertiesForViews()
        self.setActionForObject()
        self.addTapGestureForTextfieldContainers()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_CODE, eventName: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideForegroundKeyboardView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setLanguageForView(){
        self.mLabelNoticeSentCode.text = emailCurrent + NSLocalizedString("inputcodeforgetview_label_notice", comment: "")
        self.mLabelNoticeContact.text = NSLocalizedString("inputcodeforgetview_label_contact", comment: "")
        self.mLabelSentCode.text = NSLocalizedString("inputcodeforgetview_label_sendcode", comment: "")

        self.mButtonNext.setTitle(NSLocalizedString("inputcodeforgetview_button_next", comment: ""), for: UIControlState.normal)
    }

    private func setPropertiesForViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(InputCodeForgetViewController.hideForegroundKeyboardView))
        self.view.addGestureRecognizer(tap)
    }

    override func hideForegroundKeyboardView() {
        super.hideForegroundKeyboardView()
        self.view.endEditing(true)
    }


    @IBAction func tappedInquiry(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
//            mail.setToRecipients(["club-smart@smt-days.co.jp"])
            mail.setToRecipients(["club-smart@smt-days.co.jp"])
            mail.setSubject(NSLocalizedString("inquiry_forgetpassword_subject", comment:"subject"))
            mail.setMessageBody(NSLocalizedString("inquiry_forgetpassword_content", comment:"content"), isHTML: false)
            present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            print("送信成功")
        default:
            break
        }
        dismiss(animated: true, completion:{
            if result == .sent {
                let alert:UIAlertController = UIAlertController(title: "送信しました", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in print("OK") }
                alert.addAction(okAction)
                self.present(alert,animated: true,completion: nil)
            }
            
        })
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    private func setFontForViews() {
        let fontYuthicB = self.mLabelNoticeSentCode.font.fontName
        let fontYuthicM = self.mLabelSentCode.font.fontName
        self.mLabelNoticeSentCode.font = UIFont.init(name: fontYuthicB, size: 12 * scaleDisplay)
        self.mLabelNoticeContact.font = UIFont.init(name: fontYuthicB, size: 12 * scaleDisplay)

        self.mLabelSentCode.font = UIFont(name: fontYuthicM, size: 10 * scaleDisplay )
        self.mTextFieldSentCode.font = UIFont(name: fontYuthicM, size: 12 * scaleDisplay )

        self.mButtonNext.titleLabel!.font = UIFont(name: fontYuthicB, size: 17 * scaleDisplay )
    }

    private func setConstraintForViews() {
        self.mTrailingConstraintTextFieldPassword.constant = 15 * scaleDisplay
        self.mLeadingConstraintLabelPassword.constant = 15 * scaleDisplay
        self.mLeadingConstraintTextFieldPassword.constant = 15 * scaleDisplay
    }

    private func setActionForObject(){
        self.mButtonNext.addTarget(self, action: #selector(self.mButtonNextTouch), for: .touchUpInside)
    }

    func setTextEmailForViews(email:String) {
        self.emailCurrent = email
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sentCodeSegue" {
            if self.mTextFieldSentCode.text?.isEmpty == true {
                self.errorAPIAppear(message: NSLocalizedString("err_msg_content_forget_password_empty_code", comment: "code is empty"))
                return false
            } else {
                return true
            }
        }
        return true
    }

    // MARK ACTION
    @objc func mButtonNextTouch() {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_CODE, eventName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_CODE_ACTION_NEXT)

        if self.mTextFieldSentCode.text?.isEmpty == false {
            self.callAPIUserActivation(verifyCode: self.mTextFieldSentCode.text!)
        } else {
            self.errorAPIAppear(message: NSLocalizedString("err_msg_content_forget_password_empty_code", comment: "code is empty"))
        }

    }


    // MARK API
    private func callAPIUserActivation(verifyCode: String) {
        let params: [String : Any] = [
            "token"         : verifyCode,
            "regist_type"   : "forget_password"
        ]

        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIUserActivation(params: params, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body:NSDictionary = result?.object(forKey: "body") as? NSDictionary {
                    if let token: String = body.object(forKey: "token") as? String {
                        let storyboard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
                        let vc:InputNewPasswordViewController? = storyboard.instantiateViewController(withIdentifier: "inputNewPassVC") as? InputNewPasswordViewController
                        vc?.token = token
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
            }
            else {
                self.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)

        })
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldCodeContainerTapGesture {
            self.mTextFieldSentCode.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Code
        self.fieldCodeContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldCodeContainerView.addGestureRecognizer(self.fieldCodeContainerTapGesture!)
    }
}

extension InputCodeForgetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideForegroundKeyboardView()
        return true
    }
}
