//
//  APIBase+Notification.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireObjectMapper

extension APIBase {
    
    //MARK: - INFO API
    func callAPIGetListNotification(params: Parameters?, completionHandler: @escaping (Any?, Error?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_NOTIFICATIONS)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    
    func callAPIReadNotification(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL = "\(APP_BASE_URL)\(API_SET_READ_NOTIFICATIONS)"
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

