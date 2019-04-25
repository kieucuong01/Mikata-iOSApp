//
//  NavbarSettingViewController.swift
//  SmartTablet
//
//  Created by thanhlt on 7/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NavbarSettingViewController: UINavigationController {
    
    var navBarCustomView:NavBarSettingView = {
        let scale =  IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view:NavBarSettingView = (Bundle.main.loadNibNamed("NavBarSettingView", owner: self, options: nil))?[0] as! NavBarSettingView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: GlobalMethod.getTopPadding() + (51 * scale))
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSubviews()
        self.addNotificationCenter()
        // Do any additional setup after loading the view.
        if let vc = self.viewControllers[0] as? SettingMenuViewController {
            vc.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func createSubviews() {
        self.view.addSubview(self.navBarCustomView)
        self.navBarCustomView.delegate = self
        self.navBarCustomView.changeIconCloseButton()
    }
    
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(NavbarSettingViewController.changeTitleWhenChangeScreen(notification:)), name: NSNotificationChangeTitleNavBarSetting, object: nil)
    }
    
    // MARK: - Notification Center
    @objc func changeTitleWhenChangeScreen(notification: NSNotification) {
        let stringTitle = notification.object as! String
        self.navBarCustomView.titleLabel.text = stringTitle
    }
}

extension NavbarSettingViewController: NavBarSettingViewDelegate {
    func clickButtonBackNavigationBar() {
        if self.viewControllers.count <= 1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            if self.viewControllers.count == 2 {
                self.navBarCustomView.titleLabel.text = NSLocalizedString("settingview_navbar", comment: "")
            }
            self.popViewController(animated: true)
        }
    }
}

extension NavbarSettingViewController: SettingMenuViewControllerDelegate {
    func callbackDelegateToChangeNavBarLeftButtonIsBack() {
        self.navBarCustomView.changeIconLeftBackButton()
    }
    func callbackDelegateToChangeNavBarLeftButtonIsClose() {
        self.navBarCustomView.changeIconCloseButton()
    }
}
