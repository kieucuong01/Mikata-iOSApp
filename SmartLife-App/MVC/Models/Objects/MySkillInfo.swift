//
//  MySkillInfo.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/8/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
enum SkillTypeAnswer {
    case single
    case multi
}

class MySkillInfo: NSObject {
    var m_id_skill:String
    var m_id_skill_group:String
    var m_name_skill:String
    var m_value_type:SkillTypeAnswer
    var m_name_skill_group:String
    var m_page_skill_group_setting:String
    var m_page_skill_group_mypage:String
    var m_skill_value:String
    
    override init() {
        m_id_skill = ""
        m_name_skill = ""
        m_value_type = .single
        m_name_skill_group = ""
        m_id_skill_group = ""
        m_page_skill_group_setting = ""
        m_page_skill_group_mypage = ""
        m_skill_value = ""
    }
    
    init(id_skill:String,name_skill:String, value_type:String, name_skill_group:String, id_skill_group:String,
         page_skill_group_setting:String, page_skill_group_mypage:String, skill_value:String) {
        m_id_skill = id_skill
        m_name_skill = name_skill
        m_name_skill_group = name_skill_group
        m_id_skill_group = id_skill_group
        m_page_skill_group_setting = page_skill_group_setting
        m_page_skill_group_mypage = page_skill_group_mypage
        m_skill_value = skill_value
        if value_type == "1" {
            m_value_type = .single
        } else {
            m_value_type = .multi
        }
    }
    
    init(dict:NSDictionary) {
        m_id_skill = (dict.object(forKey: "id") as? String)!
        m_name_skill = (dict.object(forKey: "name") as? String)!
        m_name_skill_group = (dict.object(forKey: "skill_group_name") as? String)!
        m_id_skill_group = (dict.object(forKey: "skill_group_id") as? String)!
        m_page_skill_group_setting = (dict.object(forKey: "skill_group_setting_page") as? String)!
        m_page_skill_group_mypage = (dict.object(forKey: "skill_group_mypage_page") as? String)!
        if let skill_value = dict.object(forKey: "skill_value") as? String {
            m_skill_value = skill_value
        } else {
            m_skill_value = ""
        }
        let value_type = (dict.object(forKey: "value_type") as? String)!
        if value_type == "1" {
            m_value_type = .single
        } else {
            m_value_type = .multi
        }
    }
}
