//
//  ListAlertsViewController.swift
//  SmartLife-App
//
//  Created by DELL7447 on 9/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import ObjectMapper

class ListAlertsViewController: BaseViewController {
    @IBOutlet weak var mTopConstraintButtonCheck: NSLayoutConstraint!
    @IBOutlet weak var mTopConstrantLabelEmpty: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintImageView: NSLayoutConstraint!
    @IBOutlet weak var mButtonAll: UIButton!
    @IBOutlet weak var mButtonUnread: UIButton!
    @IBOutlet weak var mButtonRead: UIButton!
    
    @IBOutlet weak var mSearchBarCustomView: SearchBarCustomView!
    
    @IBOutlet weak var mLabelEmpty: UILabel!
    @IBOutlet weak var mViewEmpty: UIView!
    @IBOutlet weak var mButtonCheck: UIButton!
    
    
    @IBOutlet weak var mTableListAlert: UITableView!
    var arrayNotification:[NotificationObj] = [NotificationObj]()
    
    var mKeywordSearch:String = ""
    var selectedIndex = 0
    var indexPage = 0
    var limitNotifications = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropetiesForViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setHideNavBar(isHiden: false)
        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeTitle, object: NSLocalizedString("listalertview_navbar", comment: ""))
        self.clickedButtonAll(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: - Private method
    private func setLanguageForView(){
        self.mLabelEmpty.text = NSLocalizedString("listalertview_label_empty", comment: "")

        self.mButtonAll.setTitle(NSLocalizedString("listalertview_button_all", comment: ""), for: .normal)
        self.mButtonUnread.setTitle(NSLocalizedString("listalertview_button_unread", comment: ""), for: .normal)
        self.mButtonRead.setTitle(NSLocalizedString("listalertview_button_read", comment: ""), for: .normal)
        self.mButtonCheck.setTitle(NSLocalizedString("listalertview_button_check", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        self.mTopConstraintImageView.constant = 81 * scaleDisplay
        self.mTopConstrantLabelEmpty.constant = 14 * scaleDisplay
        self.mTopConstraintButtonCheck.constant = 10 * scaleDisplay
    }
    
    private func setFontForViews() {
        self.mButtonAll.titleLabel?.font = UIFont(name: self.mButtonAll.titleLabel!.font.fontName, size: 14 * scaleDisplay)
        self.mButtonUnread.titleLabel?.font = UIFont(name: self.mButtonUnread.titleLabel!.font.fontName, size: 14 * scaleDisplay)
        self.mButtonRead.titleLabel?.font = UIFont(name: self.mButtonRead.titleLabel!.font.fontName, size: 14 * scaleDisplay)
        self.mButtonCheck.titleLabel?.font = UIFont(name: self.mButtonCheck.titleLabel!.font.fontName, size: 14 * scaleDisplay)
        
        self.mLabelEmpty.font = UIFont(name: self.mLabelEmpty.font.fontName, size: 12 * scaleDisplay)
    }
    
    private func setPropetiesForViews() {
        self.mButtonRead.layer.cornerRadius = 4
        self.mButtonAll.layer.cornerRadius = 4
        self.mButtonUnread.layer.cornerRadius = 4
        
        self.mViewEmpty.isHidden = true
        self.mSearchBarCustomView.delegate = self
        self.addForegroundKeyboard(parentView: self.view)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//MARK: - Call API
    func callAPIGetListNotifications() {
        
        MBProgressHUD.showAdded(to:self.view, animated: true)
        var param = [String:Any]()
        param["user_id"] = PublicVariables.userInfo.m_id
        param["login_user_id"] = PublicVariables.userInfo.m_id
        param["title"] = self.mKeywordSearch
        param["page"] = String(indexPage + 1)
        param["limit"] = String(limitNotifications)
        param["read_date"] = "0"
        param["unread_date"] = "0"
        if selectedIndex == 2 {
            param["unread_date"] = "1"
        } else if selectedIndex == 3 {
            param["read_date"] = "1"
        }
        
        self.arrayNotification.removeAll()
        APIBase.shareObject.callAPIGetListNotification(params:param) { (result, error) in
            //Structure
            /*
                {
                    body: {
                        data : [, 
                                ]
                    },
                    status: 200 // success
                }
             */
            
            if let dictionary = result as? [String:Any?] {
                
                if let status = dictionary["status"] as? NSNumber {
                    
                    if status.intValue == 200 {
                        if let body = dictionary["body"] as? [String:Any] {
                            
                            if let array = body["data"] as? [[String:Any]] {
                                
                                self.arrayNotification = Mapper<NotificationObj>().mapArray(JSONArray: array)
                                if array.count > 0 {
                                    self.mTableListAlert.isHidden = false
                                    self.mViewEmpty.isHidden = true
                                } else {
                                    //empty array
                                    self.mTableListAlert.isHidden = true
                                    self.mButtonCheck.isHidden = true
                                    self.mViewEmpty.isHidden = false
                                    if self.selectedIndex == 3 {
                                        self.mButtonCheck.isHidden = false
                                    }
                                }
                            } else {
                                print("api get list notification non array")
                                self.mTableListAlert.isHidden = true
                                self.mButtonCheck.isHidden = true
                                self.mViewEmpty.isHidden = false
                                if self.selectedIndex == 3 {
                                    self.mButtonCheck.isHidden = false
                                }
                            }
                        } else {
                            print("api get list notification error array")
                        }
                    } else {
                        print("api get list notification error status")
                        
                    }
                }
            } else {
                if error != nil {
                    
                }
                APIBase.shareObject.showAPIError(result: result as? NSDictionary)
            }
            self.mTableListAlert.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
//MARK: - Selector
    
    @IBAction func clickedButtonAll(_ sender: Any?) {
        self.hiddenKeyboardOnView()
        //Check status select button
        if selectedIndex == 1 {
            return
        }
        // Track repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ALERT, eventName: ReproEvent.REPRO_SCREEN_ALERT_ACTION_TAB_ALL)

        //Set new status select button
        selectedIndex = 1
        
        //Set Color for buttons
        self.mButtonAll.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#000000")
        self.mButtonAll.setTitleColor(.white, for: .normal)
        
        
        self.mButtonUnread.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#D8D8D8")
        self.mButtonUnread.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#7B7A7A"), for: .normal)
        
        self.mButtonRead.backgroundColor = GlobalMethod.hexStringToUIColor(hex:"#D8D8D8")
        self.mButtonRead.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#7B7A7A"), for: .normal)
        
        self.mViewEmpty.isHidden = true
        self.mButtonCheck.isHidden = true
        self.mTableListAlert.isHidden = false
        self.callAPIGetListNotifications()
    }
    @IBAction func clickedButtonUnread(_ sender: Any?) {
        
        self.hiddenKeyboardOnView()
        //Check status select button
        if selectedIndex == 2 {
            return
        }
        // Track repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ALERT, eventName: ReproEvent.REPRO_SCREEN_ALERT_ACTION_TAB_UNREAD)

        //Set new status select button
        selectedIndex = 2
        
        //Set Color for buttons
        self.mButtonUnread.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#000000")
        self.mButtonUnread.setTitleColor(.white, for: .normal)
        
        
        self.mButtonAll.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#D8D8D8")
        self.mButtonAll.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#7B7A7A"), for: .normal)
        
        self.mButtonRead.backgroundColor = GlobalMethod.hexStringToUIColor(hex:"#D8D8D8")
        self.mButtonRead.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#7B7A7A"), for: .normal)
        
        self.mLabelEmpty.text = NSLocalizedString("listalertview_label_empty_unread_notice", comment: "empty list read")
        self.callAPIGetListNotifications()
    }
    
    @IBAction func clickedButtonRead(_ sender: Any?) {
        self.hiddenKeyboardOnView()
        //Check status select button
        if selectedIndex == 3 {
            return
        }

        // Track repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ALERT, eventName: ReproEvent.REPRO_SCREEN_ALERT_ACTION_TAB_READ)

        //Set new status select button
        selectedIndex = 3
        
        //Set Color for buttons
        self.mButtonRead.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#000000")
        self.mButtonRead.setTitleColor(.white, for: .normal)
        
        
        self.mButtonUnread.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#D8D8D8")
        self.mButtonUnread.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#7B7A7A"), for: .normal)
        
        self.mButtonAll.backgroundColor = GlobalMethod.hexStringToUIColor(hex:"#D8D8D8")
        self.mButtonAll.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#7B7A7A"), for: .normal)
        
        
        self.mLabelEmpty.text = NSLocalizedString("listalertview_label_empty_read_notice", comment: "empty list read")
        
        self.callAPIGetListNotifications()
    }
    
    @IBAction func clickedButtonCheck(_ sender: Any) {
        self.clickedButtonUnread(self.mButtonUnread)

    }
    func hiddenKeyboardOnView (){
        self.mSearchBarCustomView.textFieldCell.resignFirstResponder()
    }
}

extension ListAlertsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayNotification.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: AlertViewCell = tableView.dequeueReusableCell(withIdentifier: "alertViewCell") as? AlertViewCell {
            cell.mBotttomLineView.isHidden = true
            if indexPath.row == self.arrayNotification.count - 1 {
                cell.mBotttomLineView.isHidden = false
            }
            if self.arrayNotification.indices.contains(indexPath.row) == true {
                cell.updateAlertViewCellAtIndexPath(index: indexPath,andObject: self.arrayNotification[indexPath.row])
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hiddenKeyboardOnView()
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AlertDetailViewController") as? AlertDetailViewController {
            if self.arrayNotification.indices.contains(indexPath.row) == true {
                detailVC.objNotification = self.arrayNotification[indexPath.row]
            }
            detailVC.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
}

extension ListAlertsViewController: AlertDetailViewControllerDelegate {
    func callbackDelegateToRefreshListNotification(sender: AlertDetailViewController) {
        self.callAPIGetListNotifications()
    }
}

extension ListAlertsViewController: SearchBarCustomViewDelegate {
    func callbackActionClickedButtonFilter() {
    }

    func callAPISearchPointItems(keyword: String) {
        self.mKeywordSearch = keyword.trimmingCharacters(in: .whitespaces)
        self.callAPIGetListNotifications()
    }
}
