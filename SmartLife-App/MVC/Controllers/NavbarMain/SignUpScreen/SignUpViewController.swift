//
//  SignUpViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 7/31/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Repro

class SignUpViewController: BaseViewController, UIGestureRecognizerDelegate {

    //MARK: - UIView
    @IBOutlet weak var mLabelNavbar: UILabel!
    @IBOutlet weak var mLabelCode: UILabel!
    @IBOutlet weak var mLabelFullName: UILabel!
    @IBOutlet weak var mLabelUserName: UILabel!
    @IBOutlet weak var mLabelEmail: UILabel!
    @IBOutlet weak var mLabelPassword: UILabel!
    @IBOutlet weak var mLabelPhoneNumber: UILabel!
    @IBOutlet weak var mLabelBirthday: UILabel!
    @IBOutlet weak var mLabelBuildings: UILabel!
    @IBOutlet weak var mLabelRoom: UILabel!
    @IBOutlet weak var mLabelExistAccount: UILabel!
    @IBOutlet weak var mLabelErrorMessage: UILabel!

    @IBOutlet weak var mTextFieldCode: UITextField!
    @IBOutlet weak var mTextFieldFullName: UITextField!
    @IBOutlet weak var mTextFieldUserName: UITextField!
    @IBOutlet weak var mTextFieldEmail: UITextField!
    @IBOutlet weak var mTextFieldPassword: UITextField!
    @IBOutlet weak var mTextFieldPhoneNumber: UITextField!
    @IBOutlet weak var mTextFieldBirthDay: UITextField!
    @IBOutlet weak var mTextFieldRoom: UITextField!
    @IBOutlet weak var mTextFieldBuildings: UITextField!

    @IBOutlet weak var mImgFullName: UIImageView!
    @IBOutlet weak var mImgUserName: UIImageView!
    @IBOutlet weak var mImgEmail: UIImageView!
    @IBOutlet weak var mImgPhone: UIImageView!
    @IBOutlet weak var mImgBirthday: UIImageView!
    @IBOutlet weak var mImgBuildings: UIImageView!
    @IBOutlet weak var mImgRoom: UIImageView!

    @IBOutlet weak var mScrollViewContain: UIScrollView!
    @IBOutlet weak var mViewHeader: UIView!
    @IBOutlet weak var mViewCode: UIView!
    @IBOutlet weak var mViewFullName: UIView!
    @IBOutlet weak var mViewNickName: UIView!
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet weak var mViewPhoneNumber: UIView!
    @IBOutlet weak var mViewBirthday: UIView!
    @IBOutlet weak var mviewBuilding: UIView!
    @IBOutlet weak var mViewRoom: UIView!
    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var mDatePickerView: UIDatePicker!
    @IBOutlet weak var mListBuidingPickerView: UIPickerView!
    @IBOutlet weak var mListRoomBuilding: UIPickerView!
    @IBOutlet weak var mViewBackgroundPickerView: UIView!

    @IBOutlet weak var mViewErrorMessage: UIView!

    @IBOutlet weak var mButtonEye: UIButton!
    @IBOutlet weak var mButtonCancel: UIButton!
    @IBOutlet weak var mButtonDone: UIButton!

    @IBOutlet weak var mButtonCheck: UIButton!
    //MARK: - Constraint
    @IBOutlet weak var mLeadingLabelFullNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingTextFieldFullNameConstraint: NSLayoutConstraint!

    // Expand Click
    var fieldCodeContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldFullNameContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldNickNameContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldEmailContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldPasswordContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldPhoneNumberContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldBirthdayContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldBuildingContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldRoomContainerTapGesture: UITapGestureRecognizer? = nil

    private var confirmView:ConfirmSignUpView = {
        let view = (Bundle.main.loadNibNamed("ConfirmSignUpView", owner: self, options: nil))?[0] as! ConfirmSignUpView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()
    
    var listKabochiViewController: ListBuildingViewController = {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListBuildingViewController") as? ListBuildingViewController
        return vc!
    }()

    var listKabochaBuildings: [KabochaBuilding] = []
    var listRoomSelected: [String]? = nil
    var indexKabochaSelected:Int = -1
    var isShowKeyboard = false
    var selectedBuilding: NSDictionary? = nil

    var isValidEmail = false
    var codeString: String = ""
    var nameString: String = ""
    var nickNameString: String = ""
    var emailString: String = ""
    var isEditCode: Bool = false
    var isEditName: Bool = false
    var isEditNickName: Bool = false
    var isEditEmail: Bool = false

    var valueBirthDay:String? = nil
    var valueBuildingId:String? = nil
    var valueRoom:String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setReproMark()
        self.setFontDefaultForView()
        self.setConstraintDefaultForView()
        self.setGestureForView()
        self.createSubviews()
        self.setDefaultVariables()
        self.callAPIGetListKabochaBuldingAll()
        self.addTapGestureForTextfieldContainers()
        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP, eventName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        Repro.mask(self.mTextFieldPassword)
    }

    private func setLanguageForView(){
        self.mLabelNavbar.text = NSLocalizedString("registerview_label_top", comment: "")
        self.mLabelCode.text = NSLocalizedString("registerview_label_code", comment: "")
        self.mLabelFullName.text = NSLocalizedString("registerview_label_fullname", comment: "")
        self.mLabelUserName.text = NSLocalizedString("registerview_label_username", comment: "")
        self.mLabelEmail.text = NSLocalizedString("registerview_label_email", comment: "")
        self.mLabelPassword.text = NSLocalizedString("registerview_label_password", comment: "")
        self.mLabelPhoneNumber.text = NSLocalizedString("registerview_label_phonenumber", comment: "")
        self.mLabelBirthday.text = NSLocalizedString("registerview_label_birthday", comment: "")
        self.mLabelBuildings.text = NSLocalizedString("registerview_label_building", comment: "")
        self.mLabelRoom.text = NSLocalizedString("registerview_label_room", comment: "")
        self.mLabelExistAccount.text = NSLocalizedString("registerview_label_existaccount", comment: "")

        self.mTextFieldPassword.placeholder = NSLocalizedString("registerview_placeholdertf_password", comment: "")
        self.mTextFieldCode.placeholder = NSLocalizedString("registerview_placeholdertf_code", comment: "")

        self.mButtonCheck.setTitle(NSLocalizedString("registerview_button_check", comment: ""), for: .normal)
    }

    private func setFontDefaultForView() {
        self.mLabelCode.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelFullName.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelUserName.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelEmail.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelPassword.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelPhoneNumber.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelBirthday.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelBuildings.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelRoom.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelExistAccount.font = UIFont.systemFont(ofSize: 10 * scaleDisplay)
        self.mLabelErrorMessage.font = UIFont.boldSystemFont(ofSize: 12 * scaleDisplay)

        self.mTextFieldCode.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldFullName.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldUserName.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldEmail.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldPassword.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldPhoneNumber.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldBirthDay.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldBuildings.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mTextFieldRoom.font = UIFont.systemFont(ofSize: 12 * scaleDisplay)
        self.mButtonCheck.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17 * scaleDisplay)

        self.mButtonCancel.titleLabel!.font = UIFont.systemFont(ofSize: 14 * scaleDisplay)
        self.mButtonDone.titleLabel!.font = UIFont.systemFont(ofSize: 14 * scaleDisplay)
    }

    private func setConstraintDefaultForView() {
        self.mLeadingLabelFullNameConstraint.constant = 14 * scaleDisplay
        self.mLeadingTextFieldFullNameConstraint.constant = 100 * scaleDisplay
    }

    private func setGestureForView() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(self.clickedBackButton(sender:)))
        self.mLabelExistAccount.addGestureRecognizer(tapLabel)
        var tapView = UITapGestureRecognizer(target: self, action: #selector(self.clickedButtonCancel(_:)))
        self.mViewHeader.addGestureRecognizer(tapView)
        tapView = UITapGestureRecognizer(target: self, action: #selector(self.clickedButtonCancel(_:)))
        self.mContentView.addGestureRecognizer(tapView)
    }

    private func setDefaultVariables() {
        // Brithday
        self.mTextFieldBirthDay.text = ""
        if let previsousDate: Date = Calendar.current.date(byAdding: Calendar.Component.year, value: -22, to: Date()) {
            var dateComponent: DateComponents = DateComponents()
            dateComponent.day = 1
            dateComponent.month = 1
            dateComponent.year = Calendar.current.component(Calendar.Component.year, from: previsousDate)

            // Set default date
            if let defaultDate: Date = Calendar.current.date(from: dateComponent) {
                self.mDatePickerView.date = defaultDate
            }
        }

        // List Kabochi
        self.listKabochiViewController.delegate = self
    }

    func checkValidInfomationBelowEmailInput() -> Bool {
        var isValid = true

        // Check room nil
        if self.mTextFieldRoom.text == nil || self.mTextFieldRoom.text == "" {
            isValid = false
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_not_choose_room", comment: "")
        }
        // Check building nil
        if self.valueBuildingId == nil || self.valueBuildingId == "" {
            isValid = false
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_not_choose_building", comment: "")
        }
        // Check password length
        if self.mTextFieldPassword.text != nil {
            if self.mTextFieldPassword.text!.count < 8 || self.mTextFieldPassword.text!.count > 20 {
                isValid = false
                self.mViewErrorMessage.isHidden = false
                self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_number_letter_password", comment: "")
            }
        }
        // Check password format
        if self.mTextFieldPassword.text?.isAlphanumeric != true {
                isValid = false
                self.mViewErrorMessage.isHidden = false
                self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_format_password", comment: "")
        }
        // Check password nil
        if self.mTextFieldPassword.text == nil || self.mTextFieldPassword.text == "" {
            isValid = false
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_empty_password", comment: "")
        }

        if isValid == true {
            self.mViewErrorMessage.isHidden = true
        }

        return isValid
    }

    func checkValidInfomationInput() -> Bool {
        var isValid = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        // Check mail duplicate
        if self.isEditEmail == true && (isValidEmail == false || self.emailString == "") {
            isValid = false
            self.mImgEmail.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            if self.emailString == "" {
                // Mail is empty
                self.mLabelErrorMessage.text = NSLocalizedString("error_empty_email", comment: "")
            } else {
                self.mLabelErrorMessage.text = NSLocalizedString("error_existed_email", comment: "")
            }
        }
        // Check mail format
        if self.isEditEmail == true && emailTest.evaluate(with: mTextFieldEmail.text!) == false {
            //Mail is wrong format
            isValid = false
            self.mViewErrorMessage.isHidden = false
            self.mImgEmail.image = #imageLiteral(resourceName: "icon_attention")
            self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_format_email", comment: "")
        }
        // Check nickname length
        if self.nickNameString.count > 50 {
            isValid = false
            self.mImgUserName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_number_letter_nickname", comment: "")
        }
        // Check nickname format
        if self.nickNameString.containsEmoji == true {
            isValid = false
            self.mImgUserName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_number_letter_nickname", comment: "")
        }
        // Check nickname empty
        if self.isEditNickName == true && self.nickNameString == "" {
            isValid = false
            self.mImgUserName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_empty_nickname", comment: "")
        }
        // Check name length
        if self.nameString.count > 50 {
            isValid = false
            self.mImgFullName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_number_letter_name", comment: "")
        }
        // Check name format
        if self.nameString.containsEmoji == true {
            isValid = false
            self.mImgFullName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_number_letter_name", comment: "")
        }
        // Check name empty
        if self.isEditName == true && self.nameString == "" {
            isValid = false
            self.mImgFullName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_empty_name", comment: "")
        }
        // Check code empty
        if self.isEditCode == true && self.codeString == "" {
            isValid = false
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_empty_code", comment: "")
        }

        if isValid == true {
            self.mViewErrorMessage.isHidden = true
        }

        return isValid
    }

    private func createSubviews() {
        self.view.addSubview(self.confirmView)
        self.confirmView.delegate = self
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        // Click cancel
        self.clickedButtonCancel(nil)

        if recognize == self.fieldCodeContainerTapGesture {
            self.mTextFieldCode.becomeFirstResponder()
        }
        else if recognize == self.fieldFullNameContainerTapGesture {
            self.mTextFieldFullName.becomeFirstResponder()
        }
        else if recognize == self.fieldNickNameContainerTapGesture {
            self.mTextFieldUserName.becomeFirstResponder()
        }
        else if recognize == self.fieldEmailContainerTapGesture {
            self.mTextFieldEmail.becomeFirstResponder()
        }
        else if recognize == self.fieldPasswordContainerTapGesture {
            self.mTextFieldPassword.becomeFirstResponder()
        }
        else if recognize == self.fieldPhoneNumberContainerTapGesture {
            self.mTextFieldPhoneNumber.becomeFirstResponder()
        }
        else if recognize == self.fieldBirthdayContainerTapGesture {
            self.mTextFieldBirthDay.becomeFirstResponder()
        }
        else if recognize == self.fieldBuildingContainerTapGesture {
            self.mTextFieldBuildings.becomeFirstResponder()
        }
        else if recognize == self.fieldRoomContainerTapGesture {
            self.mTextFieldRoom.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Code
        self.fieldCodeContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewCode.addGestureRecognizer(self.fieldCodeContainerTapGesture!)

        // FullName
        self.fieldFullNameContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewFullName.addGestureRecognizer(self.fieldFullNameContainerTapGesture!)

        // NickName
        self.fieldNickNameContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewNickName.addGestureRecognizer(self.fieldNickNameContainerTapGesture!)

        // Email
        self.fieldEmailContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewEmail.addGestureRecognizer(self.fieldEmailContainerTapGesture!)

        // Password
        self.fieldPasswordContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewPassword.addGestureRecognizer(self.fieldPasswordContainerTapGesture!)

        // PhoneNumber
        self.fieldPhoneNumberContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewPhoneNumber.addGestureRecognizer(self.fieldPhoneNumberContainerTapGesture!)

        // Birthday
        self.fieldBirthdayContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewBirthday.addGestureRecognizer(self.fieldBirthdayContainerTapGesture!)

        // Building
        self.fieldBuildingContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mviewBuilding.addGestureRecognizer(self.fieldBuildingContainerTapGesture!)

        // Room
        self.fieldRoomContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewRoom.addGestureRecognizer(self.fieldRoomContainerTapGesture!)
    }

    //MARK: - Selector
    @objc func clickedBackButton(sender:Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_ACTION_BACK_TO_LOGIN)

        self.navigationController?.popViewController(animated: true)
    }

    //Button show is down
    @IBAction func clickButtonDownEyeShown(_ sender: Any) {
        self.mButtonEye.isSelected = !self.mButtonEye.isSelected
        if self.mButtonEye.isSelected == false {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_ACTION_HIDE_PASSWORD)

            self.mTextFieldPassword.isSecureTextEntry = true
        } else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_ACTION_SHOW_PASSWORD)

            self.mTextFieldPassword.isSecureTextEntry = false
        }
    }

    @objc
    func hideKeyboardWhenOutside(_ sender:Any) {
        self.view.endEditing(true)
        self.valueBirthDay = nil

        self.mScrollViewContain.contentOffset = .zero
        self.mDatePickerView.isHidden = true
        self.mListBuidingPickerView.isHidden = true
        self.mListRoomBuilding.isHidden = true
        self.mViewBackgroundPickerView.isHidden = true
        self.mScrollViewContain.contentSize = CGSize(width: 0, height: 450 * scaleDisplay)
        if let gesture = sender as? UITapGestureRecognizer {
            if gesture.view?.tag == 99 {
                self.isShowKeyboard = false
            }
        }
    }

    @IBAction func clickedButtonHeaderCloseKeyboard(_ sender: UIButton) {
        self.clickedButtonCancel(sender)
    }

    @IBAction func clickedButtonCheck(_ sender: Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_ACTION_CONFIRM)

        self.hideKeyboardWhenOutside(self.view)

        // Update is edit
        if self.mViewErrorMessage.isHidden == true {
            if self.isEditCode == false { self.isEditCode = true }
            else if self.isEditName == false { self.isEditName = true }
            else if self.isEditNickName == false { self.isEditNickName = true }
            else if self.isEditEmail == false { self.isEditEmail = true }
        }

        let isValid = checkValidInfomationInput()
        if isValid == true {
            if self.checkValidInfomationBelowEmailInput() == true {
                self.confirmView.updateDateForView(code: self.codeString, fullname: self.nameString, nickname: self.nickNameString, email: self.emailString, password: self.mTextFieldPassword.text ?? "", phone: self.mTextFieldPhoneNumber.text ?? "", birthday: self.mTextFieldBirthDay.text ?? "", building: self.mTextFieldBuildings.text, room:  self.mTextFieldRoom.text!)
                self.confirmView.isHidden = false

                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_CONFIRM_ACTION_CANCEL)
            }
        }
    }

    @IBAction func clickedButtonCancel(_ sender: Any?) {
        hideKeyboardWhenOutside(self.mTextFieldBirthDay)
    }

    @IBAction func clickedButtonDone(_ sender: Any) {
        if self.valueBirthDay != nil {
            self.mTextFieldBirthDay.text = self.valueBirthDay
        }
        if self.valueRoom != nil {
            self.mTextFieldRoom.text = self.valueRoom
        }

        hideKeyboardWhenOutside(self.mTextFieldBirthDay)
    }

    // MARK: - Handle TextField

    @IBAction func handleTextFieldChanged(_ sender: UITextField) {
        let newString: String = (sender.text != nil ? sender.text!: "")
        if sender == self.mTextFieldCode {
            self.isEditCode = true
            self.codeString = newString
            // Check to update
            _ = self.checkValidInfomationInput()
        }
        else if sender.tag == 11 {
            self.isEditName = true
            self.nameString = newString
            if newString != "" { self.mImgFullName.image = UIImage(named: "icon_checked") }
            // Check to update
            _ = self.checkValidInfomationInput()
        }
        else if sender.tag == 12 {
            self.isEditNickName = true
            self.nickNameString = newString
            if newString != "" { self.mImgUserName.image = UIImage(named: "icon_checked") }
            // Check to update
            _ = self.checkValidInfomationInput()
        }
        else if sender.tag == 13 {
            self.isEditEmail = true
            let params = ["email": newString]
            self.callAPICheckValidateUser(params: params)
        }
    }

    //MARK: - Call API

    func callAPIUpdateUser(params: [String : Any]?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIAddAndUpdateUser(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body:String = result?.object(forKey: "body") as? String {
                    UserDefaults.standard.set(body, forKey: kUserDefaultUserId)
                    UserDefaults.standard.synchronize()

                }
                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP_SUCCESSFULL, eventName: nil)

                self.confirmView.mViewSuccess.isHidden = false
            } else {
                self.confirmView.isHidden = true
                if let error = result?.object(forKey: "error") as? NSArray {
                    if let dictError = error.firstObject as? NSDictionary {
                        // Default message
                        var errorMessage: String = "Error"
                        if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                            // Check error 1023
                            if errorCode == 1023 {
                                errorMessage = NSLocalizedString("error_wrong_code", comment: "")
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

    func callAPICheckValidateUser(params: [String: String]) {
        // Call API
        APIBase.shareObject.callAPICheckValidate(params: params) { (result, error) in
            if result != nil {
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if params["email"] != nil {
                        self.emailString = params["email"]!
                        self.mImgEmail.image = #imageLiteral(resourceName: "icon_checked")
                        self.isValidEmail = true
                    }
                } else {
                    if params["email"] != nil {
                        self.emailString = params["email"]!
                        self.mImgEmail.image = #imageLiteral(resourceName: "icon_attention")
                        self.isValidEmail = false
                    }
                }
            }
            else {
                // Update textfield when no network
                self.mTextFieldEmail.text = self.emailString
            }
            MBProgressHUD.hide(for: self.view, animated: true)

            // Check to update after call API
            _ = self.checkValidInfomationInput()
        }
    }

    func callAPIGetListKabochaBuldingAll() {
        APIBase.shareObject.callAPIListKabocha(params: nil) { (result, error) in

            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let list:[NSDictionary]? = result?.value(forKey: "body") as? [NSDictionary]
                if  list != nil {
                    for item in list! {
                        let kabocha = KabochaBuilding(dict: item)
                        self.listKabochaBuildings.append(kabocha)
                    }
                    self.mListBuidingPickerView.reloadComponent(0)
                }
            } else {
                
                APIBase.shareObject.showAPIError(result: result)
            }
        }
    }

    @IBAction func valueChangedPickerView(_ sender: Any) {
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy/MM/dd"
        formatDate.locale = Locale(identifier: "en_US_POSIX")
        self.valueBirthDay = formatDate.string(from: self.mDatePickerView.date)
    }
}

extension SignUpViewController : ConfirmSignUpViewDelegate {
    func clickedButtonCloseInViewSuccess(sender: ConfirmSignUpView) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_CONFIRM_ACTION_CANCEL)

        self.navigationController?.popViewController(animated: true)
    }

    func clickedButtonConfirmUser(sender: ConfirmSignUpView) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SIGNUP_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_SIGNUP_CONFIRM_ACTION_OK)

        var birthdayString: String = ""
        if self.mTextFieldBirthDay.text != nil {
            birthdayString = self.mTextFieldBirthDay.text!.replacingOccurrences(of: "/", with: "-")
        }

        let params:[String:Any] = ["nick_name":self.nickNameString, "name": self.nameString,
                                   "email" : self.emailString, "phone": self.mTextFieldPhoneNumber.text ?? "",
                                   "birthday":birthdayString, "mikata_building_id": self.valueBuildingId ?? "",
                                   "mikata_room_number": self.mTextFieldRoom.text ?? "","is_temp_password":  NSNumber.init(value: 0),
                                   "password": self.mTextFieldPassword.text!,
                                   "residence": self.codeString]
        self.callAPIUpdateUser(params:params)
    }
}

extension SignUpViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //Open building
        if textField.tag == 17 {
//            self.hideKeyboardWhenOutside(textField)
            self.present(self.listKabochiViewController, animated: true, completion: nil)
            return false
        }
        var isBegin = true
        if textField.tag == 16 {
            self.hideKeyboardWhenOutside(textField)
            self.mDatePickerView.isHidden = false
            self.mViewBackgroundPickerView.isHidden = false
            let formatDate = DateFormatter()
            formatDate.dateFormat = "yyyy/MM/dd"
            formatDate.locale = Locale(identifier: "en_US_POSIX")
            self.valueBirthDay = formatDate.string(from: self.mDatePickerView.date)
            isBegin = false
            self.mScrollViewContain.contentSize = CGSize(width: 0, height: 585 * scaleDisplay)

        }
        else if textField.tag == 18 {
            self.hideKeyboardWhenOutside(textField)
            self.mListRoomBuilding.isHidden = false
            self.mViewBackgroundPickerView.isHidden = false
            isBegin = false
            self.mScrollViewContain.contentSize = CGSize(width: 0, height: 585 * scaleDisplay)

        } else {
            self.mViewBackgroundPickerView.isHidden = true
            self.mScrollViewContain.contentSize = CGSize(width: 0, height: 570 * scaleDisplay)
        }

        let num = textField.tag % 11
        var y = CGFloat(num) * 45.0 * scaleDisplay
        y = min(y, self.mScrollViewContain.contentSize.height - self.mScrollViewContain.frame.size.height)
        self.mScrollViewContain.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        return isBegin
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboardWhenOutside(textField)
        return true
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 26 {
            if listRoomSelected != nil {
                return listRoomSelected!.count
            }
            return 1
        }
        return 1
    }



    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 26 {
            self.valueRoom = nil
            if listRoomSelected != nil && listRoomSelected?.indices.contains(row) == true {
                self.valueRoom = listRoomSelected![row]
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 26  {
            if listRoomSelected != nil && listRoomSelected?.indices.contains(row) == true {
                return listRoomSelected![row]
            } else {
                return ""
            }
        }
        return ""
    }
}

extension SignUpViewController:ListBuildingViewControllerDelegate {
    func callbackDelegateToSelectOneBuilding(sender: ListBuildingViewController, item: NSDictionary) {
        self.selectedBuilding = item
        self.mTextFieldBuildings.text = item.value(forKey: "name") as? String
        self.valueBuildingId = item.value(forKey: "id") as? String
        self.listRoomSelected = []
        if let str = item.value(forKey: "rooms") as? String {
            let array = str.components(separatedBy: ",")
            self.listRoomSelected = array
        }
        self.mListRoomBuilding.reloadComponent(0)
        self.mListRoomBuilding.layoutIfNeeded()
        self.mListRoomBuilding.selectRow(0, inComponent: 0, animated: false)
        self.valueRoom = self.listRoomSelected?.first
        self.mTextFieldRoom.text = ""
    }
}
