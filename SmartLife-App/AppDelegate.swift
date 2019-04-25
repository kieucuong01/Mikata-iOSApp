 //
 //  AppDelegate.swift
 //  smart_tablet
 //
 //  Created by thanhlt on 7/26/17.
 //  Copyright © 2017 thanhlt. All rights reserved.
 //

 import UIKit
 import Fabric
 import Crashlytics
 import Repro
 import Firebase
 import UserNotifications

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var notificationInfo: [AnyHashable : Any]? = nil
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set japanese for default language
        UserDefaults.standard.set(["ja"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // detect notification
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            self.notificationInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
        }

        Repro.setup("109cbb85-0457-4ad8-830c-cb32124f794d")
        Repro.startRecording()
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SPLASH, eventName: nil)

        self.loadFont()
        Fabric.with([Crashlytics.self])
        // Override point for customization after application launch.
        PublicVariables.api_auth_date = Date().toMillis().description
        PublicVariables.api_auth_key = ("smarttablet" + PublicVariables.api_auth_date).md5()
        print("PublicVariables.api_auth_date : \(PublicVariables.api_auth_date)" )
        print("PublicVariables.api_auth_date : \(PublicVariables.api_auth_key)" )

        // Configure firebase
        FirebaseApp.configure()

        // Register remote notification
        self.registerRemoteNotification(application: application)
        // Check auto login
        self.checkAutoLoginNew()

        // Set custom style
        self.setCustomStyle()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UserDefaults.standard.set(false, forKey: kUserIsRunning)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UserDefaults.standard.set(true, forKey: kUserIsRunning)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let params = url.queryParameters{
            if params["action"] != nil && params["token"] != nil{
                if params["action"] == "login" {
                    let token = params["token"]
                    // Get LoginVC
                    let storyboardLogin: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    if let loginVC: LoginViewController = storyboardLogin.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
                        self.setRootViewController(viewControllers: [loginVC])
                        loginVC.callAPILoginWith(token: token)
                    }
                }
            }
        }

        return true
    }


    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notiInfo = userInfo

        let isRunning : Bool = (UserDefaults.standard.object(forKey: kUserIsRunning) as? Bool) ?? false
        if isRunning == false && self.notificationInfo == nil {
            self.presentChatViewFromNotification(notificationInfo: notiInfo)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    // MARK: - Public Methods

    /*
     * Created by: hoangnn
     * Description: Register remote notification
     */
    func registerRemoteNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            // Register remote notification
            application.registerForRemoteNotifications()
        }
        else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

    }

    /*
     * Created by: cuongkt
     * Description: Increase bagde number
     */
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
    }

    /*
     * Created by: hoangnn
     * Description: Set root view controller
     */
    func setRootViewController(viewControllers: [UIViewController]?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootVC: BaseVCTutorialScreen = storyboard.instantiateViewController(withIdentifier: "BaseVCTutorialScreen") as? BaseVCTutorialScreen {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let rootNavigationController: NavbarMainViewController = NavbarMainViewController()
            rootNavigationController.automaticallyAdjustsScrollViewInsets = false
            rootNavigationController.isNavigationBarHidden = true
            if viewControllers != nil { rootNavigationController.setViewControllers(viewControllers!, animated: true) }
            else { rootNavigationController.setViewControllers([rootVC], animated: true) }
            self.window?.rootViewController = rootNavigationController
            self.window?.makeKeyAndVisible()
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        }
    }

    /*
     * Created by: cuongkt
     * Description: Check auto login
     */
    func checkAutoLoginNew() {
        let accessToken: String? = UserDefaults.standard.object(forKey: kUserDefaultAccessToken) as? String
        let userId: String? = UserDefaults.standard.object(forKey: kUserDefaultUserId) as? String
        if accessToken != nil && userId != nil{
            // Send Id to Repro
            Repro.setUserID(userId)

            // Get LoginVC
            let storyboardLogin: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC: LoginViewController? = storyboardLogin.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController

            // Get loadingVC
            let storyboarLoading: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
            let loadingVC: LoadingViewController? = storyboarLoading.instantiateViewController(withIdentifier: "loadingVC") as? LoadingViewController

            // Set root view controller
            self.setRootViewController(viewControllers: [loginVC!, loadingVC!])
        }
        else {
            // Set root view controller
            self.setRootViewController(viewControllers: nil)
        }
    }

    func loadFont() {
        _ = UIFont(name: "YuGothic-Bold", size: 10)
        _ = UIFont(name: "YuGo-Medium", size: 10)
    }

    /*
     * Created by: hoangnn
     * Description: Set custom style
     */
    func setCustomStyle() {
        UITextView.appearance().linkTextAttributes = [NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
    }

    /*
     * Created by: cuongkt
     * Description: Present chat view from push notification
     */
    func presentChatViewFromNotification(notificationInfo : [AnyHashable : Any]) {
        if let topController = UIApplication.topViewController() {
            if let roomId = notificationInfo["gcm.notification.roomId"] as? String{
                if let staffName = notificationInfo["gcm.notification.staffName"] as?  String{
                    if let userId: String = roomId.components(separatedBy: "_").last{
                        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
                        if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
                            chatVC.conversationName = staffName
                            let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: userId)
                            chatVC.selectedGroupId = groupId
                            chatVC.selectedGroupDatabase = roomReference
                            topController.present(chatVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

 }

 @available(iOS 10, *)
 extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let notiInfo = response.notification.request.content.userInfo

        let isRunning : Bool = (UserDefaults.standard.object(forKey: kUserIsRunning) as? Bool) ?? false
        if isRunning == false && self.notificationInfo == nil {
            self.presentChatViewFromNotification(notificationInfo: notiInfo)
        }
        completionHandler()
    }


 }

 extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }
 }

 extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
 }
