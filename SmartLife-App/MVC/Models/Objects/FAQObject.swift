//
//  FAQObject.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 9/29/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class FAQObject: NSObject {
    var id: String = ""
    var question: String = ""
    var answer: String = ""
    var answerHTML: String = ""
    var created: String = ""
    var updated: String = ""
    var isSelected: Bool = false
    var groupName : String = "-"

    init(dict: NSDictionary) {
        if let id = dict.object(forKey: "id") as? String {
            self.id = id
        }
        if let question = dict.object(forKey: "question") as? String {
            self.question = question
        }
        if let answer = dict.object(forKey: "answer") as? String {
            self.answer = answer
        }
        if let created = dict.object(forKey: "created") as? String {
            self.created = created
        }
        if let updated = dict.object(forKey: "updated") as? String {
            self.updated = updated
        }
        if let groupName = dict.object(forKey: "group_name") as? String {
            self.groupName = groupName
        }
    }
}
