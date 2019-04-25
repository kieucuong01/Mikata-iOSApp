//
//  AlertGetPointView..swift
//  SmartLife-App
//
//  Created by thanhlt on 8/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol AlertGetPointViewDelegate: class {
    func closeAlert()
}

class AlertGetPointView: UIView {

    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelDescription: UILabel!
    @IBOutlet weak var mButtonClosePink: UIButton!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var mButtonClose: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     @IBOutlet weak var mPoint: UILabel!
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate:AlertGetPointViewDelegate? = nil
    private var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.mButtonClosePink.layer.cornerRadius = 5.0*scale
        self.mButtonClosePink.clipsToBounds = true
        self.setLanguageForView()
        self.setConstraintForView()
    }
    
    @IBAction func clickButtonCloseBrown(_ sender: Any) {
        self.removeFromSuperview()
        self.delegate?.closeAlert()
    }

    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("alert_getpointview_label_title", comment: "")
        self.mLabelDescription.text = NSLocalizedString("alert_getpointview_label_description", comment: "")
        self.mButtonClosePink.setTitle(NSLocalizedString("alert_getpointview_button_gotogetpoint", comment: ""), for: .normal)
    }

    private func setConstraintForView() {
//        self.mBottomButtonAcceptConstraint.constant = -34 * scale
//        self.mHeightImageNoticeConstraint.constant = 350 * scale
    }

    func changeImageNoticeInView() {
//        self.status = 1
//        self.mHeightImageNoticeConstraint.constant = 270 * scale
//        self.layoutIfNeeded()
//        self.mImageNotice.image = #imageLiteral(resourceName: "img_tutorial_pickSkill_2nd")
    }

    func changeToSuccessView() {
//        self.status = 2
//        self.mButtonClose.isHidden = true
//        self.mHeightImageNoticeConstraint.constant = 167 * scale
//        self.layoutIfNeeded()
//        self.mImageNotice.image = #imageLiteral(resourceName: "img_tutorial_pickSkill_3rd")
    }
}
