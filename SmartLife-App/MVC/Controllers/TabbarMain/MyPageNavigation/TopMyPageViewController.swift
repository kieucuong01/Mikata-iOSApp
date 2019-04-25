//
//  TopMyPageViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol TopMyPageViewControllerDelegate: class {
    func callDelegateClickedButtonPointGet()
    func callDelegateClickedButtonPointExchange()
    func callDelegateClickedButtonBytes()
    func callDelegateClickedButtonJobIntro()
    func callDelegateClickedButtonNote()
}

class TopMyPageViewController: BaseViewController {
    
    @IBOutlet weak var mUsernameTitle: UILabel!
    @IBOutlet weak var mNameTitle: UILabel!
    @IBOutlet weak var mEmailTitle: UILabel!
    @IBOutlet weak var mPhoneTitle: UILabel!
    @IBOutlet weak var mBirthDateTitle: UILabel!
    @IBOutlet weak var mBuildingTitle: UILabel!
    @IBOutlet weak var mRoomTitle: UILabel!
    @IBOutlet weak var mFQATitle: UILabel!
    @IBOutlet weak var mSettingTitle: UILabel!

    @IBOutlet weak var mUsername: UILabel!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    @IBOutlet weak var mPhone: UILabel!
    @IBOutlet weak var mBirthDate: UILabel!
    @IBOutlet weak var mBuilding: UILabel!
    @IBOutlet weak var mRoom: UILabel!

    var namePos:String = NSLocalizedString("topmypageview_label_namepos", comment: "")
    
    @IBOutlet weak var mImgAvatar: UIImageView!
    @IBOutlet weak var mTopView: UIView!

    weak var delegate: TopMyPageViewControllerDelegate? = nil
    
    private var mViewTopInfoUser:UIView  = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view = UIView(frame: CGRect(x: 0, y: 93 * scale , width: SIZE_WIDTH, height: 17 * scale))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var mLabelName:UILabel = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel(frame: CGRect(x: 0, y: 2 * scale, width: 0, height: 17 * scale))
        label.font = UIFont(name: "YuGothic-Bold", size: 12 * scale)
        label.lineBreakMode = .byTruncatingTail
        label.text = ""
        label.textColor = GlobalMethod.hexStringToUIColor(hex: "#000000")
        return label
    }()
    
    private var mLabel:UILabel = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel(frame: CGRect(x: 0, y: 2 * scale, width: 0, height: 17 * scale))
        label.font = UIFont(name: "YuGo-Medium", size: 12 * scale)
        label.text = ""
        label.textColor = GlobalMethod.hexStringToUIColor(hex: "#000000")
        return label
    }()
    
    private var mImageEdit:UIImageView = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 13 * scale, height: 14 * scale))
        imgView.image = #imageLiteral(resourceName: "ic_my_page_edit")
        imgView.isUserInteractionEnabled = false
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.setPropertiesForViews()
        self.setLanguageForView()
        self.setUpUserInfomationForView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setHideNavBar(isHiden: false)
        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeTitle, object: NSLocalizedString("topmypageview_navbar", comment: ""))
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_MY_PAGE, eventName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createSubviews() {
        self.mTopView.addSubview(self.mViewTopInfoUser)
        self.mViewTopInfoUser.addSubview(self.mLabelName)
        self.mViewTopInfoUser.addSubview(self.mLabel)
        self.mViewTopInfoUser.addSubview(self.mImageEdit)
    }
    
    private func setPropertiesForViews() {
        self.mImgAvatar.layer.cornerRadius =  31.5 * scaleDisplay
        self.mImgAvatar.layer.masksToBounds = true
    }
    
    private func setLabelIntop() {
        self.mLabelName.sizeToFit()
        self.mLabel.text = self.namePos
        self.mLabel.sizeToFit()
        var width = self.mLabelName.frame.size.width + self.mLabel.frame.size.width + 23 * scaleDisplay
        var frame = self.mLabelName.frame
        if width > 290.0 * scaleDisplay {
            width = 290.0 * scaleDisplay
            frame.size.width = 290.0 * scaleDisplay - self.mLabel.frame.size.width - 23 * scaleDisplay
        }
        frame.origin.x = (SIZE_WIDTH - width) / 2
        self.mLabelName.frame = frame
        
        frame = self.mLabel.frame
        frame.origin.x = self.mLabelName.frame.maxX + 5 * scaleDisplay
        self.mLabel.frame = frame
        
        frame = self.mImageEdit.frame
        frame.origin.x = self.mLabel.frame.maxX + 5 * scaleDisplay
        self.mImageEdit.frame = frame
    }
    
    func hideHUDProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showHUDProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    private func setLanguageForView(){
        self.mUsernameTitle.text = NSLocalizedString("mypageprofileview_label_name", comment: "")
        self.mNameTitle.text = NSLocalizedString("mypageprofileview_label_username", comment: "")
        self.mEmailTitle.text = NSLocalizedString("mypageprofileview_label_email", comment: "")
        self.mPhoneTitle.text = NSLocalizedString("mypageprofileview_label_number", comment: "")
        self.mBirthDateTitle.text = NSLocalizedString("mypageprofileview_label_date", comment: "")
        self.mBuildingTitle.text = NSLocalizedString("mypageprofileview_label_building", comment: "")
        self.mRoomTitle.text = NSLocalizedString("mypageprofileview_label_room", comment: "")
        self.mFQATitle.text = NSLocalizedString("settingview_label_FAQ", comment: "")
        self.mSettingTitle.text = NSLocalizedString("settingview_navbar", comment: "")
    }

    private func setFontForViews() {
        self.mNameTitle.font = UIFont(name: self.mNameTitle.font.fontName, size: 10 * scaleDisplay)
        self.mUsernameTitle.font = UIFont(name: self.mUsernameTitle.font.fontName, size: 10 * scaleDisplay)
        self.mEmailTitle.font = UIFont(name: self.mEmailTitle.font.fontName, size: 10 * scaleDisplay)
        self.mPhoneTitle.font = UIFont(name: self.mPhoneTitle.font.fontName, size: 10 * scaleDisplay)
        self.mBirthDateTitle.font = UIFont(name: self.mBirthDateTitle.font.fontName, size: 10 * scaleDisplay)
        self.mBuildingTitle.font = UIFont(name: self.mBuildingTitle.font.fontName, size: 10 * scaleDisplay)
        self.mRoomTitle.font = UIFont(name: self.mRoomTitle.font.fontName, size: 10 * scaleDisplay)
        self.mFQATitle.font = UIFont(name: self.mFQATitle.font.fontName, size: 12 * scaleDisplay)
        self.mSettingTitle.font = UIFont(name: self.mSettingTitle.font.fontName, size: 12 * scaleDisplay)

        self.mName.font = UIFont(name: (self.mName.font?.fontName)!, size: 12 * scaleDisplay)
        self.mUsername.font = UIFont(name: (self.mUsername.font?.fontName)!, size: 12 * scaleDisplay)
        self.mEmail.font = UIFont(name: (self.mEmail.font?.fontName)!, size: 12 * scaleDisplay)
        self.mPhone.font = UIFont(name: (self.mPhone.font?.fontName)!, size: 12 * scaleDisplay)
        self.mBirthDate.font = UIFont(name: (self.mBirthDate.font?.fontName)!, size: 12 * scaleDisplay)
        self.mBuilding.font = UIFont(name: (self.mBuilding.font?.fontName)!, size: 12 * scaleDisplay)
        self.mRoom.font = UIFont(name: (self.mRoom.font?.fontName)!, size: 12 * scaleDisplay)
    }

    private func setUpUserInfomationForView(){
        self.mUsername.text = PublicVariables.userInfo.m_name
        self.mEmail.text = PublicVariables.userInfo.m_email
        self.mPhone.text = PublicVariables.userInfo.m_phone
        self.mBuilding.text = PublicVariables.userInfo.m_kabocha_building_name
        self.mName.text = PublicVariables.userInfo.m_nick_name
        self.mRoom.text = PublicVariables.userInfo.m_kabocha_room_number
        if PublicVariables.userInfo.m_birthday != "" {
            let date = Date(timeIntervalSince1970: TimeInterval((PublicVariables.userInfo.m_birthday as NSString).longLongValue))
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd"
            formater.locale = Locale(identifier: "en_US_POSIX")
            self.mBirthDate.text = formater.string(from: date)
        }
        else {
            self.mBirthDate.text = ""
        }
        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeScore, object: PublicVariables.userInfo.m_point)
        if PublicVariables.userInfo.m_icon_path != "" {
            self.mImgAvatar.setImageForm(urlString: PublicVariables.userInfo.m_icon_path, placeHolderImage: nil)
        }
        else {
            self.mImgAvatar.image = #imageLiteral(resourceName: "ic_user_defauft")
        }

        self.mLabelName.text = PublicVariables.userInfo.m_name
        self.setLabelIntop()
    }
    
    // MARK: - Selectors
    
    @IBAction func fqaButtonAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let faqVC = storyboard.instantiateViewController(withIdentifier: "navbarFQAVC") as? NavbarSettingViewController {
            faqVC.navBarCustomView.titleLabel.text = NSLocalizedString("settingview_label_FAQ", comment: "")
            self.present(faqVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingMenu = storyboard.instantiateViewController(withIdentifier: "navbarSettingVC")
        self.present(settingMenu, animated: true, completion: nil)
    }
    
    //MARK: - Segue 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMyPageProfile" {
            let myProfile = segue.destination as! MyPageProfileViewController
            myProfile.mImgForAvatarView = self.mImgAvatar.image
            myProfile.delegate = self
            NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )

            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_MY_PAGE, eventName: ReproEvent.REPRO_SCREEN_MY_PAGE_ACTION_EDIT_PROFILE)
        }
    }
    
    //MARK: - API
    func callAPIGetUserProfile() {
        self.showHUDProgress()
        let param = ["id":PublicVariables.userInfo.m_id]
        APIBase.shareObject.callAPIGetUserProfile(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.object(forKey: "body") as? [String:Any] {
                    let user:User = User(dict:body)
                    PublicVariables.userInfo = user
                    self.setUpUserInfomationForView()
                    FirebaseGlobalMethod.sendUserToServer()
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            self.hideHUDProgress()
        }
    }
}

extension TopMyPageViewController : MyPageProfileViewControllerDelegate {
    func didEditUserInfomation() {
        self.callAPIGetUserProfile()
    }
}
