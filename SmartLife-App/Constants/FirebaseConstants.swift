//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Firebase

struct FirebaseConstants {
    struct MainFields {
        static let Chat: String = "chat"
    }

    struct ChatFields {
        static let RoomMessages: String = "room-messages"
        static let RoomTypingSignal: String = "room-typing-signal"
        static let StaffUnreadRooms: String = "staff-unread-rooms"
        static let Users: String = "users"
    }

    struct MessageFields {
        static let AvatarImage: String = "avatar"
        static let ContentImage: String = "image"
        static let ContentFile: String = "file"
        static let ContentMessage: String = "message"
        static let UserName: String = "name"
        static let UserId: String = "userId"
        static let TypeString: String = "type"
        static let Time: String = "timestamp"
        static let Read: String = "read"
        static let ReadUsers: String = "read_users"
    }

    struct ReadUsers {
        static let AvatarImage: String = "avatar"
        static let UserId: String = "id"
        static let UserName: String = "name"
    }

    struct UserFields {
        static let Avatar: String = "avatar"
        static let Id: String = "id"
        static let Name: String = "name"
        static let Rooms: String = "rooms"
    }

    struct UserRoomFields {
        static let Active: String = "active"
        static let Id: String = "id"
        static let Name: String = "name"
    }

    struct StaffUnreadRoomFields {
        static let Name: String = "name"
        static let AvatarUrl: String = "avatarUrl"
        static let UpdatedAt: String = "updatedAt"
    }

    struct RoomTypingSignalFields {
        static let Id: String = "id"
        static let Name: String = "name"
        static let Time: String = "timestamp"
        static let Avatar: String = "avatar"
    }
}

class FirebaseGlobalMethod {
    // TabbarMain
    static var tabbarMainVC: TabbarMainViewController? = nil

    // Variables
    static var listNewMessageQuery: [DatabaseQuery] = []
    static var dictLatestMessageIdInRoom: [String: MessageModel] = [:]
    static var dictRoomCellInChatListVC: [String: RoomListTableViewCell] = [:]

    // MARK: - User

    /*
     * Created by: hoangnn
     * Description: Sent user to server
     */
    static func sendUserToServer() {
        let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
        let listUsersReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.Users)

        // Check user id
        if PublicVariables.userInfo.m_id != "" {
            // User reference
            let userReference: DatabaseReference = listUsersReference.child("user" + PublicVariables.userInfo.m_id)
            let userRoomsReference: DatabaseReference = userReference.child(FirebaseConstants.UserFields.Rooms)

            // Get data
            var data: [String: Any] = [:]
            data[FirebaseConstants.UserFields.Avatar] = PublicVariables.userInfo.m_icon_path
            data[FirebaseConstants.UserFields.Id] = "user" + PublicVariables.userInfo.m_id
            data[FirebaseConstants.UserFields.Name] = PublicVariables.userInfo.m_name

            // Send data
            userReference.updateChildValues(data)

            // Clear all rooms
            userRoomsReference.removeValue()
        }

        // Send 3 room default to server
        FirebaseGlobalMethod.sendCurrentRoomToServer(currentRoomId: "job-consult")
        FirebaseGlobalMethod.sendCurrentRoomToServer(currentRoomId: "living")
        if PublicVariables.userInfo.m_kabocha_building_id != "" {
            FirebaseGlobalMethod.sendCurrentRoomToServer(currentRoomId: "building" + PublicVariables.userInfo.m_kabocha_building_id)
        }

        // Get list room
        FirebaseGlobalMethod.getMyListRoomMessage(completion: { (response: [RoomMessageModel]) in })
    }

    /*
     * Created by: hoangnn
     * Description: Sent current room to server
     */
    static func sendCurrentRoomToServer(currentRoomId: String?) {
        // Check current room id
        if currentRoomId != nil && PublicVariables.userInfo.m_id != "" {
            var groupId: String = "user" + PublicVariables.userInfo.m_id + "_" + currentRoomId!
            if currentRoomId!.contains("building") {
                groupId = "room_" + currentRoomId!
            }
            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listUsersReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.Users)

            // Check user id
            if PublicVariables.userInfo.m_id != "" {
                // User reference
                let userReference: DatabaseReference = listUsersReference.child("user" + PublicVariables.userInfo.m_id)
                let userRoomsReference: DatabaseReference = userReference.child(FirebaseConstants.UserFields.Rooms)
                let currentRoomReference: DatabaseReference = userRoomsReference.child(groupId)

                // Get data
                var data: [String: Any] = [:]
                data[FirebaseConstants.UserRoomFields.Active] = true
                data[FirebaseConstants.UserRoomFields.Id] = groupId
                data[FirebaseConstants.UserRoomFields.Name] = ""

                // Send data
                currentRoomReference.updateChildValues(data)
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Get user information
     */
    static func getUserInformation(userIdCheck: String?, completion: @escaping (FirebaseUserModel) -> Void) {
        // Get user id
        if var userId: String = userIdCheck {
            // Check job and house room
            if ((userId.contains("job-consult") == true) || (userId.contains("living") == true)) {
                userId = "staff" + userId
            }

            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listUsersReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.Users)
            let userReference: DatabaseReference = listUsersReference.child(userId)

            // Update room information
            userReference.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                let userModel: FirebaseUserModel = FirebaseUserModel()
                userModel.userId = userId

                // Get value of snapshot
                if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                    userModel.avatarImage = listDatas[FirebaseConstants.UserFields.Avatar] as? String
                    userModel.userName = listDatas[FirebaseConstants.UserFields.Name] as? String
                }

                // Return
                completion(userModel)
            })
        }
    }

    // MARK: - Room Messages

    /*
     * Created by: hoangnn
     * Description: Get room message
     */
    static func getRoomWith(user: String?) -> (groupId: String?, roomReference: DatabaseReference?) {
        var groupId: String? = nil
        var roomMessageReference: DatabaseReference? = nil

        // Check user and my id
        if user != nil && PublicVariables.userInfo.m_id != "" {
            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listRoomMessageReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomMessages)
            groupId = user!
            if groupId?.contains("building") == true {
                roomMessageReference = listRoomMessageReference.child("room_" + user!)
            }
            else {
                roomMessageReference = listRoomMessageReference.child("user" + PublicVariables.userInfo.m_id + "_" + user!)
            }
        }

        return (groupId, roomMessageReference)
    }

    // MARK: - List Room Messages

    /*
     * Created by: hoangnn
     * Description: Get my list room meesage
     */
    static func getMyListRoomMessage(completion: @escaping (([RoomMessageModel]) -> Void)) {
        // Check user id
        if PublicVariables.userInfo.m_id != "" {
            // Remove list new message observer
            for query in FirebaseGlobalMethod.listNewMessageQuery {
                query.removeAllObservers()
            }
            FirebaseGlobalMethod.listNewMessageQuery.removeAll()

            // Remove old dict new message
            FirebaseGlobalMethod.dictLatestMessageIdInRoom.removeAll()

            // Get userRoom database
            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listUsersReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.Users)
            let userReference: DatabaseReference = listUsersReference.child("user" + PublicVariables.userInfo.m_id)
            let userRoomsReference: DatabaseReference = userReference.child(FirebaseConstants.UserFields.Rooms)

            // Get list room
            userRoomsReference.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // List room
                var listRoom: [RoomMessageModel] = []

                // Get value of snapshot
                if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                    if let listKeys: [String] = listDatas.allKeys as? [String] {
                        // Init and get room
                        for key in listKeys {
                            let roomMessage: RoomMessageModel = RoomMessageModel()
                            roomMessage.roomId = key
                            roomMessage.isLivingRoom = (key.hasSuffix("living") == true)
                            listRoom.append(roomMessage)
                        }
                    }
                }

                // Set observes
                for roomMessageModel in listRoom {
                    // Get room id
                    if let roomId: String = roomMessageModel.roomId {
                        // Get latest message to check
                        FirebaseGlobalMethod.getFirstLastListMessageInGroup(in: roomId)
                    }
                }

                // Return
                completion(listRoom)
            })
        }
    }

    /*
     * Created by: hoangnn
     * Description: Get room information
     */
    static func updateRoomMessageInfomation(roomMessageModel: RoomMessageModel?, completion: @escaping () -> Void) {
        // Get user id
        if var userId: String = roomMessageModel?.roomId?.components(separatedBy: "_").last {
            // Check job and house room
            if ((userId.contains("job-consult") == true) || (userId.contains("living") == true)) {
                userId = "staff" + userId
            }

            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listUsersReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.Users)
            let userReference: DatabaseReference = listUsersReference.child(userId)

            // Update room information
            userReference.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get value of snapshot
                if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                    roomMessageModel?.roomAvatar = listDatas[FirebaseConstants.UserFields.Avatar] as? String
                    roomMessageModel?.roomName = listDatas[FirebaseConstants.UserFields.Name] as? String
                }

                // Check room job
                if userId.contains("job-consult") == true {
                    roomMessageModel?.roomName = NSLocalizedString("ChatViewController_Title_Job", comment: "")
                }
                    // Check room living
                else if userId.contains("living") == true {
                    roomMessageModel?.roomName = NSLocalizedString("ChatViewController_Title_Living", comment: "")
                }
                else if userId.contains("building"){
                    roomMessageModel?.roomName = NSLocalizedString("ChatViewController_Title_Building", comment: "") + PublicVariables.userInfo.m_kabocha_building_name
                }
                // Return
                completion()
            })
        }
    }

    /*
     * Created by: hoangnn
     * Description: Get room latest message
     */
    static func updateRoomMessageLatestMessage(roomMessageModel: RoomMessageModel?, completion: @escaping () -> Void) {
        // Get user id
        if let roomId: String = roomMessageModel?.roomId {
            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listRoomMessageReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomMessages)
            let roomReference: DatabaseReference = listRoomMessageReference.child(roomId)
            let roomLatestMessageQuery: DatabaseQuery = roomReference.queryOrderedByKey().queryLimited(toLast: 1)

            // Update room information
            roomLatestMessageQuery.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get value of snapshot
                if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                    if let messageData: NSDictionary = listDatas.allValues.last as? NSDictionary {
                        roomMessageModel?.roomLatestMessageTime = messageData[FirebaseConstants.MessageFields.Time] as? Double

                        let imageContent: String? = messageData[FirebaseConstants.MessageFields.ContentImage] as? String
                        let fileContent: String? = messageData[FirebaseConstants.MessageFields.ContentFile] as? String
                        let userId: String? = messageData[FirebaseConstants.MessageFields.UserId] as? String
                        var userName: String? = messageData[FirebaseConstants.MessageFields.UserName] as? String
                        if userName == nil { userName = "" }
                        // Image message
                        if imageContent?.isEmpty == false {
                            if userId == "user" + PublicVariables.userInfo.m_id {
                                roomMessageModel?.roomMessage = "写真を送りました。"
                            }
                            else {
                                roomMessageModel?.roomMessage = "写真を受信しました。"
                            }
                        }
                            // File message
                        else if fileContent?.isEmpty == false {
                            if userId == "user" + PublicVariables.userInfo.m_id {
                                roomMessageModel?.roomMessage = "ファイルを送りました。"
                            }
                            else {
                                roomMessageModel?.roomMessage = "ファイルを受信しました。"
                            }
                        }
                            // Default
                        else {
                            roomMessageModel?.roomMessage = messageData[FirebaseConstants.MessageFields.ContentMessage] as? String
                        }
                    }
                }
                    // No have message
                else {
                    // Check room job
                    if let userId: String = roomMessageModel?.roomId?.components(separatedBy: "_").last {
                        if userId.contains("job-consult") == true {
                            roomMessageModel?.roomMessage = NSLocalizedString("ChatViewController_Default_Job_Message", comment: "")
                        }
                            // Check room living
                        else if userId.contains("living") == true {
                            roomMessageModel?.roomMessage = NSLocalizedString("ChatViewController_Default_Living_Message", comment: "")
                        }
                        else if userId.contains("building") == true {
                            roomMessageModel?.roomMessage = NSLocalizedString("ChatViewController_Default_Building_Message", comment: "")
                        }
                    }
                }

                // Return
                completion()
            })
        }
    }

    /*
     * Created by: hoangnn
     * Description: Get limit list message in group
     */
    static func getFirstLastListMessageInGroup(in roomId: String) {
        // Get room database
        let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
        let listRoomMessageReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomMessages)
        let roomDatabase: DatabaseReference = listRoomMessageReference.child(roomId)

        // Get last message
        let lastListMessageQuery: DatabaseQuery = roomDatabase.queryOrderedByKey().queryLimited(toLast: 1)
        lastListMessageQuery.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // Get value of snapshot
            if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                if let messageKey: String = listDatas.allKeys.last as? String {
                    // Get message
                    if let datas: NSDictionary = listDatas[messageKey] as? NSDictionary {
                        let messageModel: MessageModel = MessageModel()
                        messageModel.messageId = messageKey
                        messageModel.getInfoFrom(datas: datas)

                        // Update latest message in room
                        var isNeedUpdateCell: Bool = false
                        if let latestMessageIdInRoom: String = FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId]?.messageId {
                            if snapshot.key > latestMessageIdInRoom {
                                // Get and check new message
                                FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId] = messageModel
                                isNeedUpdateCell = true
                            }
                        }
                        else {
                            // Get and check new message
                            FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId] = messageModel
                            isNeedUpdateCell = true
                        }

                        // Update cell if need
                        if isNeedUpdateCell == true {
                            if let roomCell: RoomListTableViewCell = FirebaseGlobalMethod.dictRoomCellInChatListVC[roomId] {
                                roomCell.roomMessageModel?.isGetLatestMessage = false
                                roomCell.updateContentWithModel()
                            }
                        }
                    }
                }
            }

            // Check new label
            FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideChatNewLabel()

            // Get last message id in room
            var lastMessageId: String? = nil
            if let listLastMessage: [String: String] = UserDefaults.standard.object(forKey: kUserDefaultUserListLastMessageId) as? [String: String] {
                lastMessageId = listLastMessage[roomId]
            }

            // Set get new message observe
            FirebaseGlobalMethod.setObserverForNewMessage(in: roomId, lastMessageId: lastMessageId)
        })
    }

    /*
     * Created by: hoangnn
     * Description: Set observe for new message
     */
    static func setObserverForNewMessage(in roomId: String, lastMessageId: String?) {
        // Get room database
        let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
        let listRoomMessageReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomMessages)
        let roomDatabase: DatabaseReference = listRoomMessageReference.child(roomId)

        // Get new message
        var lastMessageIdCheck: String? = lastMessageId
        if lastMessageIdCheck == nil { lastMessageIdCheck = "" }
        let newMessageQuery: DatabaseQuery = roomDatabase.queryOrderedByKey().queryStarting(atValue: lastMessageIdCheck)
        // Update list new message observe
        FirebaseGlobalMethod.listNewMessageQuery.append(newMessageQuery)

        // Get list message
        newMessageQuery.observe(DataEventType.childAdded, with: { (snapshot) -> Void in
            // New message
            if let datas: NSDictionary = snapshot.value as? NSDictionary {
                let messageModel: MessageModel = MessageModel()
                messageModel.messageId = snapshot.key
                messageModel.getInfoFrom(datas: datas)

                // Update latest message in room
                var isNeedUpdateCell: Bool = false
                if let latestMessageIdInRoom: String = FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId]?.messageId {
                    if snapshot.key > latestMessageIdInRoom {
                        // Get and check new message
                        FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId] = messageModel
                        isNeedUpdateCell = true
                    }
                }
                else {
                    // Get and check new message
                    FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId] = messageModel
                    isNeedUpdateCell = true
                }

                // Update cell if need
                if isNeedUpdateCell == true {
                    if let roomCell: RoomListTableViewCell = FirebaseGlobalMethod.dictRoomCellInChatListVC[roomId] {
                        roomCell.roomMessageModel?.isGetLatestMessage = false
                        roomCell.updateContentWithModel()
                    }
                }
            }

            // Check new label
            FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideChatNewLabel()
        })
    }

    // MARK: - Public Methods

    /*
     * Created by: hoangnn
     * Description: Create or Update list last message id
     */
    static func createOrUpdateLocalListLastMessageId(messageId: String, in roomId: String) {
        // Get or init list
        var listLastMessage: [String: String]? = UserDefaults.standard.object(forKey: kUserDefaultUserListLastMessageId) as? [String: String]
        if listLastMessage == nil { listLastMessage = [:] }

        // Update list
        listLastMessage?[roomId] = messageId

        // Save local
        UserDefaults.standard.set(listLastMessage, forKey: kUserDefaultUserListLastMessageId)
        UserDefaults.standard.synchronize()
    }

    /*
     * Created by: hoangnn
     * Description: Get list room message and set new observe for first time
     */
    static func checkAndSetNewMessageObserve(navigationController: UINavigationController?) {
        // Check network
        if Reachability.isConnectedToNetwork() == true {
            // Get list room
            FirebaseGlobalMethod.getMyListRoomMessage(completion: { (response: [RoomMessageModel]) in
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vcLogin = storyboard.instantiateViewController(withIdentifier: "tabbarMainVC")
                    navigationController?.pushViewController(vcLogin, animated: true)
            })
        }
        else {
            GlobalMethod.showAlert("インターネット接続がありません。接続を確認してください。")
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vcLogin = storyboard.instantiateViewController(withIdentifier: "tabbarMainVC")
                navigationController?.pushViewController(vcLogin, animated: true)
        }
    }

    /*
     * Created by: hoangnn
     * Description: Check new message in room
     */
    static func checkNewMessageInRoom(roomId: String?) -> Bool {
        var result: Bool = true

        // Check nil
        if roomId != nil {
//            // Get last message in room
//            var lastMessageIdInRoom: String? = nil
//            if let listLastMessage: [String: String] = UserDefaults.standard.object(forKey: kUserDefaultUserListLastMessageId) as? [String: String] {
//                lastMessageIdInRoom = listLastMessage[roomId!]
//            }
//
//            // Check new message
//            if let latestMessage: MessageModel = FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId!] {
//                if latestMessage.userId != ("user" + PublicVariables.userInfo.m_id) {
//                    if latestMessage.messageId != nil {
//                        if lastMessageIdInRoom != nil {
//                            if latestMessage.messageId! > lastMessageIdInRoom! {
//                                result = true
//                            }
//                        }
//                        else {
//                            result = true
//                        }
//                    }
//                }
//            }
            if let latestMessage: MessageModel = FirebaseGlobalMethod.dictLatestMessageIdInRoom[roomId!] {
                if let readUsers = latestMessage.readUsers?.keys{
                    for readUser in readUsers {
                        if readUser == "user"+PublicVariables.userInfo.m_id {
                            result = false
                        }
                    }
                }
            }
            else {
                result = false
            }

        }

        // Return result
        return result
    }
}
