//
//  APIBase+User.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


extension APIBase {
    //MARK: - USER API
    func callAPIAddAndUpdateUser(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_ADD_UPDATE_USER)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        print("API is newParam :\(newParam)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }
        
        
    }
    
    func callAPILogin(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_LOGIN)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }
        
    }

    func callAPILoginMikata(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_GET_LOGIN_MIKATA)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }

    }

    func callAPIRegisterMikataAccount(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_GET_REGISTER_MIKATA)"
       var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }

    }
    
    func callAPICheckValidate(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_USER_VALIDATE)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIListKabocha(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_KABOCHA_ALL)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }
        
    }
    
    func callAPIListAvatarIcon(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_LIST_AVATAR_ICON)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
        
    }
    
    
    func callAPIUpdateIcon(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_UPDATE_AVATAR_ICON)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
        
    }
    
    func callAPIGetUserProfile(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_USER_PROFILES)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
        
    }
    
    func callAPIUserBoughtItemUpdate(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_USER_BOUGHT_ITEM_UPDATE)"
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    
    func callAPIGetMyPageSkill(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_GET_MY_PAGE_SKILL_ALL)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
        
    }

    func callAPIForgetPassword(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_USER_FORGETPASSWORD)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIUserActivation(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_USER_ACTIVATION)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIUpdatePassword(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_USER_UPDATE_PASSWORD)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetNumberOfUserByBuilding(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_USER_TOTAL_USER_BY_BUILDING)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
}
