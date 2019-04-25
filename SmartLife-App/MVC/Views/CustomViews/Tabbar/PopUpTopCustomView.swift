//
//  PopUpTopCustomView.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/27/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit


// ---------------- POPUPCustomView

protocol PopUpTopCustomViewDelegate: class {
    func calledButtonConsultation()
    func calledButtonHome()
    func calledButtonChatClose()
}

class PopUpTopCustomView: UIView {

    weak var delegate :PopUpTopCustomViewDelegate? = nil
    var foregroundView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT))
        view.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#1A0E02").withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action:#selector(PopUpTopCustomView.clickButtonChatClose(sender:)))
        view.addGestureRecognizer(tap)
        return view
    }()

    var labelView : UILabel = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let y = SIZE_HEIGHT

        let label = UILabel(frame: CGRect(x: 0, y: y, width: SIZE_WIDTH, height: 15 * scale))
        label.font = UIFont(name: "YuGothic-Bold", size: 14)
        label.text = NSLocalizedString("popuptopcustomview_label_top", comment: "")
        label.textAlignment = .center
        label.tag = 3
        label.textColor = UIColor.white

        return label
    }()

    var buttonConsultation: UIView = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let x = SIZE_WIDTH/2 - (32.0 * scale)
        let y = SIZE_HEIGHT
        let view = UIView(frame: CGRect(x: x, y: y, width: 90.0 * scale, height: 72.0 * scale))
        view.tag = 1

        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 90.0 * scale, height: 50.0 * scale))
        button.setImage(UIImage(named:"button-consultation"), for: .normal)
        button.addTarget(self, action: #selector(PopUpTopCustomView.clickButtonConsultation(sender:)), for: .touchUpInside)

        let label = UILabel(frame: CGRect(x: 0, y: 53.0 * scale, width: 90.0 * scale, height: 12 * scale))
        label.font = UIFont(name: "YuGothic-Bold", size: 11)
        label.text = NSLocalizedString("tabbar_consultation_button", comment: "")
        label.textAlignment = .center
        label.textColor = UIColor.white

        view.addSubview(button)
        view.addSubview(label)
        return view
    }()

    var buttonHome: UIView = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let x = SIZE_WIDTH/2 - 32 * scale
        let y = SIZE_HEIGHT
        let view = UIView(frame: CGRect(x: x, y: y, width: 90.0 * scale, height: 72.0 * scale))
        view.tag = 2

        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 90 * scale, height: 50.0 * scale))
        button.setImage(UIImage(named:"button_house"), for: .normal)
        button.addTarget(self, action: #selector(PopUpTopCustomView.clickButtonHome(sender:)), for: .touchUpInside)

        let label = UILabel(frame: CGRect(x: 0, y: 53.0 * scale, width: 90.0 * scale, height: 12 * scale))
        label.font = UIFont(name: "YuGothic-Bold", size: 11)
        label.text = NSLocalizedString("tabbar_home_button", comment: "")
        label.textAlignment = .center
        label.textColor = UIColor.white

        view.addSubview(button)
        view.addSubview(label)
        return view
    }()


    var butonChat: UIButton = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let x = SIZE_WIDTH/2.0 - SIZE_WIDTH/10.0 - 0.5
        let y = SIZE_HEIGHT - 64 * scale - GlobalMethod.getBottomPadding()
        let button = UIButton(frame: CGRect(x: x, y: y, width: SIZE_WIDTH/5.0, height: 50 * scale))
        button.tag = 4
        button.setImage(UIImage(named:"button-chat-close"), for: .normal)
        button.addTarget(self, action: #selector(PopUpTopCustomView.clickButtonChatClose(sender:)), for: .touchUpInside)
        return button
    }()

    var buttonChatLabel: UILabel = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let x = SIZE_WIDTH/2.0 - SIZE_WIDTH/10.0 - 0.5
        let y = SIZE_HEIGHT - 14 * scale - GlobalMethod.getBottomPadding()
        let buttonChatLabel = UILabel(frame: CGRect(x: x, y: y, width: SIZE_WIDTH/5.0, height: 10 * scale))
        buttonChatLabel.font = UIFont(name: "YuGothic-Bold", size: 10.0)
        buttonChatLabel.text = NSLocalizedString("tabbar_label_popup", comment: "")
        buttonChatLabel.textColor = primaryColor
        buttonChatLabel.textAlignment = .center
        return buttonChatLabel
    }()

    @objc func clickButtonConsultation(sender: Any?) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ADD_NEW_CONSULTATION, eventName: ReproEvent.REPRO_SCREEN_ADD_NEW_CONSULTATION_ACTION_CHOOSE_JOB)
        self.resetView()
        self.delegate?.calledButtonConsultation()
    }

    @objc func clickButtonHome(sender: Any?) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ADD_NEW_CONSULTATION, eventName: ReproEvent.REPRO_SCREEN_ADD_NEW_CONSULTATION_ACTION_CHOOSE_HOUSE)
        self.resetView()
        self.delegate?.calledButtonHome()

    }

    @objc func clickButtonChatClose(sender: Any?) {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        let buttonChat = self.viewWithTag(4) as! UIButton
        buttonChat.isUserInteractionEnabled = false

        if let buttonHome = self.viewWithTag(1) {
            if let buttonConsultant = self.viewWithTag(2) {

                let xConsultant = SIZE_WIDTH/2 + 19 * scale
                let xHome = SIZE_WIDTH/2 - 102 * scale
                let y = SIZE_HEIGHT - (137 * scale) - GlobalMethod.getBottomPadding()


                UIView.animate(withDuration: 0.4, animations: {
                    buttonHome.frame.origin.x = xHome
                    buttonHome.frame.origin.y = y

                    buttonConsultant.frame.origin.x = xConsultant
                    buttonConsultant.frame.origin.y = y
                }, completion: { finised in
                    buttonHome.frame.origin.x = xHome
                    buttonHome.frame.origin.y = y

                    buttonConsultant.frame.origin.x = xConsultant
                    buttonConsultant.frame.origin.y = y

                    let x = SIZE_WIDTH/2 - 32 * scale
                    let y = SIZE_HEIGHT

                    UIView.animate(withDuration: 0.3, animations: {
                        buttonHome.frame.origin.x = x
                        buttonHome.frame.origin.y = y

                        buttonConsultant.frame.origin.x = x
                        buttonConsultant.frame.origin.y = y
                    },completion: { finised in
                        buttonHome.frame.origin.x = x
                        buttonHome.frame.origin.y = y

                        buttonConsultant.frame.origin.x = x
                        buttonConsultant.frame.origin.y = y
                        if let labelTitle = self.viewWithTag(3) as? UILabel {
                            let y = SIZE_HEIGHT

                            self.butonChat.setImage(UIImage(named:"button_chat-off"), for: .normal)
                            self.butonChat.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/4.0))
                            UIView.animate(withDuration: 0.4, animations: {
                                labelTitle.frame.origin.y = y
                                self.butonChat.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/2.0))
                            },completion: {finised in
                                buttonChat.isUserInteractionEnabled = true
                                self.isHidden = true
                                self.butonChat.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/2.0))
                                FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.updateStateButtons(isAllOff: false)
                            })
                        }

                    })

                })
            }
        }
    }

    func resetView(){
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        if let buttonHome = self.viewWithTag(1) {
            let x = SIZE_WIDTH/2 - 32 * scale
            let y = SIZE_HEIGHT
            buttonHome.frame.origin.x = x
            buttonHome.frame.origin.y = y
        }

        if let buttonConsultant = self.viewWithTag(2) {
            let x = SIZE_WIDTH/2 - 32 * scale
            let y = SIZE_HEIGHT
            buttonConsultant.frame.origin.x = x
            buttonConsultant.frame.origin.y = y
        }

        if let labelTitle = self.viewWithTag(3) as? UILabel {
            let y = SIZE_HEIGHT
            labelTitle.frame.origin.y = y
        }
    }

    func updateButtonChat(isHideTitle : Bool) {
        let y = SIZE_HEIGHT - 64 * GlobalMethod.displayScale - GlobalMethod.getBottomPadding()
        if isHideTitle == true {
            self.butonChat.frame = CGRect(x: self.butonChat.frame.origin.x, y: y + 14 * GlobalMethod.displayScale, width: self.butonChat.frame.size.width, height: self.butonChat.frame.size.height)
            self.buttonChatLabel.isHidden = true
        }
        else {
            self.butonChat.frame = CGRect(x: self.butonChat.frame.origin.x, y: y, width: self.butonChat.frame.size.width, height: self.butonChat.frame.size.height)
            self.buttonChatLabel.isHidden = false
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubViews()
    }

    func createSubViews() {

        self.addSubview(self.foregroundView)
        self.addSubview(self.labelView)
        self.addSubview(self.buttonConsultation)
        self.addSubview(self.buttonHome)
        self.addSubview(self.butonChat)
        self.addSubview(self.buttonChatLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Animation

    func showButtonChatAnimation() {
        self.butonChat.setImage(UIImage(named:"button-chat-close"), for: .normal)
        self.butonChat.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/4.0))
        UIView.animate(withDuration: 0.4, animations: {
            self.butonChat.transform = CGAffineTransform.identity
        }) { (complete: Bool) in
            self.butonChat.transform = CGAffineTransform.identity
        }
    }
}
