//
//  NotificationCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/20/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var namePost: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblFavorite: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    @IBOutlet weak var mButtonDelete: UIButton!
    
    @IBOutlet weak var viewBackground: UIView!

    var alertCustomView: AlertConfirmCustomView = {
        let view: AlertConfirmCustomView = (Bundle.main.loadNibNamed("AlertConfirmCustomView", owner: self, options: nil))?[0] as! AlertConfirmCustomView
        view.frame = CGRect(x:0 , y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = false
        return view
    }()

    var parentClass: NotificationLineCollectionView? = nil
    var parentTableView: UITableView? = nil
    var cellIndex: IndexPath? = nil
    var noteId: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setPropertiesView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setPropertiesView() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
    
    
    
    func updateCellFromDict(note: NoteObj) {
        self.noteId = note.m_id

        self.namePost.text = note.m_title
        self.lblComment.text = note.m_comment_count
        self.lblFavorite.text = note.m_counts_favorite
        
        let date1 = Date(timeIntervalSince1970: TimeInterval(note.m_created)!)
        let date2 = Date(timeIntervalSince1970: TimeInterval(note.m_time_stamp)!)
        self.lblDateTime.text = self.getDate(fromDate: date1, endDate: date2)

        self.layoutIfNeeded()
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

    // MARK: - Call API

    func callAPIDelete() {
        if self.noteId != nil {
            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "id": self.noteId!
            ]

            if let window: UIWindow = UIApplication.shared.delegate?.window as? UIWindow {
                MBProgressHUD.showAdded(to: window, animated: true)
            }
            APIBase.shareObject.callAPIDeleteNote(params: params, completionHandler: { (result, error) in
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

extension NotificationCell: AlertConfirmCustomViewDelegate {
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
