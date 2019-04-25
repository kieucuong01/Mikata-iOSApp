//
//  APIBase+Setting.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


extension APIBase {
    func callAPIGetFAQ(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_USER_GET_FAQ)"
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIUnregisterPush(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_UNREGISTER_PUSH)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIRegisterPush(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_REGISTER_PUSH)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetTimeOutChat(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_CHAT_TIME_OUT)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
}

