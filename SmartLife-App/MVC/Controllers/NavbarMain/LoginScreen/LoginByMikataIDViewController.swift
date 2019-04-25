//
//  LoginByMikataIDViewController.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 3/30/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit
import Repro

class LoginByMikataIDViewController: UIViewController {

    @IBOutlet weak var mTopLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mIDLabel: UILabel!
    @IBOutlet weak var mPasswordLabel: UILabel!
    @IBOutlet weak var mIDTf: UITextField!
    @IBOutlet weak var mPasswordTf: UITextField!
    @IBOutlet weak var mRegisterButton: UIButton!
    @IBOutlet weak var mBackButton: UIButton!
    @IBOutlet weak var mButtonEye: UIButton!

    @IBOutlet weak var mConstraintTopButton: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopTextField: NSLayoutConstraint!

    @IBOutlet weak var fieldIDContainerView: UIView!
    @IBOutlet weak var fieldPasswordContainerView: UIView!
    var fieldIDContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldPasswordContainerTapGesture: UITapGestureRecognizer? = nil
    var idLogin : String = ""
    var scaleDisplay:CGFloat = SIZE_WIDTH/375.0
    private var noticeView:
        NoticeView = {
            let view = (Bundle.main.loadNibNamed("NoticeView", owner: self, options: nil))?[0] as! NoticeView
            view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
            view.isHidden = true
            return view
    }()

    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scaleDisplay = IS_IPAD ? DISPLAY_SCALE_IPAD : SIZE_WIDTH/375.0
        self.hideKeyboard()
        self.createSubviews()
        self.addTapGestureForTextfieldContainers()
        self.setLanguageForView()
        self.setFontDefaultForView()
        self.setConstraintDefaultForView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldIDContainerTapGesture {
            self.mIDTf.becomeFirstResponder()
        }
        else if recognize == self.fieldPasswordContainerTapGesture {
            self.mPasswordTf.becomeFirstResponder()
        }
    }
    private func addTapGestureForTextfieldContainers() {
        // ID
        self.fieldIDContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldIDContainerView.addGestureRecognizer(self.fieldIDContainerTapGesture!)

        // Password
        self.fieldPasswordContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldPasswordContainerView.addGestureRecognizer(self.fieldPasswordContainerTapGesture!)
    }

    private func createSubviews() {
        self.view.addSubview(self.noticeView)
        self.noticeView.delegate = self
    }

    private func setLanguageForView(){
        self.mTitleLabel.text = NSLocalizedString("loginmikata_label_new_register", comment: "")
        self.mTopLabel.text = NSLocalizedString("loginmikata_label_top", comment: "")
        self.mIDLabel.text = NSLocalizedString("loginmikata_label_enter_id", comment: "")
        self.mPasswordLabel.text = NSLocalizedString("loginmikata_label_password", comment: "")

        self.mRegisterButton.setTitle(NSLocalizedString("loginmikata_button_register_ielove", comment: ""), for: .normal)
        self.mBackButton.setTitle(NSLocalizedString("loginmikata_button_back", comment: ""), for: .normal)

    }

    private func setFontDefaultForView() {
        self.mIDLabel.font = UIFont(name: self.mIDLabel.font.fontName, size: 12 * scaleDisplay)
        self.mPasswordLabel.font = UIFont(name: self.mPasswordLabel.font.fontName, size: 12 * scaleDisplay)
        self.mRegisterButton.titleLabel?.font = UIFont(name: (self.mRegisterButton.titleLabel?.font?.fontName)!, size: 20 * scaleDisplay)
        self.mBackButton.titleLabel?.font = UIFont(name: (self.mBackButton.titleLabel?.font?.fontName)!, size: 12 * scaleDisplay)
    }

    private func setConstraintDefaultForView() {
        self.mConstraintTopButton.constant = 20 * scaleDisplay
        self.mConstraintTopTextField.constant = 18 * scaleDisplay
    }


    // MARK: - API
    func callAPILoginMikata() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: [String : Any] = [
            "email"   : self.mIDTf.text!,
            "password"    : self.mPasswordTf.text!
        ]
        APIBase.shareObject.callAPILoginMikata(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let contract : ContractObj = ContractObj(dict: result?.object(forKey: "body") as! NSDictionary)
                self.idLogin = contract.mID
                self.view.endEditing(true)
                self.noticeView.updateContent(contractObj: contract)
                self.noticeView.isHidden = false

            } else {
                if let error = result?.object(forKey: "error") as? NSArray {
                    if let dictError = error.firstObject as? NSDictionary {
                        // Default message
                        var errorMessage: String = "Error"

                        if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                            // Check error 403
                            if errorCode == 403 || errorCode == 1026{
                                errorMessage = NSLocalizedString("err_exist_ieloveid", comment: "")
                            }
                            if errorCode == 1027{
                                errorMessage = NSLocalizedString("err_ieloveid_or_password_not_match", comment: "")
                            }
                            // Check error 1000
                            if errorCode == 1000 {
                                errorMessage = NSLocalizedString("err_ieloveid_or_password_not_match", comment: "")
                            }
                        }
                        // Show alert
                        GlobalMethod.showAlert(errorMessage)
                    }
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }



    func callAPIRegister() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: [String : Any] = [
            "id"   : self.idLogin,
            "is_import"    : "1"
        ]
        APIBase.shareObject.callAPIRegisterMikataAccount(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                var loginViewController = self.navigationController?.viewControllers[0] as? LoginViewController

                if loginViewController == nil{
                    loginViewController = self.navigationController?.viewControllers[1] as? LoginViewController
                }
                loginViewController?.callAPILoginWith(email: self.mIDTf.text, password: self.mPasswordTf.text)

            } else {
                if let error = result?.object(forKey: "error") as? NSArray {
                    if let dictError = error.firstObject as? NSDictionary {
                        // Default message
                        var errorMessage: String = "Error"

                        if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                            // Check error duplicate data
                            if errorCode == 1011{
                                errorMessage = NSLocalizedString("err_duplicate_data", comment: "")
                                // Show alert
                                GlobalMethod.showAlert(errorMessage)
                            }
                            else if errorCode == 1000{
                                errorMessage = NSLocalizedString("err_duplicate_data", comment: "")
                                // Show alert
                                GlobalMethod.showAlert(errorMessage)
                            }
                            else {
                                APIBase.shareObject.showAPIError(result: result)
                            }
                        }
                    }
                }

            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }


    @IBAction func mRegisterButtonAction(_ sender: UIButton) {
        if self.mIDTf.text?.isEmpty == false && self.mPasswordTf.text?.isEmpty == false {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: self.mIDTf.text ) {
                self.callAPILoginMikata()
            } else {
                let alertVC = UIAlertController(title: nil, message: NSLocalizedString("error_wrong_format_email", comment: ""), preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: .cancel, handler: nil)
                alertVC.addAction(btnCancel)
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            }

        } else {
            if self.mIDTf.text == nil || self.mIDTf.text?.isEmpty == true {
                let alertVC = UIAlertController(title: nil, message: NSLocalizedString("error_empty_email", comment: ""), preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: .cancel, handler: nil)
                alertVC.addAction(btnCancel)
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            } else if self.mPasswordTf.text == nil || self.mPasswordTf.text?.isEmpty == true {

                let alertVC = UIAlertController(title: nil, message: NSLocalizedString("error_empty_password", comment: ""), preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: .cancel, handler: nil)
                alertVC.addAction(btnCancel)
                self.navigationController?.present(alertVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func mBackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //Button show is down
    @IBAction func clickButtonDownEyeShown(_ sender: Any) {
        self.mPasswordTf.clearsOnBeginEditing = false;
        self.mButtonEye.isSelected = !self.mButtonEye.isSelected
        self.mPasswordTf.isSecureTextEntry = !self.mPasswordTf.isSecureTextEntry
    }
}


extension LoginByMikataIDViewController : UITextFieldDelegate {
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.mPasswordTf == textFieldToChange{
            let nsString = self.mPasswordTf.text as NSString?
            self.mPasswordTf.text = nsString?.replacingCharacters(in: range, with: string)
            return false
        }
        return true
    }
}

extension LoginByMikataIDViewController : NoticeViewDelegate {
    func closeNotice() {
        self.callAPIRegister()
        //        let storyboard: UIStoryboard = UIStoryboard(name: "SignUpIeLove", bundle: nil)
        //        let vc:ChangePasswordDefaultViewController? = storyboard.instantiateViewController(withIdentifier: "ChangePasswordDefaultVC") as? ChangePasswordDefaultViewController
        //        vc?.setIeloveId(ieloveId: self.mIDTf.text!)
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
