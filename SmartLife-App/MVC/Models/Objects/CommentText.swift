//
//  CommentText.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/19/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class CommentText: NSObject {
    var m_type:String
    var m_content:Any
    
    
    override init() {
        m_type = ""
        m_content = ""
    }
    
    init(type:String, content:String) {
        m_type = type
        m_content = content
    }
    
    init(dict:NSDictionary) {
        if let type = dict.object(forKey: "type") as? String {
            m_type = type
        } else {
            m_type = ""
        }
        
        if let content = dict.object(forKey: "content") as? String {
            m_content = content
        } else {
            m_content = ""
        }
    }

}
