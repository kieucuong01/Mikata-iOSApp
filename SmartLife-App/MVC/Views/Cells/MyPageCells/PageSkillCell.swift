//
//  PageSkillCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/25/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class PageSkillCell: UICollectionViewCell {

    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var mHeightConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var mLabelTopPage: UILabel!

    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    @IBOutlet weak var noticeTItleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var midIconImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var midLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftIconImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightLabelLeadingConstraint: NSLayoutConstraint!
    
    var mArrayMySkill:[MySkillInfo] = [MySkillInfo]()
    let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setLanguageForView()
        self.setPropertiesForViews()
        self.setPropertiesForNoticeView()
    }

    private func setLanguageForView(){
        self.noticeTitleLabel.text = NSLocalizedString("mypageskillview_label_noticetitle", comment: "")
        self.leftLabel.text = NSLocalizedString("mypageskillview_label_left", comment: "")
        self.midLabel.text = NSLocalizedString("mypageskillview_label_mid", comment: "")
        self.rightLabel.text = NSLocalizedString("mypageskillview_label_right", comment: "")
    }
    
    private func setPropertiesForViews() {
        self.mCollectionView.delegate = self
        self.mCollectionView.dataSource = self
        self.mCollectionView.register(UINib.init(nibName: "SkillUserCell", bundle: nil), forCellWithReuseIdentifier: "skillUserCell")
    }

     private func setPropertiesForNoticeView() {
        // NoticeView
        self.noticeView.layer.borderWidth = 1.0 * self.scale
        self.noticeView.layer.borderColor = lightGrayColor.cgColor

        // NoticeTitleLabel
        self.noticeTItleLabelHeightConstraint.constant = 15.0 * self.scale
        self.noticeTitleLabel.font = self.noticeTitleLabel.font.withSize(13.5 * self.scale)

        // MidView
        self.midIconImageViewLeadingConstraint.constant = 8.5 * self.scale
        self.midLabelLeadingConstraint.constant = 4.0 * self.scale
        self.midLabel.font = self.midLabel.font.withSize(12.0 * self.scale)

        // LeftView
        self.leftIconImageViewLeadingConstraint.constant = 8.5 * self.scale
        self.leftLabelLeadingConstraint.constant = 4.0 * self.scale
        self.leftLabel.font = self.leftLabel.font.withSize(12.0 * self.scale)

        // RightView
        self.rightIconImageViewLeadingConstraint.constant = 8.5 * self.scale
        self.rightLabelLeadingConstraint.constant = 4.0 * self.scale
        self.rightLabel.font = self.rightLabel.font.withSize(12.0 * self.scale)
    }

    func updateArraySkill(array:[MySkillInfo]) {
        mArrayMySkill = array
//        if array.count > 12 {
//            let index = Int(ceil(CGFloat(array.count)/4.0))
//            let height:CGFloat = 75.0 * scale * CGFloat(index) - 10 * scale
//            self.mHeightConstraintCollectionView.constant = height
//        } else {
//            self.mHeightConstraintCollectionView.constant = 215 * scale
//        }
        
        let index = Int(ceil(CGFloat(array.count)/4.0))
        let height:CGFloat = 75.0 * scale * CGFloat(index) - 10 * self.scale
        self.mHeightConstraintCollectionView.constant = height
        
        self.mCollectionView.reloadData()
    }
}

extension PageSkillCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mArrayMySkill.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SkillUserCell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillUserCell", for: indexPath) as! SkillUserCell
        let objectSkill = mArrayMySkill[indexPath.row]
        cell.updateDataSkill(skill:objectSkill)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return UIEdgeInsetsMake(0, 14 * scale, 0, 14 * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return CGSize(width: 65 * scale, height: 65 * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return 10 * scale
    }
}
