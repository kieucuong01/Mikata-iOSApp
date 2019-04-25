//
//  PointGetCell.swift
//  SmartTablet
//
//  Created by DELL7447 on 7/12/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
protocol PointGetCellDelegate: class {
    func clickButtonClear(dict : NSDictionary)
}
class PointGetCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var rounderView: UIView!
    @IBOutlet weak var foreground2View: UIView!
    @IBOutlet weak var titleDescribe: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDate: UILabel!

    @IBOutlet weak var titlePoint: UILabel!

    @IBOutlet weak var buttonForeground: UIButton!
    @IBOutlet weak var commentForgound: UILabel!
    @IBOutlet weak var titleForeground: UILabel!
    @IBOutlet weak var foregroundView: UIView!
    @IBOutlet weak var mHeightConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mWidthConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLeadingLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var foregroundButtonTopConstraint: NSLayoutConstraint!
    private var scale = DISPLAY_SCALE
    var delegate : PointGetCellDelegate?
    var dict: NSDictionary = NSDictionary()
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        setConstraintForView()
        setBorderView()
        setFontViews()
        setForeground()
//        setActionForViews()
    }

    private func setConstraintForView() {
        self.mTopLabelConstraint.constant = 6 * scale
        self.mLeadingLabelConstraint.constant = 4 * scale
        self.mHeightConstraintLabelTitle.constant = 20 * scale
        self.foregroundButtonTopConstraint.constant = 14.5 * self.scale
    }

    private func setFontViews() {
        let myString = "7899pt"
        let attribute1: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: primaryColor, NSAttributedStringKey.font: UIFont(name: self.titleLabel.font.fontName, size:14 * scale) as Any]
        let attribute2: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: lightGrayColor, NSAttributedStringKey.font:  UIFont(name: self.titleLabel.font.fontName, size: 10 * scale) as Any]

        let attributeStr = NSMutableAttributedString(string: myString)
        let length = myString.count
        attributeStr.addAttributes(attribute1, range: NSRange(location: 0, length: length - 2))
        attributeStr.addAttributes(attribute2, range: NSRange(location: myString.count - 2, length: 2 ))
        self.titlePoint.attributedText = attributeStr
        // set attributed text on a UILabel
        self.titleDescribe.font = UIFont(name: self.titleDescribe.font.fontName, size: 9 * scale)
        self.titleLabel.font = UIFont(name: self.titleLabel.font.fontName, size: 8 * scale)
        self.titleDate.font = UIFont(name: self.titleDate.font.fontName, size: 8 * scale)
    }

    private func setBorderView() {
        rounderView.layer.cornerRadius = 7 * scale
        rounderView.layer.masksToBounds = true
        rounderView.layer.borderColor = lightGrayColor.cgColor
        rounderView.layer.borderWidth = 0.2
        shadowView.mask = rounderView.mask
    }

    private func setForeground(){
        foregroundView.layer.masksToBounds = true
        foregroundView.layer.cornerRadius = 7 * scale
        self.buttonForeground.layer.cornerRadius = 5.0*scale
        self.buttonForeground.clipsToBounds = true
    }

//    private func setActionForViews(){
//        self.buttonForeground.addTarget(self, action: #selector(buttonForegroundTouchUpInside), for: .touchUpInside)
//    }

    func updateCellFromDict(dict: NSDictionary) {
        self.dict = dict
        let date = Date(timeIntervalSince1970: TimeInterval((dict.object(forKey: "display_end_date") as! NSString).longLongValue))
        let fommater = DateFormatter()
        fommater.dateFormat = "yyyy.MM.ddまで"
        fommater.locale = Locale(identifier: "en_US_POSIX")
        self.titleDate.text = fommater.string(from: date)

        self.titleDescribe.text = dict.object(forKey: "title") as? String

        var point = "0pt"
        if let pointString: String = dict.object(forKey: "point") as? String {
            if let pointInt: Int = Int(pointString) {
                point = pointInt.convertToStringDecimalFormat()  + "pt"
            }
        }

        let attribute1 = [NSAttributedStringKey.foregroundColor: primaryColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14 * scale)]
        let attribute2 = [NSAttributedStringKey.foregroundColor: lightGrayColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10 * scale)]

        let attributeStr = NSMutableAttributedString(string: point)
        let length = point.count
        attributeStr.addAttributes(attribute1, range: NSRange(location: 0, length: length - 2))
        attributeStr.addAttributes(attribute2, range: NSRange(location: point.count - 2, length: 2 ))
        self.titlePoint.attributedText = attributeStr

        if let imageurl = (dict.object(forKey: "image_url") as? String) {
            self.imageAvatar.af_setImage(withURL: URL.init(string: imageurl)!)
        } else {
            self.imageAvatar.image = nil
        }

        let mission_type:Int = (dict.value(forKey: "mission_type") as! NSString).integerValue

        let label = UILabel()
        label.font = self.titleLabel.font

        switch mission_type{
        case 1:
            self.titleLabel.text = NSLocalizedString("get_point_title_site_access", comment: "site access")
            break;
        case 2:
            self.titleLabel.text = NSLocalizedString("get_point_title_questionnaire", comment: "questionnaire")
            break;
        case 3:
            self.titleLabel.text = NSLocalizedString("get_point_title_photo_taking", comment: "photo taking")
            break;
        case 4:
            self.titleLabel.text = NSLocalizedString("get_point_title_site_registration", comment: "site registration")
            break;
        case 9:
            self.titleLabel.text = NSLocalizedString("get_point_title_mission_after_attendance", comment: "after attendance")
            break;
        default:
            self.titleLabel.text = NSLocalizedString("get_point_title_news", comment: "news")
            break;
        }

        let user_point_work_status:Int = (dict.value(forKey: "user_point_work_status") as! NSString).integerValue

        switch user_point_work_status{
        case 99:
            self.foregroundView.isHidden = true
            self.foreground2View.isHidden = true
            break;
        case 1:
            self.commentForgound.isHidden = true
            self.buttonForeground.isHidden = false
            self.buttonForeground.addTarget(self, action: #selector(buttonForegroundTouchUpInside), for: .touchUpInside)
            self.foregroundView.isHidden = false
            self.foreground2View.isHidden = false
            self.titleForeground.text = NSLocalizedString("get_point_clear", comment: "")
            self.buttonForeground.setTitle(NSLocalizedString("get_point_button_clear", comment: ""), for: .normal)
            break;
        case 0:
            self.commentForgound.isHidden = false
            self.buttonForeground.isHidden = true
            self.foregroundView.isHidden = false
            self.foreground2View.isHidden = false
            self.titleForeground.text = NSLocalizedString("get_point_please_wait", comment: "")
            self.commentForgound.text = NSLocalizedString("get_point_comment_please_wait", comment: "")
            break;
        case 3:
            self.commentForgound.isHidden = false
            self.buttonForeground.isHidden = true
            self.foregroundView.isHidden = false
            self.foreground2View.isHidden = false
            self.titleForeground.text = NSLocalizedString("get_point_complete", comment: "")
            self.commentForgound.text = NSLocalizedString("get_point_comment_complete", comment: "")
            break;
        default:
            self.foregroundView.isHidden = true
            self.foreground2View.isHidden = true
            break;
        }

        label.text = self.titleLabel.text
        label.sizeToFit()

        self.layoutIfNeeded()
        self.setNeedsUpdateConstraints()
        self.mHeightConstraintLabelTitle.constant = 20 * self.scale
        self.mWidthConstraintLabelTitle.constant = label.frame.size.width + 10 * self.scale
        
    }

    // MARK ACTION
    @objc func buttonForegroundTouchUpInside(){
        self.delegate?.clickButtonClear(dict: self.dict)
    }
}
