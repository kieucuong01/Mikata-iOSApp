//
//  JobFirstCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class JobSecondCell: UITableViewCell {

    @IBOutlet weak var customSecondview: CustomSecondView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDateFromDictionary(dict:NSDictionary) {
    }
}
