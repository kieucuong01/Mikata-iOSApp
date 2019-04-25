//
//  SearchBarCustomView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/13/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
protocol SearchBarCustomViewDelegate {
    func callAPISearchPointItems(keyword:String)
    func callbackActionClickedButtonFilter()
}

@IBDesignable  class SearchBarCustomView: UIView {
    private var lastText:String? = nil
    var delegate: SearchBarCustomViewDelegate? = nil
    
    @IBOutlet weak var textFieldCell: UITextField!
    @IBOutlet weak var mButtonFilter: UIButton!
    @IBOutlet weak var mConstraintLeadingButtonFilter: NSLayoutConstraint!
    
    @IBOutlet weak var viewContentTextField: UIView!
    var scale:CGFloat = DISPLAY_SCALE
    var timer: Timer? = nil

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
        lastText = ""
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        lastText = ""
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.textFieldCell.delegate = self
        self.textFieldCell.attributedPlaceholder = NSAttributedString.init(string:self.textFieldCell.placeholder! , attributes: [NSAttributedStringKey.foregroundColor : GlobalMethod.hexStringToUIColor(hex: "7B7A7A"), NSAttributedStringKey.font: UIFont(name: (self.textFieldCell.font?.fontName)!,size:10 * scale) ?? UIFont.systemFont(ofSize: 12 * scale)])
        self.textFieldCell.addTarget(self, action: #selector(SearchBarCustomView.textFieldDidChange(_:)), for: .editingChanged)
        self.textFieldCell.text = ""
        self.textFieldCell.placeholder = NSLocalizedString("placeholder_search", comment: "")
        
        self.mConstraintLeadingButtonFilter.constant = -36 * scale
        
        self.viewContentTextField.layer.borderWidth = 1.0
        self.viewContentTextField.layer.borderColor = UIColor(red: 123, green: 122, blue: 122).cgColor
        self.viewContentTextField.layer.cornerRadius = 4
        self.mButtonFilter.isHidden = true
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"SearchBarCustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        
        return view
    }
    
    //MARK:- Selector
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(SearchBarCustomView.searchAction),
            userInfo: textField.text,
            repeats: false)
    }
    @objc func searchAction(timer: Timer) {
        let userInfo = timer.userInfo as? String
        self.delegate?.callAPISearchPointItems(keyword:userInfo ?? "")
    }

    func updateConstraintWhenHaveFilterButton() {
        self.mButtonFilter.isHidden = false
        self.mConstraintLeadingButtonFilter.constant = 10 * scale
    }
    @IBAction func clickedButtonFilter(_ sender: Any) {
        self.delegate?.callbackActionClickedButtonFilter()
    }
}

extension SearchBarCustomView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}

