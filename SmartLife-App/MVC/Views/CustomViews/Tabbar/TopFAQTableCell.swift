//
//  TopFAQTableCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/27/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class TopFAQTableCell: UITableViewCell {

    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mImageArrow: UIImageView!
    
    
    @IBOutlet weak var mTopConstrainLabelTable: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintImage: NSLayoutConstraint!
    
    var scale: CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraintForViews() {
        self.mTopConstrainLabelTable.constant = 13 * scale
        self.mLeadingConstraintLabelTitle.constant = 14 * scale
        self.mBottomConstraintLabelTitle.constant = 13 * scale
        self.mTrailingConstraintImage.constant = 14 * scale
    }
}
