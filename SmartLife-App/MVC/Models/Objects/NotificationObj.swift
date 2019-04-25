//
//  NotificationObj.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationObj: Mappable {
    var id: String = ""
    var user_id: String = ""
    var title: String = ""
    var content_type:String = ""
    var content:String = ""
    var target_url:String = ""
    var target_url_label:String = ""
    var is_important:String = ""
    var recieved_date:String = ""
    var read_date:String = ""
    var created:String = ""
    var updated:String = ""
    var disable:String = ""
    var user_notification_id:String = ""
    var is_read:String = ""
    
    init() {
    
    }
    
    required init?(map: Map) {
        
    }
    
    //Map data from ObjectMapple to object
    func mapping(map: Map) {
        id                                      <- map["id"]
        user_id                                 <- map["user_id"]
        title                                   <- map["title"]
        content_type                            <- map["content_type"]
        content                                 <- map["content"]
        target_url                              <- map["target_url"]
        target_url_label                        <- map["target_url_label"]
        is_important                            <- map["is_important"]
        recieved_date                           <- map["recieved_date"]
        read_date                               <- map["read_date"]
        created                                 <- map["created"]
        updated                                 <- map["updated"]
        disable                                 <- map["disable"]
        user_notification_id                    <- map["user_notification_id"]
        is_read                                 <- map["is_read"]
    }
}
