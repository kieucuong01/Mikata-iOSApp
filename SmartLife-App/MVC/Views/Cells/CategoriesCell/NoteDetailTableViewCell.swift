//
//  NoteDetailTableViewCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/13/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import SnapKit

protocol NoteDetailTableViewCellDelegate: class {
    func didDownloadedImage(sender: NoteDetailTableViewCell, newImage: UIImage?, contentIndex: Int)
}

class NoteDetailTableViewCell: UITableViewCell {
    weak var delegate: NoteDetailTableViewCellDelegate? = nil

    private var mLabelTitle:UILabel = {
        let scale: CGFloat = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel(frame: CGRect(x: 14 * scale, y: 14 * scale, width: 200 * scale, height: 14 * scale ))
        label.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
        label.textColor = GlobalMethod.hexStringToUIColor(hex: "#6C5032")
        label.numberOfLines = 0
        return label
    }()

    private var mLabelDate: UILabel = {
        let scale: CGFloat = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel(frame: CGRect(x: 60 * scale, y: 18 * scale, width: 32 * scale, height: 14 * scale ))
        label.font = UIFont(name: "YuGo-Medium", size: 8 * scale)
        label.textColor = GlobalMethod.hexStringToUIColor(hex: "#6C5032")
        return label
    }()

    private var mViewContentList: UIView = {
        let scale: CGFloat = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view = UIView(frame: CGRect(x: 14 * scale, y: 24 * scale, width: 292 * scale, height: 0 * scale ))
        return view
    }()

    private var mButtonImage: UIButton = {
        let scale: CGFloat = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let button = UIButton()
        let image = #imageLiteral(resourceName: "rectangleBodder").resizableImage(withCapInsets: UIEdgeInsetsMake(10, 10, 10, 10))
        button.setBackgroundImage(image, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.isEnabled = false
        return button
    }()

    var scaleDisplay:CGFloat = DISPLAY_SCALE
    var indexPath: IndexPath? = nil

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        scaleDisplay = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 70 * scaleDisplay)
        self.createSubviews()
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func createSubviews() {
        self.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "FFF6F0")

        self.contentView.addSubview(mButtonImage)
        mButtonImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-8 * scaleDisplay)
        }
        self.addSubview(self.mLabelTitle)
        self.addSubview(self.mLabelDate)
        self.addSubview(self.mViewContentList)
    }

    private func newLabelFromText(text:String,curY:CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: curY , width: 292 * scaleDisplay, height: 14 * scaleDisplay ))
        label.font = UIFont(name: "YuGo-Medium", size: 14 * scaleDisplay)
        label.text = text
        label.numberOfLines = 0
        label.textColor = GlobalMethod.hexStringToUIColor(hex: "#6C5032")
        label.sizeToFit()
        return label
    }


    func updateCellWithData(indexPath: IndexPath, commentDetail: NSDictionary, listContentImageSize: [String: CGSize]) {
        for subview in self.mViewContentList.subviews {
            subview.removeFromSuperview()
        }

        // Title
        var idString: String = ((indexPath.row + 1) < 9999 ? String(indexPath.row + 1) : "9999")
        while idString.count < 4 {
            idString = "0" + idString
        }
        self.mLabelTitle.text = idString
        self.mLabelTitle.sizeToFit()

        // Date
        self.mLabelDate.text = "-"
        let createdString: String? = commentDetail.object(forKey: "created") as? String
        let timestampString: String? = commentDetail.object(forKey: "time_stamp") as? String
        if createdString != nil && timestampString != nil && TimeInterval(createdString!) != nil && TimeInterval(timestampString!) != nil {
            let createdDate: Date = Date(timeIntervalSince1970: TimeInterval(createdString!)!)
            let timestampDate: Date = Date(timeIntervalSince1970: TimeInterval(timestampString!)!)
            self.mLabelDate.text = self.getDate(fromDate: createdDate, endDate: timestampDate)
        }
        self.mLabelDate.sizeToFit()

        var frame = self.mLabelDate.frame
        frame.origin.x = self.mLabelTitle.frame.maxX + 7 * scaleDisplay
        self.mLabelDate.frame = frame

        // List content
        var listContent: [NSDictionary] = []
        if let listContentFromComment: [NSDictionary] = commentDetail.object(forKey: "content") as? [NSDictionary] {
            listContent = listContentFromComment
        }

        var curY:CGFloat = 0

        var contentIndex: Int = -1
        for content in listContent {
            contentIndex = contentIndex + 1

            // Content
            if let text = content.object(forKey: "content") as? String {
                let label = self.newLabelFromText(text: text, curY: curY)
                curY = label.frame.size.height + curY + 7 * scaleDisplay
                self.mViewContentList.addSubview(label)
            }

            // Image
            let imageSize: CGSize? = listContentImageSize["index" + String(contentIndex)]
            let imagePath: String? = content.object(forKey: "image_path") as? String
            let imageView = UIImageView()
            if imageSize == nil || imageSize == CGSize.zero {
                imageView.frame = CGRect(x:0, y: curY, width: 292 * scaleDisplay, height: 0.0)
            }
            else {
                let maxWidth: CGFloat = 292 * scaleDisplay
                let imageWidthNew: CGFloat = min(imageSize!.width, maxWidth)
                let imageHeightNew: CGFloat = imageSize!.height * imageWidthNew / imageSize!.width
                imageView.frame = CGRect(x: 0.0, y: curY, width: imageWidthNew, height: imageHeightNew)
            }
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.setImageForm(urlString: imagePath, placeHolderImage: nil, completion: {
                if imageView.image != nil && imageSize == nil {
                    self.delegate?.didDownloadedImage(sender: self, newImage: imageView.image, contentIndex: contentIndex)
                }
            })
            curY = curY + imageView.frame.size.height + 7 * scaleDisplay
            self.mViewContentList.addSubview(imageView)
        }

        frame = self.mViewContentList.frame
        frame.size.height = curY
        frame.origin.y = self.mLabelTitle.frame.maxY + 7 * scaleDisplay
        self.mViewContentList.frame = frame
    }
    
    func getDate(fromDate startDate: Date ,endDate: Date) -> String{
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day,.second] , from: startDate, to: endDate)

        let componentStartDay = calendar.dateComponents([.year, .month, .day], from: startDate)
        let componentEndDay = calendar.dateComponents([.year, .month, .day], from: endDate)

        let formater = DateFormatter()
        formater.dateFormat = "dd MM yyyy hh:mm"
        formater.locale = Locale(identifier: "en_US_POSIX")
        if component.second! < 60 {
            // Lower than minute
            return "\(component.second!) 秒前"
        }

        if component.second! < 3600 {
            // Lower than hour
            let min = Int(component.second!/60)
            return "\(min) 分前"
        }

        if component.second! < 86400 {
            // Lower than day
            let hour = Int(component.second!/3600)
            return "\(hour) 時間前"
        }

        if componentStartDay.year! == componentEndDay.year! {
            if (componentStartDay.month! == componentEndDay.month!) &&
                ((componentEndDay.day! - componentStartDay.day!) <= 7 ) {
                if (componentEndDay.day! - componentStartDay.day!) == 1 {
                    return "昨日"
                } else {
                    return "1週間前"
                }
            } else {
                //2008年12月31日
                return "\(componentStartDay.month!)月\(componentStartDay.day!)日 "
            }

        } else {
            return "\(componentStartDay.year!)年\(componentStartDay.month!)月\(componentStartDay.day!)日 "
        }
    }
}
