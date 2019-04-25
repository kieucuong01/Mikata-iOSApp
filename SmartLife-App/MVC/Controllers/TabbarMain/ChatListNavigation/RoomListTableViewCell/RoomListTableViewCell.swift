//
//  RoomListTableViewCell.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/20/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol RoomListTableViewCellDelegate {
    func didTapChooseInRoomListTableViewCell(_ cell: RoomListTableViewCell)
}

class RoomListTableViewCell: UITableViewCell {
    // Delegate
    var delegate: RoomListTableViewCellDelegate? = nil

    // Subviews
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var leftCornerView: UIView!
    @IBOutlet weak var leftCornerLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // Constraints
    @IBOutlet weak var backgroundContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftCornerLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var midViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var newLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var newLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewWidthConstraint: NSLayoutConstraint!

    // Variables
    var parentVC: ChatListTopViewController? = nil
    var parentTableView: UITableView? = nil
    var cellIndex: IndexPath? = nil
    var roomMessageModel: RoomMessageModel? = nil

    // MARK: - View Lifecycle

    override func awakeFromNib() {
        // Call super
        super.awakeFromNib()

        // Configure self
        self.configureSelf()

        // Configure subviews
        self.configureSubviews()

        // Disable multi touch
        self.enableExclusiveTouchForViewAndSubView()
    }

    // MARK: - Configure View

    /*
     * Created by: hoangnn
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    func configureSubviews() {
        // Configure subviews
        self.configureContainerView()
        self.configureLeftCornerView()
        self.configureAvatarImageView()
        self.configureMidView()
        self.configureRightView()

        // Default value
        self.leftCornerLabel.text = nil
        self.avatarImageView.image = nil
        self.nameLabel.text = nil
        self.newLabelWidthConstraint.constant = 0.0
        self.contentLabel.text = nil
        self.dateLabel.text = nil
    }

    /*
     * Created by: hoangnn
     * Description: Configure containerView
     */
    func configureContainerView() {
        // Update constraints
        self.backgroundContainerViewHeightConstraint.constant = -1.0 * GlobalMethod.displayScale

        // Set attributes for view
        self.backgroundContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.backgroundContainerView.layer.shadowRadius = 2.0 * GlobalMethod.displayScale
        self.backgroundContainerView.layer.shadowOpacity = 0.25
    }

    /*
     * Created by: hoangnn
     * Description: Configure leftCornerView
     */
    func configureLeftCornerView() {
        // Update constraints
        self.leftCornerLabelBottomConstraint.constant = -2.5 * GlobalMethod.displayScale

        // Set attributes
        self.leftCornerView.transform = CGAffineTransform.identity.rotated(by: CGFloat(-Double.pi / 4.0))
        self.leftCornerLabel.font = self.leftCornerLabel.font.withSize(8.5 * GlobalMethod.displayScale)
    }

    /*
     * Created by: hoangnn
     * Description: Configure avatarImageView
     */
    func configureAvatarImageView() {
        // Update constraints
        self.avatarImageViewLeadingConstraint.constant = 13.5 * GlobalMethod.displayScale

        // Set attributes
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2.0
    }

    /*
     * Created by: hoangnn
     * Description: Configure midView
     */
    func configureMidView() {
        self.layoutIfNeeded()

        // Update constraints
        self.midViewLeadingConstraint.constant = 6.0 * GlobalMethod.displayScale
        self.newLabelLeadingConstraint.constant = 4.5 * GlobalMethod.displayScale

        // Set attributes for labels
        self.nameLabel.font = self.nameLabel.font.withSize(12.0 * GlobalMethod.displayScale)
        self.newLabel.font = self.newLabel.font.withSize(8.5 * GlobalMethod.displayScale)
        self.newLabel.layer.cornerRadius = self.newLabel.frame.height/2.0
        self.contentLabel.font = self.contentLabel.font.withSize(10.0 * GlobalMethod.displayScale)
    }

    /*
     * Created by: hoangnn
     * Description: Configure rightView
     */
    func configureRightView() {
        // Update constraints
        self.rightViewTrailingConstraint.constant = -13.5 * GlobalMethod.displayScale
        self.rightViewWidthConstraint.constant = 10.0 * GlobalMethod.displayScale

        // Set attributes for dateLabel
        self.dateLabel.font = self.dateLabel.font.withSize(8.5 * GlobalMethod.displayScale)
    }

    // MARK: - Public Methods

    /*
     * Created by: hoangnn
     * Description: Get date from now
     */
    func getDateFromNow(toTimeStamp timeStamp: Double?) -> String? {
        if timeStamp != nil {
            let startDate = Date(timeIntervalSince1970: (timeStamp! / 1000.0))
            let endDate: Date = Date()

            // Check start and end date
            if startDate <= endDate {
                let calendar = Calendar.current
                let component = calendar.dateComponents([.day,.second] , from: startDate, to: endDate)

                let componentStartDay = calendar.dateComponents([.year, .month, .day], from: startDate)
                let componentEndDay = calendar.dateComponents([.year, .month, .day], from: endDate)

                let formater = DateFormatter()
                formater.dateFormat = "dd MM yyyy hh:mm"
                formater.locale = Locale(identifier: "en_US_POSIX")
                if component.second! < 60 {
                    // Lower than minute
                    return "\(component.second!) 秒前"
                }

                if component.second! < 3600 {
                    // Lower than hour
                    let min = Int(component.second!/60)
                    return "\(min) 分前"
                }

                if component.second! < 86400 {
                    // Lower than day
                    let hour = Int(component.second!/3600)
                    return "\(hour) 時間前"
                }

                if componentStartDay.year! == componentEndDay.year! {
                    if (componentStartDay.month! == componentEndDay.month!) && ((componentEndDay.day! - componentStartDay.day!) <= 7 ) {
                        if (componentEndDay.day! - componentStartDay.day!) == 1 {
                            return "昨日"
                        } else {
                            return "1週間前"
                        }
                    } else {
                        //2008年12月31日
                        return "\(componentStartDay.month!)月\(componentStartDay.day!)日 "
                    }

                } else {
                    return "\(componentStartDay.year!)年\(componentStartDay.month!)月\(componentStartDay.day!)日 "
                }
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }

    /*
     * Created by: hoangnn
     * Description: Check new message
     */
    func checkNewMessage() {
        // Check nil
        if self.roomMessageModel != nil {
            self.contentLabel.textColor = UIColor(red: 123.0/255.0, green: 122.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            self.newLabelWidthConstraint.constant = 0.0
            // Check new message
            if FirebaseGlobalMethod.checkNewMessageInRoom(roomId: self.roomMessageModel?.roomId) == true {
                self.contentLabel.textColor = UIColor.black
                self.newLabelWidthConstraint.constant = 38.5 * GlobalMethod.displayScale
            }
        }
    }

    // MARK: - Update Configure

    /*
     * Created by: hoangnn
     * Description: Update left corner
     */
    func updateLeftCorner() {
        if self.roomMessageModel?.roomId?.contains("building") == true {
            self.leftCornerView.isHidden = true
        }
        else {
            self.leftCornerView.isHidden = false
            if self.roomMessageModel?.isLivingRoom == true {
                self.leftCornerView.backgroundColor = UIColor(red: 245.0/255.0, green: 173.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                self.leftCornerLabel.text = "家"
            }
            else {
                self.leftCornerView.backgroundColor = UIColor(red: 245.0/255.0, green: 173.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                self.leftCornerLabel.text = "仕事"
            }
        }
    }

    /*
     * Created by: hoangnn
     * Description: Update configure when display
     */
    func updateConfigureWhenDisplay() {
        self.layoutIfNeeded()

        // AvatarImageView
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2.0
    }

    /*
     * Created by: hoangnn
     * Description: Update content with model
     */
    func updateContentWithModel() {
        // Check nil
        if self.roomMessageModel != nil {
            // Update information
            if roomMessageModel?.isGetInfomation == false {
                FirebaseGlobalMethod.updateRoomMessageInfomation(roomMessageModel: self.roomMessageModel, completion: {
                    // Update isGetInformation
                    self.roomMessageModel?.isGetInfomation = true
                    self.parentTableView?.checkAndReloadCell(with: self.cellIndex)
                })
                return
            }

            // Update latest message
            if roomMessageModel?.isGetLatestMessage == false {
                FirebaseGlobalMethod.updateRoomMessageLatestMessage(roomMessageModel: self.roomMessageModel, completion: {
                    // Update isGetInformation
                    self.roomMessageModel?.isGetLatestMessage = true
                    self.parentVC?.sortAndReloadListRoomFilter()
                })
                return
            }

            // Update content
            self.isHidden = false
            self.updateLeftCorner()
            if self.roomMessageModel?.roomId?.contains("building") == true {
                self.avatarImageView.image = #imageLiteral(resourceName: "iconGroup")
            }
            else {
                self.avatarImageView.setImageForm(urlString: self.roomMessageModel?.roomAvatar, placeHolderImage: UIImage(named: "NoAvatar"))
            }
            self.nameLabel.text = self.roomMessageModel?.roomName
            self.contentLabel.text = self.roomMessageModel?.roomMessage
            self.dateLabel.text = self.getDateFromNow(toTimeStamp: self.roomMessageModel?.roomLatestMessageTime)

            // Check new message
            self.checkNewMessage()
        }
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: chooseButton action
     */
    @IBAction func chooseButtonAction(_ sender: UIButton) {
        self.endEditing(true)
        self.delegate?.didTapChooseInRoomListTableViewCell(self)
    }
}
