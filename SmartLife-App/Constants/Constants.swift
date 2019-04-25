//
//  Constants.swift
//  SmartTablet
//
//  Created by thanhlt on 6/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit


let SIZE_WIDTH:CGFloat          =       UIScreen.main.bounds.size.width
let SIZE_HEIGHT:CGFloat         =       UIScreen.main.bounds.size.height

let DISPLAY_SCALE:CGFloat       =       SIZE_WIDTH/320.0
let DISPLAY_SCALE_IPAD:CGFloat  =       SIZE_WIDTH/768.0


//MARK:- Device
let IS_IPAD             =       UI_USER_INTERFACE_IDIOM() == .pad


//MARK: - Link
let LINK_TERM_OF_USE    =       "useterms/web"
let LINK_POLICY         =       "privacy_policy"


//MARK: - Notification Name
let NSNotificationNavbarMainHideNavbar      =        NSNotification.Name("NSNotificationNavbarMainHideNavbar")
let NSNotificationNavbarMainShowAlertCustomView      =        NSNotification.Name("NSNotificationNavbarMainShowAlertCustomView")
let NSNotificationNavbarMainShowConfirmExchangePointView      =        NSNotification.Name("NSNotificationNavbarMainShowConfirmExchangePointView")
let NSNotificationNavbarMainNavigateToGetPointView     =        NSNotification.Name("NSNotificationNavbarMainNavigateToGetPointView")
let NSNotificationNavbarMainNavigateToExchangePointView     =        NSNotification.Name("NSNotificationNavbarMainNavigateToExchangePointView")
let NSNotificationNavbarMainChangeScore     =        NSNotification.Name("NSNotificationNavbarMainChangeScore")
let NSNotificationNavbarMainChangeTitle     =        NSNotification.Name("NSNotificationNavbarMainChangeTitle")
let NSNotificationChangeTitleNavBarSetting  =        NSNotification.Name("NSNotificationChangeTitleNavBarSetting")
let NSNotificationShowHUDProgress           =        NSNotification.Name("NSNotificationShowHUDProgress")
let NSNotificationHideHUDProgress           =        NSNotification.Name("NSNotificationHideHUDProgress")


//MARK: - UserDefault Name
let kUserIsRunning = "kUserIsRunning"
let kUserDefaultUserId = "kUserDefaultUserID"
let kUserDefaultAccessToken = "kUserDefaultAccessToken"
let kUserDefaultUserListLastMessageId = "kUserDefaultUserListLastMessageId"

//MARK: COLOR
let primaryColor : UIColor = UIColor(red: 252, green: 107, blue: 42)
let lightGrayColor : UIColor = UIColor(red: 123, green: 122, blue: 122)
let grayColor = UIColor(red: 68, green: 68, blue: 68)
