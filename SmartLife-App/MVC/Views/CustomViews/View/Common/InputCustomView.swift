//
//  InputCustomView.swift
//  SmartLife-App
//
//  Created by DELL7447 on 9/26/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
protocol InputCustomViewDelegate: class {
    func callbackClickedButtonCamera(sender:InputCustomView)
    func callbackClickedButtonImage(sender:InputCustomView)
    func didChangeValueTextView(sender:InputCustomView,textView:UITextView)
    func callbackUpdateLayoutKeyboardHidden(sender:InputCustomView)
    func callbackUpdateLayoutKeyboardChange(sender:InputCustomView, height:CGFloat)
}
@IBDesignable class InputCustomView: UIView {

    @IBOutlet weak var mTextView: UITextView!
    
    @IBOutlet weak var mButtonCamera: UIButton!
    @IBOutlet weak var mButtonImage: UIButton!
    
    @IBOutlet weak var mButtonSent: UIButton!
    var maxWidthTextView:CGFloat = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var currentInput = "";
    var scale:CGFloat = DISPLAY_SCALE
    weak var delegate:InputCustomViewDelegate? = nil
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"InputCustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        maxWidthTextView = self.mTextView.frame.size.width
        self.mTextView.font = UIFont(name: self.mTextView.font!.fontName, size: 12 * scale)
        self.mButtonSent.titleLabel!.font = UIFont(name: self.mButtonSent.titleLabel!.font.fontName, size: 12 * scale)
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        addSubview(view)
        
        addObserverForViewController()
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
    
    private func addObserverForViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(InputCustomView.keyboardIsHidden), name: Notification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InputCustomView.keyboardIsChangeFrame), name: Notification.Name.UIKeyboardDidChangeFrame, object: nil)
    }

    @IBAction func clickedButtonCamera(_ sender: Any) {
        
        self.delegate?.callbackClickedButtonCamera(sender: self)
    }
    
    @IBAction func clickedButtonImage(_ sender: Any) {
        
        self.delegate?.callbackClickedButtonImage(sender: self)
    }

    @objc func keyboardIsHidden(_ notification: Notification) {
        self.delegate?.callbackUpdateLayoutKeyboardHidden(sender:self)
    }
    
    @objc func keyboardIsChangeFrame(_ notification: Notification) {
       
        let keyboardSize:CGSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        print("Keyboard size: \(keyboardSize)")
        //
        let height = min(keyboardSize.height, keyboardSize.width)
        self.delegate?.callbackUpdateLayoutKeyboardChange(sender:self, height:height)

    }
    @IBAction func clickedButttonSent(_ sender: Any) {
    }
}

extension InputCustomView : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if currentInput.isEmpty {
            textView.text = "";
            textView.textColor = GlobalMethod.hexStringToUIColor(hex: "#583F25")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = self.mTextView.text;
        if textView.text.isEmpty {
            textView.text = "メッセージを入力してください"
            textView.textColor = GlobalMethod.hexStringToUIColor(hex: "#B89F98")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //230 * scale
        let sizeTextViewFit = textView.sizeThatFits(CGSize(width: maxWidthTextView, height: CGFloat(MAXFLOAT)))
        let maxHeight = 100.0 * scale
        if  self.mTextView.frame.size.height != sizeTextViewFit.height  && sizeTextViewFit.height < maxHeight{
            
            var frame = self.mTextView.frame
            frame.size.width = maxWidthTextView
            frame.size.height = sizeTextViewFit.height
            self.mTextView.frame = frame
            
            self.delegate?.didChangeValueTextView(sender: self,textView: textView)
        }
        
    }
    
    
}
