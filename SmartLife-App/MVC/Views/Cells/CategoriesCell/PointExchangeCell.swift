//
//  PointExchangeCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/12/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol PointExchangeCellDelegate:class {
    func clickedFavoritedImageOnCell(sender: PointExchangeCell,value:String)
}

class PointExchangeCell: UICollectionViewCell {
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var imageFavoriteOff: UIImageView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var rounderView: UIView!
    @IBOutlet weak var titleDescribe: UILabel!
    @IBOutlet weak var titlePoint: UILabel!
    
    weak var delegate:PointExchangeCellDelegate? = nil
    
    private var currentDict:NSMutableDictionary = NSMutableDictionary()
    private var scale = DISPLAY_SCALE
    var indexPath:IndexPath = IndexPath()
    var isCallingAPIFavorite: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        setBorderView()
        setFontViews()
    }
    
    private func setFontViews() {
        let myString = "7899pt"
        let attribute1: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: primaryColor, NSAttributedStringKey.font: UIFont(name:self.titleDescribe.font.fontName, size: 14 * scale) as Any ]
        let attribute2: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: lightGrayColor, NSAttributedStringKey.font: UIFont(name:self.titleDescribe.font.fontName, size: 10 * scale) as Any]
        
        let attributeStr = NSMutableAttributedString(string: myString)
        let length = myString.count
        attributeStr.addAttributes(attribute1, range: NSRange(location: 0, length: length - 2))
        attributeStr.addAttributes(attribute2, range: NSRange(location: myString.count - 2, length: 2 ))
        
        self.titlePoint.attributedText = attributeStr
        
        // set attributed text on a UILabel
        self.titleDescribe.font = UIFont(name: self.titleDescribe.font.fontName, size: 9 * scale)
        
        self.imageFavoriteOff.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PointExchangeCell.clickedTapButtonImage))
        self.imageFavoriteOff.addGestureRecognizer(tap)
    }
    
    
    private func setBorderView() {
        rounderView.layer.cornerRadius = 7 * scale
        rounderView.layer.masksToBounds = true
        
        shadowView.mask = rounderView.mask
//        shadowView.layer.shadowColor = UIColor.black.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        shadowView.layer.shadowOpacity = 0.5
//        shadowView.layer.shadowRadius = 2.0
//        shadowView.layer.shadowPath = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: 142 * scale, height: 157 * scale), cornerRadius: 14 * scale).cgPath
    }
    
    @objc func clickedTapButtonImage() {
        if self.isCallingAPIFavorite == false {
            if let is_favorite = currentDict.object(forKey: "is_favorite") as? String {
                self.callAPIFavoritePointItem(currentFavorite: is_favorite)
            }
        }
    }
    
    func updateDateFromDict(dict: NSDictionary) {
        currentDict = NSMutableDictionary(dictionary: dict)
        
        self.titleDescribe.frame = CGRect(x: 0, y: 0, width: 130 * scale, height: 24 * scale)
        self.titleDescribe.text = dict.object(forKey: "name") as? String
        self.titleDescribe.sizeToFit()
        
        var point = "0pt"
        if let pointString: String = dict.object(forKey: "point") as? String {
            if let pointInt: Int = Int(pointString) {
                point = pointInt.convertToStringDecimalFormat()  + "pt"
            }
        }

        let attribute1 = [NSAttributedStringKey.foregroundColor: primaryColor, NSAttributedStringKey.font: UIFont(name:self.titleDescribe.font.fontName, size: 14 * scale) ?? UIFont.systemFont(ofSize: 14 * scale)]
        let attribute2 = [NSAttributedStringKey.foregroundColor: lightGrayColor, NSAttributedStringKey.font: UIFont(name:self.titleDescribe.font.fontName, size: 10 * scale) ?? UIFont.systemFont(ofSize: 10 * scale)]
        
        let attributeStr = NSMutableAttributedString(string: point)
        let length = point.count
        attributeStr.addAttributes(attribute1, range: NSRange(location: 0, length: length - 2))
        attributeStr.addAttributes(attribute2, range: NSRange(location: point.count - 2, length: 2 ))
        self.titlePoint.attributedText = attributeStr
        
        if let imageurl = (dict.object(forKey: "image_url") as? String) {
            if GlobalMethod.verifyUrl(urlString: imageurl){
                self.imageAvatar.af_setImage(withURL: URL.init(string: imageurl)!)
            }
        } else {
            self.imageAvatar.image = nil
        }
        if let is_history = (dict.object(forKey: "is_history") as? String){
            if is_history == "1" {
                self.imageFavoriteOff.isHidden = true
            }
            else {
                self.imageFavoriteOff.isHidden = false
            }
        }
        else {
            self.imageFavoriteOff.isHidden = false
        }

        if let is_favorite = (dict.object(forKey: "is_favorite") as? String) {
            if is_favorite == "1" {
                self.imageFavoriteOff.image = #imageLiteral(resourceName: "favorite_on")
            } else {
                self.imageFavoriteOff.image = #imageLiteral(resourceName: "favorite_off")
            }
        }
    }

    // MARK: - Call API

    func callAPIFavoritePointItem(currentFavorite: String) {
        if let pointItemId: String = currentDict.object(forKey: "id") as? String {
            self.isCallingAPIFavorite = true

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "point_item_id": pointItemId,
                "disable": currentFavorite
            ]

            APIBase.shareObject.callAPIFavoritePointItem(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    var newValue:String = "0"
                    if currentFavorite == "1" {
                        self.imageFavoriteOff.image = #imageLiteral(resourceName: "favorite_off")
                    } else {
                        self.imageFavoriteOff.image = #imageLiteral(resourceName: "favorite_on")
                        newValue = "1"
                    }
                    self.currentDict.setValue(newValue, forKey: "is_favorite")
                    self.delegate?.clickedFavoritedImageOnCell(sender: self, value: newValue)
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.isCallingAPIFavorite = false
            })
        }
    }
}
