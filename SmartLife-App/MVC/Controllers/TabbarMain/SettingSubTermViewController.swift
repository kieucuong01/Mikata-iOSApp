//
//  SettingSubTermViewController.swift
//  SmartTablet
//
//  Created by thanhlt on 7/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

enum TypeMenu:Int {
    case termOfUser = 1
    case privacy = 2
    case termOfUserInSetting = 3
}

protocol SettingSubTermViewControllerDelegate : class {
    func callbackDelegateToChangeIconBack()
    func callbackDelegateToChangeIconClose()
    
}

class SettingSubTermViewController: BaseViewController {
    var type:TypeMenu = .termOfUser
    
    weak var delegate:SettingSubTermViewControllerDelegate? = nil
    var webView:UIWebView = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let width = SIZE_WIDTH
        let height = SIZE_HEIGHT - (51 * scale) - GlobalMethod.getTopPadding()
        let view = UIWebView(frame: CGRect(x: 0, y: (51 * scale) + GlobalMethod.getTopPadding(), width: width, height: height))
        view.dataDetectorTypes = .all
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var navBarCustomView:NavBarSettingView = {
        let scale =  IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view:NavBarSettingView = (Bundle.main.loadNibNamed("NavBarSettingView", owner: self, options: nil))?[0] as! NavBarSettingView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: GlobalMethod.getTopPadding() + (51 * scale))
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.createSubviews()
        switch type {
        case .termOfUser:
            self.navBarCustomView.changeIconCloseButton()
            self.navBarCustomView.titleLabel.text = NSLocalizedString("settingview_label_termofuse", comment: "")
            self.webView.loadRequest(URLRequest(url: URL (string: APP_BASE_URL+LINK_TERM_OF_USE)!))
            break
        case .termOfUserInSetting:
            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_TERM, eventName: nil)
            self.webView.loadRequest(URLRequest(url: URL (string: APP_BASE_URL+LINK_TERM_OF_USE)!))
            break
        default:
            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PRIVACY, eventName: nil)
            self.navBarCustomView.changeIconCloseButton()
            self.webView.loadRequest(URLRequest(url: URL (string: APP_BASE_URL+LINK_POLICY)!))
            break
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
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
    
    private func createSubviews() {
        self.view.addSubview(self.webView)
    }
    
    func createNavBar() {
        self.view.addSubview(self.navBarCustomView)
        self.navBarCustomView.delegate = self
        
        let scale =  IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let height = SIZE_HEIGHT - (51 * scale) - 20
        self.webView.frame = CGRect(x: 0, y: 51 * scale + 20, width: SIZE_WIDTH, height: height)
    }
}

extension SettingSubTermViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}

extension SettingSubTermViewController: NavBarSettingViewDelegate {
    func clickButtonBackNavigationBar() {
        self.dismiss(animated: true, completion: nil)
    }
}
