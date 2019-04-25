//
//  NoticeSelectSkillView..swift
//  SmartLife-App
//
//  Created by thanhlt on 8/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol NoticeSelectSkillViewDelegate: class {
    func finishedProgressCheckSkill()
}

class NoticeSelectSkillView: UIView {

    @IBOutlet weak var titleSuccessLabel: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var descriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipButtonTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var okButtonBottomConstraint: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate:NoticeSelectSkillViewDelegate? = nil
    private var status:Int = 0
    private var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setLanguageForView()
        self.setAttributesForConfirmView()
        self.setAttributesForSuccessView()
    }
    
    @IBAction func clickCloseButton(_ sender: Any) {
        self.isHidden = true
    }

    @IBAction func clickSkipButton(_ sender: Any) {
        self.isHidden = true
        self.delegate?.finishedProgressCheckSkill()
    }

    @IBAction func clickConfirmButton(_ sender: Any) {
        self.isHidden = true
    }

    @IBAction func clickOkButton(_ sender: Any) {
        self.isHidden = true
        self.delegate?.finishedProgressCheckSkill()
    }

    private func setLanguageForView(){
        self.titleSuccessLabel.text = NSLocalizedString("popup_noticeselectskillview_label_title_success", comment: "")
        self.titleLabel.text = NSLocalizedString("popup_noticeselectskillview_label_title", comment: "")
        self.descriptionLabel.text = NSLocalizedString("popup_noticeselectskillview_label_description", comment: "")

        self.skipButton.setTitle(NSLocalizedString("popup_noticeselectskillview_button_skip", comment: ""), for: .normal)
        self.confirmButton.setTitle(NSLocalizedString("popup_noticeselectskillview_button_confirm", comment: ""), for: .normal)
    }

    private func setAttributesForConfirmView() {
        // ConfirmView
        self.confirmView.isHidden = false

        // TitleLabel
        self.titleLabel.font = self.titleLabel.font.withSize(13.5 * self.scale)

        // DescriptionLabel
        self.descriptionLabelTopConstraint.constant = 17.0 * self.scale
        self.descriptionLabel.font = self.descriptionLabel.font.withSize(11.0 * self.scale)

        // SkipButton
        self.skipButtonTopConstraint.constant = 17.0 * self.scale
        self.skipButton.layer.cornerRadius = 3.0
        self.skipButton.layer.borderWidth = 0.8 * self.scale
        self.skipButton.layer.borderColor = UIColor(red: 108.0/255.0, green: 80.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor
        self.skipButton.titleLabel?.font = self.skipButton.titleLabel?.font.withSize(13.5 * self.scale)

        // ConfirmButton
        self.confirmButtonTopConstraint.constant = 17.0 * self.scale
        self.confirmButton.layer.cornerRadius = 3.0
        self.confirmButton.titleLabel?.font = self.confirmButton.titleLabel?.font.withSize(13.5 * self.scale)
    }

    private func setAttributesForSuccessView() {
        // SuccessView
        self.successView.isHidden = true

        // OkButton
        self.okButtonBottomConstraint.constant = -28.0 * self.scale
    }

    func changeToSuccessView() {
        self.status = 1
        self.confirmView.isHidden = true
        self.successView.isHidden = false
    }
}
