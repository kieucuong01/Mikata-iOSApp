//
//  ChatUserTableCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/26/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ChatUserTableCell: UITableViewCell {
    
    @IBOutlet weak var mLabelChat: UILabel!
    @IBOutlet weak var mImageViewChat: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setPropertiesForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setPropertiesForViews() {
        self.mImageViewChat.image = #imageLiteral(resourceName: "img_background_chat_house").resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
    }
}
