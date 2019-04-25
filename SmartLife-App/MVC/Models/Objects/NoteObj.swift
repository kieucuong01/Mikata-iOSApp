//
//  NoteObj.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/7/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NoteCommentContentObj: NSObject {
    var m_content: String? = nil
    var m_image_path: String? = nil
    var m_image_size: CGSize? = nil
}

class NoteObj: NSObject {
    
    var m_id:String
    var m_note_id:String
    var m_title:String
    var m_kabocha_building_id:String
    var m_area_id:String
    var m_jenre_id:String
    var m_important:String
    var m_public_range:String
    var m_jenre:String
    var m_comment_count:String
    var m_counts_favorite:String
    var m_time_stamp:String
    var m_created:String
    var m_updated:String
    var m_disable:String
    var m_list_note_comment_content: [NoteCommentContentObj] = []
    
    override init() {
        m_id = ""
        m_note_id = ""
        m_title = ""
        m_kabocha_building_id = ""
        m_area_id = ""
        m_jenre_id = ""
        m_important = ""
        m_public_range = ""
        m_jenre = ""
        m_comment_count = ""
        m_counts_favorite = ""
        m_time_stamp = ""
        m_created = ""
        m_updated = ""
        m_disable = ""
    }
    
    init(id:String,title:String, kabocha_building_id:String, area_id:String, jenre_id:String, important:String, public_range:String, jenre:String, comment_count:String, counts_favorite:String, time_stamp:String, created:String, updated:String, disable:String) {
        m_id = id
        m_note_id = ""
        m_title = title
        m_kabocha_building_id = kabocha_building_id
        m_area_id = area_id
        m_jenre_id = jenre_id
        m_important = important
        m_public_range = public_range
        m_jenre = jenre
        m_comment_count = comment_count
        m_counts_favorite = counts_favorite
        m_time_stamp = time_stamp
        m_created = created
        m_updated = updated
        m_disable = disable
    }
    
    
    init(dict:NSDictionary) {
        
        if let id = dict["id"] as? String {
            m_id = id
        } else {
            m_id = ""
        }

        if let note_id = dict["note_id"] as? String {
            m_note_id = note_id
        } else {
            m_note_id = ""
        }
        
        if let title = dict["title"] as? String {
            m_title = title
        } else {
            m_title = ""
        }
        
        if let kabocha_building_id = dict["mikata_building_id"] as? String {
            m_kabocha_building_id = kabocha_building_id
        } else {
            m_kabocha_building_id = ""
        }
        
        if let area_id = dict["area_id"] as? String {
            m_area_id = area_id
        } else {
            m_area_id = ""
        }
        
        if let jenre_id = dict["jenre_id"] as? String {
            m_jenre_id = jenre_id
        } else {
            m_jenre_id = ""
        }
        
        if let important = dict["important"] as? String {
            m_important = important
        } else {
            m_important = ""
        }
        
        if let public_range = dict["public_range"] as? String {
            m_public_range = public_range
        } else {
            m_public_range = ""
        }
        
        if let jenre = dict["jenre"] as? String {
            m_jenre = jenre
        } else {
            m_jenre = ""
        }
        
        if let comment_count = dict["comment_count"] as? String {
            m_comment_count = comment_count
        } else {
            m_comment_count = ""
        }
        
        if let counts_favorite = dict["counts_favorite"] as? String {
            m_counts_favorite = counts_favorite
        } else {
            m_counts_favorite = ""
        }
        
        if let time_stamp = dict["time_stamp"] as? String {
            m_time_stamp = time_stamp
        } else {
            m_time_stamp = ""
        }
        if let created = dict["created"] as? String {
            m_created = created
        } else {
            m_created = ""
        }
        
        if let updated = dict["updated"] as? String {
            m_updated = updated
        } else {
            m_updated = ""
        }
        
        if let disable = dict["disable"] as? String {
            m_disable = disable
        } else {
            m_disable = ""
        }

        if let listContent: NSArray = dict["content"] as? NSArray {
            for content in listContent {
                if let contentDict: NSDictionary = content as? NSDictionary {
                    let noteCommentContent: NoteCommentContentObj = NoteCommentContentObj()
                    noteCommentContent.m_content = contentDict.object(forKey: "content") as? String
                    noteCommentContent.m_image_path = contentDict.object(forKey: "image_path") as? String
                    self.m_list_note_comment_content.append(noteCommentContent)
                }
            }
        }
    }

} 
