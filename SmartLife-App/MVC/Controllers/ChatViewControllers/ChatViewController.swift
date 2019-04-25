//
//  ChatViewController.swift
//  FamilyApp
//
//  Created by Hoang Nguyen on 12/3/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import Photos
import AVFoundation
import AXPhotoViewer
import FLAnimatedImage

class CustomForExpandTextView: UITextView {
    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: false)
    }
}

class ChatViewController: NewBaseViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, RightPhotoMessageTableViewCellDelegate, LeftPhotoMessageTableViewCellDelegate, LeftMessageTableViewCellDelegate, GoToUserChatPopupViewDelegate {
    // Subviews
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendPhotoButton: UIButton!
    @IBOutlet weak var chatTextView: CustomForExpandTextView!
    @IBOutlet weak var chatTextViewPlaceHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var jobIntroView: UIView!
    @IBOutlet weak var jobIntroLabel: UILabel!

    @IBOutlet weak var houseIntroView: UIView!
    @IBOutlet weak var houseIntroTitleLabel: UILabel!
    @IBOutlet weak var houseIntroContentLabel: UILabel!

    // Constraints
    @IBOutlet weak var inputeMessageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButtonTrailingConstraint: NSLayoutConstraint!

    // Refresh controller
    let refreshControll: UIRefreshControl = UIRefreshControl()

    // Popup
    var goToUserChatPopupView: GoToUserChatPopupView? = nil
    var confirmImagePopupView: ConfirmImagePopupVIew? = nil

    // IntroView
    var introView: UIView? = nil

    // Firebase Variables
    var getModifyMessageQuery: DatabaseQuery? = nil
    var getNewMessageQuery: DatabaseQuery? = nil
    var getTypingMessageQuery: DatabaseQuery? = nil
    var isNeedToScrollMessageTableToRow: Int? = nil

    // Variables
    var conversationName: String? = nil
    var selectedGroupId: String? = nil
    var selectedGroupDatabase: DatabaseReference? = nil
    let limitNumberGetMessage: UInt = 50
    var conversationKeys: [String] = []
    var conversationContents: [String: MessageModel] = [:]
    var isLoadingMoreMessage: Bool = false
    var isNeedToLoadMoreMessage: Bool = true
    var deleteTypingSignalTimer: Timer? = nil
    var typingTimer: Timer? = nil
    var isTyping: Bool = false
    var avatarTyping : String = ""
    var autoReplyMessageContent: String? = nil
    var timeOutStartTime: String? = nil
    var timeOutEndTime: String? = nil
    var indexAutoReplyMessage: Int = 0

    var numberOfUserInBuildingRoom : String = ""

    // Image picker controller
    let imagePicker: UIImagePickerController = UIImagePickerController()

    // MARK: - View Lifecycle

    deinit {
        self.selectedGroupDatabase?.removeAllObservers()
        self.getModifyMessageQuery?.removeAllObservers()
        self.getNewMessageQuery?.removeAllObservers()
        self.getTypingMessageQuery?.removeAllObservers()
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        // Call super
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        // Call super
        super.viewDidLoad()

        // Bring header view to front
        self.view.bringSubview(toFront: self.headerView)

        // Configure image picker controller
        self.imagePicker.delegate = self

        // Add keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyBoardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        // Call API get time out chat
        self.callAPIGetChatTimeOut()

        // Set observe for list message
        self.isNeedToScrollMessageTableToRow = -1
        self.getFirstLastListMessageInGroup()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Call super
        super.viewWillAppear(animated)

        // Check network
        if Reachability.isConnectedToNetwork() == false {
            GlobalMethod.showAlert("インターネット接続がありません。接続を確認してください。", in: self)
        }
        if self.conversationName == NSLocalizedString("ChatViewController_Title_Job", comment: ""){
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_JOB, eventName: nil)
        }
        else if self.conversationName == NSLocalizedString("ChatViewController_Title_Living", comment: "") {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE, eventName: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        // Call super
        super.viewDidAppear(animated)

        // Hide intro
        self.hideIntroView()
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    override func configureSelf() {
        // Call super
        super.configureSelf()

        // Configure self
        self.view.backgroundColor = UIColor.white
        self.view.clipsToBounds = true
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    override func configureSubviews() {
        // Call super
        super.configureSubviews()

        // Configure subviews
        self.configureHeaderView()
        self.configureTitleImageView()
        self.configureTitleLabel()
        self.configureMessageTableView()
        self.configureChatTextView()
        self.configureSendButton()
        self.configureIntroViews()
        self.configureGoToUserChatPopupView()
        self.configureConfirmImagePopupView()

        self.view.layoutIfNeeded()
        // Update content edge inset back button
        let backButtonInset: CGFloat = self.backButton.frame.size.width / 4.0
        self.backButton.contentEdgeInsets = UIEdgeInsets(top: backButtonInset, left: backButtonInset, bottom: backButtonInset, right: backButtonInset)
        // Update content edge inset send photo button
        let sendPhotoButtonInset: CGFloat = self.sendPhotoButton.frame.size.width / 4.0
        self.sendPhotoButton.contentEdgeInsets = UIEdgeInsets(top: sendPhotoButtonInset, left: sendPhotoButtonInset, bottom: sendPhotoButtonInset, right: sendPhotoButtonInset)

        // Update title
        self.updateTitleView()
    }

    /*
     * Created by: hoangnn
     * Description: Configure headerView
     */
    func configureHeaderView() {
        //()
    }

    /*
     * Created by: hoangnn
     * Description: Configure titleImageView
     */
    func configureTitleImageView() {
        // Set attributes
        self.view.layoutIfNeeded()
        self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0
        self.titleImageView.image = nil
    }

    /*
     * Created by: hoangnn
     * Description: Configure titleLabel
     */
    func configureTitleLabel() {
        // Set attributes
        self.titleLabel.font = UIFont(name: "YuGothic-Bold", size: 15.0 * GlobalMethod.displayScale)
        // Set room title
        if self.selectedGroupId?.contains("job-consult") == true {
            self.conversationName = NSLocalizedString("ChatViewController_Title_Job", comment: "")
        }
        else if self.selectedGroupId?.contains("living") == true {
            self.conversationName = NSLocalizedString("ChatViewController_Title_Living", comment: "")
        }
        else if self.selectedGroupId?.contains("building") == true {
            if self.numberOfUserInBuildingRoom.isEmpty == true {
                self.callAPINumberOfUserInBuilding()
            }
            else {
                self.conversationName = PublicVariables.userInfo.m_kabocha_building_name + " (" + self.numberOfUserInBuildingRoom + ")"
            }
        }

        self.titleLabel.text = self.conversationName
    }

    /*
     * Created by: hoangnn
     * Description: Configure messageTableView
     */
    func configureMessageTableView() {
        // Set delegate
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self

        // Register cell
        self.messageTableView.register(UINib(nibName: "LeftMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftMessageTableViewCell")
        self.messageTableView.register(UINib(nibName: "RightMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "RightMessageTableViewCell")
        self.messageTableView.register(UINib(nibName: "LeftPhotoMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftPhotoMessageTableViewCell")
        self.messageTableView.register(UINib(nibName: "RightPhotoMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "RightPhotoMessageTableViewCell")

        // Set attributes
        self.messageTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.messageTableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1.0))
        self.messageTableView.allowsSelection = false
        self.messageTableView.allowsMultipleSelection = false
        self.messageTableView.alwaysBounceVertical = true

        // Add gesture
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboardFunction))
        self.messageTableView.addGestureRecognizer(tapGesture)

        // Add refresh controll
        self.refreshControll.backgroundColor = UIColor.clear
        self.refreshControll.tintColor = UIColor.lightGray
        self.refreshControll.addTarget(self, action: #selector(self.getPreviousListMessageInGroup), for: UIControlEvents.valueChanged)
        self.messageTableView.addSubview(self.refreshControll)
    }

    /*
     * Created by: hoangnn
     * Description: Configure chatTextView
     */
    func configureChatTextView() {
        // Update constraint
        self.chatTextViewTrailingConstraint.constant = -5.0 * GlobalMethod.displayScale

        // Delegate
        self.chatTextView.delegate = self

        // Set attributes
        self.chatTextView.font = GlobalMethod.mainFont
        self.chatTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.chatTextView.contentInset = UIEdgeInsets.zero
        self.chatTextView.textContainer.lineFragmentPadding = 0.0
        self.chatTextView.text = nil
        self.chatTextViewPlaceHolderLabel.isHidden = false
        self.updateHeightForChatTextViewWith(numberLine: 1)

        // Placeholder Label
        self.chatTextViewPlaceHolderLabel.font = GlobalMethod.mainFont
        self.chatTextViewPlaceHolderLabel.text = NSLocalizedString("ChatViewController_ChatTextField_Placeholder", comment: "")
    }

    /*
     * Created by: hoangnn
     * Description: Configure sendButton
     */
    func configureSendButton() {
        // Update constraint
        self.sendButtonTrailingConstraint.constant = -5.0 * GlobalMethod.displayScale

        // Set attributes
        self.sendButton.titleLabel?.numberOfLines = 1
        self.sendButton.titleLabel?.font = GlobalMethod.mainFont.withSize(12.0 * GlobalMethod.displayScale)
        self.sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.sendButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.sendButton.setTitle(NSLocalizedString("ChatViewController_SendButton_Text", comment: ""), for: UIControlState.normal)
        self.sendButton.layer.cornerRadius = 3.0 * GlobalMethod.displayScale
    }

    /*
     * Created by: hoangnn
     * Description: Configure introViews
     */
    func configureIntroViews() {
        // Set attributes for job intro
        self.jobIntroView.isHidden = true
        self.jobIntroLabel.font = self.jobIntroLabel.font.withSize(12.0 * GlobalMethod.displayScale)

        // Set attributes for house intro
        self.houseIntroView.isHidden = true
        self.houseIntroTitleLabel.font = self.houseIntroTitleLabel.font.withSize(12.0 * GlobalMethod.displayScale)
        self.houseIntroContentLabel.font = self.houseIntroContentLabel.font.withSize(12.0 * GlobalMethod.displayScale)

        // Show intro
        // Comment out (maybe use later)
        // self.checkAndShowIntroView()
    }

    /*
     * Created by: hoangnn
     * Description: Configure goToUserChatPopupView
     */
    func configureGoToUserChatPopupView() {
        // Init popup
        self.view.layoutIfNeeded()
        self.goToUserChatPopupView = GoToUserChatPopupView(frame: GlobalMethod.screenSize)
        self.goToUserChatPopupView?.parentView = GlobalMethod.mainWindow

        // Set attributes
        self.goToUserChatPopupView?.delegate = self
    }

    /*
     * Created by: hoangnn
     * Description: Configure confirmImagePopupView
     */
    func configureConfirmImagePopupView() {
        // Init popup
        self.view.layoutIfNeeded()
        self.confirmImagePopupView = ConfirmImagePopupVIew(frame: GlobalMethod.screenSize)
        self.confirmImagePopupView?.parentView = GlobalMethod.mainWindow

        // Set attributes
        self.confirmImagePopupView?.delegate = self
    }

    // MARK: - UITableViewDelegate

    /*
     * Created by: hoangnn
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*
     * Created by: hoangnn
     * Description: Estimate height for row
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*
     * Created by: hoangnn
     * Description: Did select row
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var messageModelDidShow: MessageModel? = nil

        // Get messageModel
        if let cellDidShow: LeftMessageTableViewCell = cell as? LeftMessageTableViewCell {
            messageModelDidShow = cellDidShow.messageModel
        }
        else if let cellDidShow: LeftPhotoMessageTableViewCell = cell as? LeftPhotoMessageTableViewCell {
            messageModelDidShow = cellDidShow.messageModel
        }
        else if let cellDidShow: RightMessageTableViewCell = cell as? RightMessageTableViewCell {
            messageModelDidShow = cellDidShow.messageModel
        }
        else if let cellDidShow: RightPhotoMessageTableViewCell = cell as? RightPhotoMessageTableViewCell {
            messageModelDidShow = cellDidShow.messageModel
        }

        // Update read state
        if messageModelDidShow != nil {
            self.updateReadStateForMessage(messageModel: messageModelDidShow!)
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
        // Send room information to server
        if self.conversationKeys.count > 0 {
            FirebaseGlobalMethod.sendCurrentRoomToServer(currentRoomId: self.selectedGroupId)
        }

        if self.isTyping == true {
            return self.conversationKeys.count + 1
        }
        else {
            return self.conversationKeys.count
        }
    }

    /*
     * Created by: hoangnn
     * Description: Configure tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check array has key
        if self.conversationKeys.indices.contains(indexPath.row) == true {
            // Check exist content
            if let messageModel: MessageModel = self.conversationContents[self.conversationKeys[indexPath.row]] {
                var previousMessageModel: MessageModel
                if indexPath.row != 0 {
                    previousMessageModel = self.conversationContents[self.conversationKeys[indexPath.row-1]]!
                }
                else {
                    previousMessageModel = messageModel
                }
                // My message
                if messageModel.userId == ("user" + PublicVariables.userInfo.m_id) {
                    // Photo message
                    if messageModel.contentImage != nil && messageModel.contentImage != "" {
                        if let cell: RightPhotoMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightPhotoMessageTableViewCell") as? RightPhotoMessageTableViewCell {
                            cell.delegate = self
                            cell.parentTableView = tableView
                            cell.cellIndex = indexPath
                            if GlobalMethod.getStringDateFromTime(time: previousMessageModel.time, with: "dd/MM/yyyy") == GlobalMethod.getStringDateFromTime(time: messageModel.time, with: "dd/MM/yyyy"){
                                cell.mConstraintHeightDate.constant = 5
                                cell.dateLabel.isHidden = true
                            }
                            else {
                                cell.mConstraintHeightDate.constant = 40
                                cell.dateLabel.isHidden = false
                            }
                            cell.setMessageContent(messageModel: messageModel)
                            return cell
                        }
                    }
                        // Text message
                    else {
                        if let cell: RightMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightMessageTableViewCell") as? RightMessageTableViewCell {
                            // Set date title
                            if GlobalMethod.getStringDateFromTime(time: previousMessageModel.time, with: "dd/MM/yyyy") == GlobalMethod.getStringDateFromTime(time: messageModel.time, with: "dd/MM/yyyy"){
                                cell.mConstraintHeightDate.constant = 5
                                cell.dateLabel.isHidden = true
                            }
                            else {
                                cell.mConstraintHeightDate.constant = 40
                                cell.dateLabel.isHidden = false
                            }
                            cell.setMessageContent(messageModel: messageModel)
                            return cell
                        }
                    }
                }
                    // Other's message
                else {
                    // Photo message
                    if messageModel.contentImage != nil && messageModel.contentImage != "" {
                        if let cell: LeftPhotoMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftPhotoMessageTableViewCell") as? LeftPhotoMessageTableViewCell {
                            cell.delegate = self
                            cell.parentTableView = tableView
                            cell.cellIndex = indexPath

                            if GlobalMethod.getStringDateFromTime(time: previousMessageModel.time, with: "dd/MM/yyyy") == GlobalMethod.getStringDateFromTime(time: messageModel.time, with: "dd/MM/yyyy"){
                                cell.mConstraintHeightDate.constant = 5
                                cell.dateLabel.isHidden = true
                            }
                            else {
                                cell.mConstraintHeightDate.constant = 40
                                cell.dateLabel.isHidden = false
                            }

                            cell.setMessageContent(messageModel: messageModel)
                            return cell
                        }
                    }
                        // Text message
                    else {
                        if let cell: LeftMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftMessageTableViewCell") as? LeftMessageTableViewCell {
                            cell.delegate = self

                            // Set date title
                            if GlobalMethod.getStringDateFromTime(time: previousMessageModel.time, with: "dd/MM/yyyy") == GlobalMethod.getStringDateFromTime(time: messageModel.time, with: "dd/MM/yyyy"){
                                cell.mConstraintHeightDate.constant = 5
                                cell.dateLabel.isHidden = true
                            }
                            else {
                                cell.mConstraintHeightDate.constant = 40
                                cell.dateLabel.isHidden = false
                            }

                            cell.setMessageContent(messageModel: messageModel)
                            cell.setTypingText(isTyping: false)
                            return cell
                        }
                    }
                }
            }
        }
            // Typing cell
        else {
            if let cell: LeftMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftMessageTableViewCell") as? LeftMessageTableViewCell {
                cell.delegate = self
                cell.mConstraintHeightDate.constant = 0
                cell.dateLabel.isHidden = true
                cell.setMessageContent(messageModel: nil)
                cell.setTypingText(isTyping: true, avatarURL: self.avatarTyping)
                return cell
            }
        }

        return UITableViewCell()
    }

    // MARK: - UITextViewDelegate

    /*
     * Created by: hoangnn
     * Description: Text view did change
     */
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.chatTextView {
            // Update place holder
            self.chatTextViewPlaceHolderLabel.isHidden = (self.chatTextView.text != nil && self.chatTextView.text != "")

            // Update text view height
            if self.chatTextView.font != nil {
                let numberLine: Int = Int(self.chatTextView.contentSize.height / self.chatTextView.font!.lineHeight)
                self.updateHeightForChatTextViewWith(numberLine: numberLine)
            }

            // Send signal typing
            self.sendTypingSignalToServer(isDelete: false)
        }
    }

    // MARK: - Adjust Image

    /*
     * Created by: hoangnn
     * Description: Normalize image
     */
    func normalizeImage(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        else {
            UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
            image.draw(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: image.size))
            var normalizeImage = image
            if UIGraphicsGetImageFromCurrentImageContext() != nil {
                normalizeImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            UIGraphicsEndImageContext()
            return normalizeImage
        }
    }

    /*
     * Created by: hoangnn
     * Description: Scale image to under 1MB
     */
    func scaleImage(image: UIImage) -> UIImage {
        let sizeScale: Int = (1024 * 1024) / 2 // 1MB on server
        var imageData = UIImageJPEGRepresentation(image, 1.0)!
        var scaleImage = image
        var adjustment: CGFloat = 0.9

        // Check and resize data image <= 1MB
        if (imageData.count > sizeScale) {
            while (imageData.count > sizeScale) {
                NSLog("While start - The imagedata size is currently: %f KB", roundf(Float(imageData.count / 1024)));

                // Update adjustment
                adjustment = CGFloat(sizeScale) / CGFloat(imageData.count)
                if adjustment < 0.5 { adjustment = 0.5 }
                if adjustment > 0.95 { adjustment = 0.95 }

                // While the imageData is too large scale down the image

                // Resize the image
                let newSize = CGSize(width: scaleImage.size.width * adjustment, height: scaleImage.size.height * adjustment)
                let rect = CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                scaleImage.draw(in: rect)
                if UIGraphicsGetImageFromCurrentImageContext() != nil {
                    scaleImage = UIGraphicsGetImageFromCurrentImageContext()!
                }
                UIGraphicsEndImageContext()

                // Pass the NSData out again
                imageData = UIImageJPEGRepresentation(scaleImage, 1.0)!;
            }
        }

        return scaleImage
    }

    // MARK: - Public methods

    /*
     * Created by: hoangnn
     * Description: Update title
     */
    func updateTitleView() {
        // Do not update with job and house room
        if self.selectedGroupId?.contains("job-consult") != true && self.selectedGroupId?.contains("living") != true {
            FirebaseGlobalMethod.getUserInformation(userIdCheck: self.selectedGroupId, completion: { (userModel: FirebaseUserModel) in
                // Set image
                if let image = userModel.avatarImage {
                    self.titleImageView.setImageForm(urlString: image, placeHolderImage: UIImage(named: "NoAvatar"))
                }
                // Set name
                if let conversation = userModel.userName {
                    self.conversationName = conversation
                    self.titleLabel.text = conversation
                }
            })
        }
    }

    /*
     * Created by: hoangnn
     * Description: Check and show intro view
     */
    func checkAndShowIntroView() {
        if self.selectedGroupId?.contains("job-consult") == true {
            self.introView = self.jobIntroView
        }
        else if self.selectedGroupId?.contains("living") == true {
            self.introView = self.houseIntroView
        }

        self.introView?.isHidden = false
        self.introView?.alpha = 1.0
    }

    /*
     * Created by: hoangnn
     * Description: Hide intro view
     */
    func hideIntroView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.introView?.alpha = 1.0
            UIView.animate(withDuration: 1.0, animations: {
                self.introView?.alpha = 0.0
            }) { (complete: Bool) in
                self.introView?.alpha = 0.0
                self.introView?.isHidden = true
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Get default message
     */
    func getDefaultMessage() {
        if self.selectedGroupId?.contains("job-consult") == true
            || self.selectedGroupId?.contains("living") == true {
            let defaultMessageModel: MessageModel = MessageModel()
            defaultMessageModel.messageId = "Default"

            // Content message
            if self.selectedGroupId?.contains("job-consult") == true {
                defaultMessageModel.contentMessage = NSLocalizedString("ChatViewController_Default_Job_Message", comment: "")
            }
            else if self.selectedGroupId?.contains("living") == true {
                defaultMessageModel.contentMessage = NSLocalizedString("ChatViewController_Default_Living_Message", comment: "")
            }

            // Add to list
            self.conversationKeys.insert("Default", at: 0)
            self.conversationContents["Default"] = defaultMessageModel
        }
    }

    /*
     * Created by: hoangnn
     * Description: Close keyboard
     */
    @objc func closeKeyboardFunction() {
        self.view.endEditing(true)
    }

    /*
     * Created by: hoangnn
     * Description: Show action sheet choose camera or photo library
     */
    func showActionSheetChooseCameraOrLibrary() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        // Cancel action
        let cancelActionTitle: String = NSLocalizedString("ChatViewController_ActionSheet_CancelAction", comment: "")
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelActionTitle, style: UIAlertActionStyle.cancel, handler: nil)

        // Camera action
        let cameraActionTitle: String = NSLocalizedString("ChatViewController_ActionSheet_CameraAction", comment: "")
        let cameraAction: UIAlertAction = UIAlertAction(title: cameraActionTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
            // Track Repro
            if self.conversationName == NSLocalizedString("ChatViewController_Title_Job", comment: ""){
                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_JOB, eventName: ReproEvent.REPRO_SCREEN_CHAT_JOB_ACTION_CAMERA)
            }
            else if self.conversationName == NSLocalizedString("ChatViewController_Title_Living", comment: "") {
                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE, eventName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE_ACTION_CAMERA)
            }

            self.launchCamera()
        })

        // Camera action
        let photoLibraryActionTitle: String = NSLocalizedString("ChatViewController_ActionSheet_PhotoLibraryAction", comment: "")
        let photoLibraryAction: UIAlertAction = UIAlertAction(title: photoLibraryActionTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
            // Track Repro
            if self.conversationName == NSLocalizedString("ChatViewController_Title_Job", comment: ""){
                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_JOB, eventName: ReproEvent.REPRO_SCREEN_CHAT_JOB_ACTION_GALLERY)
            }
            else if self.conversationName == NSLocalizedString("ChatViewController_Title_Living", comment: "") {
                GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE, eventName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE_ACTION_GALLERY)
            }

            self.goToPhotoLibrary()
        })

        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoLibraryAction)

        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }

    /*
     * Created by: hoangnn
     * Description: Check permission and launch camera
     */
    func launchCamera() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .authorized:
            // Open camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
            break
        case .denied, .restricted:
            break
        case .notDetermined:
            // Ask for permissions
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    // Open camera
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            break
        }
    }

    /*
     * Created by: hoangnn
     * Description: Check permission and open library
     */
    func goToPhotoLibrary() {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Open photo library
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            break
        case .denied, .restricted :
            break
        case .notDetermined:
            // Ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // Open photo library
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                    break
                case .denied, .restricted:
                    break
                case .notDetermined:
                    break
                }
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Update height for chat text view
     */
    func updateHeightForChatTextViewWith(numberLine: Int) {
        var appearLines: Int = numberLine
        if appearLines < 1 { appearLines = 1 }
        if appearLines > 3 { appearLines = 3 }

        // Update text view height
        if self.chatTextView.font != nil {
            let newHeight: CGFloat = (CGFloat(appearLines) + 0.8) * self.chatTextView.font!.lineHeight

            let oldHeight: CGFloat = self.chatTextViewHeightConstraint.constant
            self.chatTextViewHeightConstraint.constant = newHeight

            // Update message table view content offset
            let adjustHeight: CGFloat = self.messageTableView.contentOffset.y + newHeight - oldHeight
            self.messageTableView.setContentOffset(CGPoint(x: 0.0, y: adjustHeight), animated: false)

            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Logic Show Typing

    /*
     * Created by: hoangnn
     * Description: Get data typing from server
     */
    func setObserverForTyping() {
        // Check current room id
        if self.selectedGroupId != nil && PublicVariables.userInfo.m_id != "" {
            var groupId: String = "user" + PublicVariables.userInfo.m_id + "_" + self.selectedGroupId!
            if self.selectedGroupId!.contains("building") == true{
                groupId = "room_" + self.selectedGroupId!
            }
            let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
            let listRoomTypingReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomTypingSignal)
            self.getTypingMessageQuery = listRoomTypingReference.child(groupId).queryOrderedByKey()

            // Get list typing
            self.getTypingMessageQuery?.observe(DataEventType.value, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }

                // Get old typing status
                let oldIsTyping: Bool = strongSelf.isTyping
                strongSelf.isTyping = false

                // Get value of snapshot
                if let datas: NSDictionary = snapshot.value as? NSDictionary {
                    if let listUserTyping: [NSDictionary] = datas.allValues as? [NSDictionary] {
                        if listUserTyping.count == 1{
                            for userDict in listUserTyping {
                                // Get and check user id typing
                                let userId: String? = userDict[FirebaseConstants.RoomTypingSignalFields.Id] as? String
                                if userId != "user" + PublicVariables.userInfo.m_id {
                                    // Get avatar typing
                                    strongSelf.avatarTyping = (userDict[FirebaseConstants.RoomTypingSignalFields.Avatar] as? String) ?? ""
                                    // Get time typing
                                    let miliSecondTyping: Double = ((userDict[FirebaseConstants.RoomTypingSignalFields.Time] as? Double) ?? 0.0)
                                    let dateTyping: Date = Date(timeIntervalSince1970: miliSecondTyping/1000.0)
                                    let timeAfter5Minutes: Date = dateTyping.addingTimeInterval(300.0) // Add 5 minutes

                                    // Check time after 5 minute
                                    if timeAfter5Minutes > Date() {
                                        if (strongSelf.typingTimer == nil) || (timeAfter5Minutes > strongSelf.typingTimer!.fireDate) {
                                            // Update isTyping
                                            strongSelf.isTyping = true

                                            // Set timer
                                            strongSelf.typingTimer?.invalidate()
                                            strongSelf.typingTimer = Timer(fireAt: timeAfter5Minutes, interval: 0.0, target: strongSelf, selector: #selector(strongSelf.delayedAction), userInfo: nil, repeats: false)
                                            RunLoop.main.add(strongSelf.typingTimer!, forMode: RunLoopMode.defaultRunLoopMode)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Check for reload table
                if strongSelf.isTyping != oldIsTyping {
                    strongSelf.messageTableView.reloadData()
                    let lastIndexPath = IndexPath(row: strongSelf.conversationContents.count-1, section: 0)

                    if strongSelf.isTyping && strongSelf.messageTableView.indexPathsForVisibleRows?.contains(lastIndexPath) == true {
                        strongSelf.scrollToLastRow()
                    }
                }
            })
        }
    }

    func scrollToLastRow() {
        let indexPath = IndexPath(row: self.conversationContents.count, section: 0)
        self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    // MARK: - Logic Methods

    /*
     * Created by: hoangnn
     * Description: Get limit list message in group
     */
    func getFirstLastListMessageInGroup() {
        if let lastListMessageQuery: DatabaseQuery = self.selectedGroupDatabase?.queryOrderedByKey().queryLimited(toLast: self.limitNumberGetMessage) {
            // Remove old list message
            self.conversationKeys.removeAll()
            self.conversationContents.removeAll()

            lastListMessageQuery.observeSingleEvent(of: DataEventType.value, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                // Get value of snapshot
                if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                    if var listKeys: [String] = listDatas.allKeys as? [String] {
                        // Sort list
                        listKeys = listKeys.sorted()

                        // Get list message
                        for key in listKeys {
                            if let datas: NSDictionary = listDatas[key] as? NSDictionary {
                                let messageModel: MessageModel = MessageModel()
                                messageModel.messageId = key
                                messageModel.getInfoFrom(datas: datas)

                                // Send read signal to server
                                strongSelf.sendReadSignalToServer(messageId: key)

                                // Update convesations
                                if strongSelf.conversationKeys.contains(key) == false {
                                    strongSelf.conversationKeys.append(key)
                                    strongSelf.conversationContents[key] = messageModel
                                }
                            }
                        }


                        // Check new message
                        FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideChatNewLabel()

//                        if strongSelf.selectedGroupId != nil && listKeys.last != nil {
//                            // Update latest message in room
//                            var roomId: String = "user" + PublicVariables.userInfo.m_id + "_" + strongSelf.selectedGroupId!
//                            if self?.selectedGroupId!.contains("building") == true{
//                                roomId = "room_" + strongSelf.selectedGroupId!
//                            }
//
//                            FirebaseGlobalMethod.createOrUpdateLocalListLastMessageId(messageId: listKeys.last!, in: roomId)
//                            // Check new message
//                            FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideChatNewLabel()
//                        }
                    }
                }

                // Add default message
                if strongSelf.conversationKeys.count < Int(strongSelf.limitNumberGetMessage) {
                    strongSelf.isNeedToLoadMoreMessage = false
                    strongSelf.getDefaultMessage()
                }

                // Reload table
                strongSelf.messageTableReload()
            })
        }
    }


    /*
     * Created by: hoangnn
     * Description: Get limit list message in group
     */
    @objc func getPreviousListMessageInGroup() {
        if self.selectedGroupDatabase != nil && self.isLoadingMoreMessage == false && self.isNeedToLoadMoreMessage == true {
            // Update is loading more message
            self.isLoadingMoreMessage = true

            // Update is need to load more message
            self.isNeedToLoadMoreMessage = false

            // Get first message
            if let firstMessageId: String = self.conversationKeys.first, firstMessageId != "Default" {
                if let loadMoreMessageQuery: DatabaseQuery = self.selectedGroupDatabase?.queryOrderedByKey().queryEnding(atValue: firstMessageId).queryLimited(toLast: (self.limitNumberGetMessage + 1)) {

                    // Save last visible row
                    if let indexPathlastVisibleCell: IndexPath = self.messageTableView.indexPathsForVisibleRows?.last {
                        self.isNeedToScrollMessageTableToRow = indexPathlastVisibleCell.row
                    }

                    // Get list message
                    loadMoreMessageQuery.observeSingleEvent(of: DataEventType.value, with: { [weak self] (snapshot) in
                        guard let strongSelf = self else { return }
                        // Get value of snapshot
                        if let listDatas: NSDictionary = snapshot.value as? NSDictionary {
                            if var listKeys: [String] = listDatas.allKeys as? [String] {
                                // Sort list
                                listKeys = listKeys.sorted()

                                // Get list message
                                var indexGet: UInt = 0
                                for key in listKeys {
                                    if let datas: NSDictionary = listDatas[key] as? NSDictionary {
                                        let messageModel: MessageModel = MessageModel()
                                        messageModel.messageId = key
                                        messageModel.getInfoFrom(datas: datas)

                                        // Update convesations
                                        if strongSelf.conversationKeys.contains(key) == false {
                                            strongSelf.conversationKeys.insert(key, at: Int(indexGet))
                                            strongSelf.conversationContents[key] = messageModel

                                            // Update indexGet
                                            indexGet = indexGet + 1
                                            strongSelf.isNeedToLoadMoreMessage = (indexGet >= strongSelf.limitNumberGetMessage)
                                            if strongSelf.isNeedToScrollMessageTableToRow != nil {
                                                strongSelf.isNeedToScrollMessageTableToRow = strongSelf.isNeedToScrollMessageTableToRow! + 1
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Add default message
                        if strongSelf.isNeedToLoadMoreMessage == false {
                            strongSelf.getDefaultMessage()
                        }

                        // Reload table
                        strongSelf.refreshControll.endRefreshing()
                        strongSelf.messageTableReload()
                    })
                }
                else {
                    self.refreshControll.endRefreshing()
                }
            }
            else {
                self.refreshControll.endRefreshing()
            }
        }
        else {
            self.refreshControll.endRefreshing()
        }
    }

    /*
     * Created by: hoangnn
     * Description: Set observe for new message
     */
    func setObserverForNewMessage() {
        // Get last message
        var lastMessageId: String? = self.conversationKeys.last
        if lastMessageId == "Default" { lastMessageId = nil }
        if lastMessageId == nil { lastMessageId = "" }
        if let newMessageQuery: DatabaseQuery = self.selectedGroupDatabase?.queryOrderedByKey().queryStarting(atValue: lastMessageId) {
            // Get new message query
            self.getNewMessageQuery = newMessageQuery

            // Get list message
            newMessageQuery.observe(DataEventType.childAdded, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                // Get value of snapshot
                if strongSelf.conversationKeys.contains(snapshot.key) == false {
                    if let datas: NSDictionary = snapshot.value as? NSDictionary {
                        let messageModel: MessageModel = MessageModel()
                        messageModel.messageId = snapshot.key
                        messageModel.getInfoFrom(datas: datas)

                        // Update convesations
                        if strongSelf.conversationKeys.contains(snapshot.key) == false {
                            strongSelf.conversationKeys.append(snapshot.key)
                            strongSelf.conversationContents[snapshot.key] = messageModel

                            // Check to auto reply
                            if messageModel.userId == "user" + PublicVariables.userInfo.m_id {
                                strongSelf.checkAndAddAutoReplyMessageToList()
                            }
                            else {
                                // Reload table chat
                                strongSelf.isNeedToScrollMessageTableToRow = nil
                                strongSelf.messageTableReload()
                            }
                        }

                        strongSelf.sendReadSignalToServer(messageId: snapshot.key)

                        // Check new message
                        FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideChatNewLabel()

//                        if strongSelf.selectedGroupId != nil {
//                            // Update latest message in room
//                            var roomId: String = "user" + PublicVariables.userInfo.m_id + "_" + strongSelf.selectedGroupId!
//                            if self?.selectedGroupId!.contains("building") == true{
//                                roomId = "room_" + strongSelf.selectedGroupId!
//                            }
//                            FirebaseGlobalMethod.createOrUpdateLocalListLastMessageId(messageId: snapshot.key, in: roomId)
//                            // Check new message
//                            FirebaseGlobalMethod.tabbarMainVC?.viewTabbar.checkToShowOrHideChatNewLabel()
//                        }
                    }
                }
            })
        }
    }

    /*
     * Created by: hoangnn
     * Description: Set observe for modify message
     */
    func setObserverForModifyMessage() {
        if let modifyMessageQuery: DatabaseQuery = self.selectedGroupDatabase?.queryOrderedByKey() {
            // Get new message query
            self.getModifyMessageQuery = modifyMessageQuery

            // Get list message
            modifyMessageQuery.observe(DataEventType.childChanged, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                // Get value of snapshot
                if strongSelf.conversationKeys.contains(snapshot.key) == true {
                    if let datas: NSDictionary = snapshot.value as? NSDictionary {
                        strongSelf.conversationContents[snapshot.key]?.getInfoFrom(datas: datas)

                        // Reload table chat
                        strongSelf.messageTableView.layoutIfNeeded()
                        strongSelf.isNeedToScrollMessageTableToRow = nil
                        strongSelf.messageTableReload()
                    }
                }
            })
        }
    }

    /*
     * Created by: hoangnn
     * Description: Reload message table
     */
    func messageTableReload() {
        // Reload message table view
        UIView.animate(withDuration: 0.0, animations: {
            self.messageTableView.reloadData()
            self.scrollMessageTableViewToIndex(indexPathRow: self.isNeedToScrollMessageTableToRow)
        }, completion: { (complete) in
            self.isNeedToScrollMessageTableToRow = nil
            self.refreshControll.endRefreshing()
        })

        // Set observe for new message
        if self.getNewMessageQuery == nil {
            self.setObserverForNewMessage()
        }

        // Set observe for modify message
        if self.getModifyMessageQuery == nil {
            self.setObserverForModifyMessage()
        }

        // Set observe for typing message
        if self.getTypingMessageQuery == nil {
            self.setObserverForTyping()
        }
    }

    /*
     * Created by: hoangnn
     * Description: Scroll to bottom of content of message table view
     */
    func scrollMessageTableViewToIndex(indexPathRow: Int?) {
        // Check nil
        if indexPathRow != nil {
            var indexRow: Int = 0
            // Scroll to bottom
            if indexPathRow == -1 {
                indexRow = self.messageTableView.numberOfRows(inSection: 0) - 1
            }
            else {
                indexRow = indexPathRow!
            }

            if indexRow >= 0 && indexRow <= self.messageTableView.numberOfRows(inSection: 0) - 1 {
                let indexPath: IndexPath = IndexPath(row: indexRow, section: 0)
                // Scroll to bottom
                if indexPathRow == -1 {
                    self.messageTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
                    // For load more message
                else {
                    self.messageTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
                    self.isLoadingMoreMessage = false
                }
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Send message to server
     */
    func sendMessageToServer(image: String?, text: String?) {
        // Check uid
        if Auth.auth().currentUser?.uid != nil {
            if self.selectedGroupDatabase != nil {
                let seconds: Double = Date().timeIntervalSince1970
                let milliseconds: Int = Int(seconds * 1000.0)

                // Get data
                var messageData: [String: Any] = [:]
                messageData[FirebaseConstants.MessageFields.AvatarImage] = PublicVariables.userInfo.m_icon_path
                messageData[FirebaseConstants.MessageFields.ContentImage] = image
                messageData[FirebaseConstants.MessageFields.ContentMessage] = text
                messageData[FirebaseConstants.MessageFields.UserName] = PublicVariables.userInfo.m_name
                messageData[FirebaseConstants.MessageFields.UserId] = "user" + PublicVariables.userInfo.m_id
                messageData[FirebaseConstants.MessageFields.TypeString] = ((image?.isEmpty == false) ? "image" : "default")
                messageData[FirebaseConstants.MessageFields.Time] = milliseconds
                messageData[FirebaseConstants.MessageFields.Read] = 0

                var readUser: [String: Any] = [:]
                readUser[FirebaseConstants.ReadUsers.UserId] = "user" + PublicVariables.userInfo.m_id
                readUser[FirebaseConstants.ReadUsers.UserName] = PublicVariables.userInfo.m_name
                readUser[FirebaseConstants.ReadUsers.AvatarImage] = PublicVariables.userInfo.m_icon_path
                let dic: [String:Any] = ["user" + PublicVariables.userInfo.m_id :  readUser]

                messageData[FirebaseConstants.MessageFields.ReadUsers] = dic

                // Send data
                self.selectedGroupDatabase?.childByAutoId().updateChildValues(messageData, withCompletionBlock: { (error, data) in
                })

                // Send unread room
                self.sendInfoUnreadToServer(timestamp: milliseconds)
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Convert time string (hh:mm) to time double
     */
    func convertTimeStringToTimeDouble(timeString: String?) -> Double {
        let hourInt: Int = Int(timeString?.components(separatedBy: ":").first ?? "") ?? 0
        let minuteInt: Int = Int(timeString?.components(separatedBy: ":").last ?? "") ?? 0
        var timeDouble: Double = Double(hourInt) + (Double(minuteInt) / 60.0)
        if timeDouble < 0.0 { timeDouble = 0.0 }
        if timeDouble > 23.99 { timeDouble = 23.99 }
        return timeDouble
    }

    /*
     * Created by: hoangnn
     * Description: Convert date to time double
     */
    func convertDateToTimeDouble(date: Date) -> Double {
        let hourInt: Int = Calendar.current.component(Calendar.Component.hour, from: date)
        let minuteInt: Int = Calendar.current.component(Calendar.Component.minute, from: date)
        var timeDouble: Double = Double(hourInt) + (Double(minuteInt) / 60.0)
        if timeDouble < 0.0 { timeDouble = 0.0 }
        if timeDouble > 23.99 { timeDouble = 23.99 }
        return timeDouble
    }

    /*
     * Created by: hoangnn
     * Description: Check time valid
     */
    func checkTimeInvalid(startTime: Double, endTime: Double, checkTime: Double) -> Bool {
        var isInvalid: Bool = false

        // End time larger than start time
        if endTime > startTime {
            if (checkTime >= startTime) && (checkTime <= endTime) {
                isInvalid = true
            }
        }
            // End time smaller than start time
        else if endTime < startTime {
            if (checkTime >= startTime) && (checkTime <= 23.99) {
                isInvalid = true
            }
            else if (checkTime >= 0.0) && (checkTime <= endTime) {
                isInvalid = true
            }
        }

        // Return result
        return isInvalid
    }

    /*
     * Created by: hoangnn
     * Description: Check and Send auto reply message to server
     */
    func checkAndAddAutoReplyMessageToList() {
        // Check valid time
        let startTime: Double = self.convertTimeStringToTimeDouble(timeString: self.timeOutStartTime)
        let endTime: Double = self.convertTimeStringToTimeDouble(timeString: self.timeOutEndTime)
        let checkTime: Double = self.convertDateToTimeDouble(date: Date())
        let isInvalid: Bool = self.checkTimeInvalid(startTime: startTime, endTime: endTime, checkTime: checkTime)

        // Out of service
        if isInvalid == true {
            let seconds: Double = Date().timeIntervalSince1970
            let milliseconds: Int = Int(seconds * 1000.0)

            // AutoReplyMessageId
            let autoReplyMessageId: String = "AutoReply" + String(self.indexAutoReplyMessage)
            self.indexAutoReplyMessage = self.indexAutoReplyMessage + 1

            // Add auto reply message
            let autoReplyMessageModel: MessageModel = MessageModel()
            autoReplyMessageModel.messageId = autoReplyMessageId
            autoReplyMessageModel.contentMessage = self.autoReplyMessageContent
            autoReplyMessageModel.time = Double(milliseconds)

            // Add to list
            self.conversationKeys.append(autoReplyMessageId)
            self.conversationContents[autoReplyMessageId] = autoReplyMessageModel
        }

        // Reload table chat
        self.isNeedToScrollMessageTableToRow = -1
        self.messageTableReload()
    }

    /*
     * Created by: hoangnn
     * Description: Send info unread to server
     */
    func sendInfoUnreadToServer(timestamp: Int) {
        if Auth.auth().currentUser?.uid != nil {
            // Check group id and my id
            if self.selectedGroupId != nil && PublicVariables.userInfo.m_id != "" {
                let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
                let listRoomReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.StaffUnreadRooms)
                var roomReference: DatabaseReference
                if self.selectedGroupId!.contains("building") == true{
                    roomReference = listRoomReference.child("room_" + self.selectedGroupId!)
                }
                else {
                    roomReference = listRoomReference.child("user" + PublicVariables.userInfo.m_id + "_" + self.selectedGroupId!)
                }
                // Get data
                var staffUnreadRoomData: [String: Any] = [:]
                staffUnreadRoomData[FirebaseConstants.StaffUnreadRoomFields.Name] = PublicVariables.userInfo.m_name
                staffUnreadRoomData[FirebaseConstants.StaffUnreadRoomFields.AvatarUrl] = PublicVariables.userInfo.m_icon_path
                staffUnreadRoomData[FirebaseConstants.StaffUnreadRoomFields.UpdatedAt] = timestamp

                // Send data
                roomReference.updateChildValues(staffUnreadRoomData, withCompletionBlock: { (error, data) in
                })
            }
        }
    }

    /*
     * Created by: cuongkt
     * Description: Send read signal to server
     */
    func sendReadSignalToServer(messageId : String) {
        if Auth.auth().currentUser?.uid != nil {
            // Check group id and my id
            if self.selectedGroupId != nil && PublicVariables.userInfo.m_id != "" {
                let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
                let listRoomMessageReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomMessages)
                var roomMessageReference: DatabaseReference
                if self.selectedGroupId!.contains("building") == true{
                    roomMessageReference = listRoomMessageReference.child("room_" + self.selectedGroupId!)
                }
                else {
                    roomMessageReference = listRoomMessageReference.child("user" + PublicVariables.userInfo.m_id + "_" + self.selectedGroupId!)
                }

                let lastMessageReference : DatabaseReference = roomMessageReference.child(messageId)
                let readUsersReference : DatabaseReference = lastMessageReference.child(FirebaseConstants.MessageFields.ReadUsers)

                // Get data
                var readUser: [String: Any] = [:]
                readUser[FirebaseConstants.ReadUsers.UserId] = "user" + PublicVariables.userInfo.m_id
                readUser[FirebaseConstants.ReadUsers.UserName] = PublicVariables.userInfo.m_name
                readUser[FirebaseConstants.ReadUsers.AvatarImage] = PublicVariables.userInfo.m_icon_path

                // Send data
                readUsersReference.child("user" + PublicVariables.userInfo.m_id).updateChildValues(readUser, withCompletionBlock: { (error, data) in

                })
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Send typing signal to server
     */
    func sendTypingSignalToServer(isDelete: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            // Check current room id
            if self.selectedGroupId != nil && PublicVariables.userInfo.m_id != "" {
                let userId: String = "user" + PublicVariables.userInfo.m_id
                var groupId: String = "user" + PublicVariables.userInfo.m_id + "_" + self.selectedGroupId!
                if self.selectedGroupId!.contains("building") {
                    groupId = "room_" + self.selectedGroupId!
                }
                let chatReference: DatabaseReference = Database.database().reference().child(FirebaseConstants.MainFields.Chat)
                let listRoomTypingReference: DatabaseReference = chatReference.child(FirebaseConstants.ChatFields.RoomTypingSignal)
                let roomReference: DatabaseReference  = listRoomTypingReference.child(groupId)

                // Send signal
                if isDelete == false {
                    let seconds: Double = Date().timeIntervalSince1970
                    let milliseconds: Int = Int(seconds * 1000.0)

                    // Get data
                    var signalData: [String: Any] = [:]
                    signalData[FirebaseConstants.RoomTypingSignalFields.Name] = PublicVariables.userInfo.m_name
                    signalData[FirebaseConstants.RoomTypingSignalFields.Id] = "user" + PublicVariables.userInfo.m_id
                    signalData[FirebaseConstants.RoomTypingSignalFields.Time] = milliseconds
                    signalData[FirebaseConstants.RoomTypingSignalFields.Avatar] = PublicVariables.userInfo.m_icon_path

                    // Send data
                    roomReference.child(userId).updateChildValues(signalData, withCompletionBlock: { (error, data) in
                    })

                    // Set timer
                    self.deleteTypingSignalTimer?.invalidate()
                    self.deleteTypingSignalTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.deleteTypingSignalAction), userInfo: nil, repeats: false)
                    RunLoop.main.add(self.deleteTypingSignalTimer!, forMode: RunLoopMode.defaultRunLoopMode)
                }
                    // Delete signal
                else {
                    roomReference.child(userId).removeValue(completionBlock: { (error, data) in
                    })
                }
            }
        }
    }

    func updateReadStateForMessage(messageModel: MessageModel) {
        // Check uid
        if Auth.auth().currentUser?.uid != nil {
            if (self.selectedGroupDatabase != nil) && (messageModel.messageId != nil) && (messageModel.messageId != "Default") {
                if messageModel.messageId?.contains("AutoReply") != true {
                    if messageModel.userId?.contains("staff") == true {
                        // Send data (Update isRead)
                        if messageModel.isRead != 1 {
                        self.selectedGroupDatabase?.child(messageModel.messageId!).child(FirebaseConstants.MessageFields.Read).setValue(1)
                        }
                    }
                }
            }
        }
    }

    // MARK: - GoToUserChatPopupViewDelegate

    /*
     * Created by: hoangnn
     * Description: Did choose go to user chat
     */
    func didChooseGoToUserChat(popup: GoToUserChatPopupView) {
        self.view.endEditing(true)
        if let userId: String = popup.messageModel?.userId {
            // Push to chat
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            if let chatVC: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
                chatVC.conversationName = popup.messageModel?.userName
                let (groupId, roomReference): (String?, DatabaseReference?) = FirebaseGlobalMethod.getRoomWith(user: userId)
                chatVC.selectedGroupId = groupId
                chatVC.selectedGroupDatabase = roomReference
                self.present(chatVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - MessageTableViewCellDelegate

    /*
     * Created by: hoangnn
     * Description: Did tap avatar in left message
     */
    func didTapAvatarInLeftMessageTableViewCell(_ cell: LeftMessageTableViewCell) {
        self.view.endEditing(true)
        // Only in job room
        if self.selectedGroupId?.contains("job-consult") == true {
            self.goToUserChatPopupView?.setMessageContent(messageModel: cell.messageModel)
            self.goToUserChatPopupView?.showPopup()
        }
    }

    /*
     * Created by: hoangnn
     * Description: Did tap avatar in left photo message
     */
    func didTapAvatarInLeftPhotoMessageTableViewCell(_ cell: LeftPhotoMessageTableViewCell) {
        self.view.endEditing(true)
        // Only in job room
        if self.selectedGroupId?.contains("job-consult") == true {
            self.goToUserChatPopupView?.setMessageContent(messageModel: cell.messageModel)
            self.goToUserChatPopupView?.showPopup()
        }
    }

    /*
     * Created by: hoangnn
     * Description: Did tap photo in left photo message
     */
    func didTapPhotoInLeftPhotoMessageTableViewCell(_ cell: LeftPhotoMessageTableViewCell) {
        self.previewPhotoFrom(imageView: cell.photoImageView)
        self.view.endEditing(true)
    }

    /*
     * Created by: hoangnn
     * Description: Did tap photo in right photo message
     */
    func didTapPhotoInRightPhotoMessageTableViewCell(_ cell: RightPhotoMessageTableViewCell) {
        self.view.endEditing(true)
        self.previewPhotoFrom(imageView: cell.photoImageView)
    }
    
    func previewPhotoFrom(imageView : UIImageView) {
        let photos = [Photo(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: imageView.image, url: nil)]
        let dataSource = PhotosDataSource(photos: photos, initialPhotoIndex: 0)
        let transitionInfo = TransitionInfo(interactiveDismissalEnabled: true, startingView: imageView) {(photo, index) -> UIImageView? in
            return imageView
        }
        let photosViewController = PhotosViewController(dataSource: dataSource, pagingConfig: nil, transitionInfo: transitionInfo)
        self.present(photosViewController, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate

    /*
     * Created by: hoangnn
     * Description: Did finish picking image from gallery
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageScaled = self.scaleImage(image: self.normalizeImage(image: pickedImage))
            self.confirmImagePopupView?.confirmImageView.image = imageScaled
            self.confirmImagePopupView?.showPopup()
        }

        self.dismiss(animated: true, completion: nil)
    }

    /*
     * Created by: hoangnn
     * Description: Did cancel picking image
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
     * Created by: hoangnn
     * Description: Upload image to server
     */
    func uploadImageToServer(image: UIImage) {
        // Check network
        if Reachability.isConnectedToNetwork() == false {
            GlobalMethod.showAlert("インターネット接続がありません。接続を確認してください。", in: self)
            return
        }

        self.callAPIUploadImageToServer(image: image)
    }

    // MARK: - Call API
    /*
     * Created by: cuongkt
     * Description: Get number of user of building room
     */
    func callAPINumberOfUserInBuilding() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: [String : Any] = [
            "user_id"   : PublicVariables.userInfo.m_id
        ]
        APIBase.shareObject.callAPIGetNumberOfUserByBuilding(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.object(forKey: "body") as? [String:Any] {
                    if let total = body["total"] as? String {
                        self.numberOfUserInBuildingRoom = total
                        self.titleLabel.text = PublicVariables.userInfo.m_kabocha_building_name + " (" + self.numberOfUserInBuildingRoom + ")"
                    }
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    func callAPIGetChatTimeOut() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIGetTimeOutChat(params: nil) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.object(forKey: "body") as? [String: Any] {
                    self.autoReplyMessageContent = body["message"] as? String
                    self.timeOutStartTime = body["start_time"] as? String
                    self.timeOutEndTime = body["end_time"] as? String
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    func callAPIUploadImageToServer(image: UIImage) {
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id
        ]
        let imageParams: [String : UIImage] = [
            "image_path": image
        ]

        APIBase.shareObject.callAPIChatUploadImage(params: params, imageParams: imageParams, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let imageUrl: String = result?.value(forKey: "body") as? String {
                    // Send message
                    self.sendMessageToServer(image: imageUrl, text: nil)
                }
            }
        })
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: backButton action
     */
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)

        // Remove observe
        self.selectedGroupDatabase?.removeAllObservers()
        self.getModifyMessageQuery?.removeAllObservers()
        self.getNewMessageQuery?.removeAllObservers()
        self.getTypingMessageQuery?.removeAllObservers()
        NotificationCenter.default.removeObserver(self)

        // Stop timer
        self.typingTimer?.invalidate()
        self.typingTimer = nil
        self.deleteTypingSignalTimer?.invalidate()
        self.deleteTypingSignalTimer = nil

        self.dismiss(animated: true, completion: nil)
    }

    /*
     * Created by: hoangnn
     * Description: sendPhotoButton action
     */
    @IBAction func sendPhotoButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showActionSheetChooseCameraOrLibrary()
    }

    /*
     * Created by: hoangnn
     * Description: sendButton action
     */
    @IBAction func sendButtonAction(_ sender: UIButton) {
        // Check network
        if Reachability.isConnectedToNetwork() == false {
            GlobalMethod.showAlert("インターネット接続がありません。接続を確認してください。", in: self)
            return
        }

        // Send message
        if self.chatTextView.text != nil && self.chatTextView.text != "" {
            self.sendMessageToServer(image: nil, text: self.chatTextView.text)
        }

        // Reset text field
        self.chatTextView.text = nil
        self.chatTextViewPlaceHolderLabel.isHidden = false
        self.updateHeightForChatTextViewWith(numberLine: 1)

        // Track Repro
        if self.conversationName == NSLocalizedString("ChatViewController_Title_Job", comment: "") {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_JOB, eventName: ReproEvent.REPRO_SCREEN_CHAT_JOB_ACTION_SEND)
        }
        else if self.conversationName == NSLocalizedString("ChatViewController_Title_Living", comment: "") {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE, eventName: ReproEvent.REPRO_SCREEN_CHAT_HOUSE_ACTION_SEND)
        }
    }

    /*
     * Created by: cuongkt
     * Description: delaytimer action
     */
    @objc func delayedAction() {
        self.isTyping = false
        self.typingTimer?.invalidate()
        self.typingTimer = nil
        self.messageTableView.reloadData()
    }

    /*
     * Created by: hoangnn
     * Description: Delete typing signal action
     */
    @objc func deleteTypingSignalAction() {
        self.deleteTypingSignalTimer?.invalidate()
        self.deleteTypingSignalTimer = nil
        self.sendTypingSignalToServer(isDelete: true)
    }

    /*
     * Created by: hoangnn
     * Description: Handle keyboard will change frame
     */
    @objc func handleKeyBoardWillChangeFrame(notification: NSNotification) {
        if let userInfo: Dictionary = notification.userInfo {
            let endFrame: CGRect? = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN: NSNumber? = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw: UInt = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)

            let oldBottomConstraintConstant: CGFloat = self.inputeMessageViewBottomConstraint.constant

            if endFrame?.origin.y != nil {
                // Adjust constraint
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    self.inputeMessageViewBottomConstraint.constant = 0.0
                } else {
                    self.inputeMessageViewBottomConstraint.constant = -(endFrame?.size.height ?? 0.0) + GlobalMethod.getBottomPadding()
                }
            }
            
            // Update message table view content offset
            let adjustHeight: CGFloat = self.messageTableView.contentOffset.y - self.inputeMessageViewBottomConstraint.constant + oldBottomConstraintConstant
            self.messageTableView.setContentOffset(CGPoint(x: 0.0, y: adjustHeight), animated: false)
            
            // Update view
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { 
                self.view.layoutIfNeeded()
            }, completion: { (complete: Bool) in
            })
        }
    }
}

// MARK: - ConfirmImagePopupViewDelegate

extension ChatViewController: ConfirmImagePopupViewDelegate {
    func didConfirmSelectedImage(popup: ConfirmImagePopupVIew, imageSelected: UIImage) {
        self.uploadImageToServer(image: imageSelected)
    }
}
