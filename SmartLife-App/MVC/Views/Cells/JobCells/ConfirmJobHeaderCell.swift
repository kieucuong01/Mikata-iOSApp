//
//  ConfirmJobHeaderCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ConfirmJobHeaderCellDelegate: class {
    func callbackDelegateToClickedButtonClose(sender: ConfirmJobHeaderCell?)
    
}

class ConfirmJobHeaderCell: UITableViewCell {
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelHeader: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelHeader: NSLayoutConstraint!

    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelHeader: UILabel!
    
    weak var delegateView: ConfirmJobHeaderCellDelegate? = nil
    
    var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
        self.setLanguageForView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("confirmapplyjobview_label_title", comment: "")
        self.mLabelHeader.text = NSLocalizedString("confirmapplyjobview_section_submission_detail", comment: "")
    }

    private func setConstraintForViews() {
        self.mTopConstraintLabelTitle.constant = 36 * scale
        self.mTopConstraintLabelHeader.constant = 45 * scale
        self.mBottomConstraintLabelHeader.constant = 11 * scale
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scale)
        self.mLabelHeader.font = UIFont(name: self.mLabelHeader.font.fontName, size: 16 * scale)
    }
    
    @IBAction func clickedButtonClose(_ sender: Any) {
        self.delegateView?.callbackDelegateToClickedButtonClose(sender: self)
    }
    
}
