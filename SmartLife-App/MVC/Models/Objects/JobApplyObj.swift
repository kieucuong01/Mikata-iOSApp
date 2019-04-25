//
//  JobApplyObj.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import ObjectMapper

class JobApplyObj: Mappable {
    
    var name: String = ""
    var description: String = ""
    var tags:[String] = [String]()
    
    init() {

    }

    required init?(map: Map) {

    }

    //Map data from ObjectMapple to object
    func mapping(map: Map) {
        name                            <- map["name"]
        description                     <- map["description"]
        tags                            <- map["tags"]
    }
}
