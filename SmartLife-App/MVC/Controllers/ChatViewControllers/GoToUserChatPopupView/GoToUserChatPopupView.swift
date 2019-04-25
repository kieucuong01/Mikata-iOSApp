//
//  GoToUserChatPopupView.swift
//  SmartLife-App
//
//  Created by Ghost on 10/24/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol GoToUserChatPopupViewDelegate: class {
    func didChooseGoToUserChat(popup: GoToUserChatPopupView)
}

class GoToUserChatPopupView: UIView {
    // Delegate
    weak var delegate: GoToUserChatPopupViewDelegate? = nil

    // Subviews
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goToUserChatlButton: UIButton!

    // Variables
    var parentView: UIView? = nil
    var frameCurrent: CGRect = CGRect.zero
    var messageModel: MessageModel? = nil

    // MARK: - View Lifecycle

    override init(frame: CGRect) {
        self.frameCurrent = frame
        self.frameCurrent.origin = CGPoint.zero

        // Call super
        super.init(frame: frame)

        // Configure self
        self.configureSelf()

        // Configure subviews
        self.configureSubviews()

        // Disable multi touch
        self.enableExclusiveTouchForViewAndSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self
        Bundle.main.loadNibNamed(String(describing: GoToUserChatPopupView.self), owner: self, options: nil)
        self.addSubview(self.mainView)
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    func configureSubviews() {
        // Configure subviews
        self.configureMainView()
        self.configureContainerView()
        self.configureAvatarImageView()
        self.configureNameLabel()
        self.configureGoToUserChatlButton()
    }

    /*
     * Created by: hoangnn
     * Description: Configure mainView
     */
    func configureMainView() {
        // Set attributes
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.backgroundColor = UIColor(white: 0.0, alpha: 0.55)

        // Init constraints
        let centerXConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.centerX,
                                                                       relatedBy: NSLayoutRelation.equal,
                                                                       toItem: self, attribute: NSLayoutAttribute.centerX,
                                                                       multiplier: 1.0, constant: 0.0)
        let centerYConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.centerY,
                                                                       relatedBy: NSLayoutRelation.equal,
                                                                       toItem: self, attribute: NSLayoutAttribute.centerY,
                                                                       multiplier: 1.0, constant: 0.0)
        let widthConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.width,
                                                                     relatedBy: NSLayoutRelation.equal,
                                                                     toItem: self, attribute: NSLayoutAttribute.width,
                                                                     multiplier: 1.0, constant: 0.0)
        let heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.mainView, attribute: NSLayoutAttribute.height,
                                                                      relatedBy: NSLayoutRelation.equal,
                                                                      toItem: self, attribute: NSLayoutAttribute.height,
                                                                      multiplier: 1.0, constant: 0.0)

        // Add constraints
        self.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }

    /*
     * Created by: hoangnn
     * Description: Configure containerView
     */
    func configureContainerView() {
        // Set attributes
        self.containerView.backgroundColor = UIColor.white
    }

    /*
     * Created by: hoangnn
     * Description: Configure avatarImageView
     */
    func configureAvatarImageView() {
        // Set attributes
        self.layoutIfNeeded()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0
    }

    /*
     * Created by: hoangnn
     * Description: Configure nameLabel
     */
    func configureNameLabel() {
        // Set attributes
        self.nameLabel.font = self.nameLabel.font.withSize(15.5 * GlobalMethod.displayScale)
    }

    /*
     * Created by: hoangnn
     * Description: Configure goToUserChatlButton
     */
    func configureGoToUserChatlButton() {
        // Set attributes
        self.goToUserChatlButton.titleLabel?.font = self.goToUserChatlButton.titleLabel?.font.withSize(13.5 * GlobalMethod.displayScale)
        self.goToUserChatlButton.layer.cornerRadius = 3.0
    }

    // MARK: - Public Methods

    /*
     * Created by: hoangnn
     * Description: Show popup
     */
    func showPopup() {
        // Show popup
        if self.messageModel?.userId != nil && self.messageModel?.userId != "" {
            self.parentView?.addSubview(self)

            // Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POPUP_USER, eventName: nil)
        }
    }

    /*
     * Created by: hoangnn
     * Description: Update message content
     */
    func setMessageContent(messageModel: MessageModel?) {
        if messageModel != nil {
            // Get model
            self.messageModel = messageModel

            // Set image
            self.avatarImageView.setImageForm(urlString: messageModel?.avatarImage, placeHolderImage: UIImage(named: "NoAvatar"))

            // Set user name
            self.nameLabel.text = messageModel?.userName
        }
        
        self.layoutIfNeeded()
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: CancelButton action
     */
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }

    /*
     * Created by: hoangnn
     * Description: CancelButton action
     */
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }

    /*
     * Created by: hoangnn
     * Description: GoToUserChatlButton action
     */
    @IBAction func goToUserChatlButtonAction(_ sender: UIButton) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POPUP_USER, eventName: ReproEvent.REPRO_SCREEN_POPUP_USER_ACTION_SEND_MESSAGE)

        self.removeFromSuperview()
        self.delegate?.didChooseGoToUserChat(popup: self)
    }
}
