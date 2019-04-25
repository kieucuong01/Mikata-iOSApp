//
//  CheckSkillTypeSelectionCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol CheckSkillTypeSelectionCellDelegate:class {
    func clickedButtonCheckSkill(sender:CheckSkillTypeSelectionCell, strAnswer:String, index:IndexPath)
}

class CheckSkillTypeSelectionCell: UITableViewCell {
    
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var mBtnSelectionA: UIButton!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var mBtnSelectionB: UIButton!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var mBtnSelectionC: UIButton!
    
    @IBOutlet weak var mLeadingLabelConstraint: NSLayoutConstraint!
    var indexPath:IndexPath? = nil
    weak var delegate:CheckSkillTypeSelectionCellDelegate? = nil
    private var scale:CGFloat  = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setFontForViews()
        self.setConstraintForViews()
        self.updateViewTitle(isHideTitle: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont.init(name: "YuGothic-Bold", size: 11 * scale)
    }
    
    private func setConstraintForViews() {
        self.mLeadingLabelConstraint.constant = 12 * scale
        
    }
    @IBAction func clickButtonAnswerA(_ sender: Any) {
        self.mBtnSelectionA.setImage(UIImage(named: "skill_checked"), for: .normal)
        self.mBtnSelectionB.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.mBtnSelectionC.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.delegate?.clickedButtonCheckSkill(sender: self, strAnswer: "1", index: indexPath!)
    }
    
    @IBAction func clickButtonAnswerB(_ sender: Any) {
        self.mBtnSelectionA.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.mBtnSelectionB.setImage(UIImage(named: "skill_checked"), for: .normal)
        self.mBtnSelectionC.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.delegate?.clickedButtonCheckSkill(sender: self, strAnswer: "2", index: indexPath!)
    }

    @IBAction func clickButtonAnswerC(_ sender: Any) {
        self.mBtnSelectionA.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.mBtnSelectionB.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.mBtnSelectionC.setImage(UIImage(named: "skill_checked"), for: .normal)
        self.delegate?.clickedButtonCheckSkill(sender: self, strAnswer: "3", index: indexPath!)
        
    }
    
    func updateButtonAnswers(strAnswer:String) {
        self.mBtnSelectionA.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.mBtnSelectionB.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        self.mBtnSelectionC.setImage(UIImage(named: "skill_unchecked"), for: .normal)
        if strAnswer == "1" {
            self.mBtnSelectionA.setImage(UIImage(named: "skill_checked"), for: .normal)
        } else if strAnswer == "2" {
            self.mBtnSelectionB.setImage(UIImage(named: "skill_checked"), for: .normal)
        } else if strAnswer == "3" {
            self.mBtnSelectionC.setImage(UIImage(named: "skill_checked"), for: .normal)
        }
    }
    
    func updateViewTitle(isHideTitle: Bool) {
        self.labelA.isHidden = isHideTitle
        self.labelB.isHidden = isHideTitle
        self.labelC.isHidden = isHideTitle
    }
}
