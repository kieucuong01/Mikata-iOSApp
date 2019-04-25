//
//  InputImageTextCustomView.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/18/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol InputImageTextCustomViewDelegate: class {
    func callbackClickedButtonCamera(sender:InputImageTextCustomView);
    func callbackClickedButtonImage(sender:InputImageTextCustomView);
    func callbackClickedButtonSent(sender:InputImageTextCustomView);
}

@IBDesignable class InputImageTextCustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var mButtonCamera: UIButton!
    @IBOutlet weak var mButtonImage: UIButton!
    @IBOutlet weak var mButtonSent: UIButton!
    
    @IBOutlet weak var mTrailingConstraintButtonSent: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintButtonCamera: NSLayoutConstraint!
    
    var scale:CGFloat = DISPLAY_SCALE
    weak var delegate:InputImageTextCustomViewDelegate? = nil
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"InputImageTextCustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        
        self.mTrailingConstraintButtonSent.constant = 14 * scale
        self.mLeadingConstraintButtonCamera.constant = 14 * scale
        self.mButtonSent.titleLabel?.font = UIFont(name: self.mButtonSent.titleLabel!.font.fontName, size: 12 * scale)
        self.mButtonSent.layer.cornerRadius = 4
        
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        addSubview(view)
        
        
    }
    
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
    @IBAction func clickedButtonSend(_ sender: Any) {
        
        self.delegate?.callbackClickedButtonSent(sender:self)
    }
    @IBAction func clickedButtonCamera(_ sender: Any) {
        self.delegate?.callbackClickedButtonCamera(sender: self)
    }

    @IBAction func clickedButtonImage(_ sender: Any) {
        self.delegate?.callbackClickedButtonImage(sender: self)
    }
}
