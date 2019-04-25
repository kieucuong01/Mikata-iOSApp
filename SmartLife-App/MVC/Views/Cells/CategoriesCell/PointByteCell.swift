//
//  PointByteCell.swift
//  SmartTablet
//
//  Created by DELL7447 on 7/12/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol PointByteCellCellDelegate:class {
    func clickedFavoritedImageOnPointByteCell(sender: PointByteCell,value: String)
}

class PointByteCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var rounderView: UIView!
    @IBOutlet weak var titleDescribe: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    //Date Title
    @IBOutlet weak var titlePoint: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!

    weak var delegate: PointByteCellCellDelegate? = nil

    private var scale = DISPLAY_SCALE
    var infoItem: NSMutableDictionary = [:]
    var indexPath:IndexPath =  IndexPath()
    var isCallingAPIFavorite: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        setBorderView()
        setFontViews()
    }

    private func setFontViews() {
        self.titlePoint.font = UIFont(name: self.titlePoint.font.fontName, size: 8 * scale)
        // set attributed text on a UILabel
        self.titleDescribe.font = UIFont(name: self.titleDescribe.font.fontName, size: 9 * scale)
    }

    private func setBorderView() {
        rounderView.layer.cornerRadius = 7 * scale
        rounderView.layer.masksToBounds = true

        shadowView.mask = rounderView.mask
    }

    func updateCellFromDict(dict: NSDictionary) {
        // Get dict
        self.infoItem = NSMutableDictionary(dictionary: dict)

        self.titleDescribe.text = dict.object(forKey: "works_tbasicitemp_jobtypedtl") as? String

        //Date Title
        if let strTimeString = dict.object(forKey: "works_updated") as? String {
            let timestamp = Double(strTimeString)
            let date = Date(timeIntervalSince1970: timestamp!)
            let formaterDate = DateFormatter()
            formaterDate.dateFormat = "更新日:yyyy.MM.dd"
            formaterDate.locale = Locale(identifier: "en_US_POSIX")
            self.titlePoint.text = formaterDate.string(from: date)
        } else {
            self.titlePoint.text = "-"
        }

        let imageUrl = dict.object(forKey: "works_image_main") as? String
        self.imageAvatar.setImageForm(urlString: imageUrl, placeHolderImage: nil)

        if let is_favorite = (dict.object(forKey: "is_favorite") as? String) {
            if is_favorite == "1" {
                self.buttonFavorite.isSelected = true
            } else {
                self.buttonFavorite.isSelected = false
            }
        }
    }

    @IBAction func clickedButtonFavorited(_ sender: Any) {
        if self.isCallingAPIFavorite == false {
            if let is_favorite = self.infoItem.object(forKey: "is_favorite") as? String {
                self.callAPIFavoriteBytes(currentFavorite: is_favorite)
            }
        }
    }

    // MARK: - Call API

    func callAPIFavoriteBytes(currentFavorite: String) {
        if let bytesId: String = self.infoItem.object(forKey: "works_id") as? String {
            self.isCallingAPIFavorite = true

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "work_id": bytesId,
                "disable": currentFavorite
            ]

            APIBase.shareObject.callAPIFavoriteBytes(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    var newValue:String = "0"
                    if currentFavorite == "1" {
                        self.buttonFavorite.isSelected = false
                    } else {
                        self.buttonFavorite.isSelected = true
                        newValue = "1"
                    }
                    self.infoItem.setValue(newValue, forKey: "is_favorite")
                    self.delegate?.clickedFavoritedImageOnPointByteCell(sender: self, value: newValue)
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.isCallingAPIFavorite = false
            })
        }
    }
}
