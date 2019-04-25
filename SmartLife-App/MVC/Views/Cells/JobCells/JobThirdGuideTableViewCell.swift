//
//  JobThirdGuideTableViewCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol JobThirdGuideTableViewCellDelegate {
    func handleTextFieldChanged(sender: UITextField)
}

class JobThirdGuideTableViewCell: UITableViewCell {
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var contentTextField: UITextField!

    @IBOutlet weak var mLeadingConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var contentTextFieldLeadingConstraint: NSLayoutConstraint!

    // Expand Click
    @IBOutlet weak var fieldContainerView: UIView!
    var fieldContainerTapGesture: UITapGestureRecognizer? = nil

    var delegate : JobThirdGuideTableViewCellDelegate?
    var scale:CGFloat = DISPLAY_SCALE
    var typeCell: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
        self.addTapGestureForTextfieldContainers()
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
        self.contentTextField.font = self.contentTextField.font?.withSize(12.0 * self.scale)
    }
    
    func updateDataWithObject(title: String?, content : String?) {
        self.mLabelTitle.text = title
        self.contentTextField.text = content
    }

    // MARK: - Add Gesture For ContainerViews

    @objc func handleContainerTapGesture(recognize: UITapGestureRecognizer) {
        if recognize == self.fieldContainerTapGesture {
            self.contentTextField.becomeFirstResponder()
        }
    }

    func addTapGestureForTextfieldContainers() {
        // Name
        self.fieldContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleContainerTapGesture(recognize:)))
        self.fieldContainerView.addGestureRecognizer(self.fieldContainerTapGesture!)
    }

    // MARK: - Handle TextField

    @IBAction func handleTextFieldChanged(_ sender: UITextField) {
        self.delegate?.handleTextFieldChanged(sender: sender)
    }
}
