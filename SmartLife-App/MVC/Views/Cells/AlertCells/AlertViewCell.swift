//
//  AlertViewCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 9/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class AlertViewCell: UITableViewCell {

    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintLabelTitle: NSLayoutConstraint!
    
    
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mBotttomLineView: UIView!
    var indexPath:IndexPath = IndexPath()
    var scale: CGFloat = DISPLAY_SCALE
    var object:NotificationObj = NotificationObj()
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        self.setConstraintForViews()
        self.setFontForViews()
    }
    
    //MARK: - Private method
    private func setConstraintForViews() {
        self.mLeadingConstraintLabelTitle.constant = 16 * scale
        self.mTrailingConstraintLabelTitle.constant = 16 * scale
    }
    
    private func setFontForViews() {
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName, size: 8 * scale)
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 12 * scale)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateAlertViewCellAtIndexPath(index:IndexPath ,andObject notificationObj:NotificationObj) {
        self.object = notificationObj
        self.mLabelTitle.text = object.title
        if let time = Double(object.created) {
            let date = Date(timeIntervalSince1970: time)
            let format = DateFormatter()
            format.dateFormat = "yyyy/MM/dd"
            format.locale = Locale(identifier: "en_US_POSIX")
            self.mLabelDate.text = format.string(from: date)
        } else {
            self.mLabelDate.text = ""
        }
        self.indexPath = index
    }

    
}
