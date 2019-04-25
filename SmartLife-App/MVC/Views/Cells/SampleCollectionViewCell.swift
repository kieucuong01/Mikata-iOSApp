//
//  SampleCollectionViewCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 9/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class SampleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mViewContent: UIView!
    
    @IBOutlet weak var mTrailingConstraintForView: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabel: NSLayoutConstraint!
    
    var isHeightCalculated: Bool = false

    var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        
        self.setConstraintForView()
        self.setFontForView()
    }
    
    private func setConstraintForView() {
        self.mLeadingConstraintLabel.constant = 5 * scale
        self.mTrailingConstraintForView.constant = 5 * scale
    }
    
    private func setFontForView() {
        self.mLabelTitle.font = UIFont(name: mLabelTitle.font.fontName, size: 14 * scale)
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        //Exhibit A - We need to cache our calculation to prevent a crash.
//        if !isHeightCalculated {
//            setNeedsLayout()
//            layoutIfNeeded()
//            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//            var newFrame = layoutAttributes.frame
//            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
//            layoutAttributes.frame = newFrame
//            isHeightCalculated = true
//        }
//        return layoutAttributes
//    }
    
    func updateDataWithString(string:String) {
        self.mLabelTitle.text = string
        self.mLabelTitle.sizeToFit()
        frame = self.frame
        frame.size.width = self.mLabelTitle.frame.size.width + 10 * scale
        self.frame = frame
    }
}
