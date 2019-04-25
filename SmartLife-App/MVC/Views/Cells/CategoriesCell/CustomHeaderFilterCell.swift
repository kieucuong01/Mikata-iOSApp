//
//  CustomHeaderFilterCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/6/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol CustomHeaderFilterCellDelegate: class {
    func callbackDelegateToClickedButtonLeft(sender:CustomHeaderFilterCell?)
    func callbackDelegateToClickedButtonRight(sender:CustomHeaderFilterCell?)
}

class CustomHeaderFilterCell: UITableViewCell {

    @IBOutlet weak var mViewContentTwoButtons: UIView!
    @IBOutlet weak var mButtonLeft: UIButton!
    @IBOutlet weak var mButtonRight: UIButton!
    weak var delegate: CustomHeaderFilterCellDelegate? = nil
    var scale:CGFloat = DISPLAY_SCALE
    var selectButton:Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setFontForViews()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.setColorButtonSelected()
        // Configure the view for the selected state
    }
    
    func setFontForViews() {
        self.mButtonLeft.titleLabel!.font = UIFont(name: self.mButtonLeft.titleLabel!.font.fontName, size: 12 * scale)
        self.mButtonRight.titleLabel!.font = UIFont(name: self.mButtonRight.titleLabel!.font.fontName, size: 12 * scale)
        
        self.mViewContentTwoButtons.layer.cornerRadius = 3 * scale
        self.mViewContentTwoButtons.layer.borderWidth = 1
        self.mViewContentTwoButtons.layer.borderColor = GlobalMethod.hexStringToUIColor(hex: "#B89F98").cgColor
    }
    
    func setColorButtonSelected() {
        let colorUnselectTitle = GlobalMethod.hexStringToUIColor(hex: "#6C5032")
        let colorUnselectBackground = GlobalMethod.hexStringToUIColor(hex: "#FEF6EF")
        let colorSelectTitle = UIColor.white
        let colorSelectBackground = GlobalMethod.hexStringToUIColor(hex: "#B89F98")
        
        self.mButtonLeft.setTitleColor(colorUnselectTitle, for: .normal)
        self.mButtonLeft.backgroundColor = colorUnselectBackground
        
        self.mButtonRight.setTitleColor(colorUnselectTitle, for: .normal)
        self.mButtonRight.backgroundColor = colorUnselectBackground
        
        
        if selectButton == 1 {
            self.mButtonLeft.setTitleColor(colorSelectTitle, for: .normal)
            self.mButtonLeft.backgroundColor = colorSelectBackground
        } else {
            self.mButtonRight.setTitleColor(colorSelectTitle, for: .normal)
            self.mButtonRight.backgroundColor = colorSelectBackground
        }
    }
    
    @IBAction func clickedButtonLeft(_ sender: Any) {
        self.selectButton = 1
        self.setColorButtonSelected()
        self.delegate?.callbackDelegateToClickedButtonLeft(sender: self)
        
    }
    @IBAction func clickedButtonRight(_ sender: Any) {
        self.selectButton = 2
        self.setColorButtonSelected()
        self.delegate?.callbackDelegateToClickedButtonRight(sender: self)
    }
}
