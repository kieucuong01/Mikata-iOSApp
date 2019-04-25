//
//  SettingMenuViewController.swift
//  SmartTablet
//
//  Created by thanhlt on 7/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol SettingMenuViewControllerDelegate: class {
    func callbackDelegateToChangeNavBarLeftButtonIsClose()
    func callbackDelegateToChangeNavBarLeftButtonIsBack()
}

class SettingMenuViewController: UIViewController {
    
    @IBOutlet weak var viewTopMenu: UIView!
    weak var delegate:SettingMenuViewControllerDelegate? = nil
    private var scale:CGFloat = DISPLAY_SCALE
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.delegate?.callbackDelegateToChangeNavBarLeftButtonIsClose()

        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SETTING_MENU, eventName: nil)
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
    @IBAction func touchUpInsideBackButton(_ sender: Any) {
        
    }
}

extension SettingMenuViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return 51.2 * scale
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        for subview in cell.contentView.subviews {
            if subview.tag == 12 {
                let label:UILabel = subview as! UILabel
                label.font = UIFont.boldSystemFont(ofSize: 14 * scale)
                switch indexPath.row {
                case 1:
                    label.text = NSLocalizedString("settingview_label_policy", comment: "")
                    break
                case 2:
                    label.text = NSLocalizedString("settingview_label_logout", comment: "")
                    break
                default:
                    label.text = NSLocalizedString("settingview_label_termofuse", comment: "")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SETTING_MENU, eventName: ReproEvent.REPRO_SCREEN_SETTING_MENU_ACTION_LOGOUT)

            let logoutView = ConfirmLogoutView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT ))
            logoutView.delegate = self
            self.navigationController?.view.addSubview(logoutView)

            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOGOUT_CONFIRM, eventName: nil)

            //Show alert log out
            break
        case 1:
            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SETTING_MENU, eventName: ReproEvent.REPRO_SCREEN_SETTING_MENU_ACTION_GO_PRIVACY)

            NotificationCenter.default.post(name: NSNotificationChangeTitleNavBarSetting, object: NSLocalizedString("settingview_label_policy", comment: ""))
            let termVC = SettingSubTermViewController()
            termVC.type = .privacy
            termVC.delegate = self
            self.navigationController?.pushViewController(termVC, animated: true)
            break;
        default:
            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SETTING_MENU, eventName: ReproEvent.REPRO_SCREEN_SETTING_MENU_ACTION_GO_TERM)

            NotificationCenter.default.post(name: NSNotificationChangeTitleNavBarSetting, object: NSLocalizedString("settingview_label_termofuse", comment: ""))
            let termVC = SettingSubTermViewController()
            termVC.type = .termOfUserInSetting
            termVC.delegate = self
            self.navigationController?.pushViewController(termVC, animated: true)
        }
    }
}

extension SettingMenuViewController: ConfirmLogoutViewDelegate {
    func callLogout() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingMenuViewController: SettingSubTermViewControllerDelegate {
    func callbackDelegateToChangeIconClose() {
        self.delegate?.callbackDelegateToChangeNavBarLeftButtonIsClose()
    }
    
    func callbackDelegateToChangeIconBack() {
        self.delegate?.callbackDelegateToChangeNavBarLeftButtonIsBack()
        
    }
}
