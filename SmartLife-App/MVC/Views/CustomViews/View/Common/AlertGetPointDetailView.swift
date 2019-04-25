//
//  AlertGetPointView..swift
//  SmartLife-App
//
//  Created by thanhlt on 8/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol AlertGetPointDetailViewDelegate: class {
    func closeAlert()
}

class AlertGetPointDetailView: UIView {

    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelDescription: UILabel!
    @IBOutlet weak var mLabelMessage: UILabel!
    @IBOutlet weak var mButtonClosePink: UIButton!
    @IBOutlet weak var mButtonClose: UIButton!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    weak var delegate:AlertGetPointDetailViewDelegate? = nil
    private var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLanguageForView()
        self.setPropertiesForView()
    }

    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("alert_getpointview_label_title", comment: "")
        self.mLabelDescription.text = NSLocalizedString("alert_getpointview_label_description", comment: "")
        self.mButtonClosePink.setTitle(NSLocalizedString("alert_getpointview_button_gotogetpoint", comment: ""), for: .normal)
    }

    private func setPropertiesForView(){
        self.mButtonClosePink.layer.cornerRadius = 5.0*scale
        self.mButtonClosePink.clipsToBounds = true
    }

    @IBAction func clickButtonCloseBrown(_ sender: Any) {
        self.removeFromSuperview()
        self.delegate?.closeAlert()
    }
    
}
