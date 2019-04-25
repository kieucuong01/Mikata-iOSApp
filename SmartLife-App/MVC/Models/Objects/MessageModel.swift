//
//  MessageModel.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/18/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
class FirebaseUserModel: NSObject {
    // Properties
    var userId: String? = nil
    var avatarImage: String? = nil
    var userName: String? = nil
    
    // MARK: Initialization

    override init() {
        // Call super
        super.init()
    }
}

// MARK: -
class MessageModel: NSObject {
    // Properties
    var messageId: String? = nil
    var avatarImage: String? = nil
    var contentImage: String? = nil
    var contentFile: String? = nil
    var contentMessage: String? = nil
    var userName: String? = nil
    var userId: String? = nil
    var type: String? = nil
    var time: Double? = nil
    var isRead: Int? = nil
    var savedImage: UIImage? = nil
    var readUsers: [String : Any]? = nil
    // MARK: Initialization

    override init() {
        // Call super
        super.init()
    }

    // MARK: Public Methods
    
    /*
     * Created by: hoangnn
     * Description: Get message info from dictionary
     */
    func getInfoFrom(datas: NSDictionary) {
        self.avatarImage = datas[FirebaseConstants.MessageFields.AvatarImage] as? String
        self.contentImage = datas[FirebaseConstants.MessageFields.ContentImage] as? String
        self.contentFile = datas[FirebaseConstants.MessageFields.ContentFile] as? String
        self.contentMessage = datas[FirebaseConstants.MessageFields.ContentMessage] as? String
        self.userName = datas[FirebaseConstants.MessageFields.UserName] as? String
        self.userId = datas[FirebaseConstants.MessageFields.UserId] as? String
        self.type = datas[FirebaseConstants.MessageFields.TypeString] as? String
        self.time = datas[FirebaseConstants.MessageFields.Time] as? Double
        self.isRead = datas[FirebaseConstants.MessageFields.Read] as? Int
        self.readUsers = datas[FirebaseConstants.MessageFields.ReadUsers] as? [String : Any]
    }
}

// MARK: -
class RoomMessageModel: NSObject {
    // Properties
    var roomId: String? = nil
    var roomAvatar: String? = nil
    var roomName: String? = nil
    var isLivingRoom: Bool = false
    var roomMessage: String? = nil
    var roomLatestMessageTime: Double? = nil
    var isGetInfomation: Bool = false
    var isGetLatestMessage: Bool = false

    // MARK: Initialization

    override init() {
        // Call super
        super.init()
    }

    // MARK: Public Methods

    
}
