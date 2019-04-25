//
//  AvatarUser.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class AvatarUser: NSObject {
    var m_icon_path:String
    var m_id:String
    var m_name:String
    var m_priority:String
    
    override init() {
        m_icon_path = ""
        m_id = ""
        m_name = ""
        m_priority = ""
    }
    
    init(icon_path:String,id:String, name:String, priority:String) {
        m_icon_path = icon_path
        m_id = id
        m_name = name
        m_priority = priority
    }
    
    init(dict:NSDictionary) {
        if let icon_path = dict["icon_path"] as? String {
            m_icon_path = icon_path
        } else {
            m_icon_path = ""
        }
        
        if let id = dict["id"] as? String {
            m_id = id
        } else {
            m_id = ""
        }
        
        if let name = dict["name"] as? String {
            m_name = name
        } else {
            m_name = ""
        }
        
        if let priority = dict["priority"] as? String {
            m_priority = priority
        } else {
            m_priority = ""
        }
    }
}
