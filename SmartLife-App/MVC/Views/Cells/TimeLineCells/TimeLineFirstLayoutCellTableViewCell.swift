//
//  TimeLineFirstLayoutCellTableViewCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol TimeLineFirstLayoutCellTableViewCellDelegate:class {
    func clickedFavoritedImageOnCell(sender: TimeLineFirstLayoutCellTableViewCell,value: String)
    func clickedLoadMore(sender: TimeLineFirstLayoutCellTableViewCell,heightAdditionalText : CGFloat?)
}

class TimeLineFirstLayoutCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var mHeightConstraintbutton: NSLayoutConstraint!
    @IBOutlet weak var mHeightImageConstraintAvatar: NSLayoutConstraint!
    
    @IBOutlet weak var mButtonFavorite: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var mButtonGoDetail: UIButton!
    @IBOutlet weak var mButtonGoDetailImageView: UIImageView!
    @IBOutlet weak var mLblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var lblConvertPoint: UILabel!
    private var scale:CGFloat = DISPLAY_SCALE
    var parentVC: UIViewController? = nil
    var parentTableView: UITableView? = nil
    var indexPath:IndexPath = IndexPath()
    var timeLineObj: TimeLineObject? = nil

    weak var delegate: TimeLineFirstLayoutCellTableViewCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        updateFontLabel()
        viewBackground.layer.masksToBounds = false
        viewBackground.layer.shadowColor = UIColor.black.cgColor
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewBackground.layer.shadowOpacity = 0.5
        viewBackground.layer.shadowRadius = 1.0
        
        // ContentTextView
        self.contentTextView.isEditable = false
        self.contentTextView.isSelectable = true
        self.contentTextView.dataDetectorTypes = .all
        self.contentTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.contentTextView.contentInset = UIEdgeInsets.zero
        self.contentTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func updateFontLabel() {
        lblConvertPoint.font = UIFont.boldSystemFont(ofSize: 9 * scale)
        contentTextView.font = UIFont(name: contentTextView.font!.fontName, size: 12 * scale)
        lblDate.font = UIFont(name: lblDate.font!.fontName, size: 12 * scale)
        mLblTitle.font = UIFont(name: mLblTitle.font!.fontName, size: 14 * scale)
        mButtonGoDetail.setTitle(NSLocalizedString("timeline_button_title_go_detail", comment: ""), for: .normal)
        mButtonGoDetail.titleLabel?.font =  UIFont(name: mButtonGoDetail.titleLabel!.font!.fontName, size: 12 * scale)
    }
    
    func updateDataFromDict(timeLineObject: TimeLineObject?) {
        // Update obj
        self.timeLineObj = timeLineObject
        
        if timeLineObject != nil {
            // Name
            self.mLblTitle.text = timeLineObject?.name
            // Content
            self.contentTextView.textContainer.maximumNumberOfLines = timeLineObject!.numberContentLineShow
            self.contentTextView.text = timeLineObject?.descriptionTimeLineHTMLString
            
            // Date
            if let time:Double = Double(timeLineObject!.display_end_date) {
                let date = Date(timeIntervalSince1970:time)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                self.lblDate.text = dateFormatter.string(from: date)
            }
            
            // Set favorite
            if timeLineObject?.is_favorite == "1" {
                self.mButtonFavorite.isSelected = true
            } else {
                self.mButtonFavorite.isSelected = false
            }
            self.layoutIfNeeded()
            
            // Button load more
            let heightOfText: CGFloat? = timeLineObject?.descriptionTimeLineHTMLString.height(withConstrainedWidth: 0.90*SIZE_WIDTH, font: self.contentTextView.font!)
            let heightOfTitleText: CGFloat? = self.timeLineObj?.name.height(withConstrainedWidth: 0.90*SIZE_WIDTH, font: self.mLblTitle.font!)
            
            if heightOfText == nil || (heightOfText! + heightOfTitleText!) <= (30.0 * self.scale) {
                self.mButtonGoDetail.isHidden = true
                self.mButtonGoDetailImageView.isHidden = true
                self.mHeightConstraintbutton.constant = 35.0 * self.scale
                self.timeLineObj?.numberContentLineShow = 0
            }
            else {
                self.mButtonGoDetail.isHidden = false
                self.mButtonGoDetailImageView.isHidden = false
                self.mHeightConstraintbutton.constant = 35.0 * self.scale
            }
            
            if timeLineObject?.numberContentLineShow == 0 {
                self.mButtonGoDetail.isHidden = true
                self.mButtonGoDetailImageView.isHidden = true
            }
            else {
                self.mButtonGoDetail.setTitle(NSLocalizedString("timeline_button_title_go_detail", comment: ""), for: .normal)
                self.mButtonGoDetailImageView.image = UIImage(named: "img_to_bottom")
            }
            
            self.layoutIfNeeded()
            self.updateConstraintsIfNeeded()
        }
    }
    
    @IBAction func clickedButtonShowMore(_ sender: Any) {
        // Update object
        // If post have not loaded
        if self.timeLineObj?.numberContentLineShow == 1 {
            self.timeLineObj?.numberContentLineShow = 0
            // Button load more
            let heightOfTitleText: CGFloat? = 50 * scale
            // Caculate content height
            let componentOccurrenciesOfNewLine : [String]? = self.timeLineObj?.descriptionTimeLineHTMLString.components(separatedBy: "\n")
            var heightOfContentText: CGFloat = 0
            for paragraph in componentOccurrenciesOfNewLine! {
                heightOfContentText += paragraph.height(withConstrainedWidth: 0.9*SIZE_WIDTH, font: contentTextView.font!) + 5.5 * scale
            }
            let totalHeight : CGFloat = heightOfTitleText! + heightOfContentText - 20 * scale
            
            // make title mutiple line
            self.mLblTitle.numberOfLines = 0
            // Content
            self.contentTextView.textContainer.maximumNumberOfLines = 0
            
            // hide loadmore button
            self.mButtonGoDetail.isHidden = true
            self.mButtonGoDetailImageView.isHidden = true
            
            self.layoutIfNeeded()
            self.delegate?.clickedLoadMore(sender: self, heightAdditionalText: totalHeight)
        }
    }
    
    @IBAction func clickedButtonFavorited(_ sender: Any) {
        self.callAPIFavoriteNews()
    }
    
    // MARK: - Call API
    
    func callAPIFavoriteNews() {
        let params: [String : String] = [
            "timeline_id": (self.timeLineObj?.id)!
        ]
        APIBase.shareObject.callAPIFavoriteTimeLine(params: params, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                var newValue:String = "0"
                if self.timeLineObj?.is_favorite == "1" {
                    self.mButtonFavorite.isSelected = false
                } else {
                    self.mButtonFavorite.isSelected = true
                    newValue = "1"
                }
                self.timeLineObj?.is_favorite = newValue
                self.delegate?.clickedFavoritedImageOnCell(sender: self, value: newValue)
            }
            else {
                APIBase.shareObject.showAPIError(result: result)
            }
        })
    }
}

