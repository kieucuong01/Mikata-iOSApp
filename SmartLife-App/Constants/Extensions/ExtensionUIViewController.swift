//
//  ExtensionUIViewController.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 3/16/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import Foundation

extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    func setHideNavBar(isHiden: Bool){
        let navVC = UIApplication.shared.keyWindow?.rootViewController as? NavbarMainViewController
        navVC?.setVisibleNavigationBarCustom(isHidden: isHiden)
    }
}
