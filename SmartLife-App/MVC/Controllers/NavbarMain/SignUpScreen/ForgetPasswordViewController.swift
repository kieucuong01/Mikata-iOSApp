//
//  ForgetPasswordViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit


class ForgetPasswordViewController: BaseViewController {


    @IBOutlet weak var mLeadingConstraintLabelPassword: NSLayoutConstraint!

    //Top view of space in top
    @IBOutlet weak var mTopViewConstraint: NSLayoutConstraint!


    @IBOutlet weak var mBottomConstraintLabelTop: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintTextFieldPassword: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintTextFieldPassword: NSLayoutConstraint!

    @IBOutlet weak var mLabelTop: UILabel!
    @IBOutlet weak var mLabelEmail: UILabel!
    @IBOutlet weak var mLabelEmailConfirm: UILabel!
    @IBOutlet weak var mTxtFieldEmail: UITextField!
    @IBOutlet weak var mTxtFieldEmailConfirm: UITextField!
    @IBOutlet weak var mButtonNext: UIButton!

    // Expand Click
    @IBOutlet weak var fieldEmailContainerView: UIView!
    @IBOutlet weak var fieldEmailConfirmContainerView: UIView!
    var fieldEmailContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldEmailConfirmContainerTapGesture: UITapGestureRecognizer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLanguageForView()
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesForViews()
        self.addTapGestureForTextfieldContainers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_MAIL, eventName: nil)
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
        self.mLabelEmail.text = NSLocalizedString("forgetpasswordview_label_email", comment: "")
        self.mLabelEmailConfirm.text = NSLocalizedString("forgetpasswordview_label_confirm_email", comment: "")
        self.mLabelTop.text = NSLocalizedString("forgetpasswordview_label_top", comment: "")

        self.mButtonNext.setTitle(NSLocalizedString("forgetpasswordview_button_next", comment: ""), for: UIControlState.normal)
    }

    private func setPropertiesForViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ForgetPasswordViewController.hideForegroundKeyboardView))
        self.view.addGestureRecognizer(tap)
    }

    override func hideForegroundKeyboardView() {
        super.hideForegroundKeyboardView()
        self.view.endEditing(true)
        self.mTopViewConstraint.constant = 0
    }



    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    private func setConstraintForViews() {
        self.mLeadingConstraintLabelPassword.constant = 15 * scaleDisplay
        self.mLeadingConstraintTextFieldPassword.constant = 15 * scaleDisplay
        self.mTrailingConstraintTextFieldPassword.constant = 15 * scaleDisplay
        self.mBottomConstraintLabelTop.constant = 21 * scaleDisplay
    }

    private func setFontForViews() {
        self.mLabelEmail.font = UIFont(name: self.mLabelEmail.font.fontName, size: 10 * scaleDisplay)
        self.mLabelEmailConfirm.font = UIFont(name: self.mLabelEmailConfirm.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTop.font = UIFont(name: self.mLabelTop.font.fontName, size: 12 * scaleDisplay)
        self.mTxtFieldEmail.font = UIFont(name: (self.mTxtFieldEmail.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTxtFieldEmailConfirm.font = UIFont(name: (self.mTxtFieldEmailConfirm.font?.fontName)!, size: 12 * scaleDisplay)
        self.mButtonNext.titleLabel?.font = UIFont(name: (self.mButtonNext.titleLabel?.font?.fontName)!, size: 17 * scaleDisplay)
    }

    @IBAction func clickedButtonSentRequest(_ sender: Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_MAIL, eventName: ReproEvent.REPRO_SCREEN_FORGET_PASSWORD_INPUT_MAIL_ACTION_SEND)

        if let string = self.mTxtFieldEmail.text {

            if checkValidMail(email: string) {
                if self.mTxtFieldEmail.text! != self.mTxtFieldEmailConfirm.text! {
                    self.errorAPIAppear(message: NSLocalizedString("err_msg_content_forget_password_not_match_emails", comment: "Emails doest match"))
                } else {
                    // Is valid sent mail0
                    self.callAPIForgetPasswordd(email: string)
                }
            } else {
                self.errorAPIAppear(message: NSLocalizedString("err_msg_content_forget_password_not_valid_email", comment: "Email isn't valid"))

            }
        } else {
            self.errorAPIAppear(message: NSLocalizedString("error_empty_email", comment: "Email is Empty"))
        }
    }

    func checkValidMail( email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    // MARK API

    private func callAPIForgetPasswordd(email: String) {
        let params: [String : Any] = [
            "email": email
        ]

        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIForgetPassword(params: params, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let _:Bool = result?.object(forKey: "body") as? Bool {
                    let storyboard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
                    let vc:InputCodeForgetViewController? = storyboard.instantiateViewController(withIdentifier: "inputCodeForgetPassVC") as? InputCodeForgetViewController
                    vc?.setTextEmailForViews(email: self.mTxtFieldEmail.text ?? "")
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
            else {
                if let error = result?.object(forKey: "error") as? NSArray {
                    if let dictError = error.firstObject as? NSDictionary {
                        // Default message
                        var errorMessage: String = "Error"

                        if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                            // Check error 1022
                            if errorCode == 1010 || errorCode == 1022 {
                                errorMessage = NSLocalizedString("error_not_registered_email", comment: "")
                            }
                        }

                        // Show alert
                        GlobalMethod.showAlert(errorMessage, in: self)
                    }
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldEmailContainerTapGesture {
            self.mTxtFieldEmail.becomeFirstResponder()
        }
        else if recognize == self.fieldEmailConfirmContainerTapGesture {
            self.mTxtFieldEmailConfirm.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Email
        self.fieldEmailContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldEmailContainerView.addGestureRecognizer(self.fieldEmailContainerTapGesture!)

        // EmailConfirm
        self.fieldEmailConfirmContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldEmailConfirmContainerView.addGestureRecognizer(self.fieldEmailConfirmContainerTapGesture!)
    }
}

extension ForgetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideForegroundKeyboardView()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.mTopViewConstraint.constant = -30 * scaleDisplay
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
