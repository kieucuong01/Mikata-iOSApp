//
//  NavBarSettingView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol NavBarSettingViewDelegate {
    func clickButtonBackNavigationBar()
}

class NavBarSettingView: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var scale:CGFloat = DISPLAY_SCALE
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate: NavBarSettingViewDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setDefaultProperties()
    }
    
    
    
    private func setDefaultProperties() {
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.titleLabel.text = NSLocalizedString("settingview_navbar", comment: "")
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 14 * scale)
        
        
        self.viewTop.layer.masksToBounds = false
        self.viewTop.layer.shadowColor = UIColor.black.cgColor
        self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewTop.layer.shadowOpacity = 0.5
        self.viewTop.layer.shadowRadius = 2.0
    }

    func changeIconCloseButton() {
        self.leftButton.setImage(#imageLiteral(resourceName: "icon_close_brown"), for: .normal)
    }
    
    func changeIconLeftBackButton() {
        self.leftButton.setImage(#imageLiteral(resourceName: "button_back"), for: .normal)
    }
    
    @IBAction func clickButtonBack(_ sender: Any) {
        self.delegate?.clickButtonBackNavigationBar()
    }
}
