//
//  CustomWebViewController.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class CustomWebViewController: NewBaseViewController, UIWebViewDelegate {
    // Subviews
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainWebView: UIWebView!
    
    // Variables
    var infoItem:NSDictionary = NSDictionary()
    var isNeedToPopToTimelineVC: Bool = false

    // MARK: - View Lifecycle

    override func didReceiveMemoryWarning() {
        // Call super
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        // Call super
        super.viewDidLoad()

        // Clear cookie
        self.clearAllCookie()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Call super
        super.viewWillAppear(animated)

        // Hide NavBar
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true))
        FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.isHidden = true

        // Update content
        self.updateContentWithModel()

        // Indicator
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Call super
        super.viewDidDisappear(animated)

        // Show NavBar
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false))
        FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.isHidden = false
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    override func configureSelf() {
        // Call super
        super.configureSelf()
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    override func configureSubviews() {
        // Call super
        super.configureSubviews()

        // Configure subviews
        self.configureHeaderView()
        self.configureMainWebView()
    }

    /*
     * Created by: hoangnn
     * Description: Configure headerView
     */
    func configureHeaderView() {
        // Set attributes for titleLabel
        self.titleLabel.font = self.titleLabel.font.withSize(13.5 * GlobalMethod.displayScale)
        self.titleLabel.text = nil
    }

    /*
     * Created by: hoangnn
     * Description: Configure mainWebView
     */
    func configureMainWebView() {
        // Set attributes
        self.mainWebView.delegate = self
        self.mainWebView.scrollView.bounces = false
    }

    // MARK: - Update Configure

    /*
     * Created by: hoangnn
     * Description: Pop to TimelineVC
     */
    func popToTimelineVC() {
        // Pop to TimeLineViewController
        if self.navigationController != nil {
            for viewControler in self.navigationController!.viewControllers {
                if viewControler is TimeLineViewController {
                    self.navigationController?.popToViewController(viewControler, animated: true)
                }
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Clear all cookie
     */
    func clearAllCookie() {
        let cookieJar = HTTPCookieStorage.shared
        if let listCookie: [HTTPCookie] = cookieJar.cookies {
            for cookie in listCookie {
                cookieJar.deleteCookie(cookie)
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Update content with model
     */
    func updateContentWithModel() {
        // Load link for webview
        if let missionType : String = self.infoItem.value(forKey: "mission_type") as? String{
            var urlWebView : String? = ""
            if missionType == "2" {
                urlWebView = self.infoItem.value(forKey: "set_track_url") as? String
            }
            else if missionType == "4" {
                urlWebView = self.infoItem.value(forKey: "target_page_url") as? String

                self.isNeedToPopToTimelineVC = true
            }

            if urlWebView != nil {
                if let linkUrl: URL = URL(string: urlWebView!) {
                    let linkUrlRequest: URLRequest = URLRequest(url: linkUrl)
                    self.mainWebView.loadRequest(linkUrlRequest)
                }
            }
        }

        self.view.layoutIfNeeded()
    }

    // MARK: - UIWebViewDelegate

    /*
     * Created by: hoangnn
     * Description: Should start load with
     */
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url?.absoluteString ?? 0)

        // Check when submit survey
        if let afterMissionURL: String = self.infoItem.value(forKey: "get_track_url") as? String {
            if request.url?.absoluteString.contains(afterMissionURL) == true {
                self.isNeedToPopToTimelineVC = true
            }
        }

        // Check when click finish
        if request.url?.absoluteString.contains("http://api.smartapp.dev/") == true {
            self.popToTimelineVC()
            return false
        }

        return true
    }

    /*
     * Created by: hoangnn
     * Description: Did finish load
     */
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    /*
     * Created by: hoangnn
     * Description: Did fail load
     */
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: backButton action
     */
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isNeedToPopToTimelineVC == true {
            self.isNeedToPopToTimelineVC = false
            self.popToTimelineVC()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
