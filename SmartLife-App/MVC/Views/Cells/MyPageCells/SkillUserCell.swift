//
//  SkillUserCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/25/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class SkillUserCell: UICollectionViewCell {

    @IBOutlet weak var mImageSkill: UIImageView!
    @IBOutlet weak var mLabelNameSkill: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        self.mLabelNameSkill.font = UIFont(name: self.mLabelNameSkill.font.fontName, size: 10 * scale)
    }
    
    func updateDataSkill(skill:MySkillInfo) {
        self.mLabelNameSkill.text = skill.m_name_skill
        if skill.m_skill_value.isEmpty {
            self.mImageSkill.image = #imageLiteral(resourceName: "ic_skill_user_clear")
            self.mLabelNameSkill.textColor = UIColor(red: 216, green: 216, blue: 216)
        } else {
            self.mLabelNameSkill.textColor = .white
            if skill.m_value_type == .single {
                if skill.m_skill_value == "1" {
                    self.mImageSkill.image = #imageLiteral(resourceName: "ic_skill_user_pink")
                } else if skill.m_skill_value == "2" {
                    self.mImageSkill.image = #imageLiteral(resourceName: "ic_skill_user_yellow")
                } else if  skill.m_skill_value == "3" {
                    self.mImageSkill.image = #imageLiteral(resourceName: "ic_skill_user_blue")
                }
            } else {
                self.mImageSkill.image = #imageLiteral(resourceName: "ic_skill_user_red")
            }
        }
    }

}
