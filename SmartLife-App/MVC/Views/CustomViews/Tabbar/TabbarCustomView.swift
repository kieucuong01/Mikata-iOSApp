//
//  TabbarCustomView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/7/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol TabbarCustomViewDelegate: class {
    func calledButtonChat()
    func calledButtonMyPage()
    func calledButtonHomePage()
    func calledButtonAlert()
    func calledButtonChatList()
}

class TabbarCustomView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonTImeLine: UIButton!
    @IBOutlet weak var buttonChat: UIButton!
    @IBOutlet weak var chatNewLabel: UILabel!
    @IBOutlet weak var buttonMyPage: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var notificationNewLabel: UILabel!
    
    @IBOutlet weak var labelTimeLine: UILabel!
    @IBOutlet weak var labelChat: UILabel!
    @IBOutlet weak var labelMyPage: UILabel!
    @IBOutlet weak var labelPopUp: UILabel!
    @IBOutlet weak var labelNotification: UILabel!

    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!

    weak var delegate: TabbarCustomViewDelegate? = nil
    
    var buttonSelecting: UIButton? = nil
    var buttonLabelSelecting: UILabel? = nil

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLanguageForView()
        self.setPropertiesView()
    }

    // MARK: - Public methods
    func setLanguageForView(){
        self.labelTimeLine.text = NSLocalizedString("tabbar_label_timeline", comment: "")
        self.labelChat.text = NSLocalizedString("tabbar_label_chat", comment: "")
        self.labelNotification.text = NSLocalizedString("tabbar_label_notification", comment: "")
        self.labelMyPage.text = NSLocalizedString("tabbar_label_mypage", comment: "")
        self.labelPopUp.text = NSLocalizedString("tabbar_label_popup", comment: "")
    }
    
    func updateStateButtons(isAllOff: Bool) {
        self.buttonTImeLine.isSelected = false
        self.buttonChat.isSelected = false
        self.buttonNotification.isSelected = false
        self.buttonMyPage.isSelected = false
        self.labelTimeLine.textColor = lightGrayColor
        self.labelChat.textColor = lightGrayColor
        self.labelPopUp.textColor = lightGrayColor
        self.labelNotification.textColor = lightGrayColor
        self.labelMyPage.textColor = lightGrayColor
        
        if isAllOff == false {
            self.buttonSelecting?.isSelected = true
            self.buttonLabelSelecting?.textColor = primaryColor
        }
    }

    func changeToHomePage() {
        self.buttonSelecting = self.buttonTImeLine
        self.buttonLabelSelecting = self.labelTimeLine
        self.updateStateButtons(isAllOff: false)
    }
    
    //MARK: - Getter
    private func setPropertiesView() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0

        // ContainerView
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.containerViewHeightConstraint.constant = 60.0 * scale

        // ChatNewLabel
        self.layoutIfNeeded()
        self.chatNewLabel.font = self.chatNewLabel.font.withSize(7.5 * GlobalMethod.displayScale)
        self.chatNewLabel.layer.cornerRadius = self.chatNewLabel.frame.size.width / 2.0
        self.chatNewLabel.clipsToBounds = true
        self.chatNewLabel.isHidden = true

        // NotificationNewLabel
        self.layoutIfNeeded()
        self.notificationNewLabel.font = self.notificationNewLabel.font.withSize(7.5 * GlobalMethod.displayScale)
        self.notificationNewLabel.layer.cornerRadius = self.notificationNewLabel.frame.size.width / 2.0
        self.notificationNewLabel.clipsToBounds = true
        self.checkToShowOrHideNotificationNewLabel()
        
        self.buttonTImeLine.setImage(#imageLiteral(resourceName: "button_home-off"), for: .normal)
        self.buttonChat.setImage( #imageLiteral(resourceName: "button_ChatHistory-off"), for: .normal)
        self.buttonNotification.setImage(#imageLiteral(resourceName: "button_alert-off"), for: .normal)
        self.buttonMyPage.setImage( #imageLiteral(resourceName: "button_Mypage_off"), for: .normal)
        self.buttonTImeLine.setImage(#imageLiteral(resourceName: "button_home-on"), for: .selected)
        self.buttonChat.setImage( #imageLiteral(resourceName: "button_ChatHistory_on"), for: .selected)
        self.buttonNotification.setImage(#imageLiteral(resourceName: "button_alert-on"), for: .selected)
        self.buttonMyPage.setImage( #imageLiteral(resourceName: "button_Mypage_on"), for: .selected)
        
        // Set timeline default
        self.buttonSelecting = self.buttonTImeLine
        self.buttonLabelSelecting = self.labelTimeLine
        self.updateStateButtons(isAllOff: false)
    }
    @IBAction func clickButtonChat(_ sender: Any) {
        self.updateStateButtons(isAllOff: true)
        self.delegate?.calledButtonChat()
    }
    
    @IBAction func clickedButtonHomePage(_ sender: Any) {
        self.buttonSelecting = self.buttonTImeLine
        self.buttonLabelSelecting = self.labelTimeLine
        self.updateStateButtons(isAllOff: false)
        
        self.delegate?.calledButtonHomePage()
    }
    
    @IBAction func clickedButtonChatList(_ sender: Any) {
        self.buttonSelecting = self.buttonChat
        self.buttonLabelSelecting = self.labelChat
        self.updateStateButtons(isAllOff: false)

        self.delegate?.calledButtonChatList()
    }
    
    
    @IBAction func clickedButtonAlert(_ sender: Any) {
        self.buttonSelecting = self.buttonNotification
        self.buttonLabelSelecting = self.labelNotification
        self.updateStateButtons(isAllOff: false)

        self.delegate?.calledButtonAlert()
    }
    
    
    @IBAction func clickedButtonMyPage(_ sender: Any) {
        self.buttonSelecting = self.buttonMyPage
        self.buttonLabelSelecting = self.labelMyPage
        self.updateStateButtons(isAllOff: false)

        self.delegate?.calledButtonMyPage()
    }

    // MARK: - Public Methods
    func setAlphaTitleTabar(alpha: CGFloat){
        self.labelTimeLine.alpha = alpha
        self.labelChat.alpha = alpha
        self.labelMyPage.alpha = alpha
        self.labelPopUp.alpha = alpha
        self.labelNotification.alpha = alpha
    }

    func checkToShowOrHideChatNewLabel() {
        // Default
        self.chatNewLabel.isHidden = true

        // Check new message
        let listRoomId: [String] = Array(FirebaseGlobalMethod.dictLatestMessageIdInRoom.keys)
        for roomId in listRoomId {
            if FirebaseGlobalMethod.checkNewMessageInRoom(roomId: roomId) == true {
                self.chatNewLabel.isHidden = false
                break
            }
        }
    }

    func checkToShowOrHideNotificationNewLabel() {
        self.notificationNewLabel.isHidden = (PublicVariables.userInfo.m_flag_new != "1")
    }
}
