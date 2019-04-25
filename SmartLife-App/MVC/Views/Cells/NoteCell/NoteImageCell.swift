//
//  NoteImageCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/19/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol NoteImageCellDelegate: class {
    func clickedImageCellView(sender:NoteImageCell)
    func didCloseButtonCell(sender:NoteImageCell)
}

class NoteImageCell: UITableViewCell {

    @IBOutlet weak var mViewBackground: UIView!
    @IBOutlet weak var mImageNote: UIImageView!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: NoteImageCellDelegate? = nil
    var indexPath: IndexPath = IndexPath()
    var scale:CGFloat = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setPropertiesForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPropertiesForViews() {
        self.imageLeadingConstraint.constant = 7.0 * self.scale
        self.mViewBackground.layer.borderWidth = 2 * scale
        self.mViewBackground.layer.borderColor = GlobalMethod.hexStringToUIColor(hex: "#FD8688").cgColor
        self.mViewBackground.isHidden = true
    }

    func setImageForCell(image: UIImage?) {
        self.mImageNote.image = image
        if image == nil {
            self.imageWidthConstraint.constant = 0.0
            self.imageHeightConstraint.constant = 0.0
        }
        else {
            let maxWidth: CGFloat = self.frame.size.width - (14.0 * self.scale)
            let minWidth: CGFloat = 120.0
            self.imageWidthConstraint.constant = max(min(image!.size.width, maxWidth), minWidth)
            self.imageHeightConstraint.constant = image!.size.height * self.imageWidthConstraint.constant / image!.size.width
        }
    }

    @IBAction func clickedButtonChooseImage(_ sender: Any) {
        self.delegate?.clickedImageCellView(sender: self)
    }
    
    @IBAction func clickedButtonClose(_ sender: Any) {
        self.delegate?.didCloseButtonCell(sender: self)
    }
}
