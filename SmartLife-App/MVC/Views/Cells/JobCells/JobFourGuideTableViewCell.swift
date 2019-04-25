//
//  JobFourGuideTableViewCell.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/20/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class JobFourGuideTableViewCell: UITableViewCell {
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var contentTextFieldLeadingConstraint: NSLayoutConstraint!

    // Expand Click
    @IBOutlet weak var fieldContainerView: UIView!
    var fieldContainerTapGesture: UITapGestureRecognizer? = nil

    var scale:CGFloat = DISPLAY_SCALE
    var typeCell: String? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
        self.addTapGestureForTextfieldContainers()
        contentTextView.textColor = UIColor.lightGray
        contentTextView.selectedTextRange = contentTextView.textRange(from: contentTextView.beginningOfDocument, to: contentTextView.beginningOfDocument)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setConstraintForViews() {
        self.mLeadingConstraintLabelTitle.constant = 14.0 * self.scale
        self.contentTextFieldLeadingConstraint.constant = 100.0 * self.scale
    }

    private func setFontForViews() {
        self.mLabelTitle.font = self.mLabelTitle.font.withSize(10.0 * self.scale)
        self.contentTextView.font = self.contentTextView.font?.withSize(12.0 * self.scale)
    }

    func updateDataWithObject(title: String?, content : String?) {
        self.mLabelTitle.text = title
        self.contentTextView.text = content
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldContainerTapGesture {
            self.contentTextView.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Name
        self.fieldContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldContainerView.addGestureRecognizer(self.fieldContainerTapGesture!)
    }
}
