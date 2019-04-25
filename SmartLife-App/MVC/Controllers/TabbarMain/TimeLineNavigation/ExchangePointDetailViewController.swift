//
//  ExchangePointDetailViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/1/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ExchangePointDetailViewController: BaseViewController {

    @IBOutlet weak var mLabelStatusMessage: UILabel!
    @IBOutlet weak var mLabelTitleNav: UILabel!
    
    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelPoint: UILabel!
    
    @IBOutlet weak var mLabelTitleContent: UILabel!
    @IBOutlet weak var mLabelDescription: UILabel!
    
    
    @IBOutlet weak var mButtonNext: UIButton!
    @IBOutlet weak var mButtonFavorite: UIButton!
    
    @IBOutlet weak var mConstraintLeadingLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopLabelPoint: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopTitleContent: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopLabelDescription: NSLayoutConstraint!
    @IBOutlet weak var mConstraintBottomViewContent: NSLayoutConstraint!

    var statusMessageString:String = ""
    var point:Int = 0
    var infoItem: NSMutableDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.callAPIGetPointItemDetailExchange()
        self.setLanguageForView()
        self.setConstraintForViews()
        self.setVariablesForViews()
        self.setFontForViews()


        NotificationCenter.default.addObserver(self, selector: #selector(ExchangePointDetailViewController.updateVariableContent(notification:)), name: NSNotification.Name("ExchangeVCUpdateContent"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL, eventName: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Getter
    private func setLanguageForView(){
        self.mLabelTitleNav.text = NSLocalizedString("exchangepointdetailview_navbar", comment: "")
        self.mLabelTitleContent.text = NSLocalizedString("exchangepointdetailview_label_titlecontent", comment: "")
        self.mButtonNext.setTitle(NSLocalizedString("exchangepointdetailview_button_next", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        self.mConstraintBottomViewContent.constant = 34 * scaleDisplay
        self.mConstraintLeadingLabelTitle.constant = 14 * scaleDisplay
        self.mConstraintTopLabelTitle.constant = 8 * scaleDisplay
        self.mConstraintTopLabelPoint.constant = 11 * scaleDisplay
        self.mConstraintTopTitleContent.constant = 25 * scaleDisplay
        self.mConstraintTopLabelDescription.constant = 8 * scaleDisplay
    }

    @objc func updateVariableContent(notification: Notification) {
        if let dict: NSMutableDictionary = notification.object as? NSMutableDictionary {
            self.infoItem = dict
        }
    }
    
    private func setVariablesForViews() {
        self.mLabelTitle.text = infoItem.value(forKey: "name") as? String
        self.mLabelDescription.text = infoItem.value(forKey: "description") as? String

        point = 0
        if let pointString: NSString = infoItem.object(forKey: "point") as? NSString {
            point = pointString.integerValue
        }

        let urlString: String? = infoItem.value(forKey: "image_url") as? String
        self.mImageView.setImageForm(urlString: urlString, placeHolderImage: nil)

        self.mImageView.setImageForm(urlString: urlString, placeHolderImage: nil, completion: {
            self.view.layoutIfNeeded()
            if (self.mImageView.image?.size == nil) || (self.mImageView.image?.size == CGSize.zero) || (self.mImageView.image?.size.width == 0.0) {
                self.mImageViewHeightConstraint.constant = 8.0 * GlobalMethod.displayScale
            }
            else {
                let ratioHeightImageSize: CGFloat = (self.mImageView.image?.size)!.height / (self.mImageView.image?.size)!.width
                self.mImageViewHeightConstraint.constant = self.mImageView.frame.size.width * ratioHeightImageSize
            }
        })

        let is_favorite = infoItem.value(forKey: "is_favorite") as? String
        if is_favorite != "1" {
            self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_off"), for: .normal)
        } else {
            self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_on"), for: .normal)
        }

        // Setup message info
        if let stock : Int = infoItem.value(forKey: "is_stock") as? Int {
            // If has items in stock
            if stock != 0 {
                if let limitQuantity = infoItem.value(forKey: "count_point_item") as? String {
                    if limitQuantity == "0" {
                        self.statusMessageString = NSLocalizedString("exchange_point_detail_over_exchangetime", comment: "")
                        self.mButtonNext.isEnabled = false
                        self.mButtonNext.backgroundColor = UIColor.lightGray
                    }
                    else {
                        self.statusMessageString = String(format: "%@%@%@", NSLocalizedString("exchange_point_detail_status_message_enough", comment: ""), limitQuantity ,NSLocalizedString("exchange_point_detail_item", comment: ""))
                    }
                }
                
            }
            else {
                self.statusMessageString = NSLocalizedString("exchange_point_detail_status_message_not_enough", comment: "")
                self.mButtonNext.isEnabled = false
                self.mButtonNext.backgroundColor = UIColor.lightGray
            }
        }
        self.mLabelStatusMessage.text = self.statusMessageString

    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 17 * scaleDisplay)
        self.mLabelTitleContent.font = UIFont(name: self.mLabelTitleContent.font.fontName, size: 12 * scaleDisplay)
        self.mLabelDescription.font = UIFont(name: self.mLabelDescription.font.fontName, size: 12 * scaleDisplay)
        self.mLabelStatusMessage.font = UIFont(name: self.mLabelStatusMessage.font.fontName, size: 12 * scaleDisplay)
        self.mButtonNext.titleLabel!.font = UIFont(name: self.mButtonNext.titleLabel!.font.fontName, size: 14 * scaleDisplay)
        
        self.setPointForLabel()
    }
    
    private func setPointForLabel() {
        let str = "\(point.convertToStringDecimalFormat())pt"
        let range1 = NSRange(location: 0, length: str.count - 2)
        let range2 = NSRange(location: str.count - 2, length: 2)
        let attribute = NSMutableAttributedString(string: str)
        
        attribute.addAttributes([NSAttributedStringKey.font: UIFont(name: self.mLabelTitle.font.fontName, size: 21 * scaleDisplay) ?? UIFont.systemFont(ofSize: 21 * scaleDisplay),
                                 NSAttributedStringKey.foregroundColor: primaryColor], range: range1)
        attribute.addAttributes([NSAttributedStringKey.font:  UIFont(name: self.mLabelTitle.font.fontName, size: 16 * scaleDisplay) ?? UIFont.systemFont(ofSize: 16 * scaleDisplay),
                                 NSAttributedStringKey.foregroundColor: lightGrayColor], range: range2)
        self.mLabelPoint.attributedText = attribute
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickedButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedButtonConfirm(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotificationNavbarMainShowConfirmExchangePointView, object: infoItem)
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL, eventName:  ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_EXCHANGE)
    }

    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if let is_favorite = infoItem.value(forKey: "is_favorite") as? String {
            self.callAPIFavoritePointItem(currentFavorite: is_favorite)
        }
    }

    // MARK: - Call API

    func callAPIFavoritePointItem(currentFavorite: String) {
        if let pointItemId: String = self.infoItem.object(forKey: "id") as? String {
            self.mButtonFavorite.isUserInteractionEnabled = false

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "point_item_id": pointItemId,
                "disable": currentFavorite
            ]

            APIBase.shareObject.callAPIFavoritePointItem(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    var newValue:String = "0"
                    if currentFavorite == "0" {
                        self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_on"), for: .normal)
                        newValue = "1"
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL, eventName:  ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_FAVORITE)
                    } else {
                        self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_off"), for: .normal)
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL, eventName:  ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_UNFAVORITE)
                    }
                    self.infoItem.setValue(newValue, forKey: "is_favorite")
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.mButtonFavorite.isUserInteractionEnabled = true
            })
        }
    }

    func callAPIGetPointItemDetailExchange() {
        var params: [String : Any] = [:]
        if let id = infoItem.value(forKey: "id") as? String{
            params["id"] = id
            params["user_id"] = PublicVariables.userInfo.m_id
        }

        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIGetPointItemDetailExchange(params: params, completionHandler: { (result, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let dictDetail: NSDictionary = result?.value(forKey: "body") as? NSDictionary {
                    self.infoItem = NSMutableDictionary(dictionary: dictDetail)
                    self.setVariablesForViews()
                }
            }
            else {
                APIBase.shareObject.showAPIError(result: result)
            }
        })
    }

}
