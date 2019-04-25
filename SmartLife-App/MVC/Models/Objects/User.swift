//
//  User.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/24/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import Foundation

class User: NSObject {
    var m_birthday:String = ""
    var m_icon_path:String = ""
    var m_kabocha_room_number:String = ""
    var m_kabocha_building_name:String = ""
    var m_kabocha_building_id:String = ""
    var m_is_temp_password:String = ""
    var m_address1:String = ""
    var m_address2:String = ""
    var m_start_living_date:String = ""
    var m_updated:String = ""
    var m_name:String = ""
    var m_prefecture_id:String = ""
    var m_point:String = "0"
    var m_id:String = ""
    var m_is_email_check:String = ""
    var m_token:String = ""
    var m_firebase_token:String = ""
    var m_email:String = ""
    var m_phone:String = ""
    var m_disable:String = ""
    var m_is_residence_check:String = ""
    var m_nick_name:String = ""
    var m_password:String = ""
    var m_post_code:String = ""
    var m_created:String = ""
    var m_graduated_date:String = ""
    var m_skill_status: String = ""
    var m_department_id: String = ""
    var m_flag_new: String = "0"

    override init() {
    }
    
    init(dict : [String:Any]) {
        super.init()
        if let birthday:String = dict["birthday"] as? String {
            m_birthday = birthday
        }
        
        if let icon_path = dict["icon_path"] as? String {
            m_icon_path = icon_path
        }
        
        if let kabocha_room_number = dict["mikata_room_number"] as? String {
            m_kabocha_room_number = kabocha_room_number
        }
        
        if let kabocha_building_name = dict["mikata_building_name"] as? String {
            m_kabocha_building_name = kabocha_building_name
        }
        
        if let kabocha_building_id = dict["mikata_building_id"] as? String {
            m_kabocha_building_id = kabocha_building_id
        }
        
        if let is_temp_password = dict["is_temp_password"] as? String {
            m_is_temp_password = is_temp_password
        }
        
        if let address1 = dict["address1"] as? String {
            m_address1 = address1
        }
        
        if let address2 = dict["address2"] as? String {
            m_address2 = address2
        }
        
        if let start_living_date = dict["start_living_date"] as? String {
            m_start_living_date = start_living_date
        }
        
        if let updated = dict["updated"] as? String {
            m_updated = updated
        }
        
        if let name = dict["name"] as? String {
            m_name = name
        }
        
        if let prefecture_id = dict["prefecture_id"] as? String {
            m_prefecture_id = prefecture_id
        }
        
        if let point = dict["point"] as? String {
            m_point = point
        }
        
        if let id = dict["id"] as? String {
            m_id = id
        }
        
        if let is_email_check = dict["is_email_check"] as? String {
            m_is_email_check = is_email_check
        }
        
        if let token = dict["token"] as? String {
            m_token = token
        }

        if let firebase_token = dict["firebase_token"] as? String {
            m_firebase_token = firebase_token
        }
        
        if let email = dict["email"] as? String {
            m_email = email
        }
        
        if let phone = dict["phone"] as? String {
            m_phone = phone
        }
        
        if let disable = dict["disable"] as? String {
            m_disable = disable
        }
        
        if let is_residence_check = dict["is_residence_check"] as? String {
            m_is_residence_check = is_residence_check
        }
        
        if let nick_name = dict["nick_name"] as? String {
            m_nick_name = nick_name
        }
        
        if let password = dict["password"] as? String {
            m_nick_name = password
        }
        
        if let disable = dict["disable"] as? String {
            m_disable = disable
        }
        
        if let is_residence_check = dict["is_residence_check"] as? String {
            m_is_residence_check = is_residence_check
        }
        
        if let nick_name = dict["nick_name"] as? String {
            m_nick_name = nick_name
        }
        
        if let password = dict["password"] as? String {
            m_password = password
        }
        
        if let post_code = dict["post_code"] as? String {
            m_post_code = post_code
        }
        
        if let created = dict["created"] as? String {
            m_created = created
        }
        
        if let graduated_date = dict["graduated_date"] as? String {
            m_graduated_date = graduated_date
        }

        if let skill_status = dict["skill_status"] as? String {
            m_skill_status = skill_status
        }

        if let department_id = dict["department_id"] as? String {
            m_department_id = department_id
        }

        self.updateAndCheckNotificationFlagNew(flagNew: (dict["flag_new"] as? String))
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.m_birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        self.m_icon_path = aDecoder.decodeObject(forKey: "icon_path") as! String
        self.m_kabocha_room_number = aDecoder.decodeObject(forKey: "mikata_room_number") as! String
        self.m_kabocha_building_name = aDecoder.decodeObject(forKey: "mikata_building_name") as! String
        self.m_kabocha_building_id = aDecoder.decodeObject(forKey: "mikata_building_id") as! String
        self.m_is_temp_password = aDecoder.decodeObject(forKey: "is_temp_password") as! String
        self.m_address1 = aDecoder.decodeObject(forKey: "address1") as! String
        self.m_address2 = aDecoder.decodeObject(forKey: "address2") as! String
        self.m_start_living_date = aDecoder.decodeObject(forKey: "start_living_date") as! String
        self.m_updated = aDecoder.decodeObject(forKey: "updated") as! String
        self.m_name = aDecoder.decodeObject(forKey: "name") as! String
        self.m_prefecture_id = aDecoder.decodeObject(forKey: "prefecture_id") as! String
        self.m_point = aDecoder.decodeObject(forKey: "point") as! String
        self.m_id = aDecoder.decodeObject(forKey: "id") as! String
        self.m_is_email_check = aDecoder.decodeObject(forKey: "is_email_check") as! String
        self.m_token = aDecoder.decodeObject(forKey: "token") as! String
        self.m_firebase_token = aDecoder.decodeObject(forKey: "firebase_token") as! String
        self.m_email = aDecoder.decodeObject(forKey: "email") as! String
        self.m_phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.m_disable = aDecoder.decodeObject(forKey: "disable") as! String
        self.m_is_residence_check = aDecoder.decodeObject(forKey: "is_residence_check") as! String
        self.m_nick_name = aDecoder.decodeObject(forKey: "nick_name") as! String
        self.m_password = aDecoder.decodeObject(forKey: "password") as! String
        self.m_post_code = aDecoder.decodeObject(forKey: "post_code") as! String
        self.m_created = aDecoder.decodeObject(forKey: "created") as! String
        self.m_graduated_date = aDecoder.decodeObject(forKey: "graduated_date") as! String
        self.m_department_id = aDecoder.decodeObject(forKey: "department_id") as! String
        self.m_flag_new = aDecoder.decodeObject(forKey: "flag_new") as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(m_birthday, forKey: "birthday")
        aCoder.encode(m_icon_path, forKey: "icon_path")
        aCoder.encode(m_kabocha_room_number, forKey: "mikata_room_number")
        aCoder.encode(m_kabocha_building_name, forKey: "mikata_building_name")
        aCoder.encode(m_kabocha_building_id, forKey: "mikata_building_id")
        aCoder.encode(m_is_temp_password, forKey: "is_temp_password")
        aCoder.encode(m_address1, forKey: "address1")
        aCoder.encode(m_address2, forKey: "address2")
        aCoder.encode(m_start_living_date, forKey: "start_living_date")
        aCoder.encode(m_updated, forKey: "updated")
        aCoder.encode(m_name, forKey: "name")
        aCoder.encode(m_prefecture_id, forKey: "prefecture_id")
        aCoder.encode(m_point, forKey: "point")
        aCoder.encode(m_id, forKey: "id")
        aCoder.encode(m_is_email_check, forKey: "is_email_check")
        aCoder.encode(m_token, forKey: "token")
        aCoder.encode(m_firebase_token, forKey: "m_firebase_token")
        aCoder.encode(m_email, forKey: "email")
        aCoder.encode(m_phone, forKey: "phone")
        aCoder.encode(m_disable, forKey: "disable")
        aCoder.encode(m_is_residence_check, forKey: "is_residence_check")
        aCoder.encode(m_nick_name, forKey: "nick_name")
        aCoder.encode(m_password, forKey: "password")
        aCoder.encode(m_post_code, forKey: "post_code")
        aCoder.encode(m_created, forKey: "created")
        aCoder.encode(m_graduated_date, forKey: "graduated_date")
        aCoder.encode(m_skill_status, forKey: "skill_status")
        aCoder.encode(m_department_id, forKey: "department_id")
        aCoder.encode(m_flag_new, forKey: "flag_new")
    }

    // MARK: - Update notification flag new

    func updateAndCheckNotificationFlagNew(flagNew: String?) {
        if flagNew != nil {
            m_flag_new = flagNew!
            FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideNotificationNewLabel()
        }
    }
}
