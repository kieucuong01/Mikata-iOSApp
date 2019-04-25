//
//  APIBase+TimeLine.swift
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
    func callAPIGetTimeLine(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_TIMELINE)"
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
        
    }

    func callAPIFavoriteTimeLine(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_FAVORITE_TIMELINE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
}
