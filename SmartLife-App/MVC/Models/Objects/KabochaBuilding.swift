//
//  KabochaBuilding.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class KabochaBuilding: NSObject {
    var m_id:String
    var m_name:String
    var m_room:String
    
    
    override init() {
        m_id = ""
        m_name = ""
        m_room = ""
    }
    
    init(id:String, name:String, room:String) {
        m_id = id
        m_name = name
        m_room = room
    }
    
    init(dict:NSDictionary) {
        
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
        
        if let room = dict["rooms"] as? String {
            m_room = room
        } else {
            m_room = ""
        }
    }
}
