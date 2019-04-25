//
//  LoadingViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Firebase
import Repro

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingView: LoadingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.startAnimating()
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_LOADING, eventName: nil)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.getUserInfo()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Call API

    func getUserInfo() {
        if let userId: String = UserDefaults.standard.object(forKey: kUserDefaultUserId) as? String {
            let param = ["id": userId]
            APIBase.shareObject.callAPIGetUserProfile(params: param) { (result, error) in
                // No network
                if result == nil {
                    if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.setRootViewController(viewControllers: nil)
                    }
                }
                else {
                    let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                    if status == 200 {
                        PublicVariables.userInfo = User(dict: result?.value(forKey: "body") as! [String : Any] )
                        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeScore, object:  PublicVariables.userInfo.m_point)

                        // Login firebase
                        Auth.auth().signIn(withCustomToken: PublicVariables.userInfo.m_firebase_token, completion: { (user, error) in
                            // Check error
                            if error == nil {
                                FirebaseGlobalMethod.sendUserToServer()
                            }
                            else {
                                self.navigationController?.popViewController(animated: false)
                            }

                            // Set observe first time
                            FirebaseGlobalMethod.checkAndSetNewMessageObserve(navigationController: self.navigationController)
                        })
                    } else {
                        APIBase.shareObject.showAPIError(result: result)
                    }
                }
            }
        }
        else {
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.setRootViewController(viewControllers: nil)
            }
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - Private method
    func navigationMainController() {
    }
}
