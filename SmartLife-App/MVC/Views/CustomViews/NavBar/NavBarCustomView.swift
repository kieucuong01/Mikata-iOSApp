//
//  NavBarCustomView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/7/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
protocol NavBarCustomViewDelegate: class {
    func clickButtonSettingInNavBar()
    func callbackDelegateToButtonPoint()
}

class NavBarCustomView: UIView {

    @IBOutlet weak var pointNavBar: UILabel!
    @IBOutlet weak var tittleNavBar: UILabel!
    
    
    var delegate: NavBarCustomViewDelegate?
    private var scale:CGFloat = DISPLAY_SCALE
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        
        
        self.setDefaultFontLabel()
    }
    
    private func setDefaultFontLabel() {
        
        let myString = "0pt"
        let attribute1 = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 21 * scale)]
        let attribute2 = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10 * scale)]
        
        let attributeStr = NSMutableAttributedString(string: myString)
        let length = myString.count
        attributeStr.addAttributes(attribute1, range: NSRange(location: 0, length: length - 2))
        attributeStr.addAttributes(attribute2, range: NSRange(location: myString.count - 2, length: 2 ))
        
        self.pointNavBar.attributedText = attributeStr
        self.tittleNavBar.font = UIFont.boldSystemFont(ofSize: 14 * scale)
    }

    func updateScore(score:String) {
        if let scoreInt: Int = Int(score) {
            let myString = "\(scoreInt.convertToStringDecimalFormat())pt"
            let attribute1 = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 21 * scale)]
            let attribute2 = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10 * scale)]

            let attributeStr = NSMutableAttributedString(string: myString)
            let length = myString.count
            attributeStr.addAttributes(attribute1, range: NSRange(location: 0, length: length - 2))
            attributeStr.addAttributes(attribute2, range: NSRange(location: myString.count - 2, length: 2 ))

            self.pointNavBar.attributedText = attributeStr
        }
    }
    
    @IBAction func closeKeyboardButtonAction(_ sender: UIButton) {
        self.window?.endEditing(true)
    }
    
    @IBAction func touchUpInsideSettingButton(_ sender: Any) {
        self.endEditing(true)
        self.delegate?.clickButtonSettingInNavBar()
    }
    @IBAction func clickedButtonPoint(_ sender: Any) {
        self.endEditing(true)
        self.delegate?.callbackDelegateToButtonPoint()
    }
}
