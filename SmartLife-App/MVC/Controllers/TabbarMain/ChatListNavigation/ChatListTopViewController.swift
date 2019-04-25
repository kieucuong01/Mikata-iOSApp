//
//  ChatListTopViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Firebase

class ChatListTopViewController: NewBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RoomListTableViewCellDelegate {
    // Subviews
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var listRoomTableView: UITableView!

    // Variables
    var listRoom: [RoomMessageModel] = []
    var listRoomFilter: [RoomMessageModel] = []
    var numberOfUserOfBuildingRoom : String = ""
    let dispatchGroup = DispatchGroup()

    // MARK: - View Lifecycle

    override func didReceiveMemoryWarning() {
        // Call super
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        // Call super
        super.viewDidLoad()
        self.searchTextField.placeholder = NSLocalizedString("placeholder_search", comment: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        // Call super
        super.viewWillAppear(animated)
        self.setHideNavBar(isHiden: false)
        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeTitle, object: NSLocalizedString("chatlisttopview_navbar", comment: ""))

        self.listRoomTableView.isHidden = true
        self.callAPINumberOfUserInBuilding()
        // Get list room
        dispatchGroup.notify(queue: .main) {
            self.getListRoom()
        }


        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_TAB_CHAT, eventName: nil)
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    override func configureSelf() {
        // Call super
        super.configureSelf()
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    override func configureSubviews() {
        // Call super
        super.configureSubviews()

        // Configure subviews
        self.configureSearchView()
        self.configureSearchTextField()
        self.configureListRoomTableView()
    }

    /*
     * Created by: hoangnn
     * Description: Configure searchView
     */
    func configureSearchView() {
        // Set attributes
        self.searchView.layer.cornerRadius = 2.0 * GlobalMethod.displayScale
        self.searchView.layer.borderWidth = 1.0 * GlobalMethod.displayScale
        self.searchView.layer.borderColor = UIColor(red: 123.0/255.0, green: 122.0/255.0, blue: 122.0/255.0, alpha: 1.0).cgColor
    }

    /*
     * Created by: hoangnn
     * Description: Configure searchTextField
     */
    func configureSearchTextField() {
        // Set attributes
        self.searchTextField.font = self.searchTextField.font?.withSize(13.5 * GlobalMethod.displayScale)
    }

    /*
     * Created by: hoangnn
     * Description: Configure listRoomTableView
     */
    func configureListRoomTableView() {
        // Register cells
        self.listRoomTableView.register(UINib(nibName: "RoomListTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomListTableViewCell")

        // Set attributes
        self.listRoomTableView.delegate = self
        self.listRoomTableView.dataSource = self
        self.listRoomTableView.separatorStyle = UITableViewCellSeparatorStyle.none

        // Add gesture
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboardFunction))
        self.listRoomTableView.addGestureRecognizer(tapGesture)

        // Add pull refresh
        self.listRoomTableView.addPullToRefreshHandler {
            // Get list room
            self.getListRoom()
        }
    }

    // MARK: - UITableViewDelegate

    /*
     * Created by: hoangnn
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0 * GlobalMethod.displayScale
    }

    /*
     * Created by: hoangnn
     * Description: Will display cell
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell: RoomListTableViewCell = cell as? RoomListTableViewCell {
            cell.updateConfigureWhenDisplay()
        }
    }

    // MARK: - UITableViewDataSource

    /*
     * Created by: hoangnn
     * Description: Number of section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
     * Created by: hoangnn
     * Description: Number of row in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listRoomFilter.count
    }

    /*
     * Created by: hoangnn
     * Description: Configure tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: RoomListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RoomListTableViewCell") as? RoomListTableViewCell {
            // Update index
            cell.delegate = self
            cell.parentVC = self
            cell.parentTableView = tableView
            cell.cellIndex = indexPath

            // Update content
            if self.listRoomFilter.indices.contains(indexPath.item) == true {
                cell.roomMessageModel = self.listRoomFilter[indexPath.item]
                cell.isHidden = true
                cell.updateContentWithModel()

                // Update user in building room
                if cell.roomMessageModel?.roomName != nil && cell.roomMessageModel?.roomId?.contains("building") == true{
                    cell.nameLabel.text = (cell.roomMessageModel?.roomName)! + " (" + self.numberOfUserOfBuildingRoom + ")"
                }
                // Update dict room cell
                if let roomId: String = cell.roomMessageModel?.roomId {
                    FirebaseGlobalMethod.dictRoomCellInChatListVC[roomId] = cell
                }
            }

            // Return cell
            return cell
        }

        // Default
        return UITableViewCell()
    }

    // MARK: - RoomListTableViewCellDelegate

    func didTapChooseInRoomListTableViewCell(_ cell: RoomListTableViewCell) {
        // Get user id
        if let userId: String = cell.roomMessageModel?.roomId?.components(separatedBy: "_").last {
            // Push to chat
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
                chatVC.conversationName = cell.roomMessageModel?.roomName
                chatVC.numberOfUserInBuildingRoom = self.numberOfUserOfBuildingRoom
                let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: userId)
                chatVC.selectedGroupId = groupId
                chatVC.selectedGroupDatabase = roomReference
                self.present(chatVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.listRoomTableView {
            let bottomContentOffsetY: CGFloat = self.listRoomTableView.contentOffset.y + self.listRoomTableView.frame.size.height
            if bottomContentOffsetY > self.listRoomTableView.contentSize.height {
                self.view.endEditing(true)
            }
        }
    }

    // MARK: - Public Methods
    
    /*
     * Created by: hoangnn
     * Description: Close keyboard
     */
    @objc func closeKeyboardFunction() {
        self.view.endEditing(true)
    }

    /*
     * Created by: hoangnn
     * Description: Get list room
     */
    func getListRoom() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Check network
        if Reachability.isConnectedToNetwork() == true {
            // Get list room
            FirebaseGlobalMethod.getMyListRoomMessage(completion: { (response: [RoomMessageModel]) in
                self.searchTextField.text = nil
                self.listRoom = response
                self.listRoomFilter = response
                self.sortAndReloadListRoomFilter()
                self.listRoomTableView.layoutIfNeeded()
                self.listRoomTableView.isHidden = false
                self.listRoomTableView.pullToRefreshView?.stopAnimating()
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
        else {
            self.listRoomTableView.isHidden = false
            self.listRoomTableView.pullToRefreshView?.stopAnimating()
            GlobalMethod.showAlert(NSLocalizedString("error_no_internet_connection", comment: ""))
        }
    }

    /*
     * Created by: cuongkt
     * Description: Get number of user of building room
     */
    func callAPINumberOfUserInBuilding() {
        self.dispatchGroup.enter()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: [String : Any] = [
            "user_id"   : PublicVariables.userInfo.m_id
        ]
        APIBase.shareObject.callAPIGetNumberOfUserByBuilding(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.object(forKey: "body") as? [String:Any] {
                    if let total = body["total"] as? String {
                        self.numberOfUserOfBuildingRoom = total
                        self.dispatchGroup.leave()
                    }
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    /*
     * Created by: hoangnn
     * Description: Sort and reload list room
     */
    func sortAndReloadListRoomFilter() {
        // End update
        self.listRoomTableView.endUpdates()

        // Sort list room filter
        self.listRoomFilter = self.listRoomFilter.sorted(by: { (leftRoom: RoomMessageModel, rightRoom: RoomMessageModel) -> Bool in
            // Check new message
            let isLeftRoomHasNewMessage: Bool = FirebaseGlobalMethod.checkNewMessageInRoom(roomId: leftRoom.roomId)
            let isRightRoomHasNewMessage: Bool = FirebaseGlobalMethod.checkNewMessageInRoom(roomId: rightRoom.roomId)

            // Check time if 2 room same status
            if isLeftRoomHasNewMessage == isRightRoomHasNewMessage {
                var leftRoomLatestMessageTime: Double = 0.0
                var rightRoomLatestMessageTime: Double = 0.0
                if leftRoom.roomLatestMessageTime != nil { leftRoomLatestMessageTime = leftRoom.roomLatestMessageTime! }
                if rightRoom.roomLatestMessageTime != nil { rightRoomLatestMessageTime = rightRoom.roomLatestMessageTime! }
                return (leftRoomLatestMessageTime > rightRoomLatestMessageTime)
            }
            else {
                // Room has new message will be left room
                return isLeftRoomHasNewMessage
            }
        })

        // Reload table
        self.listRoomTableView.reloadData()
    }
    
    // MARK: - Handle TextField

    /*
     * Created by: hoangnn
     * Description: Handle text field changed
     */
    @IBAction func handleTextFieldChanged(_ sender: UITextField) {
        self.listRoomFilter.removeAll()

        // Get list room filter
        if let filterString: String = sender.text, filterString != "" {
            for room in self.listRoom {
                if room.roomName?.contains(filterString) == true {
                    self.listRoomFilter.append(room)
                }
            }
        }
        else {
            self.listRoomFilter = self.listRoom
        }

        // Reload table
        self.sortAndReloadListRoomFilter()
    }

    // MARK: - SELECTOR
    @IBAction func btnHouseAction(_ sender: UIButton) {
        // Push to chat living
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            chatVC.conversationName = NSLocalizedString("ChatViewController_Title_Living", comment: "")
            let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: "living")
            chatVC.selectedGroupId = groupId
            chatVC.selectedGroupDatabase = roomReference
            self.present(chatVC, animated: true, completion: nil)
        }
    }
    @IBAction func btnJobAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            chatVC.conversationName = NSLocalizedString("ChatViewController_Title_Job", comment: "")
            let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: "job-consult")
            chatVC.selectedGroupId = groupId
            chatVC.selectedGroupDatabase = roomReference
            self.present(chatVC, animated: true, completion: nil)
        }
    }

}
