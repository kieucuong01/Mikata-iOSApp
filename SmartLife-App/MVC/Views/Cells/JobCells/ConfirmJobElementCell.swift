//
//  ConfirmJobElementCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ConfirmJobElementCell: UITableViewCell {

    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintCollectionTags: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintCollectionTags: NSLayoutConstraint!
    
    @IBOutlet weak var mHeightConstraintCollectionTags: NSLayoutConstraint!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mViewTags: UIView!
    
    var scale: CGFloat = DISPLAY_SCALE
    var arrayTags:[String] = [String]()
    var jobApply:[String:Any?] = [String:Any?]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraintForViews() {
        self.mLeadingConstraintLabelTitle.constant = 7 * scale
        self.mTopConstraintLabelTitle.constant = 8 * scale
        self.mTopConstraintLabelContent.constant = 7 * scale
        self.mTopConstraintCollectionTags.constant = 10 * scale
        self.mBottomConstraintCollectionTags.constant = 12 * scale
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 12 * scale)
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 12 * scale)
    }
    
    private func setPropertiesForViews() {
        if let parentview = self.mViewTags.superview {
            parentview.layer.cornerRadius = 4 * scale
            parentview.layer.borderWidth = 1
            parentview.layer.borderColor = UIColor(red: 216, green: 216, blue: 216).cgColor
        }
        
    }
    func updateDataWithDict(item:[String:Any?]) {
        self.jobApply =  item
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
            self.mHeightConstraintCollectionTags.constant = 0.0
        }
        else {
            self.mHeightConstraintCollectionTags.constant = y + 18 * scale
        }
    }

    func updateDataWithDictByte(item:[String:Any?]) {
        self.jobApply =  item
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
            self.mHeightConstraintCollectionTags.constant = 0.0
        }
        else {
            self.mHeightConstraintCollectionTags.constant = y + 18 * scale
        }
    }

    
    
    func newLabelWithText(string:String,oldX: CGFloat, oldY: CGFloat, index:Int) -> UIView {
        let view = UIButton(frame: CGRect(x: oldX, y:oldY , width: 0, height: 0 ))
        view.backgroundColor = lightGrayColor
        let label = UILabel(frame: CGRect(x: 5 * scale, y:5 * scale , width: 0, height: 0 ))
        
        label.textColor = .white
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
        //        button.addTarget(self, action: #selector(CreateNewNoteViewController.clickedButtonTagLable(_:) ), for: .touchUpInside)
        view.addSubview(label)
        
        return view
    }
    
}
