//
//  JobFirstGuideCellTableViewCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/9/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class JobFirstGuideCellTableViewCell: UITableViewCell {

    @IBOutlet weak var mLabelContent: UILabel!
    
    var scale: CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setLanguageForView()
        self.setPropertiesForViews()
        self.setConstraintForViews()
        self.setFontForViews()
    }

    private func setLanguageForView(){
        self.mLabelContent.text = NSLocalizedString("createformjobview_label_first_guide_content", comment: "")
    }
    
    private func setPropertiesForViews() {
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
    }
    
    private func setConstraintForViews() {
    }
    
    private func setFontForViews() {
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 12 * scale)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
