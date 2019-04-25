//
//  RightPhotoMessageTableViewCell.swift
//  FamilyApp
//
//  Created by Hoang Nguyen on 12/4/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol RightPhotoMessageTableViewCellDelegate {
    func didTapPhotoInRightPhotoMessageTableViewCell(_ cell: RightPhotoMessageTableViewCell)
}

class RightPhotoMessageTableViewCell: UITableViewCell {
    // Delegate
    var delegate: RightPhotoMessageTableViewCellDelegate? = nil

    // Subviews
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var textContentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!

    // Constraints
    @IBOutlet weak var mConstraintHeightDate: NSLayoutConstraint!
    @IBOutlet weak var photoImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoImageViewHeightConstraint: NSLayoutConstraint!

    // Gestures
    let choosePhotoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()

    // Variables
    var parentTableView: UITableView? = nil
    var cellIndex: IndexPath? = nil
    var messageModel: MessageModel? = nil

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
        self.backgroundColor = UIColor.clear
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
    }

    /*
     * Created by: hoangnn
     * Description: Configure subviews
     */
    func configureSubviews() {
        // Configure subviews
        self.configureTextContentView()
        self.configurePhotoImageView()

        // Configure gesture
        self.configureChoosePhotoTapGesture()
    }

    /*
     * Created by: hoangnn
     * Description: Configure textContentView
     */
    func configureTextContentView() {
        // Set attributes
        self.textContentView.layer.cornerRadius = 10.0
    }

    /*
     * Created by: hoangnn
     * Description: Configure photoImageView
     */
    func configurePhotoImageView() {
        // Add action
        self.photoImageView.addGestureRecognizer(self.choosePhotoTapGesture)
    }

    // MARK: - Configure Gesture

    /*
     * Created by: hoangnn
     * Description: Configure choosePhotoTapGesture
     */
    func configureChoosePhotoTapGesture() {
        // Add action
        self.choosePhotoTapGesture.addTarget(self, action: #selector(self.handleChoosePhotoTapGesture(_:)))
    }

    // MARK: - Public methods

    /*
     * Created by: hoangnn
     * Description: Update message content
     */
    func setMessageContent(messageModel: MessageModel?) {
        if messageModel != nil {
            // Get model
            self.messageModel = messageModel

            // Set photo image
            if messageModel?.savedImage != nil {
                // Set image
                self.photoImageView.image = messageModel?.savedImage
                
                // Update constraint
                //                if (messageModel?.savedImage?.size.width == 0.0) {
                self.photoImageViewWidthConstraint.constant = 150
                self.photoImageViewHeightConstraint.constant = 150
                //                }
                //                else {
                //                    let imageWidth: CGFloat = (messageModel?.savedImage)!.size.width
                //                    let imageHeight: CGFloat = (messageModel?.savedImage)!.size.height
                //                    var finalImageWidth: CGFloat = min(imageWidth, GlobalMethod.screenSize.width * 0.75)
                //                    finalImageWidth = max(finalImageWidth, 100.0)
                //                    var finalImageHeight: CGFloat = 0.0
                //                    if imageWidth != 0.0 {
                //                        finalImageHeight = finalImageWidth * imageHeight / imageWidth
                //                    }
                //                    self.photoImageViewWidthConstraint.constant = finalImageWidth
                //                    self.photoImageViewHeightConstraint.constant = finalImageHeight
                //                }
            }
            else {
                self.photoImageViewWidthConstraint.constant = 150
                self.photoImageViewHeightConstraint.constant = 150
                self.photoImageView.setImageForm(urlString: messageModel?.contentImage, placeHolderImage: UIImage(named: "NoImage"), completion: {
                    if messageModel?.savedImage == nil {
                        messageModel?.savedImage = self.photoImageView.image
                    }
                })
            }

            // Set time
            self.timeLabel.text = GlobalMethod.getStringDateFromTime(time: messageModel?.time, with: "HH:mm")
            
            // Set date
            self.dateLabel.text = GlobalMethod.getStringDateFromTime(time: messageModel?.time, with: "dd/MM/yyyy")

            // Set isRead
            if messageModel?.isRead == 1 { self.readLabel.text = "既読" }
            else { self.readLabel.text = nil }
        }
        else {
            self.photoImageView.image = nil
            self.timeLabel.text = nil
            self.dateLabel.text = nil
            self.readLabel.text = nil
        }

        self.layoutIfNeeded()
    }

    // MARK: - Selectors

    /*
     * Created by: hoangnn
     * Description: Handle choose photo tap gesture
     */
    @objc func handleChoosePhotoTapGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapPhotoInRightPhotoMessageTableViewCell(self)
    }
}
