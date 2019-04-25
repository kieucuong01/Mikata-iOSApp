//
//  RightMessageTableViewCell.swift
//  FamilyApp
//
//  Created by Hoang Nguyen on 12/4/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class RightMessageTableViewCell: UITableViewCell {
    // Subviews
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textContentView: UIView!
    @IBOutlet weak var textContentTextView: UITextView!

    @IBOutlet weak var mConstraintHeightDate: NSLayoutConstraint!
    // Variables
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
        self.configureTextContentTextView()
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
     * Description: Configure textContentTextView
     */
    func configureTextContentTextView() {
        // Set attributes
        self.textContentTextView.isEditable = false
        self.textContentTextView.dataDetectorTypes = .all
        self.textContentTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.textContentTextView.contentInset = UIEdgeInsets.zero
        self.textContentTextView.textContainer.lineFragmentPadding = 0.0
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

            // Set text content
            self.textContentTextView.text = nil
            if messageModel?.contentFile?.isEmpty == false {
                // Default
                let localizedString: NSMutableAttributedString = NSMutableAttributedString(string: (messageModel?.contentFile)!)
                let textRange: NSRange = localizedString.mutableString.range(of: (messageModel?.contentFile)!)
                localizedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15.0), range: textRange)
                localizedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: textRange)
                self.textContentTextView.attributedText = localizedString

                // Get url and file name
                if let fileUrl: URL = URL(string: (messageModel?.contentFile)!) {
                    if let stringAfterRemoveEncoding: String = messageModel?.contentFile?.removingPercentEncoding {
                        let fileName: String? = stringAfterRemoveEncoding.components(separatedBy: "/").last
                        if let fileNameWithoutExtension: String = fileName?.components(separatedBy: "?").first {
                            let localizedStringUrl: NSMutableAttributedString = NSMutableAttributedString(string: fileNameWithoutExtension)
                            let textRangeUrl: NSRange = localizedStringUrl.mutableString.range(of: fileNameWithoutExtension)
                            localizedStringUrl.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15.0), range: textRangeUrl)
                            localizedStringUrl.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: textRangeUrl)
                            localizedStringUrl.addAttribute(NSAttributedStringKey.link, value: fileUrl, range: textRangeUrl)
                            self.textContentTextView.attributedText = localizedStringUrl
                        }
                    }
                }
            }
            else {
                let contentMessage: String = messageModel?.contentMessage ?? ""
                let localizedString: NSMutableAttributedString = NSMutableAttributedString(string: contentMessage)
                let textRange: NSRange = localizedString.mutableString.range(of: contentMessage)
                localizedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15.0), range: textRange)
                localizedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: textRange)
                self.textContentTextView.attributedText = localizedString
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
            self.textContentTextView.text = nil
            self.timeLabel.text = nil
            self.dateLabel.text = nil
            self.readLabel.text = nil
        }

        if self.textContentTextView.text == nil || self.textContentTextView.text == "" {
            self.textContentTextView.text = " "
        }

        self.layoutIfNeeded()
    }
}
