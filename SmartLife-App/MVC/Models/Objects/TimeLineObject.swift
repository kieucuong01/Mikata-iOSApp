//
//  TimeLineObject.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 9/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class TimeLineObject: NSObject {
    var id: String = ""
    var name: String = ""
    var descriptionTimeLine: String = ""
    var descriptionTimeLineHTMLString: String = ""
    var image_url: String = ""
    var point: String = ""
    var created: String = ""
    var display_end_date: String = ""
    var type: String = ""
    var is_favorite: String = ""
    var numberContentLineShow: Int = 1
    var imageSize: CGSize? = nil

    init(dict: NSDictionary) {
        if let id = dict.object(forKey: "id") as? String {
            self.id = id
        }
        if let name = dict.object(forKey: "name") as? String {
            self.name = name
        }
        if let descriptionTimeLine = dict.object(forKey: "description") as? String {
            self.descriptionTimeLine = descriptionTimeLine
            self.descriptionTimeLineHTMLString = descriptionTimeLine.html2String
        }
        if let image_url = dict.object(forKey: "image_url") as? String {
            self.image_url = image_url
        }
        if let point = dict.object(forKey: "point") as? String {
            self.point = point
        }
        if let created = dict.object(forKey: "created") as? String {
            self.created = created
        }
        if let display_end_date = dict.object(forKey: "display_end_date") as? String {
            self.display_end_date = display_end_date
        }
        if let type = dict.object(forKey: "type") as? String {
            self.type = type
        }
        if let is_favorite = dict.object(forKey: "is_favorites") as? String {
            self.is_favorite = is_favorite
        }
    }
}
