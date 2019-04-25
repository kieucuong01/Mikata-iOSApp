//
//  NotificationNoteImageCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NotificationNoteImageCell: UITableViewCell {

    @IBOutlet weak var mContainerView: UIView!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mButtonDelete: UIButton!
    @IBOutlet weak var mExampleLabel: UILabel!

    @IBOutlet weak var mContentListView: UIView!
    @IBOutlet weak var mHeightConstraintContentListView: NSLayoutConstraint!
    
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstrainLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintLabelDate: NSLayoutConstraint!
    
    @IBOutlet weak var mWidthConstraintButtonDelete: NSLayoutConstraint!
    @IBOutlet weak var mHeightConstraintButtonDelete: NSLayoutConstraint!

    var alertCustomView: AlertConfirmCustomView = {
        let view: AlertConfirmCustomView = (Bundle.main.loadNibNamed("AlertConfirmCustomView", owner: self, options: nil))?[0] as! AlertConfirmCustomView
        view.frame = CGRect(x:0 , y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = false
        return view
    }()

    var parentClass: NotificationLineCollectionView? = nil
    var parentTableView: UITableView? = nil
    var cellIndex: IndexPath? = nil
    var commentId: String? = nil

    var currentContentHeight: CGFloat = 0.0
    
    var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        self.setConstraintForViews()
        self.setFontForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraintForViews() {
        self.mTopConstraintLabelTitle.constant = 10
        self.mLeadingConstrainLabelTitle.constant = 14 * scale
        self.mTrailingConstraintLabelDate.constant = 7 * scale
        
        self.mWidthConstraintButtonDelete.constant = 40 * scale
        self.mHeightConstraintButtonDelete.constant = 40 * scale

        // Set border
        self.mContainerView.layer.cornerRadius = 10.0 * scale
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scale)
        self.mLabelDate.font = UIFont(name: self.mLabelTitle.font.fontName, size: 9 * scale)
        self.mExampleLabel.font = UIFont(name: self.mLabelTitle.font.fontName, size: 12 * scale)
    }

    @IBAction func clickedButtonDelete(_ sender: Any) {
        let dict:[String:String] = ["lbl_confirm_title": NSLocalizedString("alert_view_delete_note_label_confirm", comment: "label for confirm title alert when delete"),
                                    "lbl_button_decline": NSLocalizedString("alert_view_delete_note_button_decline", comment: "label for button decline"),
                                    "lbl_button_accept": NSLocalizedString("alert_view_delete_note_button_accept", comment: "label for button accept"),
                                    "lbl_success_title": NSLocalizedString("alert_view_delete_note_label_success", comment: "label for success title alert when complete"),
                                    "lbl_button_success": NSLocalizedString("alert_view_delete_note_button_success", comment: "label for button accept")]
        self.alertCustomView.updateAlertViewWithDict(dict: dict)
        if let window: UIWindow = UIApplication.shared.delegate?.window as? UIWindow {
            window.addSubview(self.alertCustomView)
            self.alertCustomView.delegate = self
        }
    }

    // Public methods

    func updateCellFromDict(note: NoteObj, indexPath: IndexPath) {
        self.commentId = note.m_id

        // Title
        var idString: String = ((indexPath.row + 1) < 9999 ? String(indexPath.row + 1) : "9999")
        while idString.count < 4 {
            idString = "0" + idString
        }
        self.mLabelTitle.text = idString

        // Date
        let date1 = Date(timeIntervalSince1970: TimeInterval(note.m_created)!)
        let date2 = Date(timeIntervalSince1970: TimeInterval(note.m_time_stamp)!)
        self.mLabelDate.text = self.getDate(fromDate: date1, endDate: date2)

        // Comment
        self.addCommentFromDict(note: note)
        
        self.layoutIfNeeded()
    }

    func addCommentFromDict(note: NoteObj) {
        // Remove old content
        for subview in self.mContentListView.subviews {
            subview.removeFromSuperview()
        }
        self.currentContentHeight = 0.0

        // Add new content
        for comment in note.m_list_note_comment_content {
            self.addCommentContent(commentObj: comment)
        }

        // Update constraint
        self.mHeightConstraintContentListView.constant = self.currentContentHeight
    }

    func addCommentContent(commentObj: NoteCommentContentObj) {
        // Add subview label
        let labelView: UILabel = self.newLabelFromText(commentObj: commentObj)
        self.mContentListView.addSubview(labelView)

        // Add subview image
        let imageView: UIImageView = self.newImageFromImage(commentObj: commentObj)
        self.mContentListView.addSubview(imageView)
    }

    private func newLabelFromText(commentObj: NoteCommentContentObj) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0.0, y: self.currentContentHeight + 10.0, width: self.mContentListView.frame.size.width, height: 0.0))
        label.backgroundColor = UIColor.clear
        label.font = self.mExampleLabel.font
        label.text = commentObj.m_content
        label.numberOfLines = 0
        label.textColor = self.mExampleLabel.textColor
        label.sizeToFit()

        // Update current height
        if label.frame.size.height > 0.0 {
            self.currentContentHeight = self.currentContentHeight + 10.0 + label.frame.size.height
        }

        return label
    }

    private func newImageFromImage(commentObj: NoteCommentContentObj) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0.0, y: self.currentContentHeight + 10.0, width: self.mContentListView.frame.size.width, height: 100.0)

        // Set frame
        if commentObj.m_image_size == nil || commentObj.m_image_size == CGSize.zero {
            imageView.frame = CGRect(x: 0.0, y: self.currentContentHeight + 10.0, width: self.mContentListView.frame.size.width, height: 0.0)
        }
        else {
            let maxWidth: CGFloat = self.mContentListView.frame.size.width
            let imageWidthNew: CGFloat = min(commentObj.m_image_size!.width, maxWidth)
            let imageHeightNew: CGFloat = commentObj.m_image_size!.height * imageWidthNew / commentObj.m_image_size!.width
            imageView.frame = CGRect(x: 0.0, y: self.currentContentHeight + 10.0, width: imageWidthNew, height: imageHeightNew)
        }

        // Load image
        imageView.setImageForm(urlString: commentObj.m_image_path, placeHolderImage: nil, completion: {
            if imageView.image != nil && commentObj.m_image_size == nil {
                commentObj.m_image_size = (imageView.image?.size != nil ? imageView.image?.size : CGSize.zero)
                self.parentTableView?.checkAndReloadCell(with: self.cellIndex)
            }
        })

        // Update current height
        if imageView.frame.size.height > 0.0 {
            self.currentContentHeight = self.currentContentHeight + 10.0 + imageView.frame.size.height
        }

        return imageView
    }

    func getDate(fromDate startDate:Date , endDate:Date) -> String{
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

    // MARK: - Call API

    func callAPIDelete() {
        if self.commentId != nil {
            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "id": self.commentId!
            ]

            if let window: UIWindow = UIApplication.shared.delegate?.window as? UIWindow {
                MBProgressHUD.showAdded(to: window, animated: true)
            }
            APIBase.shareObject.callAPIDeleteNoteComment(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let window: UIWindow = UIApplication.shared.delegate?.window as? UIWindow {
                        window.addSubview(self.alertCustomView)
                        if self.cellIndex != nil {
                            self.parentClass?.arrayPostInNoteItems.remove(at: self.cellIndex!.row)
                            self.parentTableView?.reloadData()
                        }
                    }
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                if let window: UIWindow = UIApplication.shared.delegate?.window as? UIWindow {
                    MBProgressHUD.hide(for: window, animated: true)
                }
            })
        }
    }
}

extension NotificationNoteImageCell: AlertConfirmCustomViewDelegate {
    func callbackActionClickedButtonAccept() {
        self.alertCustomView.isHidden = false
        self.alertCustomView.removeFromSuperview()
        self.callAPIDelete()
    }

    func callbackActionClickedButtonDecline() {
        self.alertCustomView.isHidden = false
        self.alertCustomView.removeFromSuperview()
    }

    func callbackActionClickedButtonSuccess() {
        self.alertCustomView.isHidden = false
        self.alertCustomView.removeFromSuperview()
    }
}
