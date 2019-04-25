//
//  CustomFirstView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

@IBDesignable class CustomThirdView: UIView {

    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelSalaryHour: UILabel!
    @IBOutlet weak var mLabelTimeTravel: UILabel!
    @IBOutlet weak var mLabelCompany: UILabel!
    @IBOutlet weak var mButtonFavorite: UIButton!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
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
        self.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 128 * DISPLAY_SCALE)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        self.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 128 * DISPLAY_SCALE)
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
        let nib = UINib(nibName:"CustomThirdView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        
        return view
    }
    
    func updateConstraintForView() {
    
    }
    
    func updateFontForLabels() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scale)
        self.mLabelSalaryHour.font = UIFont(name: self.mLabelSalaryHour.font.fontName, size: 9 * scale)
        self.mLabelTimeTravel.font = UIFont(name: self.mLabelTimeTravel.font.fontName, size: 9 * scale)
        self.mLabelCompany.font = UIFont(name: self.mLabelCompany.font.fontName, size: 11 * scale)
    }
    @IBAction func clickedButtonFavorited(_ sender: Any) {
        self.mButtonFavorite.isSelected = !self.mButtonFavorite.isSelected
    }

}
