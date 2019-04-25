//
//  InputNewPasswordViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/18/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Repro

class InputNewPasswordViewController: BaseViewController {

    @IBOutlet weak var mLeadingConstraintLabelPassword: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintTextFieldPassword: NSLayoutConstraint!

    @IBOutlet weak var mLabelRequestNewPassword: UILabel!
    @IBOutlet weak var mTextFieldNewPassword: UITextField!
    @IBOutlet weak var mLabelNewPassword: UILabel!
    @IBOutlet weak var mButtonNext: UIButton!
    @IBOutlet weak var mButtonShow: UIButton!

    // Expand Click
    @IBOutlet weak var fieldNewPasswordContainerView: UIView!
    var fieldNewPasswordContainerTapGesture: UITapGestureRecognizer? = nil
    
    var token : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setReproMark()
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesForViews()
        self.addTapGestureForTextfieldContainers()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD, eventName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setPropertiesForViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(InputNewPasswordViewController.hideForegroundKeyboardView))
        self.view.addGestureRecognizer(tap)
    }

    override func hideForegroundKeyboardView() {
        super.hideForegroundKeyboardView()
        self.view.endEditing(true)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    private func setReproMark(){
        Repro.mask(self.mTextFieldNewPassword)
    }

    private func setLanguageForView(){
        self.mLabelRequestNewPassword.text = NSLocalizedString("inputnewpasswordview_label_request_newpass", comment: "")
        self.mLabelNewPassword.text = NSLocalizedString("inputnewpasswordview_label_newpass", comment: "")

        self.mButtonNext.setTitle(NSLocalizedString("inputnewpasswordview_button_next", comment: ""), for: UIControlState.normal)
    }

    private func setConstraintForViews() {
        self.mLeadingConstraintLabelPassword.constant = 15 * scaleDisplay
        self.mLeadingConstraintTextFieldPassword.constant = 15 * scaleDisplay
    }

    private func setFontForViews() {
        let YuThicB = self.mLabelRequestNewPassword.font.fontName
        let YuThicM = self.mLabelNewPassword.font.fontName
        self.mLabelNewPassword.font = UIFont(name: YuThicM, size: 10 * scaleDisplay)
        self.mLabelRequestNewPassword.font = UIFont(name: YuThicB, size: 12 * scaleDisplay)
        self.mTextFieldNewPassword.font = UIFont(name: YuThicM, size: 12 * scaleDisplay)
        self.mButtonNext.titleLabel!.font = UIFont(name: YuThicB, size: 17 * scaleDisplay)
    }

    @IBAction func clickedButtonShowPassword(_ sender: Any) {
        if self.mTextFieldNewPassword.isSecureTextEntry == true {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD, eventName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD_ACTION_SHOW_PASSWORD)

            self.mTextFieldNewPassword.isSecureTextEntry = false
            self.mButtonShow.setBackgroundImage(#imageLiteral(resourceName: "icon_eye_hiden"), for: .normal)
        } else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD, eventName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD_ACTION_HIDE_PASSWORD)

            self.mTextFieldNewPassword.isSecureTextEntry = true
            self.mButtonShow.setBackgroundImage(#imageLiteral(resourceName: "icon_eye_show"), for: .normal)
        }

    }


    @IBAction func clickedButtonSentRequest(_ sender: Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD, eventName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD_ACTION_SEND)

        // Check password nil
        if self.mTextFieldNewPassword.text == nil || self.mTextFieldNewPassword.text == "" {
            GlobalMethod.showAlert(NSLocalizedString("error_empty_password", comment: ""))
            return
        }
        // Check password format
        if self.mTextFieldNewPassword.text?.isAlphanumeric != true  {
            GlobalMethod.showAlert(NSLocalizedString("error_wrong_format_password", comment: ""))
            return
        }
        // Check password length
        if self.mTextFieldNewPassword.text != nil  {
            if self.mTextFieldNewPassword.text!.count < 8 || self.mTextFieldNewPassword.text!.count > 20 {
                GlobalMethod.showAlert(NSLocalizedString("error_wrong_number_letter_password", comment: ""))
                return
            }
        }

        self.callAPIUpdatePassword(token: self.token, password: self.mTextFieldNewPassword.text!)
    }

    // MARK API
    private func callAPIUpdatePassword(token: String, password : String) {
        let params: [String : Any] = [
            "token"         : token,
            "password"      : password
        ]

        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIUpdatePassword(params: params, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldNewPasswordContainerTapGesture {
            self.mTextFieldNewPassword.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Code
        self.fieldNewPasswordContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldNewPasswordContainerView.addGestureRecognizer(self.fieldNewPasswordContainerTapGesture!)
    }
}

extension InputNewPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideForegroundKeyboardView()
        return true
    }

    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.mTextFieldNewPassword == textFieldToChange{
            let nsString = self.mTextFieldNewPassword.text as NSString?
            self.mTextFieldNewPassword.text = nsString?.replacingCharacters(in: range, with: string)
            return false
        }
        return true
    }
}

