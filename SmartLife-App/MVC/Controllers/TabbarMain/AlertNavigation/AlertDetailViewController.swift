//
//  AlertDetailViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/22/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol AlertDetailViewControllerDelegate:class {
    func callbackDelegateToRefreshListNotification(sender: AlertDetailViewController)
}

class AlertDetailViewController: BaseViewController {

    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelDate: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonCheck: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonCheck: NSLayoutConstraint!
    
    @IBOutlet weak var mBottomConstraintScrollView: NSLayoutConstraint!
    @IBOutlet weak var mButtonCheck: UIButton!
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mLabelTitle: UILabel!
    
    @IBOutlet weak var mLabelNavBar: UILabel!
    weak var delegate:AlertDetailViewControllerDelegate? = nil
    
    var objNotification:NotificationObj = NotificationObj()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setConstraintForViews()
        self.setFontForViews()
        self.updateDateFromObjectNotification()
        self.callAPIReadNotification()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )

        // Track repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ALERT_DETAIL, eventName: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : -Private method 
    private func setLanguageForView(){
        self.mLabelNavBar.text = NSLocalizedString("alertdetailview_navbar", comment: "")
    }

    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 17 * scaleDisplay)
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName, size: 12 * scaleDisplay)
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 12 * scaleDisplay)
        
        self.mButtonCheck.titleLabel!.font = UIFont(name: self.mButtonCheck.titleLabel!.font.fontName, size: 14 * scaleDisplay)
    }
    
    private func setConstraintForViews() {
        self.mTopConstraintLabelDate.constant = 17 * scaleDisplay
        self.mTopConstraintLabelTitle.constant = 17 * scaleDisplay
        self.mTopConstraintLabelContent.constant = 17 * scaleDisplay
        self.mTopConstraintButtonCheck.constant = 17 * scaleDisplay
        self.mBottomConstraintButtonCheck.constant = 17 * scaleDisplay
        self.mBottomConstraintScrollView.constant = 51 * scaleDisplay
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateDateFromObjectNotification () {
        self.mLabelTitle.text = self.objNotification.title
        if let time = Double(self.objNotification.created) {
            let date = Date(timeIntervalSince1970: time)
            let format = DateFormatter()
            format.dateFormat = "yyyy/MM/dd"
            format.locale = Locale(identifier: "en_US_POSIX")
            self.mLabelDate.text = format.string(from: date)
        } else {
            self.mLabelDate.text = ""
        }
        self.mLabelContent.text = self.objNotification.content
        if self.objNotification.target_url_label.isEmpty == false && self.objNotification.target_url.isEmpty == false {
            self.mButtonCheck.setTitle(self.objNotification.target_url_label , for: .normal)
        } else {
            self.mButtonCheck.isHidden = true
        }
        
    }
    
    func callAPIReadNotification() {
        if objNotification.is_read != "1" {
            
            let params = ["user_notification_id":objNotification.id, "user_id":PublicVariables.userInfo.m_id];
            APIBase.shareObject.callAPIReadNotification(params: params) { (result, error) in
                if result != nil {
                    if let status = result?["status"] as? NSNumber {
                        if status.intValue == 200 {
                            self.delegate?.callbackDelegateToRefreshListNotification(sender: self)
                        }
                    }
                    
                } else {
                    APIBase.shareObject.showAPIError(result: result)
                }
            }
        }
    }
    
    @IBAction func clickedButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickedButtonOpenWeb(_ sender: Any) {
        
        var string = self.objNotification.target_url
        if self.objNotification.target_url.contains("http") == false {
           string =  "http://" + string
        }
        
        if let url = URL(string: string) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
