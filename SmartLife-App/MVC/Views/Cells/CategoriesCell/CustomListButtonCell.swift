//
//  CustomListButtonCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/5/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol CustomListButtonCellDelegate: class {
    func callbackDelegateToClickedButonFirst(sender: CustomListButtonCell?)
    func callbackDelegateToClickedButonSecond(sender: CustomListButtonCell?)
    func callbackDelegateToClickedButonThird(sender: CustomListButtonCell?)
    func callbackDelegateToSetKeyword(sender: CustomListButtonCell?, keyword:String)
    func callbackDelegateToFilterSelect(sender: CustomListButtonCell?)
}

class CustomListButtonCell: UICollectionViewCell {
    @IBOutlet weak var mTopConstraintSearchBarCustomView: NSLayoutConstraint!
    @IBOutlet weak var mTopContraintButtonList: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonList: NSLayoutConstraint!
    

    @IBOutlet weak var mSearchBarCustomView: SearchBarCustomView!
    
    @IBOutlet weak var mButtonFirst: UIButton!
    @IBOutlet weak var mButtonSecond: UIButton!
    @IBOutlet weak var mButtonThird: UIButton!
    
    var scale: CGFloat = DISPLAY_SCALE
    var selectButton:Int = 1
    weak var delegate: CustomListButtonCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        
        
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesViews()
        self.setColorButtonSelected()
    }
    
    private func setConstraintForViews() {
        self.mTopContraintButtonList.constant = 12 * scale
        self.mTopConstraintSearchBarCustomView.constant = 14 * scale
        self.mBottomConstraintButtonList.constant = 14 * scale
    }
    
    private func setFontForViews() {
        self.mButtonFirst.titleLabel!.font = UIFont(name: self.mButtonFirst.titleLabel!.font.fontName, size: 12 * scale)
        self.mButtonSecond.titleLabel!.font = UIFont(name: self.mButtonSecond.titleLabel!.font.fontName, size: 12 * scale)
        self.mButtonThird.titleLabel!.font = UIFont(name: self.mButtonThird.titleLabel!.font.fontName, size: 12 * scale)
    }
    
    private func setPropertiesViews() {
        self.mSearchBarCustomView.delegate = self
        
        self.mButtonFirst.layer.cornerRadius = 2 * scale
        self.mButtonSecond.layer.cornerRadius = 2 * scale
        self.mButtonThird.layer.cornerRadius = 2 * scale
    }
    
    private func setColorButtonSelected() {
        let colorUnselectTitle = lightGrayColor
        let colorUnselectBackground = UIColor(red: 216, green: 216, blue: 216)
        let colorSelectTitle = UIColor.white
        let colorSelectBackground = UIColor.black
        
        self.mButtonFirst.setTitleColor(colorUnselectTitle, for: .normal)
        self.mButtonFirst.backgroundColor = colorUnselectBackground
        
        self.mButtonSecond.setTitleColor(colorUnselectTitle, for: .normal)
        self.mButtonSecond.backgroundColor = colorUnselectBackground
        
        self.mButtonThird.setTitleColor(colorUnselectTitle, for: .normal)
        self.mButtonThird.backgroundColor = colorUnselectBackground
        
        if selectButton == 1 {
            self.mButtonFirst.setTitleColor(colorSelectTitle, for: .normal)
            self.mButtonFirst.backgroundColor = colorSelectBackground
        } else if selectButton == 2 {
            self.mButtonSecond.setTitleColor(colorSelectTitle, for: .normal)
            self.mButtonSecond.backgroundColor = colorSelectBackground
        } else if selectButton == 3 {
            self.mButtonThird.setTitleColor(colorSelectTitle, for: .normal)
            self.mButtonThird.backgroundColor = colorSelectBackground
        }
    }

    func setTitles(title1: String, title2: String, title3 : String) {
        self.mButtonFirst.setTitle(title1, for: .normal)
        self.mButtonSecond.setTitle(title2, for: .normal)
        self.mButtonThird.setTitle(title3, for: .normal)
    }
    
    func setFilterButtonForCell() {
        self.mSearchBarCustomView.delegate = self
        self.mSearchBarCustomView.updateConstraintWhenHaveFilterButton()
    }
    
    
    @IBAction func clickedButtonFirst(_ sender: Any?) {
        selectButton = 1
        self.endEditing(true)
        self.setColorButtonSelected()
        self.delegate?.callbackDelegateToClickedButonFirst(sender: self)
    }
    
    @IBAction func clickedButtonSecond(_ sender: Any?) {
        selectButton = 2
        self.endEditing(true)
        self.setColorButtonSelected()
        self.delegate?.callbackDelegateToClickedButonSecond(sender: self)
    }
    
    @IBAction func clickedButtonThird(_ sender: Any?) {
        selectButton = 3
        self.endEditing(true)
        self.setColorButtonSelected()
        self.delegate?.callbackDelegateToClickedButonThird(sender: self)
    }
}

extension CustomListButtonCell: SearchBarCustomViewDelegate {
    func callbackActionClickedButtonFilter() {
        self.delegate?.callbackDelegateToFilterSelect(sender: self)
    }
    
    func callAPISearchPointItems(keyword: String) {
        self.delegate?.callbackDelegateToSetKeyword(sender: self, keyword: keyword)
    }
}
