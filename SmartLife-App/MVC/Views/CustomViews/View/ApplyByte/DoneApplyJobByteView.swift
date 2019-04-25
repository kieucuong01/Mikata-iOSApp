//
//  DoneApplyJobByteView.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol DoneApplyJobByteViewDelegate:class {
    func callbackDelegateToClickedCloseButton(sender:DoneApplyJobByteView)
    func callbackDelegateToClickedButtonTop(sender:DoneApplyJobByteView)
}

class DoneApplyJobByteView: UIView {

    @IBOutlet weak var mBottomConstraintButton: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButton: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintTextViewContent: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTextViewContent: UITextView!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var scale: CGFloat = DISPLAY_SCALE
    weak var delegateView:DoneApplyJobByteViewDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        self.setLanguageForView()
        self.setConstraintForViews()
        self.setFontForViews()
    }
    
    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("doneapplyjobview_label_title", comment: "")
        self.mTextViewContent.text = NSLocalizedString("doneapplyjobview_textview_content", comment: "")
        self.mButton.setTitle(NSLocalizedString("doneapplyjobbyteview_button_done", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        self.mTopConstraintLabelTitle.constant = 36 * scale
        self.mTopConstraintTextViewContent.constant = 22 * scale
        self.mTopConstraintButton.constant = 24 * scale
        self.mBottomConstraintButton.constant = 25 * scale
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scale)
        self.mButton.titleLabel!.font = UIFont(name: self.mButton.titleLabel!.font.fontName, size: 14 * scale)
        
//        let attribute = NSMutableAttributedString(attributedString: self.mTextViewContent.attributedText)
//
//        let range = NSRange(location: 0, length:self.mTextViewContent.attributedText.string.count)
//        attribute.addAttributes([NSAttributedStringKey.font:UIFont(name: "YuGo-Medium", size: 14 * scale) ?? UIFont()], range: range)
//
//        self.mTextViewContent.attributedText = attribute
        
    }
    
    @IBAction func clickedButtonClose(_ sender: Any) {
        self.delegateView?.callbackDelegateToClickedCloseButton(sender: self)
    }
    
    @IBAction func clickedButtonTop(_ sender: Any) {
        self.delegateView?.callbackDelegateToClickedButtonTop(sender: self)
    }
    
}
