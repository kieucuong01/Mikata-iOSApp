//
//  JobSecondGuideCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/9/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
protocol JobSecondGuideTableViewCellDelegate : class {
    func callbackDelegateToClickedButtonDelete(sender: JobSecondGuideTableViewCell)
}

class JobSecondGuideTableViewCell: UITableViewCell {

    @IBOutlet weak var mHeightConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonDelete: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonDelete: NSLayoutConstraint!
    
    @IBOutlet weak var mViewTags: UIView!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mButtonDelete: UIButton!
    
    var arrayTags:[String] = []
    var jobApply:[String:Any?] = [:]
    var scale = DISPLAY_SCALE
    var delegateView:JobSecondGuideTableViewCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        self.setFontForViews()
        self.setPropertiesForViews()
        self.setConstraintForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    private func setFontForViews() {
    }

    private func setConstraintForViews() {
        self.mTopConstraintLabelTitle.constant = 8 * scale
        self.mLeadingConstraintLabelTitle.constant = 9 * scale
        self.mTopConstraintLabelContent.constant = 7 * scale
        self.mBottomConstraintLabelContent.constant = 10 * scale
        self.mTopConstraintButtonDelete.constant = 3 * scale
        self.mBottomConstraintButtonDelete.constant = 10 * scale
        
    }
    
    private func setPropertiesForViews() {
        
    }
    
    func updateDataWithDict(item:[String:Any?]) {
        self.jobApply = item
        self.mLabelTitle.text = self.jobApply["name"] as? String
        self.mLabelContent.text = (self.jobApply["content"] as? String)?.html2String

        // Tags
        self.arrayTags.removeAll()
        for view in mViewTags.subviews {
            view.removeFromSuperview()
        }
        if let jobCategoryString: String = self.jobApply["job_category"] as? String {
            if jobCategoryString != "-" {
                let arrayCategory: [String] = jobCategoryString.components(separatedBy: ",")
                for category in arrayCategory {
                    let categoryAfterTrim: String = category.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.arrayTags.append(categoryAfterTrim)
                }
            }
        }

        var x:CGFloat = 0
        var y:CGFloat = 0
        let distance = 3 * scale
        var index = 0
        for text in arrayTags {
            let view = newLabelWithText(string: text, oldX: x, oldY: y, index: index)
            x = view.frame.origin.x + view.frame.size.width + distance
            y = view.frame.origin.y
            self.mViewTags.addSubview(view)
            index = index + 1
        }

        if self.arrayTags.count <= 0 {
            self.mHeightConstraintCollectionView.constant = 0.0
        }
        else {
            self.mHeightConstraintCollectionView.constant = y + 18 * scale
        }
    }

    func updateDataWithDictByte(item:[String:Any?]) {
        self.jobApply = item
        self.mLabelTitle.text = self.jobApply["works_tbasicitemp_jobtypedtl"] as? String
        self.mLabelContent.text = (self.jobApply["works_tbasicitemp_compnm"] as? String)?.html2String

        // Tags
        self.arrayTags.removeAll()
        for view in mViewTags.subviews {
            view.removeFromSuperview()
        }
        if let jobCategoryString: String = self.jobApply["tbiemptypp_emptypnm"] as? String {
            if jobCategoryString != "-" {
                let arrayCategory: [String] = jobCategoryString.components(separatedBy: ",")
                for category in arrayCategory {
                    let categoryAfterTrim: String = category.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.arrayTags.append(categoryAfterTrim)
                }
            }
        }

        var x:CGFloat = 0
        var y:CGFloat = 0
        let distance = 3 * scale
        var index = 0
        for text in arrayTags {
            let view = newLabelWithText(string: text, oldX: x, oldY: y, index: index)
            x = view.frame.origin.x + view.frame.size.width + distance
            y = view.frame.origin.y
            self.mViewTags.addSubview(view)
            index = index + 1
        }

        if self.arrayTags.count <= 0 {
            self.mHeightConstraintCollectionView.constant = 0.0
        }
        else {
            self.mHeightConstraintCollectionView.constant = y + 18 * scale
        }
    }

    
    
    func newLabelWithText(string:String, oldX: CGFloat, oldY: CGFloat, index:Int) -> UIView {
        let view = UIButton(frame: CGRect(x: oldX, y:oldY , width: 0, height: 0 ))
        view.backgroundColor = UIColor(red: 216, green: 216, blue: 216)
        let label = UILabel(frame: CGRect(x: 5 * scale, y:5 * scale , width: 0, height: 0 ))
        
        label.textColor = grayColor
        label.font = UIFont(name: "YuGothic-Bold", size: 8 * scale)
      
        label.text = string
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        
        var frame = label.frame
        frame.origin.x = oldX
        frame.origin.y = oldY
        frame.size.width = frame.size.width + 10 * scale
        frame.size.height = 17 * scale
        if frame.size.width > (mViewTags.frame.size.width) {
            frame.origin.x = 0
            if oldX > 0 {
                frame.origin.y = frame.origin.y + 21 * scale
            }
            frame.size.width = mViewTags.frame.size.width
        } else {
            if (frame.size.width + frame.origin.x) > (mViewTags.frame.size.width) {
                frame.origin.x = 0
                frame.origin.y = frame.origin.y + 21 * scale
            }
        }
        view.frame = frame
        view.layer.cornerRadius = 1
        view.addSubview(label)
        
        return view
    }
    
    @IBAction func clickedButtonDelete(_ sender: Any) {
        self.delegateView?.callbackDelegateToClickedButtonDelete(sender: self)
    }
    
}
