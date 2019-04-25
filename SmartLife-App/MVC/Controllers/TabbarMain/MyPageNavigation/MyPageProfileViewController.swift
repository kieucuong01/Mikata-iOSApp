//
//  MyPageProfileViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol MyPageProfileViewControllerDelegate: class {
    func didEditUserInfomation()
}

class MyPageProfileViewController: BaseViewController {

    @IBOutlet weak var mWidthConstraintImageAvatar: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintImageAvatar: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabelChangeAvatar: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewNameInfo: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintTextField: NSLayoutConstraint!
    @IBOutlet weak var mWidthConstrainTextField: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintViewBackgroundPicker: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewScrollMain: NSLayoutConstraint!
    
    @IBOutlet weak var mViewChangeAvatar: UIView!
    @IBOutlet weak var mTitleNavbar: UILabel!
    @IBOutlet weak var mViewNewPassword: UIView!
    @IBOutlet weak var mViewOldPassword: UIView!
    @IBOutlet weak var mViewFullName: UIView!
    @IBOutlet weak var mViewNickName: UIView!
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mViewPhoneNumber: UIView!
    @IBOutlet weak var mViewBirthday: UIView!
    @IBOutlet weak var mviewBuilding: UIView!
    @IBOutlet weak var mViewRoom: UIView!
    
    @IBOutlet weak var mLabelTitleOldPassword: UILabel!
    @IBOutlet weak var mLabelTitleNewPassword: UILabel!
    @IBOutlet weak var mLabelTitleChangeAvatar: UILabel!
    @IBOutlet weak var mLabelTitleName: UILabel!
    @IBOutlet weak var mLabelTitleUserName: UILabel!
    @IBOutlet weak var mLabelTitleEmail: UILabel!
    @IBOutlet weak var mLabelTitleNumber: UILabel!
    @IBOutlet weak var mLabelTitleDate: UILabel!
    @IBOutlet weak var mLabelTitleBuilding: UILabel!
    @IBOutlet weak var mLabelTitleRoom: UILabel!
    
    @IBOutlet weak var mTextFieldOldPassword: UITextField!
    @IBOutlet weak var mTextFieldNewPassword: UITextField!
    @IBOutlet weak var mTextFieldName: UITextField!
    @IBOutlet weak var mTextFieldUsername: UITextField!
    @IBOutlet weak var mTextFieldEmail: UITextField!
    @IBOutlet weak var mTextFieldNumber: UITextField!
    @IBOutlet weak var mTextFieldDate: UITextField!
    @IBOutlet weak var mTextFieldBuilding: UITextField!
    @IBOutlet weak var mTextFieldRoom: UITextField!
    
    @IBOutlet weak var mButtonShowNewPassword: UIButton!
    @IBOutlet weak var mButtonShowOldPassword: UIButton!
    @IBOutlet weak var mImgFullName: UIImageView!
    @IBOutlet weak var mImgUserName: UIImageView!
    @IBOutlet weak var mImgEmail: UIImageView!
    @IBOutlet weak var mImgPhone: UIImageView!
    @IBOutlet weak var mImgBirthday: UIImageView!
    @IBOutlet weak var mImgBuildings: UIImageView!
    @IBOutlet weak var mImgRoom: UIImageView!
    
    @IBOutlet weak var mScrollViewContain: UIScrollView!
    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var mDatePickerView: UIDatePicker!
    @IBOutlet weak var mListBuidingPickerView: UIPickerView!
    @IBOutlet weak var mListRoomBuilding: UIPickerView!
    @IBOutlet weak var mViewBackgroundPickerView: UIView!
    @IBOutlet weak var mButtonCancel: UIButton!
    @IBOutlet weak var mButtonDone: UIButton!
    
    @IBOutlet weak var mImgAvatarUser: UIImageView!
    @IBOutlet weak var mViewNavBarTop: UIView!

    @IBOutlet weak var mButtonClose: UIButton!
    @IBOutlet weak var mButtonSave: UIButton!
    
    @IBOutlet weak var mViewErrorMessage: UIView!
    @IBOutlet weak var mLabelErrorMessage: UILabel!

    // Expand Click
    var fieldFullNameContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldNickNameContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldEmailContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldOldPasswordContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldNewPasswordContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldPhoneNumberContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldBirthdayContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldBuildingContainerTapGesture: UITapGestureRecognizer? = nil
    var fieldRoomContainerTapGesture: UITapGestureRecognizer? = nil

    let avatarView:SelectAvatarUserView = {
        let view = Bundle.main.loadNibNamed("SelectAvatarUserView", owner: self, options: nil)?[0] as! SelectAvatarUserView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()
    
    var listKabochiViewController: ListBuildingViewController = {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListBuildingViewController") as? ListBuildingViewController
        return vc!
    }()
    
    var selectedBuilding: NSDictionary? = nil

    var isValidEmail = false
    var nameString: String = ""
    var nickNameString: String = ""
    var emailString: String = ""
    
    var valueBirthDay:String? = nil
    var valueBuildingId:String? = nil
    var valueRoom:String? = nil
    var indexKabochaSelected:Int = -1
    
    var mImgForAvatarView:UIImage? = nil
    
    var listKabochaBuildings: [KabochaBuilding] = []
    var listRoomSelected: [String]? = nil
    weak var delegate: MyPageProfileViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.createSubviews()
        self.setDefaultVariables()
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesForViews()
        self.setGestureForViews()
        self.callAPIGetListKabochaBuldingAll()
        self.addTapGestureForTextfieldContainers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT, eventName: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
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
    private func setLanguageForView(){
        self.mTitleNavbar.text = NSLocalizedString("mypageprofileview_navbar", comment: "")
        self.mLabelTitleChangeAvatar.text = NSLocalizedString("mypageprofileview_label_changeavatar", comment: "")
        self.mLabelTitleName.text = NSLocalizedString("mypageprofileview_label_name", comment: "")
        self.mLabelTitleUserName.text = NSLocalizedString("mypageprofileview_label_username", comment: "")
        self.mLabelTitleEmail.text = NSLocalizedString("mypageprofileview_label_email", comment: "")
        self.mLabelTitleNumber.text = NSLocalizedString("mypageprofileview_label_number", comment: "")
        self.mLabelTitleDate.text = NSLocalizedString("mypageprofileview_label_date", comment: "")
        self.mLabelTitleBuilding.text = NSLocalizedString("mypageprofileview_label_building", comment: "")
        self.mLabelTitleRoom.text = NSLocalizedString("mypageprofileview_label_room", comment: "")
        self.mLabelTitleOldPassword.text = NSLocalizedString("mypageprofileview_label_oldpassword", comment: "")
        self.mLabelTitleNewPassword.text = NSLocalizedString("mypageprofileview_label_newpassword", comment: "")

        self.mButtonDone.setTitle(NSLocalizedString("mypageprofileview_button_done", comment: ""), for: .normal)
        self.mButtonCancel.setTitle(NSLocalizedString("mypageprofileview_button_cancel", comment: ""), for: .normal)
        self.mButtonClose.setTitle(NSLocalizedString("mypageprofileview_button_close", comment: ""), for: .normal)
        self.mButtonSave.setTitle(NSLocalizedString("mypageprofileview_button_save", comment: ""), for: .normal)
    }

    private func createSubviews() {
        self.view.addSubview(self.avatarView)
        self.avatarView.delegate = self
    }
    
    private func setDefaultVariables() {
        // Brithday
        self.mTextFieldDate.text = ""
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

        // Image
        self.mImgAvatarUser.image = mImgForAvatarView
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    private func setConstraintForViews() {
        self.mWidthConstraintImageAvatar.constant = 48 * scaleDisplay
        self.mLeadingConstraintImageAvatar.constant = 14 * scaleDisplay
        self.mLeadingConstraintLabelChangeAvatar.constant = 10 * scaleDisplay
        self.mTopConstraintViewNameInfo.constant = 10 * scaleDisplay
        self.mLeadingConstraintTextField.constant = 100 * scaleDisplay
        self.mWidthConstrainTextField.constant = 170 * scaleDisplay
        self.mBottomConstraintViewBackgroundPicker.constant = -51 * scaleDisplay
    }
    
    private func setFontForViews() {
        self.mLabelTitleChangeAvatar.font = UIFont(name: self.mLabelTitleChangeAvatar.font.fontName, size: 12 * scaleDisplay)
        self.mLabelTitleName.font = UIFont(name: self.mLabelTitleName.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTitleUserName.font = UIFont(name: self.mLabelTitleUserName.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTitleEmail.font = UIFont(name: self.mLabelTitleEmail.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTitleNumber.font = UIFont(name: self.mLabelTitleNumber.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTitleDate.font = UIFont(name: self.mLabelTitleDate.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTitleBuilding.font = UIFont(name: self.mLabelTitleBuilding.font.fontName, size: 10 * scaleDisplay)
        self.mLabelTitleRoom.font = UIFont(name: self.mLabelTitleRoom.font.fontName, size: 10 * scaleDisplay)
        
        
        self.mTextFieldName.font = UIFont(name: (self.mTextFieldName.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTextFieldUsername.font = UIFont(name: (self.mTextFieldUsername.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTextFieldEmail.font = UIFont(name: (self.mTextFieldEmail.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTextFieldNumber.font = UIFont(name: (self.mTextFieldNumber.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTextFieldDate.font = UIFont(name: (self.mTextFieldDate.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTextFieldBuilding.font = UIFont(name: (self.mTextFieldBuilding.font?.fontName)!, size: 12 * scaleDisplay)
        self.mTextFieldRoom.font = UIFont(name: (self.mTextFieldRoom.font?.fontName)!, size: 12 * scaleDisplay)
        
        self.mButtonCancel.titleLabel!.font = UIFont(name: (self.mButtonCancel.titleLabel!.font?.fontName)!, size: 12 * scaleDisplay)
        self.mButtonDone.titleLabel!.font = UIFont(name: (self.mButtonDone.titleLabel!.font?.fontName)!, size: 12 * scaleDisplay)
        self.mButtonClose.titleLabel!.font = UIFont(name: (self.mButtonClose.titleLabel!.font?.fontName)!, size: 12 * scaleDisplay)
        self.mButtonSave.titleLabel!.font = UIFont(name: (self.mButtonSave.titleLabel!.font?.fontName)!, size: 12 * scaleDisplay)
        
    }
    
    private func setPropertiesForViews() {
        self.mImgAvatarUser.layer.cornerRadius = 20.5 * scaleDisplay
        self.mImgAvatarUser.layer.masksToBounds = true
        self.listKabochiViewController.delegate = self
    }
    
    private func setGestureForViews() {
        var tapView = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboardWhenOutside(_:)))
        self.mViewNavBarTop.addGestureRecognizer(tapView)
        tapView = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboardWhenOutside(_:)))
        self.mContentView.addGestureRecognizer(tapView)
        tapView = UITapGestureRecognizer(target: self, action: #selector(clickedButtonDetail(_:)))
        self.mViewChangeAvatar.addGestureRecognizer(tapView)
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

        if self.mTextFieldOldPassword.text?.isEmpty == false || self.mTextFieldNewPassword.text?.isEmpty == false {
            // Check password length
            if self.mTextFieldNewPassword.text != nil {
                if self.mTextFieldNewPassword.text!.count < 8 || self.mTextFieldNewPassword.text!.count > 20 {
                    isValid = false
                    self.mViewErrorMessage.isHidden = false
                    self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_number_letter_password", comment: "")
                }
            }
            // Check password format
            if self.mTextFieldNewPassword.text?.isAlphanumeric != true {
                isValid = false
                self.mViewErrorMessage.isHidden = false
                self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_format_password", comment: "")
            }
            // Check password nil
            if (self.mTextFieldOldPassword?.text?.isEmpty != self.mTextFieldNewPassword?.text?.isEmpty) {
                isValid = false
                self.mViewErrorMessage.isHidden = false
                self.mLabelErrorMessage.text = NSLocalizedString("error_wrong_old_n_new_password", comment: "")
            }
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
        if (isValidEmail == false || self.emailString == "") {
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
        if emailTest.evaluate(with: mTextFieldEmail.text ?? "") == false {
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
        if self.nickNameString == "" {
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
        if self.nameString == "" {
            isValid = false
            self.mImgFullName.image = #imageLiteral(resourceName: "icon_attention")
            self.mViewErrorMessage.isHidden = false
            self.mLabelErrorMessage.text = NSLocalizedString("error_empty_name", comment: "")
        }

        if isValid == true {
            self.mViewErrorMessage.isHidden = true
            self.mScrollViewContain.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            self.mViewErrorMessage.isHidden = false
            self.mScrollViewContain.contentInset = UIEdgeInsets(top: self.mViewErrorMessage.frame.size.height, left: 0, bottom: 0, right: 0)
            self.mScrollViewContain.contentOffset = CGPoint(x: 0, y: 0 - self.mViewErrorMessage.frame.size.height)
        }
        
        return isValid
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
        self.mScrollViewContain.contentSize = CGSize(width: 0, height: 590 * scaleDisplay)
    }
    
    @IBAction func clickedButtonHeaderCloseKeyboard(_ sender: UIButton) {
        self.hideKeyboardWhenOutside(sender)
    }
    func hideHUDProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showHUDProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    //MARK: - API method
    
    func callAPIUpdateUser(params: [String : Any]?) {
        self.showHUDProgress()
        APIBase.shareObject.callAPIAddAndUpdateUser(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body:String = result?.object(forKey: "body") as? String {
                    UserDefaults.standard.set(body, forKey: kUserDefaultUserId)
                    UserDefaults.standard.synchronize()
                }
                GlobalMethod.showAlert(NSLocalizedString("alert_edit_profile_success_title", comment: ""), completion: {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didEditUserInfomation()
                })
            } else {
                if let error = result?.object(forKey: "error") as? NSArray {
                    if let dictError = error.firstObject as? NSDictionary {
                        // Default message
                        var errorMessage: String = "Error"

                        if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                            // Check error 1024
                            if errorCode == 1024 {
                                errorMessage = NSLocalizedString("error_wrong_old_n_new_password", comment: "")
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
    
    func callAPICheckValidateUser(params: [String: String]) {
        var paramsCheck: [String: String] = params
        paramsCheck["id"] = PublicVariables.userInfo.m_id

        // Call API
        APIBase.shareObject.callAPICheckValidate(params: paramsCheck) { (result, error) in
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
                    self.listKabochaBuildings.removeAll()
                    for item in list! {
                        let kabocha = KabochaBuilding(dict: item)
                        self.listKabochaBuildings.append(kabocha)
                    }
                    self.mListBuidingPickerView.reloadComponent(0)
                    
                    if let index = self.listKabochaBuildings.index(where: { $0.m_id == PublicVariables.userInfo.m_kabocha_building_id }) {
                        self.mListBuidingPickerView.selectRow(index, inComponent: 0, animated: false)
                    }
                }
            } else {
                
                if status == 400 {
                    self.mImgEmail.image = #imageLiteral(resourceName: "icon_attention")
                }
                APIBase.shareObject.showAPIError(result: result)
            }
            self.callAPIGetUserProfile()
        }
    }

    func callAPIGetUserProfile() {
        self.showHUDProgress()
        let param = ["id":PublicVariables.userInfo.m_id]
        APIBase.shareObject.callAPIGetUserProfile(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                PublicVariables.userInfo = User(dict: result?.value(forKey: "body") as! [String : Any] )
                if PublicVariables.userInfo.m_icon_path != "" {
                    self.mImgAvatarUser.setImageForm(urlString: PublicVariables.userInfo.m_icon_path, placeHolderImage: nil)
                }
                else {
                    self.mImgAvatarUser.image = #imageLiteral(resourceName: "ic_user_defauft")
                }
                self.mTextFieldName.text = PublicVariables.userInfo.m_name
                self.mTextFieldEmail.text = PublicVariables.userInfo.m_email
                self.mTextFieldNumber.text = PublicVariables.userInfo.m_phone
                self.mTextFieldBuilding.text = PublicVariables.userInfo.m_kabocha_building_name
                self.mTextFieldUsername.text = PublicVariables.userInfo.m_nick_name
                self.mTextFieldRoom.text = PublicVariables.userInfo.m_kabocha_room_number

                self.isValidEmail = true
                self.nameString = PublicVariables.userInfo.m_name
                self.nickNameString = PublicVariables.userInfo.m_nick_name
                self.emailString = PublicVariables.userInfo.m_email
                self.valueBuildingId = PublicVariables.userInfo.m_kabocha_building_id

                if PublicVariables.userInfo.m_kabocha_building_id.isEmpty == false {
                    if let kabocha = self.listKabochaBuildings.first(where: { $0.m_id == PublicVariables.userInfo.m_kabocha_building_id }) {
                        self.listRoomSelected = [""]
                        let array = kabocha.m_room.components(separatedBy: ",")
                        self.listRoomSelected = array
                        self.mListRoomBuilding.reloadComponent(0)
                        self.mListRoomBuilding.layoutIfNeeded()
                        self.mListRoomBuilding.selectRow(0, inComponent: 0, animated: false)
                        self.valueRoom = self.listRoomSelected?.first
                    }
                }

                if PublicVariables.userInfo.m_birthday != "" {
                    let date = Date(timeIntervalSince1970: TimeInterval((PublicVariables.userInfo.m_birthday as NSString).longLongValue))
                    let formater = DateFormatter()
                    formater.dateFormat = "yyyy/MM/dd"
                    formater.locale = Locale(identifier: "en_US_POSIX")
                    self.mTextFieldDate.text = formater.string(from: date)
                }
                else {
                    self.mTextFieldDate.text = ""
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            self.hideHUDProgress()
        }
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        // Click cancel
        self.clickedButtonCancel(nil)

        if recognize == self.fieldFullNameContainerTapGesture {
            self.mTextFieldName.becomeFirstResponder()
        }
        else if recognize == self.fieldNickNameContainerTapGesture {
            self.mTextFieldUsername.becomeFirstResponder()
        }
        else if recognize == self.fieldEmailContainerTapGesture {
            self.mTextFieldEmail.becomeFirstResponder()
        }
        else if recognize == self.fieldOldPasswordContainerTapGesture {
            self.mTextFieldOldPassword.becomeFirstResponder()
        }
        else if recognize == self.fieldNewPasswordContainerTapGesture {
            self.mTextFieldNewPassword.becomeFirstResponder()
        }
        else if recognize == self.fieldPhoneNumberContainerTapGesture {
            self.mTextFieldNumber.becomeFirstResponder()
        }
        else if recognize == self.fieldBirthdayContainerTapGesture {
            self.mTextFieldDate.becomeFirstResponder()
        }
        else if recognize == self.fieldBuildingContainerTapGesture {
            self.mTextFieldBuilding.becomeFirstResponder()
        }
        else if recognize == self.fieldRoomContainerTapGesture {
            self.mTextFieldRoom.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // FullName
        self.fieldFullNameContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewFullName.addGestureRecognizer(self.fieldFullNameContainerTapGesture!)

        // NickName
        self.fieldNickNameContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewNickName.addGestureRecognizer(self.fieldNickNameContainerTapGesture!)

        // Email
        self.fieldEmailContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewEmail.addGestureRecognizer(self.fieldEmailContainerTapGesture!)

        // OldPassword
        self.fieldOldPasswordContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewOldPassword.addGestureRecognizer(self.fieldOldPasswordContainerTapGesture!)

        // NewPassword
        self.fieldNewPasswordContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.mViewNewPassword.addGestureRecognizer(self.fieldNewPasswordContainerTapGesture!)

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

    @IBAction func clickedButtonClose(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT, eventName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT_ACTION_CANCEL)

        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickedButtonSave(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT, eventName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT_ACTION_SAVE)

        self.hideKeyboardWhenOutside(self.view)

        let isValid = checkValidInfomationInput()
        if isValid == true {
            if self.checkValidInfomationBelowEmailInput() == true {
                var birthdayString: String = ""
                if self.mTextFieldDate.text != nil {
                    birthdayString = self.mTextFieldDate.text!.replacingOccurrences(of: "/", with: "-")
                }

                var params:[String:Any] = ["nick_name":self.nickNameString, "name": self.nameString,
                                           "email" : self.emailString, "phone": self.mTextFieldNumber.text ?? "",
                                           "birthday":birthdayString, "mikata_building_id": self.valueBuildingId ?? "",
                                           "mikata_room_number": self.mTextFieldRoom.text ?? "","is_temp_password":  NSNumber.init(value: 0) ,
                                           "id":PublicVariables.userInfo.m_id]
                if self.mTextFieldOldPassword.text?.isEmpty == false && self.mTextFieldNewPassword.text?.isEmpty == false {
                    params["old_password"] = self.mTextFieldOldPassword.text ?? ""
                    params["new_password"] = self.mTextFieldNewPassword.text ?? ""
                }

                self.callAPIUpdateUser(params:params)
            }
        }
    }

    @IBAction func clickedButtonEyeOldPassword(_ sender: Any) {
        self.mTextFieldOldPassword.clearsOnBeginEditing = false;

        self.mButtonShowOldPassword.isSelected = !self.mButtonShowOldPassword.isSelected
        self.mTextFieldOldPassword.isSecureTextEntry = !self.mTextFieldOldPassword.isSecureTextEntry
    }

    @IBAction func clickedButtonEyeNewPassword(_ sender: Any) {
        self.mTextFieldNewPassword.clearsOnBeginEditing = false;

        self.mButtonShowNewPassword.isSelected = !self.mButtonShowNewPassword.isSelected
        self.mTextFieldNewPassword.isSecureTextEntry = !self.mTextFieldNewPassword.isSecureTextEntry
    }

    
    @IBAction func clickedButtonCancel(_ sender: Any?) {
        hideKeyboardWhenOutside(self.mTextFieldDate)
    }
    
    @IBAction func clickedButtonDone(_ sender: Any) {
        if self.valueBirthDay != nil {
            self.mTextFieldDate.text = self.valueBirthDay
        }
        if self.valueRoom != nil {
            self.mTextFieldRoom.text = self.valueRoom
        }
        
        hideKeyboardWhenOutside(self.mTextFieldDate)
    }

    @IBAction func clickedButtonDetail(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT, eventName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT_ACTION_CHANGE_ICON)
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT_POPUP_CHANGE_ICON, eventName: nil)

        self.avatarView.isHidden = false
        self.avatarView.callAPIGetUser()
    }
    
    @IBAction func valueChangedPickerView(_ sender: Any) {
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy/MM/dd"
        formatDate.locale = Locale(identifier: "en_US_POSIX")
        self.valueBirthDay = formatDate.string(from: self.mDatePickerView.date)
    }

    // MARK: - Handle TextField

    @IBAction func handleTextFieldChanged(_ sender: UITextField) {
        let newString: String = (sender.text != nil ? sender.text! : "")
        if sender.tag == 11 {
            self.nameString = newString
            if newString != "" { self.mImgFullName.image = UIImage(named: "icon_checked") }
            // Check to update
            _ = self.checkValidInfomationInput()
        } else if sender.tag == 12 {
            self.nickNameString = newString
            if newString != "" { self.mImgUserName.image = UIImage(named: "icon_checked") }
            // Check to update
            _ = self.checkValidInfomationInput()
        } else if sender.tag == 13 {
            let params = ["email": newString]
            self.callAPICheckValidateUser(params: params)
        }
    }
}

extension MyPageProfileViewController: SelectAvatarUserViewDelegate {
    func clickedAvatarInList(sender: SelectAvatarUserView, image:String) {
        self.mImgAvatarUser.af_setImage(withURL: URL.init(string: image )!)
        self.delegate?.didEditUserInfomation()
    }
    
    func apiGetListShowError(sender: SelectAvatarUserView, message: String) {
        self.errorAPIAppear(message: message)
    }
    
    func requestMBProgressHUDHide(sender: SelectAvatarUserView) {
        self.hideHUDProgress()
    }
    
    func requestMBProgressHUDShow(sender: SelectAvatarUserView) {
        self.showHUDProgress()
    }
}

extension MyPageProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var isBegin = true
        //Open building
        if textField.tag == 17 {
//            self.hideKeyboardWhenOutside(textField)
            self.present(self.listKabochiViewController, animated: true, completion: nil)
            return false
        }
        if textField.tag == 16 {
            self.hideKeyboardWhenOutside(textField)
            self.mDatePickerView.isHidden = false
            self.mViewBackgroundPickerView.isHidden = false
            let formatDate = DateFormatter()
            formatDate.dateFormat = "yyyy/MM/dd"
            formatDate.locale = Locale(identifier: "en_US_POSIX")
            self.valueBirthDay = formatDate.string(from: self.mDatePickerView.date)
            self.mScrollViewContain.contentSize = CGSize(width: 0, height: 770 * scaleDisplay)
            isBegin = false
        }
        else if textField.tag == 18 {
            self.hideKeyboardWhenOutside(textField)
            self.mListRoomBuilding.isHidden = false
            self.mViewBackgroundPickerView.isHidden = false
            isBegin = false
            self.mScrollViewContain.contentSize = CGSize(width: 0, height: 770 * scaleDisplay)
        } else {
            self.mViewBackgroundPickerView.isHidden = true
            self.mScrollViewContain.contentSize = CGSize(width: 0, height: 730 * scaleDisplay)
        }
        
        let num = textField.tag % 11
        var y = CGFloat(num) * 45.0 * scaleDisplay
        y = min(y, self.mScrollViewContain.contentSize.height - self.mScrollViewContain.frame.size.height)
        self.mScrollViewContain.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        return isBegin
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.mTextFieldOldPassword == textFieldToChange{
            let nsString = self.mTextFieldOldPassword.text as NSString?
            self.mTextFieldOldPassword.text = nsString?.replacingCharacters(in: range, with: string)
            return false
        }
        else if self.mTextFieldNewPassword == textFieldToChange{
            let nsString = self.mTextFieldNewPassword.text as NSString?
            self.mTextFieldNewPassword.text = nsString?.replacingCharacters(in: range, with: string)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboardWhenOutside(textField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
extension MyPageProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            if listRoomSelected != nil {
                return listRoomSelected![row]
            } else {
                return ""
            }
        }
        return ""
    }
}


extension MyPageProfileViewController:ListBuildingViewControllerDelegate {
    func callbackDelegateToSelectOneBuilding(sender: ListBuildingViewController, item: NSDictionary) {
        self.selectedBuilding = item
        self.mTextFieldBuilding.text = item.value(forKey: "name") as? String
        self.valueBuildingId = item.value(forKey: "id") as? String
        listRoomSelected = []
        if let str = item.value(forKey: "rooms") as? String {
            let array = str.components(separatedBy: ",")
            listRoomSelected = array
        }
        self.mListRoomBuilding.reloadComponent(0)
        self.mListRoomBuilding.layoutIfNeeded()
        self.mListRoomBuilding.selectRow(0, inComponent: 0, animated: false)
        self.valueRoom = self.listRoomSelected?.first
        self.mTextFieldRoom.text = ""
    }
}
