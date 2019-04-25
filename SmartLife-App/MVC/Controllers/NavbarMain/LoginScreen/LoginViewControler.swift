//
//  LoginViewControler.swift
//  smart_tablet
//
//  Created by thanhlt on 7/28/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Firebase
import Repro
import CoreBluetooth

class LoginViewController: BaseViewController{
    @IBOutlet weak var mTopViewInputInfoConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingTextFieldNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelForgetPasswordConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopButtonLoginConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopViewLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelNotAccount: NSLayoutConstraint!
    @IBOutlet weak var mTopButtonTermUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopButtonSignUpConstraint: NSLayoutConstraint!

    @IBOutlet weak var mViewForegroundKeyboard: UIView!
    @IBOutlet weak var mLabelName: UILabel!
    @IBOutlet weak var mLabelPassword: UILabel!
    @IBOutlet weak var mTxtFieldName: UITextField!
    @IBOutlet weak var mTxtFieldPassword: UITextField!

    @IBOutlet weak var mTitleNavBarLabel: UILabel!
    @IBOutlet weak var mLabelForgetPassword: UILabel!
    @IBOutlet weak var mButtonLogin: UIButton!
    @IBOutlet weak var mLabelFontNotAccount: UILabel!
    @IBOutlet weak var mButtonSignUp: UIButton!
    @IBOutlet weak var mTextViewTermUse: UITextView!
    @IBOutlet weak var mButtonEye: UIButton!

    // Expand Click
    @IBOutlet weak var fieldNameContainerView: UIView!
    @IBOutlet weak var fieldPasswordContainerView: UIView!
    var fieldNameContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldPasswordContainerTapGesture: UITapGestureRecognizer? = nil
    
    //MARK: - LifeCircle ViewController
    private var scale:CGFloat = DISPLAY_SCALE

    override func viewDidLoad() {
        super.viewDidLoad()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForView()
        self.setFontForView()
        self.setDelegateForViews()
        self.setGestureForView()
        self.addForegroundKeyboard(parentView: self.mViewForegroundKeyboard)
        self.setReproMark()
        self.addTapGestureForTextfieldContainers()
        self.setLanguageForView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        if let navbar = self.navigationController as? NavbarMainViewController {
            navbar.setVisibleNavigationBarCustom(isHidden: true)
        }

        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldNameContainerTapGesture {
            self.mTxtFieldName.becomeFirstResponder()
        }
        else if recognize == self.fieldPasswordContainerTapGesture {
            self.mTxtFieldPassword.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Name
        self.fieldNameContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldNameContainerView.addGestureRecognizer(self.fieldNameContainerTapGesture!)

        // Password
        self.fieldPasswordContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldPasswordContainerView.addGestureRecognizer(self.fieldPasswordContainerTapGesture!)
    }

    //MARK: - Private method
    private func setReproMark(){
        Repro.mask(self.mTxtFieldPassword)
    }

    private func setLanguageForView(){
        self.mTitleNavBarLabel.text = NSLocalizedString("loginview_label_navbar", comment: "")
        self.mLabelName.text = NSLocalizedString("loginview_label_email", comment: "")
        self.mLabelPassword.text = NSLocalizedString("loginview_label_password", comment: "")
        self.mLabelForgetPassword.text = NSLocalizedString("loginview_label_forgetpassword", comment: "")
        self.mLabelFontNotAccount.text = NSLocalizedString("loginview_label_top_register", comment: "")

        self.mButtonLogin.setTitle(NSLocalizedString("loginview_button_login", comment: ""), for: .normal)
        self.mButtonSignUp.setTitle(NSLocalizedString("loginview_button_register", comment: ""), for: .normal)
    }

    private func setConstraintForView() {
        self.mTopViewInputInfoConstraint.constant = 45 *   scale
        self.mLeadingTextFieldNameConstraint.constant = 95 * scale
        self.mTopLabelForgetPasswordConstraint.constant = 21 * scale
        self.mTopButtonLoginConstraint.constant = 21 * scale
        self.mTopViewLineConstraint.constant = 20 * scale
        self.mTopLabelNotAccount.constant = 20 * scale
        self.mTopButtonSignUpConstraint.constant = 12 * scale
        self.mTopButtonTermUpConstraint.constant = 15 * scale
    }

    private func setFontForView() {
        self.mLabelName.font = UIFont.systemFont(ofSize: 10.24 * scale)
        self.mLabelPassword.font = UIFont.systemFont(ofSize: 10.24 * scale)
        self.mTxtFieldName.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mTxtFieldPassword.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelForgetPassword.font = UIFont.boldSystemFont(ofSize: 14 * scale)
        self.mButtonLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17 * scale)
        self.mLabelFontNotAccount.font = UIFont.systemFont(ofSize: 14 * scale)
        self.mButtonSignUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17 * scale)

        self.mTextViewTermUse.font = UIFont.systemFont(ofSize: 10.24 * scale)
        let str = "登録することで、利用規約に同意したことになります"
        self.mTextViewTermUse.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        let attributeStr = NSMutableAttributedString(string: str)
        attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 34, green: 34, blue: 34), range: NSRange(location: 0, length: str.count))
        attributeStr.addAttribute( NSAttributedStringKey.link, value: "term_of_use", range: NSRange(location: 8, length: 4 ))
        self.mTextViewTermUse.attributedText = attributeStr
    }

    private func setDelegateForViews() {
        self.mTextViewTermUse.delegate = self
        self.mTextViewTermUse.tag = 10

        self.mTxtFieldName.delegate = self
        self.mTxtFieldName.tag = 11
        self.mTxtFieldPassword.delegate = self
        self.mTxtFieldPassword.tag = 12
    }

    private func setGestureForView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.clickedLabelForgetPassword(sender:)))
        self.mLabelForgetPassword.addGestureRecognizer(tap)
    }

    func hideHUDProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func showHUDProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    //MARK: - Selector

    @IBAction func clickedButtonEye(_ sender: Any) {
        self.mTxtFieldPassword.clearsOnBeginEditing = false;

        self.mButtonEye.isSelected = !self.mButtonEye.isSelected
        self.mTxtFieldPassword.isSecureTextEntry = !self.mTxtFieldPassword.isSecureTextEntry
        if self.mButtonEye.isSelected{
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_SHOW_PASSWORD)
        }
        else{
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_HIDE_PASSWORD)
        }

    }

    @objc func clickedLabelForgetPassword(sender:Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_FORGET_PASSWORD)

        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navbarForgetPassVC")
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction func clickedButtonLogin(_ sender: Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_LOGIN)
        if self.mTxtFieldName.text?.isEmpty == false && self.mTxtFieldPassword.text?.isEmpty == false {
            // print("validate calendar: \(testStr)")
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: self.mTxtFieldName.text ) {
                self.callAPILoginWith(email: self.mTxtFieldName.text, password: self.mTxtFieldPassword.text)
            } else {
                let alertVC = UIAlertController(title: nil, message: NSLocalizedString("error_wrong_format_email", comment: ""), preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: .cancel, handler: nil)
                alertVC.addAction(btnCancel)
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            }

        } else {
            if self.mTxtFieldName.text == nil || self.mTxtFieldName.text?.isEmpty == true {
                let alertVC = UIAlertController(title: nil, message: NSLocalizedString("error_empty_email", comment: ""), preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: .cancel, handler: nil)
                alertVC.addAction(btnCancel)
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            } else if self.mTxtFieldPassword.text == nil || self.mTxtFieldPassword.text?.isEmpty == true {

                let alertVC = UIAlertController(title: nil, message: NSLocalizedString("error_empty_password", comment: ""), preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: .cancel, handler: nil)
                alertVC.addAction(btnCancel)
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func clickedButtonSignUp(_ sender: Any) {
        //        let vc = UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController()
        //        let segue = UIStoryboardSegue(identifier: "transitToSignUp", source: self, destination: vc!) {
        //
        //            self.navigationController?.pushViewController(vc!, animated: true)
        //        }
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_SIGNIN)
    }

    @IBAction func clickedButtonLoginByMikataID(_ sender: UIButton) {
        let storyboarLoading: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let loadingVC: LoginByMikataIDViewController = storyboarLoading.instantiateViewController(withIdentifier: "LoginByMikataIDVC") as? LoginByMikataIDViewController {
            self.navigationController?.pushViewController(loadingVC, animated: true)
        }
    }

    override func hideForegroundKeyboardView() {
        super.hideForegroundKeyboardView()
        self.mTxtFieldPassword.resignFirstResponder()
        self.mTxtFieldName.resignFirstResponder()
    }

    //MARK:- API
    func callAPILoginWith(email: String?, password: String?) {
        if email != nil && password != nil {
            self.showHUDProgress()
            let params:[String:Any] = ["email" :email!,"password" : password!]
            APIBase.shareObject.callAPILogin(params: params) { (result, error) in
                let status = (result?.object(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let body = result?.object(forKey: "body") as? [String:Any] {
                        let user:User = User(dict:body)
                        PublicVariables.userInfo = user
                        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeScore, object: user.m_point)
                        print("\(user)")

                        // Save email and password
                        UserDefaults.standard.set(user.m_token, forKey: kUserDefaultAccessToken)
                        UserDefaults.standard.set(user.m_id, forKey: kUserDefaultUserId)
                        UserDefaults.standard.set(true, forKey: kUserIsRunning)
                        UserDefaults.standard.synchronize()

                        // Send Id to Repro
                        Repro.setUserID(PublicVariables.userInfo.m_id)
                    }

                    // Register push to server
                    self.callAPIRegisterPush()

                    // Get loadingVC
                    let storyboarLoading: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
                    if let loadingVC: LoadingViewController = storyboarLoading.instantiateViewController(withIdentifier: "loadingVC") as? LoadingViewController {
                        self.navigationController?.pushViewController(loadingVC, animated: true)
                    }
                } else {
                    if let error = result?.object(forKey: "error") as? NSArray {
                        if let dictError = error.firstObject as? NSDictionary {
                            // Default message
                            var errorMessage: String = "Error"

                            if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                                // Check error 403
                                if errorCode == 403 {
                                    errorMessage = NSLocalizedString("error_wrong_email", comment: "")
                                }
                                // Check error 1022
                                if errorCode == 1012 {
                                    errorMessage = NSLocalizedString("error_not_cofirm_email", comment: "")
                                }
                            }

                            // Show alert
                            GlobalMethod.showAlert(errorMessage)
                        }
                    }
                }
                self.hideHUDProgress()
            }
        }
    }



    func callAPILoginWith(token: String?) {
        // Sign out Firebase
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        } catch {
            print("Unknown error.")
        }

        // Remove saved data
        UserDefaults.standard.removeObject(forKey: kUserDefaultAccessToken)
        UserDefaults.standard.removeObject(forKey: kUserDefaultUserId)
        UserDefaults.standard.removeObject(forKey: kUserDefaultUserListLastMessageId)
        UserDefaults.standard.synchronize()

        self.showHUDProgress()
        let params:[String:Any] = ["action" :"login","token" : token!]
        APIBase.shareObject.callAPILogin(params: params) { (result, error) in
            let status = (result?.object(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.object(forKey: "body") as? [String:Any] {
                    let user:User = User(dict:body)
                    PublicVariables.userInfo = user
                    NotificationCenter.default.post(name: NSNotificationNavbarMainChangeScore, object: user.m_point)
                    print("\(user)")

                    // Save data
                    UserDefaults.standard.set(PublicVariables.userInfo.m_token, forKey: kUserDefaultAccessToken)
                    UserDefaults.standard.set(PublicVariables.userInfo.m_id, forKey: kUserDefaultUserId)
                    UserDefaults.standard.set(true, forKey: kUserIsRunning)
                    UserDefaults.standard.synchronize()

                    // Send Id to Repro
                    Repro.setUserID(PublicVariables.userInfo.m_id)
                }

                // Register push to server
                self.callAPIRegisterPush()

                // Get loadingVC
                let storyboarLoading: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
                if let loadingVC: LoadingViewController = storyboarLoading.instantiateViewController(withIdentifier: "loadingVC") as? LoadingViewController {
                    self.navigationController?.pushViewController(loadingVC, animated: true)
                }
            } else {
                if let error = result?.object(forKey: "error") as? NSArray {
                    if let dictError = error.firstObject as? NSDictionary {
                        // Default message
                        var errorMessage: String = "Error"

                        if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                            // Check error 403
                            if errorCode == 403 {
                                errorMessage = NSLocalizedString("error_wrong_email", comment: "")
                            }
                            // Check error 1022
                            if errorCode == 1012 {
                                errorMessage = NSLocalizedString("error_not_cofirm_email", comment: "")
                            }
                        }

                        // Show alert
                        GlobalMethod.showAlert(errorMessage)
                    }
                }
            }
            self.hideHUDProgress()
        }
    }


    func callAPIRegisterPush() {
        if let token = Messaging.messaging().fcmToken {
            let params: [String: Any] = [
                "regid": token
            ]
            APIBase.shareObject.callAPIRegisterPush(params: params) { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                } else {
                    APIBase.shareObject.showAPIError(result: result)
                }
            }
        }
    }
}

extension LoginViewController:UITextViewDelegate {
//    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if textView.tag == 10 {

            if URL.absoluteString == "term_of_use" {
                let vc = SettingSubTermViewController()
                vc.createNavBar()
                vc.type = .termOfUser
                self.navigationController?.present(vc, animated: true, completion: nil)
                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_SHOW_TERM)
                return false
            }
            return true
        }
        return false
    }

//    @available(iOS, obsoleted: 10.0)
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//        if textView.tag == 10 {
//            if URL.absoluteString == "term_of_use" {
//                let vc = SettingSubTermViewController()
//                vc.createNavBar()
//                vc.type = .termOfUser
//                self.navigationController?.present(vc, animated: true, completion: nil)
//                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGIN, eventName: ReproEvent.REPRO_SCREEN_LOGIN_ACTION_SHOW_TERM)
//                return false
//            }
//            return true
//        }
//        return false
//    }
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.showForegroundKeyboardView()
        return true
    }

    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.mTxtFieldPassword == textFieldToChange{
            let nsString = self.mTxtFieldPassword.text as NSString?
            self.mTxtFieldPassword.text = nsString?.replacingCharacters(in: range, with: string)
            return false
        }
        return true
    }
}
