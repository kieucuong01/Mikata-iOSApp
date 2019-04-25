//
//  PointPassHeader.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class PointPassbookHeaderView: UIView {

    @IBOutlet weak var mBottomConstraintView: NSLayoutConstraint!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mLabelBalancesOfPayment: UILabel!
    @IBOutlet weak var mLabelBalance: UILabel!
    
    var scale : CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setLanguageForView()
        self.setFontForViews()
    }
    
    private func setLanguageForView(){
        self.mLabelDate.text = NSLocalizedString("pointpassbookheaderview_label_date", comment: "")
        self.mLabelContent.text = NSLocalizedString("pointpassbookheaderview_label_content", comment: "")
        self.mLabelBalancesOfPayment.text = NSLocalizedString("pointpassbookheaderview_label_balanceofpayment", comment: "")
        self.mLabelBalance.text = NSLocalizedString("pointpassbookheaderview_label_balance", comment: "")
    }

    private func setFontForViews() {
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName, size: 9 * scale)
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 9 * scale)
        self.mLabelBalancesOfPayment.font = UIFont(name: self.mLabelBalancesOfPayment.font.fontName, size: 9 * scale)
        self.mLabelBalance.font = UIFont(name: self.mLabelBalance.font.fontName, size: 9 * scale)
        self.mBottomConstraintView.constant = 8 * scale
    }
    
    func emptyContent() {
        
        self.mLabelDate.text = ""
        self.mLabelContent.text = ""
        self.mLabelBalancesOfPayment.text = ""
        self.mLabelBalance.text = ""
    }
}
