//
//  NavbarMainViewController.swift
//  SmartTablet
//
//  Created by thanhlt on 7/7/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import CoreBluetooth

class NavbarMainViewController: UINavigationController {
    let keyWeVC : ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "keywevc") as! ViewController
    let keyWeLayer : KeyWeLib  = KeyWeLib()
    var macAddress: String = ""
    var eKeyDoor: String = ""
    var isTryForOldDoor : Bool = false
    var manager:CBCentralManager!
    var isOnBluetooth : Bool = false
    
    var navBarCustomView:NavBarCustomView = {
        let scale =  IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view:NavBarCustomView = (Bundle.main.loadNibNamed("NavBarCustomView", owner: self, options: nil))?[0] as! NavBarCustomView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: GlobalMethod.getTopPadding() + (51 * scale))
        view.isHidden = true
        return view
    }()
    override func viewDidLoad() {
        self.manager = CBCentralManager()
        self.manager.delegate = self
        self.keyWeLayer.delegate = self
        super.viewDidLoad()
        self.createSubviews()
        self.addNotificationCenter()
        // Do any additional setup after loading the view.
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
        self.view.addSubview(self.navBarCustomView)
        self.navBarCustomView.delegate = self
    }
    
    func setVisibleNavigationBarCustom(isHidden:Bool) {
        self.navBarCustomView.isHidden = isHidden
        self.navBarCustomView.alpha = CGFloat(Int(truncating: NSNumber(value:!isHidden)))
    }

    func setsetVisibleNavigationBarCustomWithAnimate(isHidden: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.navBarCustomView.alpha = CGFloat(Int(truncating: NSNumber(value:!isHidden)))
        }, completion:  {
            (value: Bool) in
            self.setVisibleNavigationBarCustom(isHidden: isHidden)
        })
    }
    
    @objc func updateTitleOfNavBarCustom(notification:Notification) {
        if let title = notification.object as? String {
            self.navBarCustomView.tittleNavBar.text = title
        }
    }

    @objc func updateBarForNotificationCenter(notification:Notification) {
        if let number = notification.object as? NSNumber {
            self.setVisibleNavigationBarCustom(isHidden: number.boolValue)
        }
    }

    @objc func updateScorePointUserNotificationCenter(notification:Notification) {
        if let number = notification.object as? String {
            self.navBarCustomView.updateScore(score: number)
        }
    }

    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(NavbarMainViewController.updateTitleOfNavBarCustom(notification:)), name: NSNotificationNavbarMainChangeTitle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NavbarMainViewController.updateBarForNotificationCenter(notification:)), name: NSNotificationNavbarMainHideNavbar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NavbarMainViewController.updateScorePointUserNotificationCenter(notification:)), name: NSNotificationNavbarMainChangeScore, object: nil)
    }
}


extension NavbarMainViewController: NavBarCustomViewDelegate {
    func clickButtonSettingInNavBar() {
        if self.isOnBluetooth == true {
        MBProgressHUD.showAdded(to: self.view, animated: false)
        self.callAPIGetDoorInfo()
        }
        else {
            GlobalMethod.showAlert(NSLocalizedString("please_turn_on_bluetooth", comment: ""))
        }

    }
    
    private func callAPIGetDoorInfo() {
        APIBase.shareObject.callAPIGetDoorInfomation(params: nil) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body: NSDictionary? = result?.value(forKey: "body") as? NSDictionary
                if let statusDoor = body?.object(forKey: "status") as? Int {
                    if statusDoor == 1 {
                        if let doorInfo : NSDictionary = body?.object(forKey: "door_info") as? NSDictionary{
                            if let macAddress = doorInfo.object(forKey: "bleMac") as? String,
                                let eKey = doorInfo.object(forKey: "eKeyDecoded") as? String {
                                self.macAddress = macAddress
                                self.eKeyDoor = eKey
                                self.keyWeVC.viewDidLoad()
                                self.keyWeVC.keywePlayer.delegate = self
                                self.isTryForOldDoor = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                    self.keyWeVC.unLockDoor(self.macAddress, eKey: self.eKeyDoor, isNewDoor: 1)
                                })
                            }
                        }
                        else {
                            GlobalMethod.hideAllMBProgressHUD(view: self.view)
                            GlobalMethod.showAlert(NSLocalizedString("no_permission_unlock_door", comment: ""))
                        }
                    }
                    else {
                        GlobalMethod.hideAllMBProgressHUD(view: self.view)
                        GlobalMethod.showAlert(NSLocalizedString("expire_permission_unlock_door", comment: ""))
                    }
                }
            }
            else {
                GlobalMethod.hideAllMBProgressHUD(view: self.view)
                APIBase.shareObject.showAPIError(result: result)
            }
        }
    }

    
    func callbackDelegateToButtonPoint() {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let pointPassbook : PointPassbookViewController = storyboard.instantiateViewController(withIdentifier: "PointPassbookViewController") as! PointPassbookViewController
            pointPassbook.delegate = self
            self.present(pointPassbook, animated: true, completion: nil)
    }
}

extension NavbarMainViewController: PointPassbookViewControllerDelegate {
    func mButtonSelectTouchUpInside() {
        for i in 0..<self.viewControllers.count {
            if let vc = self.viewControllers[i] as? TabbarMainViewController{
                vc.callDelegateClickedButtonPointExchange()
                return
            }
        }
    }
}

extension NavbarMainViewController : KeyWeDelegate {
    func onConnected(_ macAddr: String!, connectionResult: Int32) {
        if connectionResult == 0 {
            // success
            NSLog("Connected successfully")
            self.keyWeVC.keywePlayer.unLock()
        } else {
            NSLog("Fail to connect")
            // Try with old version door
            if self.isTryForOldDoor == false {
                NSLog("Try to connect old version door")
                self.isTryForOldDoor = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.keyWeVC.unLockDoor(self.macAddress, eKey: self.eKeyDoor, isNewDoor: 0)
                })
            }
            else {
                NSLog("No permission")
                GlobalMethod.hideAllMBProgressHUD(view: self.view)
                GlobalMethod.showAlert(NSLocalizedString("no_permission_unlock_door", comment: ""))
            }
        }

    }

    func onDisconnected(_ macAddr: String!) {
        NSLog("on Disconnected ")
        GlobalMethod.hideAllMBProgressHUD(view: self.view)
    }

    func onGetDoorStatus(_ macAddr: String!, doorStatus: NSMutableDictionary!) {
        NSLog("Door status ", doorStatus)
    }

    func onCommandReceived(_ macAddr: String!, cmdType: String!, cmdResult: String!) {
        NSLog("Unlock successfully")
        GlobalMethod.hideAllMBProgressHUD(view: self.view)
        self.keyWeVC.keywePlayer.disConnect()
    }
}

extension NavbarMainViewController : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.isOnBluetooth = true
            break
        case .poweredOff:
            self.isOnBluetooth = false
            break
        default:
            break
        }
    }
}
