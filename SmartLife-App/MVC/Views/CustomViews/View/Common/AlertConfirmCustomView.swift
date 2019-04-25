//
//  AlertConfirmCustomView.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol AlertConfirmCustomViewDelegate: class {
    func callbackActionClickedButtonDecline()
    func callbackActionClickedButtonAccept()
    func callbackActionClickedButtonSuccess()
}

class AlertConfirmCustomView: UIView {

    @IBOutlet weak var mConfirmView: UIView!
    @IBOutlet weak var mLabelConfirmTitle: UILabel!
    @IBOutlet weak var mButtonDecline: UIButton!
    @IBOutlet weak var mButtonAccept: UIButton!
    
    @IBOutlet weak var mSuccessView: UIView!
    @IBOutlet weak var mLabelSuccessView: UILabel!
    @IBOutlet weak var mButtonSuccess: UIButton!
    
    
    @IBOutlet weak var mTopConstraintLabelConfirmTitle: NSLayoutConstraint!
    
    @IBOutlet weak var mTopConstraintConfirmView: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelConfirmTitle: NSLayoutConstraint!
    
    @IBOutlet weak var mTopConstraintLabelSuccess: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonSuccess: NSLayoutConstraint!
    
    weak var delegate: AlertConfirmCustomViewDelegate? = nil
    
    /* 0: - nil
       1: - show confirm
       2: - show success */
    var statusAction = 0
    var scale:CGFloat = DISPLAY_SCALE
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
        self.setConstraintForViews()
        self.setLanguageForView()
        self.setFontForViews()
        self.setLayersForViews()
    }

    private func setLanguageForView(){
        self.mLabelConfirmTitle.text = NSLocalizedString("alert_confirmcustomview_label_confirmtitle", comment: "")
        self.mLabelSuccessView.text = NSLocalizedString("alert_confirmcustomview_label_successtitle", comment: "")

        self.mButtonDecline.setTitle(NSLocalizedString("common_button_cancel", comment: ""), for: .normal)
        self.mButtonAccept.setTitle(NSLocalizedString("common_button_ok", comment: ""), for: .normal)
        self.mButtonSuccess.setTitle(NSLocalizedString("alert_confirmcustomview_button_success", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        self.mTopConstraintLabelConfirmTitle.constant = 38 * scale
        self.mBottomConstraintLabelConfirmTitle.constant = 28 * scale
        self.mTopConstraintConfirmView.constant = 170 * scale
        self.mTopConstraintLabelSuccess.constant = 30 * scale
        self.mBottomConstraintButtonSuccess.constant = 28 * scale
    }
    
    private func setFontForViews() {
        self.mLabelConfirmTitle.font = UIFont(name: self.mLabelConfirmTitle.font.fontName, size: 14 * scale)
        self.mButtonDecline.titleLabel!.font = UIFont(name: self.mButtonDecline.titleLabel!.font.fontName, size: 14 * scale)
        self.mButtonAccept.titleLabel!.font = UIFont(name: self.mButtonAccept.titleLabel!.font.fontName, size: 14 * scale)
        self.mButtonSuccess.titleLabel!.font = UIFont(name: self.mButtonSuccess.titleLabel!.font.fontName, size: 14 * scale)
    }
    
    private func setLayersForViews() {
        self.mButtonAccept.layer.cornerRadius = 4
        self.mButtonSuccess.layer.cornerRadius = 4
        self.mButtonDecline.layer.cornerRadius = 4
        self.mButtonDecline.layer.borderWidth = 1
        self.mButtonDecline.layer.borderColor = GlobalMethod.hexStringToUIColor(hex: "#6C5032").cgColor
    }
    
    @IBAction func clickedButtonDeclined(_ sender: Any) {
        self.isHidden = true
        self.delegate?.callbackActionClickedButtonDecline()
    }
    @IBAction func clickedButtonAccept(_ sender: Any) {
        if statusAction == 0 {
            self.mConfirmView.isHidden = true
            self.mSuccessView.isHidden = false
        } else {
            self.isHidden = true
        }
        self.delegate?.callbackActionClickedButtonAccept()
    }
    
    @IBAction func clickedButtonSuccess(_ sender: Any) {
        self.isHidden = true
        self.delegate?.callbackActionClickedButtonSuccess()
    }
    
    func updateAlertViewWithDict(dict : [String:String?]) {
        if let action = dict["action"] {
            if action == "1" {
                statusAction = 1
                self.mLabelConfirmTitle.text = dict["lbl_confirm_title"]!
                self.mButtonDecline.setTitle(dict["lbl_button_decline"]!, for: .normal)
                self.mButtonAccept.setTitle(dict["lbl_button_accept"]!, for: .normal)
                self.mConfirmView.isHidden = false
                self.mSuccessView.isHidden = true
            } else if action == "2" {
                
                statusAction = 2
                self.mButtonSuccess.setTitle(dict["lbl_button_success"]!, for: .normal)
                self.mLabelSuccessView.text = dict["lbl_success_title"]!
                self.mConfirmView.isHidden = true
                self.mSuccessView.isHidden = false
            }
        } else {
            statusAction = 0
            self.mLabelConfirmTitle.text = dict["lbl_confirm_title"]!
            self.mButtonDecline.setTitle(dict["lbl_button_decline"]!, for: .normal)
            self.mButtonAccept.setTitle(dict["lbl_button_accept"]!, for: .normal)
            self.mLabelSuccessView.text = dict["lbl_success_title"]!
            self.mButtonSuccess.setTitle(dict["lbl_button_success"]!, for: .normal)
            self.mConfirmView.isHidden = false
            self.mSuccessView.isHidden = true
        }
    }
}
