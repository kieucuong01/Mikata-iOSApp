//
//  ConfirmJobPropertiesCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ConfirmJobPropertiesCell: UITableViewCell {

    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelContent: NSLayoutConstraint!
    
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mLabelTitle: UILabel!
    
    var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        
        self.setConstraintForViews()
        self.setFontForViews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraintForViews() {
        self.mLeadingConstraintLabelTitle.constant = 29 * scale
        self.mTopConstraintLabelContent.constant = 9 * scale
        self.mBottomConstraintLabelContent.constant = 20 * scale
    }

    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 10 * scale)
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 12 * scale)
    }
    
    func updateDataWithDict(item:[String:String]) {
        self.mLabelTitle.text = item["name"]
        self.mLabelContent.text = item["description"]
    }
}
