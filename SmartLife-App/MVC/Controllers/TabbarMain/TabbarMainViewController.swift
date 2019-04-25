//
//  TabbarMainViewController.swift
//  SmartTablet
//
//  Created by thanhlt on 7/7/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Firebase

class TabbarMainViewController: UITabBarController {

    var viewTabbar:TabbarCustomView = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view:TabbarCustomView = Bundle.main.loadNibNamed("TabbarCustomView", owner: self, options: nil)?[0] as! TabbarCustomView
        view.frame = CGRect(x: 0, y: SIZE_HEIGHT - (64 * scale + GlobalMethod.getBottomPadding()), width: SIZE_WIDTH, height: (64 * scale + GlobalMethod.getBottomPadding()))
        view.layoutIfNeeded()
        return view
    }()

    var popUpCustomView: PopUpTopCustomView = {
        let view: PopUpTopCustomView = PopUpTopCustomView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT))
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.isHidden = true
        return view

    }()

    var alertCustomView: AlertConfirmCustomView = {
        let view: AlertConfirmCustomView = (Bundle.main.loadNibNamed("AlertConfirmCustomView", owner: self, options: nil))?[0] as! AlertConfirmCustomView
        view.frame = CGRect(x:0 , y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()

    var viewConfirmExchangePoint:ConfirmExchangePointView = {
        let view:ConfirmExchangePointView = (Bundle.main.loadNibNamed("ConfirmExchangePointView", owner: self, options: nil))?[0] as! ConfirmExchangePointView
        view.frame = CGRect(x:0 , y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()

    var topPage:TimeLineNavigationController? = nil
    var navMyPage:MyPageNavigationController? = nil
    var chatListPage:ChatListNavigationController? = nil
    var alertPage:AlertNavigationController? = nil
    var isHideTitleTabbar : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseGlobalMethod.tabbarMainVC = self

        self.createSubviews()
        self.setPropertiesOfViewControllers()
        self.addObserverForViewController()

        // Do any additional setup after loading the view.
        FirebaseGlobalMethod.getMyListRoomMessage(completion: { (response: [RoomMessageModel]) in })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        // Check is need open chat
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let notificationInfo = appDelegate?.notificationInfo {
            appDelegate?.presentChatViewFromNotification(notificationInfo: notificationInfo)
            // Reset
            appDelegate?.notificationInfo = nil
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

    //MARK: - Getter
    func setHideTitleTabar(isHiden: Bool) {
        self.isHideTitleTabbar = isHiden
        if isHiden == true {
            UIView.animate(withDuration: 0.4, animations: {
                self.viewTabbar.frame = CGRect(x: 0, y: SIZE_HEIGHT - (50 * GlobalMethod.displayScale + GlobalMethod.getBottomPadding()), width: SIZE_WIDTH, height: (50 * GlobalMethod.displayScale + GlobalMethod.getBottomPadding()))
                self.viewTabbar.setAlphaTitleTabar(alpha: 0.0)
                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.4, animations: {
                self.viewTabbar.frame = CGRect(x: 0, y: SIZE_HEIGHT - (64 * GlobalMethod.displayScale + GlobalMethod.getBottomPadding()), width: SIZE_WIDTH, height: (64 * GlobalMethod.displayScale + GlobalMethod.getBottomPadding()))
                self.viewTabbar.setAlphaTitleTabar(alpha: 1.0)
                self.view.layoutIfNeeded()
            })
        }
    }

    private func createSubviews() {
        self.view.addSubview(self.viewTabbar)
        self.navigationController?.view.addSubview(self.popUpCustomView)
        self.view.addSubview(self.viewConfirmExchangePoint)
        self.view.addSubview(self.alertCustomView)
        self.popUpCustomView.delegate = self
        self.viewTabbar.delegate = self
        self.alertCustomView.delegate = self
        self.viewConfirmExchangePoint.delegate = self
        self.viewConfirmExchangePoint.parentViewController = self
    }

    private func setPropertiesOfViewControllers() {
        let navVC = self.navigationController as? NavbarMainViewController
        navVC?.setVisibleNavigationBarCustom(isHidden: false)


        topPage = self.viewControllers![0] as? TimeLineNavigationController

        let storyboardMyPage = UIStoryboard(name: "MyPage", bundle: nil)
        navMyPage = storyboardMyPage.instantiateInitialViewController() as? MyPageNavigationController
        if let topMyPage = navMyPage!.viewControllers[0] as? TopMyPageViewController {
            topMyPage.delegate = self
        }

        let storyboardAlert = UIStoryboard(name: "Alert", bundle: nil)
        alertPage = storyboardAlert.instantiateInitialViewController() as? AlertNavigationController

        let storyboardChatList = UIStoryboard(name: "ChatList", bundle: nil)
        chatListPage = storyboardChatList.instantiateInitialViewController() as? ChatListNavigationController

        self.viewControllers = [topPage!,chatListPage!, alertPage!, navMyPage!]

    }

    private func addObserverForViewController() {

        NotificationCenter.default.addObserver(self, selector: #selector(TabbarMainViewController.showAlertCustomView(notification:)), name: NSNotificationNavbarMainShowAlertCustomView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TabbarMainViewController.showConfirmExchangePointView(notification:)), name: NSNotificationNavbarMainShowConfirmExchangePointView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TabbarMainViewController.navigateToGetPointView(notification:)), name: NSNotificationNavbarMainNavigateToGetPointView, object: nil)
    }

    @objc func showConfirmExchangePointView(notification: Notification) {
        let dict:NSDictionary = notification.object as! NSDictionary
        self.viewConfirmExchangePoint.updateViewsWithDict(dict: dict)
        self.viewConfirmExchangePoint.isHidden = false
    }


    @objc func navigateToGetPointView(notification: Notification) {
        self.viewConfirmExchangePoint.isHidden = true
        self.callDelegateClickedButtonPointGet()
        // let timeLineVC:TimeLineViewController = (topPage?.viewControllers[0] as? TimeLineViewController)!
    }

    @objc func showAlertCustomView(notification:Notification) {
        if let dict = notification.object as? [String : String] {
            self.alertCustomView.updateAlertViewWithDict(dict: dict)
        }
        self.alertCustomView.isHidden = false;
    }
}

extension TabbarMainViewController: TabbarCustomViewDelegate {
    func calledButtonChat() {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_ADD_NEW_CONSULTATION, eventName: nil)

        self.popUpCustomView.isHidden = false
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        // Show buttonChat
        self.popUpCustomView.showButtonChatAnimation()

        // Update button Chat Close
        self.popUpCustomView.updateButtonChat(isHideTitle: self.isHideTitleTabbar)

        let buttonChat = self.popUpCustomView.viewWithTag(4) as! UIButton
        buttonChat.isUserInteractionEnabled = false

        if let labelTitle = self.popUpCustomView.viewWithTag(3) as? UILabel {
            let y = SIZE_HEIGHT - (154 * scale) - GlobalMethod.getBottomPadding()

            UIView.animate(withDuration: 0.4, animations: {
                labelTitle.frame.origin.y = y
            },completion: {finised in

                if let buttonHome = self.popUpCustomView.viewWithTag(1) {
                    if let buttonConsultant = self.popUpCustomView.viewWithTag(2) {
                        let xConsultant = SIZE_WIDTH/2 + 19 * scale
                        let xHome =  SIZE_WIDTH/2 - 102 * scale
                        let y = SIZE_HEIGHT - (137 * scale) - GlobalMethod.getBottomPadding()

                        UIView.animate(withDuration: 0.3, animations: {
                            buttonHome.frame.origin.x = xHome
                            buttonHome.frame.origin.y = y

                            buttonConsultant.frame.origin.x = xConsultant
                            buttonConsultant.frame.origin.y = y
                        },completion: { finised in
                            let xConsultant = SIZE_WIDTH/2 + 14 * scale
                            let xHome = SIZE_WIDTH/2 - 97 * scale
                            let y = SIZE_HEIGHT - (130 * scale) - GlobalMethod.getBottomPadding()

                            UIView.animate(withDuration: 0.2, animations: {
                                buttonHome.frame.origin.x = xHome
                                buttonHome.frame.origin.y = y

                                buttonConsultant.frame.origin.x = xConsultant
                                buttonConsultant.frame.origin.y = y
                            },completion: { finised in
                                buttonChat.isUserInteractionEnabled = true
                            })

                        })
                    }
                }
            })
        }
    }

    func calledButtonHomePage() {
        var isNeedToScrollTop : Bool = false
        if self.selectedIndex == 0 {
            isNeedToScrollTop = true
        }
        self.selectedIndex = 0
        self.topPage?.popToRootViewController(animated: false)
        if self.topPage?.viewControllers.indices.contains(0) == true {
            if let rootVC = self.topPage?.viewControllers[0] as? TimeLineViewController {
                
                rootVC.collectionView.setContentOffset(CGPoint(x: 0.0 ,y: 0), animated: true)
                if isNeedToScrollTop == true {
                    let timeLineCell = rootVC.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TimeLineCollectionCell
                    
                    timeLineCell?.tableView.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
    }

    func calledButtonMyPage() {
        self.selectedIndex = 3
    }

    func calledButtonChatList() {
        self.selectedIndex = 1
    }

    func calledButtonAlert() {
        self.selectedIndex = 2
    }
}

extension TabbarMainViewController: AlertConfirmCustomViewDelegate {
    func callbackActionClickedButtonDecline() {

    }

    func callbackActionClickedButtonAccept() {
        topPage?.popToRootViewController(animated: true)
        if let vc = topPage?.presentedViewController {
            vc.dismiss(animated: true, completion: {

            })
        }
    }

    func callbackActionClickedButtonSuccess() {
        topPage?.popToRootViewController(animated: true)
    }
}

// MARK: - PopUpTopCustomViewDelegate
extension TabbarMainViewController: PopUpTopCustomViewDelegate {
    func calledButtonConsultation() {
        // Push to chat job
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            chatVC.conversationName = NSLocalizedString("ChatViewController_Title_Job", comment: "")
            let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: "job-consult")
            chatVC.selectedGroupId = groupId
            chatVC.selectedGroupDatabase = roomReference
            self.present(chatVC, animated: true, completion: nil)
        }

        self.popUpCustomView.isHidden = true
    }

    func calledButtonHome() {
        // Push to chat living
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            chatVC.conversationName = NSLocalizedString("ChatViewController_Title_Living", comment: "")
            let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: "living")
            chatVC.selectedGroupId = groupId
            chatVC.selectedGroupDatabase = roomReference
            self.present(chatVC, animated: true, completion: nil)
        }

        self.popUpCustomView.isHidden = true
    }

    func calledButtonChatClose() {
        self.popUpCustomView.isHidden = true
    }
}

extension TabbarMainViewController: ConfirmExchangePointViewDelegate {
    func finishExchangePointProgress(sender: ConfirmExchangePointView) {
        self.viewConfirmExchangePoint.isHidden = true
        self.topPage?.popToRootViewController(animated: true)
    }
}


extension TabbarMainViewController:TopMyPageViewControllerDelegate {
    func callDelegateClickedButtonPointGet() {
        self.viewTabbar.changeToHomePage()
        self.selectedIndex = 0
        self.topPage?.popToRootViewController(animated: false)
        if self.topPage?.viewControllers.indices.contains(0) == true {
            if let rootVC = self.topPage?.viewControllers[0] as? TimeLineViewController {
                rootVC.collectionView.setContentOffset(CGPoint(x: SIZE_WIDTH,y: 0), animated: true)
            }
        }
    }

    func callDelegateClickedButtonPointExchange() {
        self.viewTabbar.changeToHomePage()
        self.selectedIndex = 0
        self.topPage?.popToRootViewController(animated: false)
        if self.topPage?.viewControllers.indices.contains(0) == true {
            if let rootVC = self.topPage?.viewControllers[0] as? TimeLineViewController {
                rootVC.collectionView.setContentOffset(CGPoint(x: 2 * SIZE_WIDTH,y: 0), animated: true)
            }
        }
    }

    func callDelegateClickedButtonBytes() {
        self.viewTabbar.changeToHomePage()
        self.selectedIndex = 0
        self.topPage?.popToRootViewController(animated: false)
        if self.topPage?.viewControllers.indices.contains(0) == true {
            if let rootVC = self.topPage?.viewControllers[0] as? TimeLineViewController {
                rootVC.collectionView.setContentOffset(CGPoint(x: 3 * SIZE_WIDTH,y: 0), animated: true)
            }
        }
    }

    func callDelegateClickedButtonJobIntro() {
        self.viewTabbar.changeToHomePage()
        self.selectedIndex = 0
        self.topPage?.popToRootViewController(animated: false)
        if self.topPage?.viewControllers.indices.contains(0) == true {
            if let rootVC = self.topPage?.viewControllers[0] as? TimeLineViewController {
                rootVC.collectionView.setContentOffset(CGPoint(x: 4 * SIZE_WIDTH,y: 0), animated: true)
            }
        }
    }

    func callDelegateClickedButtonNote() {
        self.viewTabbar.changeToHomePage()
        self.selectedIndex = 0
        self.topPage?.popToRootViewController(animated: false)
        if self.topPage?.viewControllers.indices.contains(0) == true {
            if let rootVC = self.topPage?.viewControllers[0] as? TimeLineViewController {
                rootVC.collectionView.setContentOffset(CGPoint(x: 5 * SIZE_WIDTH,y: 0), animated: true)
            }
        }
    }
}
