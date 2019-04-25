//
//  NewBaseViewController.swift
//  FundaNote
//
//  Created by Hoang Nguyen on 11/17/16.
//  Copyright © 2017 QUICK Corp. All rights reserved.
//

import UIKit

class NewBaseViewController: UIViewController {
    // Check first appear
    var isFirstAppear = true

    // Check to ingore push view controller
    var shouldIgnorePushingViewControllers: Bool = false

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Call super
        super.prepare(for: segue, sender: sender)
    }

    /*
     * Created by: hoangnn
     * Description: Check and perform segue
     */
    func checkAndPerformSegue(with identifier: String) {
        if self.shouldIgnorePushingViewControllers == false {
            // Push view controller
            if let segueTemplates: NSArray = self.value(forKey: "storyboardSegueTemplates") as? NSArray {
                let filteredArray: NSArray = segueTemplates.filtered(using: NSPredicate(format: "identifier = %@", identifier)) as NSArray
                // Can perform this segue
                if filteredArray.count > 0 {
                    self.performSegue(withIdentifier: identifier, sender: self)
                }
            }

            // Set should ignore push
            self.shouldIgnorePushingViewControllers = true
        }
    }

    // MARK: - View Lifecycle

    override func didReceiveMemoryWarning() {
        // Call super
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        // Call super
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Call super
        super.viewWillAppear(animated)

        // Update status bar
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

        // Reset should ignore push view controller
        self.shouldIgnorePushingViewControllers = false

        // Configure view when first appear
        if self.isFirstAppear == true {
            // Update isFirstAppear
            self.isFirstAppear = false

            // Configure self
            self.configureSelf()

            // Configure subviews
            self.configureSubviews()

            // Disable multi touch
            self.view.enableExclusiveTouchForViewAndSubView()
        }
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
    }
    
    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    func configureSubviews() {
        // Configure subviews
    }
}
