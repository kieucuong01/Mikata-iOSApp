//
//  CustomFirstView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

@IBDesignable class CustomSecondView: UIView {

    @IBOutlet weak var mLeadingBtnArrowDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingLabelTopNearArrowDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelNumJobsOpeningConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingTopLabelNumJobsOpeningConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingLabelValueNumJobOpening: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelSortingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelSettingConditionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mLabelTopNearArrowDown: UILabel!
    
    @IBOutlet weak var mViewBottomContent: UIView!
    @IBOutlet weak var lblNumsJobOpening: UILabel!
    @IBOutlet weak var lblValueNumJobOpening: UILabel!
    @IBOutlet weak var lblButtonSort: UILabel!
    
    @IBOutlet weak var mButtonNewAvarral: UIButton!
    @IBOutlet weak var mButtonByAttention: UIButton!
    @IBOutlet weak var mButtonInHourlyDay: UIButton!
    
    @IBOutlet weak var lblSettingCondition: UILabel!
    @IBOutlet weak var lblValueSettingCondition: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateConstraintForView()
        self.updateFontForLabels()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"CustomSecondView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK:- Getter
    
    //MARK:- Private method
    private func updateConstraintForView() {
        self.mLeadingBtnArrowDownConstraint.constant = 10 * DISPLAY_SCALE
        self.mLeadingLabelTopNearArrowDownConstraint.constant = 25 * DISPLAY_SCALE
        self.mTopLabelNumJobsOpeningConstraint.constant = 15 * DISPLAY_SCALE
        self.mLeadingTopLabelNumJobsOpeningConstraint.constant = 13 * DISPLAY_SCALE
        self.mLeadingLabelValueNumJobOpening.constant = 60 * DISPLAY_SCALE
        self.mTopLabelSortingConstraint.constant = 43 * DISPLAY_SCALE
        self.mTopLabelSettingConditionConstraint.constant = 82 * DISPLAY_SCALE
    }
    
    private func updateFontForLabels() {
        self.mLabelTopNearArrowDown.font = UIFont(name: self.mLabelTopNearArrowDown.font.fontName, size:  9 * DISPLAY_SCALE)
        self.lblSettingCondition.font = UIFont(name: self.lblSettingCondition.font.fontName, size: 10 * DISPLAY_SCALE)
        self.lblValueSettingCondition.font = UIFont(name: self.lblValueSettingCondition.font.fontName, size: 10 * DISPLAY_SCALE)
        self.lblNumsJobOpening.font = UIFont(name: self.lblNumsJobOpening.font.fontName, size: 10 * DISPLAY_SCALE)
        self.lblValueNumJobOpening.font = UIFont(name: self.lblValueNumJobOpening.font.fontName, size: 12 * DISPLAY_SCALE)
        self.lblButtonSort.font = UIFont(name: self.lblButtonSort.font.fontName, size:  10 * DISPLAY_SCALE)
        
        self.mButtonNewAvarral.titleLabel?.font = UIFont(name: self.mButtonNewAvarral.titleLabel!.font.fontName, size:  13 * DISPLAY_SCALE)
        self.mButtonByAttention.titleLabel?.font = UIFont(name: self.mButtonByAttention.titleLabel!.font.fontName, size:  13 * DISPLAY_SCALE)
        self.mButtonInHourlyDay.titleLabel?.font = UIFont(name: self.mButtonInHourlyDay.titleLabel!.font.fontName, size:  13 * DISPLAY_SCALE)
    }
}

class CustomContentInTopSecondView: UIView {
    
    var dictData:NSDictionary = NSDictionary()

    private var _imageView:UIImageView? = nil
    private var _lblNumberOfPerson:UILabel? = nil
    private var _viewDisplayPerson:UIView? = nil
    
    init(frame:CGRect,with dict:NSDictionary) {
        super.init(frame: frame)
        dictData = dict
        self.createSubviews()
        self.updateDisplayView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    //MARK:- Getter
    var imageView:UIImageView {
        if _imageView == nil {
            _imageView = UIImageView(frame: CGRect(x: 14 * DISPLAY_SCALE, y: 9 * DISPLAY_SCALE, width: 39 * DISPLAY_SCALE, height: 37 * DISPLAY_SCALE))
            _imageView!.image = UIImage(named: "ic_university.png")
            _imageView!.contentMode = .scaleAspectFill
            _imageView!.clipsToBounds = true
        }
        return _imageView!
    }
    
    var lblNumberOfPerson:UILabel {
        if _lblNumberOfPerson == nil {
            _lblNumberOfPerson = UILabel(frame: CGRect(x: 60 * DISPLAY_SCALE, y: 27 * DISPLAY_SCALE, width: 32 * DISPLAY_SCALE, height: 18 * DISPLAY_SCALE))
            _lblNumberOfPerson!.font = UIFont.boldSystemFont(ofSize: 16 * DISPLAY_SCALE)
            _lblNumberOfPerson!.textColor = GlobalMethod.hexStringToUIColor(hex: "#583f25")
            _lblNumberOfPerson!.text = dictData.object(forKey: "num_of_person") as! String + "名"
        }
        return _lblNumberOfPerson!
    }
    
    var viewDisplayPerson:UIView {
        if _viewDisplayPerson == nil {
            _viewDisplayPerson = UIView(frame: CGRect(x: 102 * DISPLAY_SCALE , y: 9 * DISPLAY_SCALE, width: 208 * DISPLAY_SCALE, height: 38 * DISPLAY_SCALE))
            _viewDisplayPerson?.backgroundColor = .clear
        }
        return _viewDisplayPerson!
    }
    
    //MARK: - Private method
    private func createSubviews() {
        self.addSubview(self.imageView)
        self.addSubview(self.lblNumberOfPerson)
        self.addSubview(self.viewDisplayPerson)
    }
    
    private func updateDisplayView() {
        for subview in self.viewDisplayPerson.subviews {
            subview.removeFromSuperview()
        }
        
        let arrays:NSArray = dictData.object(forKey: "array") as! NSArray
        let max = arrays.count > 8 ? 8 : arrays.count
        for index in 0 ... max - 1 {
            let info:NSDictionary = arrays.object(at: index) as! NSDictionary
            let width:CGFloat = 26.0 * DISPLAY_SCALE
            let x = CGFloat(index) * width
            let temp = UIView(frame: CGRect(x: x, y: 0, width: width, height: 38 * DISPLAY_SCALE))
            
            //Create image View
            let imgView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 26 * DISPLAY_SCALE))
            if (info.object(forKey: "gender") as! String) == "male" {
                imgView.image = UIImage(named: "ic_male.png")
            } else {
                imgView.image = UIImage(named: "ic_female.png")
            }
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            temp.addSubview(imgView)
            
            //Create label
            let lblInfo:UILabel = UILabel(frame: CGRect(x: 0, y: 33, width: width, height: 9 * DISPLAY_SCALE))
            lblInfo.text = info.object(forKey: "year_std") as? String
            lblInfo.font = UIFont.systemFont(ofSize: 8 * DISPLAY_SCALE)
            lblInfo.textColor = GlobalMethod.hexStringToUIColor(hex:"#583f25")
            lblInfo.textAlignment = .center
            temp.addSubview(lblInfo)
            
            self.viewDisplayPerson.addSubview(temp)
            
        }
        
    }
}
