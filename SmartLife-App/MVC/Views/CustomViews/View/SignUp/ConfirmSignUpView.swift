//
//  ConfirmSignUpView.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ConfirmSignUpViewDelegate: class {
    func clickedButtonCloseInViewSuccess(sender: ConfirmSignUpView)
    func clickedButtonConfirmUser(sender: ConfirmSignUpView)
}

class ConfirmSignUpView: UIView {

    //UIConstraint
    @IBOutlet weak var mTopLabelTitleViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelCodeConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelFullNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingLabelFullNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTrailingFullNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingLabelValueFullNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelNickNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelEmailConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelPasswordConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelPhoneNumberConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelBirthDayConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelBuildingsConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelRoomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopButtonUpdateConstraint: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonSuccess: NSLayoutConstraint!
    
    //UIView
    @IBOutlet weak var mLabelTitleView: UILabel!
    @IBOutlet weak var mLabelCode: UILabel!
    @IBOutlet weak var mLabelValueCode: UILabel!
    @IBOutlet weak var mLabelFullName: UILabel!
    @IBOutlet weak var mLabelValueFullName: UILabel!
    @IBOutlet weak var mLabelNickName: UILabel!
    @IBOutlet weak var mLabelValueNickName: UILabel!
    @IBOutlet weak var mLabelEmail: UILabel!
    @IBOutlet weak var mLabelValueEmail: UILabel!
    @IBOutlet weak var mLabelPassword: UILabel!
    @IBOutlet weak var mLabelValuePassword: UILabel!
    @IBOutlet weak var mLabelPhoneNumber: UILabel!
    @IBOutlet weak var mLabelValuePhoneNumber: UILabel!
    @IBOutlet weak var mLabelBirthday: UILabel!
    @IBOutlet weak var mLabelValueBirthday: UILabel!
    @IBOutlet weak var mLabelBuildings: UILabel!
    @IBOutlet weak var mLabelValueBuildings: UILabel!
    @IBOutlet weak var mLabelRoom: UILabel!
    @IBOutlet weak var mLabelValueRoom: UILabel!
    
    @IBOutlet weak var mViewConfirm: UIView!
    @IBOutlet weak var mViewSuccess: UIView!
    @IBOutlet weak var mLabelSuccess: UILabel!
    
    weak var delegate:ConfirmSignUpViewDelegate? = nil
    
    private var scale:CGFloat = DISPLAY_SCALE
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setLanguageForView()
        self.setConstraintForView()
        self.setFontForView()
    }

    private func setLanguageForView(){
        self.mLabelTitleView.text = NSLocalizedString("popup_confirmsignupview_label_title", comment: "")
        self.mLabelCode.text = NSLocalizedString("registerview_label_code", comment: "")
        self.mLabelFullName.text = NSLocalizedString("registerview_label_fullname", comment: "")
        self.mLabelNickName.text = NSLocalizedString("registerview_label_username", comment: "")
        self.mLabelEmail.text = NSLocalizedString("registerview_label_email", comment: "")
        self.mLabelPassword.text = NSLocalizedString("registerview_label_password", comment: "")
        self.mLabelPhoneNumber.text = NSLocalizedString("registerview_label_phonenumber", comment: "")
        self.mLabelBirthday.text = NSLocalizedString("registerview_label_birthday", comment: "")
        self.mLabelBuildings.text = NSLocalizedString("registerview_label_building", comment: "")
        self.mLabelRoom.text = NSLocalizedString("registerview_label_room", comment: "")
//        self.mButtonCheck.setTitle(NSLocalizedString("registerview_button_check", comment: ""), for: .normal)
//        self.mButtonCheck.setTitle(NSLocalizedString("registerview_button_check", comment: ""), for: .normal)
    }
    
    private func setConstraintForView() {
        self.mTopLabelTitleViewConstraint.constant = 35 * scale
        self.mLeadingLabelFullNameConstraint.constant = 14 * scale
        self.mTrailingFullNameConstraint.constant = 14 * scale
        self.mLeadingLabelValueFullNameConstraint.constant = 120 * scale
        self.mTopLabelCodeConstraint.constant = 26 * scale
        self.mTopLabelFullNameConstraint.constant = 17 * scale
        self.mTopLabelEmailConstraint.constant = 17 * scale
        self.mTopLabelPasswordConstraint.constant = 17 * scale
        self.mTopLabelPhoneNumberConstraint.constant = 17 * scale
        self.mTopLabelBirthDayConstraint.constant = 17 * scale
        self.mTopLabelBuildingsConstraint.constant = 17 * scale
        self.mTopLabelRoomConstraint.constant = 17 * scale
        self.mTopButtonUpdateConstraint.constant = 24 * scale
        self.mBottomConstraintButtonSuccess.constant = 28 * scale
    }
    
    private func setFontForView() {
        self.mLabelTitleView.font = UIFont.boldSystemFont(ofSize: 12 * scale)
        self.mLabelCode.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValueCode.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelFullName.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValueFullName.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelNickName.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValueNickName.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelValueEmail.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelPassword.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValuePassword.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelPhoneNumber.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValuePhoneNumber.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelBirthday.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValueBirthday.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelBuildings.font = UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValueBuildings.font = UIFont.systemFont(ofSize: 12 * scale)
        self.mLabelRoom.font =  UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelValueRoom.font =  UIFont.systemFont(ofSize: 10 * scale)
        self.mLabelSuccess.font = UIFont(name: self.mLabelSuccess.font.fontName, size: 14 * scale)
    }
    
    func updateDateForView(code: String, fullname:String, nickname:String, email:String, password: String, phone:String, birthday:String, building:String?, room:String) {
        self.mLabelValueCode.text = code
        self.mLabelValueFullName.text = fullname
        self.mLabelValueNickName.text = nickname
        self.mLabelValueEmail.text = email
        var string:String = ""
        if password.isEmpty == false {
            for _ in 0 ... password.count - 1 {
                string += "*"
            }
        }
        self.mLabelValueBirthday.text = birthday
        self.mLabelValuePassword.text = string
        self.mLabelValuePhoneNumber.text = phone
        self.mLabelValueRoom.text = room
        self.mLabelValueBuildings.text = building
        self.mViewConfirm.isHidden = false
    }
    
    @IBAction func clickedButtonUpdate(_ sender: Any) {
        self.isHidden = true
    }
    
    @IBAction func clickedButtonClose(_ sender: Any) {
        self.delegate?.clickedButtonCloseInViewSuccess(sender: self)
    }
    
    @IBAction func clickedButtonConfirm(_ sender: Any) {
        self.mViewConfirm.isHidden = true
        self.delegate?.clickedButtonConfirmUser(sender: self)
    }
}
