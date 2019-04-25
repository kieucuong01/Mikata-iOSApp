//
//  ByteDetailCustomCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ByteDetailCustomCellDelegate: class {
    func callbackDelegateToClickedButtonFavorite()
}

class ByteDetailCustomCell: UITableViewCell {
/*  Begin set constant*/
    @IBOutlet weak var mTopConstraintLabeltop: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonGetPoint: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonApply: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintbuttonApplyByPhone: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelDate: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewShareButton: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewLine2: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitleCompany: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabelTitleCompany: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitleNameCompany: NSLayoutConstraint!
    
    @IBOutlet weak var mLeadingConstraintLabelNameCompany: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintLabelNameCompany: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitleBusinessContent: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitleLocation: NSLayoutConstraint!
    @IBOutlet weak var mTopconstraintlabelTitleURL: NSLayoutConstraint!
    
    @IBOutlet weak var mTopConstraintLineView3: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelCopyRight: NSLayoutConstraint!
    
/*  End set constant*/
    
    
    
    /** Variable couldn't change value  - DON'T CARE */
    @IBOutlet weak var mLabeltop: UILabel!
    @IBOutlet weak var mButtonFavorite: UIButton!
    @IBOutlet weak var mButtonApply: UIButton!
    @IBOutlet weak var mButtonApplyByTelephone: UIButton!
    
    @IBOutlet weak var mLabelTitleCompany: UILabel!
    @IBOutlet weak var mLabelTitleNameCompany: UILabel!
    @IBOutlet weak var mLabelTitleBusinessContent: UILabel!
    @IBOutlet weak var mLabelTitleLocaiton: UILabel!
    @IBOutlet weak var mLabelTitleURL: UILabel!
    @IBOutlet weak var mLabelTitleCopyright: UILabel!
    /** Variable couldn't change value */
    
    
    
    
    /** Variable allow change value  - UPDATE VALUE IS HERE*/
    @IBOutlet weak var mButtonGetPoint: UIButton!
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mLabelNameCompany: UILabel!
    @IBOutlet weak var mLabelBusinessContent: UILabel!
    @IBOutlet weak var mLabelLocation: UILabel!
    @IBOutlet weak var mLabelURL: UILabel!
    
    /** Variable allow change value */
    
    
    /** Private variable */
    var scale:CGFloat = DISPLAY_SCALE
    weak var delegate:ByteDetailCustomCellDelegate? = nil
    /** Private variable */
    
    
    //MARK: - Life circle view
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
        self.setTitleForViews()
        self.setPropertiesForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //MARK: - Private method
    private func setConstraintForViews() {
        self.mTopConstraintLabeltop.constant = 17 * scale
        self.mTopConstraintButtonGetPoint.constant = 8 * scale
        self.mTopConstraintButtonApply.constant = 17 * scale
        self.mTopConstraintbuttonApplyByPhone.constant = 13 * scale
        self.mTopConstraintLabelDate.constant = 7 * scale
        self.mTopConstraintViewShareButton.constant = 3 * scale
        self.mTopConstraintViewLine2.constant = 3 * scale
        self.mTopConstraintLabelTitleCompany.constant = 12 * scale
        self.mLeadingConstraintLabelTitleCompany.constant = 9 * scale
        self.mTopConstraintLabelTitleNameCompany.constant = 17 * scale
        self.mLeadingConstraintLabelNameCompany.constant = 9 * scale
        self.mTrailingConstraintLabelNameCompany.constant = 9 * scale
        self.mTopConstraintLabelTitleBusinessContent.constant = 17 * scale
        
        self.mTopconstraintlabelTitleURL.constant = 17 * scale
        
        self.mTopConstraintLabelTitleLocation.constant = 17 * scale
        self.mTopConstraintLineView3.constant = 12 * scale
        self.mTopConstraintLabelCopyRight.constant = 30 * scale
    }
    
    private func setFontForViews() {
        self.mLabeltop.font = UIFont(name: self.mLabeltop.font.fontName, size: 12 * scale)
        self.mButtonGetPoint.titleLabel!.font = UIFont(name: self.mButtonGetPoint.titleLabel!.font.fontName, size: 23 * scale)
        
        self.mButtonFavorite.titleLabel!.font = UIFont(name: self.mButtonFavorite.titleLabel!.font.fontName, size: 11 * scale)
        
        self.mButtonApply.titleLabel!.font = UIFont(name: self.mButtonApply.titleLabel!.font.fontName, size: 19 * scale)

        
        self.mButtonApplyByTelephone.titleLabel!.font = UIFont(name: self.mButtonApplyByTelephone.titleLabel!.font.fontName, size: 13
            * scale)
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName, size:  9
            * scale)

        self.mLabelTitleCompany.font = UIFont(name: self.mLabelTitleCompany.font.fontName, size: 11
            * scale)
        self.mLabelTitleNameCompany.font = UIFont(name: self.mLabelTitleNameCompany.font.fontName, size: 10
            * scale)
        self.mLabelNameCompany.font = UIFont(name: self.mLabelNameCompany.font.fontName, size: 10
            * scale)
        
        self.mLabelTitleBusinessContent.font = UIFont(name: self.mLabelTitleBusinessContent.font.fontName, size: 10
            * scale)
        
        self.mLabelBusinessContent.font = UIFont(name: self.mLabelBusinessContent.font.fontName, size: 10
            * scale)
        
        self.mLabelTitleLocaiton.font = UIFont(name: self.mLabelTitleLocaiton.font.fontName, size: 10
            * scale)
        self.mLabelTitleURL.font = UIFont(name: self.mLabelTitleURL.font.fontName, size: 10
            * scale)
        self.mLabelLocation.font = UIFont(name: self.mLabelLocation.font.fontName, size: 10
            * scale)
        self.mLabelURL.font = UIFont(name: self.mLabelURL.font.fontName, size: 10
            * scale)
        self.mLabelTitleCopyright.font =  UIFont(name: self.mLabelTitleCopyright.font.fontName, size: 11
            * scale)
    }
    
    private func setTitleForViews() {
        let strTitleButtonGetPoint = NSLocalizedString("byte_rule_button_title_get_point", comment: "example 000ポイントGET！")
        self.mButtonGetPoint.setTitle(strTitleButtonGetPoint, for: .normal)
        
        let strTitleButtonFav = NSLocalizedString("byte_rule_button_title_favorite", comment: "お気に入り")
        self.mButtonFavorite.setTitle(strTitleButtonFav, for: .normal)
        self.mButtonFavorite.setTitle(strTitleButtonFav,for: .selected)
        
        let strTitleButtonApply = NSLocalizedString("byte_rule_button_title_apply", comment: "text apply")
        self.mButtonApply.setTitle(strTitleButtonApply, for: .normal)
        
        
    }
    
    private func setPropertiesForViews() {
        self.mButtonGetPoint.layer.cornerRadius = 8 * scale
        self.mButtonFavorite.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10 * scale, 0)
        self.mButtonApplyByTelephone.imageEdgeInsets  = UIEdgeInsetsMake(0, 0, 0 , 10 * scale)
        self.mButtonApply.setBackgroundImage( self.mButtonApply.backgroundImage(for: .normal)?.resizableImage(withCapInsets:  UIEdgeInsetsMake(15, 15, 15, 15))  , for: .normal)
        self.mButtonApplyByTelephone.setBackgroundImage(self.mButtonApply.backgroundImage(for: .normal)?.resizableImage(withCapInsets:  UIEdgeInsetsMake(15, 15, 15, 15))  , for: .normal)
        
        
    }
    
    
    
    //MARK: - Selector
    @IBAction func clickedButtonGetPoint(_ sender: Any) {
    }
    
    
    @IBAction func clickedButtonFavorite(_ sender: Any) {
        self.mButtonFavorite.isSelected = !self.mButtonFavorite.isSelected
        self.delegate?.callbackDelegateToClickedButtonFavorite()
        
    }
    
    @IBAction func clickedButtonApply(_ sender: Any) {
    }
    
    @IBAction func clickedButtonApplyByPhone(_ sender: Any) {
    }
    
    @IBAction func clickedButtonLine(_ sender: Any) {
    }
    
    @IBAction func clickedButtonTweet(_ sender: Any) {
    }
    @IBAction func clickedButtonFacebook(_ sender: Any) {
    }
    
    
    
}

