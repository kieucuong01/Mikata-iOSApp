//
//  NoteTextViewCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/19/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol NoteTextViewCellDelegate: class {
    func didBeginEditTextView(sender:NoteTextViewCell)
    func didEndEditTextView(sender:NoteTextViewCell)
    func didChangeValueTextView(sender:NoteTextViewCell)
}

class NoteTextViewCell: UITableViewCell {

    @IBOutlet weak var mTextView: UITextView!
    weak var delegate: NoteTextViewCellDelegate? = nil
    var scale:CGFloat = DISPLAY_SCALE_IPAD
    var indexPath: IndexPath = IndexPath()

    var placeHolderString: String = ""
    var isShowPlaceHolderString: Bool = false
    var mainTextColor: UIColor = GlobalMethod.hexStringToUIColor(hex: "6C5032")
    var placeHolderColor: UIColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")

    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setFontForViews()
        self.mTextView.delegate = self
        self.mTextView.isScrollEnabled = false
        
        _ = self.mTextView.sizeThatFits(CGSize(width: self.mTextView.frame.size.width, height: CGFloat(MAXFLOAT))).height
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFontForViews() {
        self.mTextView.font = UIFont(name: self.mTextView.font!.fontName, size: 12 * scale)
    }

    func setTextForTextView(text: String?) {
        // Check text
        if text != nil && text != "" {
            self.mTextView.text = text
            self.isShowPlaceHolderString = false
            self.mTextView.textColor = self.mainTextColor
        }
        else {
            self.mTextView.text = self.placeHolderString
            self.isShowPlaceHolderString = true
            self.mTextView.textColor = self.placeHolderColor
            let newPosition = self.mTextView.beginningOfDocument
            self.mTextView.selectedTextRange = self.mTextView.textRange(from: newPosition, to: newPosition)
        }

        _ = self.mTextView.sizeThatFits(CGSize(width: self.mTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
    }
}

extension NoteTextViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.isShowPlaceHolderString == true {
            self.setTextForTextView(text: text)
            let newPosition = self.mTextView.endOfDocument
            self.mTextView.selectedTextRange = self.mTextView.textRange(from: newPosition, to: newPosition)
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        self.setTextForTextView(text: textView.text)
        self.delegate?.didChangeValueTextView(sender: self)
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.isShowPlaceHolderString == true {
            let newPosition = self.mTextView.beginningOfDocument
            self.mTextView.selectedTextRange = self.mTextView.textRange(from: newPosition, to: newPosition)
        }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.didBeginEditTextView(sender: self)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.didEndEditTextView(sender: self)
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.isShowPlaceHolderString == true {
            let newPosition = self.mTextView.beginningOfDocument
            self.mTextView.selectedTextRange = self.mTextView.textRange(from: newPosition, to: newPosition)
        }
    }
}
