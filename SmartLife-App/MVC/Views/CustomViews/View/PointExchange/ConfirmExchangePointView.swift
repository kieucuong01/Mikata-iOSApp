//
//  ConfirmExchangePointView.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/1/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ConfirmExchangePointViewDelegate: class {
    func finishExchangePointProgress(sender:ConfirmExchangePointView)
}

class ConfirmExchangePointView: UIView {

    @IBOutlet weak var mViewNotEnoughPoint: UIView!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelDescriptionNotice: UILabel!
    @IBOutlet weak var mLabelFavorite: UILabel!
    @IBOutlet weak var mButtonFavorite: UIButton!
    @IBOutlet weak var mButtonConfirm: UIButton!
    @IBOutlet weak var mImgChecked: UIImageView!
    
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelDescription: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonConfirm: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonConfirm: NSLayoutConstraint!
    
    
    @IBOutlet weak var mViewExchangePoint: UIView!
    @IBOutlet weak var mLabelTitle2: UILabel!
    @IBOutlet weak var mImageItem: UIImageView!
    @IBOutlet weak var mLabelNameItem: UILabel!
    @IBOutlet weak var mLabelPoint: UILabel!
    @IBOutlet weak var mLabelMyPoint: UILabel!
    @IBOutlet weak var mLabelValueMyPoint: UILabel!
    @IBOutlet weak var mLabelPointUsing: UILabel!
    @IBOutlet weak var mLabelValuePointUsing: UILabel!
    @IBOutlet weak var mLabelResult: UILabel!
    @IBOutlet weak var mLabelValueResult: UILabel!
    @IBOutlet weak var mButtonCancel: UIButton!
    @IBOutlet weak var mButtonAccept: UIButton!
    
    
    @IBOutlet weak var mTopConstraintLabelTitle2: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintImageItem: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintTopLabelMyPoint: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelPointUsing: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabePointUsing: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelResult: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtons: NSLayoutConstraint!
    
    @IBOutlet weak var mViewSuccessExchange: UIView!
    @IBOutlet weak var mLabelTitle3: UILabel!
    @IBOutlet weak var mLabelDescription3: UILabel!
    @IBOutlet weak var mButtonGoTop: UIButton!
    
    @IBOutlet weak var mTopConstraintLabelTitle3: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelDescription3: NSLayoutConstraint!
    @IBOutlet weak var mBottomconstraintButtonGoTop: NSLayoutConstraint!
    
    weak var delegate: ConfirmExchangePointViewDelegate? = nil
    var parentViewController: UIViewController? = nil
    var itemId: String? = nil
    var scale :CGFloat = DISPLAY_SCALE
    var infoItem: NSMutableDictionary = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ?  DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        self.setLanguageForView()
        self.setConstraintForViews()
        self.setFontForViews()
        self.setContentLabels()
        self.setLayerForViews()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private func setLanguageForView(){
        // not enough
        self.mLabelTitle.text = NSLocalizedString("confirmexchangepointview_label_title_notenough", comment: "")
        self.mLabelDescriptionNotice.text = NSLocalizedString("confirmexchangepointview_label_description_notenough", comment: "")
        self.mLabelTitle.text = NSLocalizedString("confirmexchangepointview_label_title_notenough", comment: "")
        //self.mButtonFavorite.setTitle(NSLocalizedString("confirmexchangepointview_label_favorite_notenough", comment: "") , for: .normal)
        self.mButtonConfirm.setTitle(NSLocalizedString("confirmexchangepointview_button_confirm_notenough", comment: "") , for: .normal)

        self.mLabelTitle2.text = NSLocalizedString("confirmexchangepointview_label_title2", comment: "")
        self.mLabelMyPoint.text = NSLocalizedString("confirmexchangepointview_label_mypoint", comment: "")
        self.mLabelPointUsing.text = NSLocalizedString("confirmexchangepointview_label_pointusing", comment: "")
        self.mLabelResult.text = NSLocalizedString("confirmexchangepointview_label_result", comment: "")

        self.mButtonCancel.setTitle(NSLocalizedString("common_button_cancel", comment: "") , for: .normal)
        self.mButtonAccept.setTitle(NSLocalizedString("confirmexchangepointview_button_accept", comment: "") , for: .normal)

        // success
        self.mLabelTitle3.text = NSLocalizedString("confirmexchangepointview_label_title3", comment: "")
        self.mLabelDescription3.text = NSLocalizedString("confirmexchangepointview_label_description3", comment: "")

        self.mButtonGoTop.setTitle(NSLocalizedString("confirmexchangepointview_button_gotop", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        self.mTopConstraintLabelTitle.constant = 37 * scale
        self.mTopConstraintLabelDescription.constant = 17 * scale
        self.mBottomConstraintButtonConfirm.constant = 22 * scale
        self.mTopConstraintButtonConfirm.constant = 28 * scale
        
        self.mTopConstraintLabelTitle2.constant = 34 * scale
        self.mTopConstraintImageItem.constant = 76 * scale
        self.mTopConstraintTopLabelMyPoint.constant = 23 * scale
        self.mTopConstraintLabelPointUsing.constant = 11 * scale
        self.mBottomConstraintLabePointUsing.constant = 11 * scale
        self.mTopConstraintLabelResult.constant = 11 * scale
        self.mBottomConstraintButtons.constant = 28 * scale
        
        self.mTopConstraintLabelTitle3.constant = 35 * scale
        self.mTopConstraintLabelDescription3.constant = 17 * scale
        self.mTopConstraintLabelDescription3.constant = 28 * scale
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scale)
        self.mLabelDescriptionNotice.font = UIFont(name: self.mLabelDescriptionNotice.font.fontName, size: 14 * scale)
        self.mLabelFavorite.font = UIFont(name: self.mLabelFavorite.font.fontName, size: 12 * scale)
        self.mButtonConfirm.titleLabel!.font = UIFont(name: self.mButtonConfirm.titleLabel!.font.fontName, size: 14 * scale)
        
        self.mLabelTitle2.font = UIFont(name: self.mLabelTitle2.font.fontName, size: 14 * scale)
        self.mLabelNameItem.font = UIFont(name: self.mLabelNameItem.font.fontName, size: 12 * scale)
        self.mLabelMyPoint.font = UIFont(name: self.mLabelMyPoint.font.fontName, size: 12 * scale)
        self.mLabelResult.font = UIFont(name: self.mLabelResult.font.fontName, size: 12 * scale)
        self.mLabelPointUsing.font = UIFont(name: self.mLabelPointUsing.font.fontName, size: 12 * scale)
        self.mButtonCancel.titleLabel!.font = UIFont(name: self.mButtonCancel.titleLabel!.font.fontName, size: 14 * scale)
        self.mButtonAccept.titleLabel!.font = UIFont(name: self.mButtonAccept.titleLabel!.font.fontName, size: 14 * scale)
        
        var string = "0pt"
        if let mPointInt: Int = Int(PublicVariables.userInfo.m_point) {
            string = mPointInt.convertToStringDecimalFormat() + "pt"
        }
        let size1 = 15 * scale
        let size2 = 11 * scale
        let color = UIColor.black
        self.mLabelValueMyPoint.attributedText = setAttributeStringForScore(string: string, color: color, size1: size1, size2: size2)
        
        
        self.mLabelTitle3.font = UIFont(name: self.mLabelTitle3.font.fontName, size: 14 * scale)
        self.mLabelDescription3.font = UIFont(name: self.mLabelDescription3.font.fontName, size: 14 * scale)
        self.mButtonGoTop.titleLabel!.font = UIFont(name: self.mButtonGoTop.titleLabel!.font.fontName, size: 14 * scale)

        
    }
    
    private func setContentLabels() {
        
        self.mLabelTitle.text = NSLocalizedString("exchange_point_detail_title_confirm_view", comment: "title confirm favorite")
        self.mButtonConfirm.setTitle(NSLocalizedString("point_exchange_button_title_go_to_get_point", comment: "button confirm"), for: .normal)
    }
    
    private func setLayerForViews() {
        self.mImageItem.layer.borderWidth = 1
        self.mImageItem.layer.borderColor = GlobalMethod.hexStringToUIColor(hex: "#D8D8D8").cgColor
        
        
        self.mButtonCancel.layer.borderWidth = 1
        self.mButtonCancel.layer.borderColor = UIColor.black.cgColor
        self.mButtonCancel.layer.cornerRadius = 4
    }
    
    private func setAttributeStringForScore(string:String,color:UIColor,size1:CGFloat,size2:CGFloat) -> NSMutableAttributedString {
        let font1: UIFont? = UIFont(name: "YuGothic-Bold", size: size1)
        let font2: UIFont? = UIFont(name: "YuGothic-Bold", size: size2)
        let dict1: [NSAttributedStringKey:Any] = [NSAttributedStringKey.font:font1 ?? 0, NSAttributedStringKey.foregroundColor:color]
        let dict2: [NSAttributedStringKey:Any] = [NSAttributedStringKey.font:font2 ?? 0, NSAttributedStringKey.foregroundColor:UIColor.black]
        let range1 = NSRange(location: 0, length: string.count - 2)
        let range2 = NSRange(location: string.count - 2, length: 2)
        return GlobalMethod.getAttributeString(fromString: string, withDictionary1: dict1, onRange1: range1, withDictionary2: dict2  , onRange2: range2)
    }
    
    @IBAction func clickedButtonClosed(_ sender: Any) {
        self.isHidden = true
    }
    
    @IBAction func clickedButtonCancel(_ sender: Any) {
        self.isHidden = true
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM_ACTION_CANCEL)
    }

    @IBAction func clickedButtonConfirm(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotificationNavbarMainNavigateToGetPointView, object: nil)
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT_ACTION_GO_TO_GET_POINT)
    }

    @IBAction func clickedButtonGoTop(_ sender: Any) {
        self.delegate?.finishExchangePointProgress(sender: self)
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_SUCCESSFULL, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_SUCCESSFULL_ACTION_GO_TO_POINT_EXCHANGE)
    }

    @IBAction func clickedButtonClose(_ sender: Any) {
        self.delegate?.finishExchangePointProgress(sender: self)
        self.isHidden = true
    }
    
    
    @IBAction func clickedButtonAccept(_ sender: Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM_ACTION_ACCEPT)
        self.mViewExchangePoint.isHidden = true
        self.isHidden = true
        self.callAPIUserBoughtItemUpdate()
    }

    @IBAction func clickedButtonFavorite(_ sender: Any) {
        if let is_favorite = infoItem.value(forKey: "is_favorite") as? String {
            self.callAPIFavoritePointItem(currentFavorite: is_favorite)
        }
    }
    
    //MARK: - Public method
    func updateViewsWithDict(dict:NSDictionary) {
        // Get itemId
        self.itemId = dict.object(forKey: "id") as? String
        self.infoItem = NSMutableDictionary(dictionary: dict)

        self.mViewSuccessExchange.isHidden = true
        
        self.mLabelNameItem.text = dict.object(forKey: "name") as? String
        self.mLabelNameItem.sizeToFit()
        self.mImageItem.setImageForm(urlString: dict.object(forKey: "image_url") as? String, placeHolderImage: nil)

        var point: Int32 = 0
        if let pointString: NSString = dict.object(forKey: "point") as? NSString {
            point = pointString.intValue
        }
        // Update my point
        var string = "0pt"
        if let mPointInt: Int = Int(PublicVariables.userInfo.m_point) {
            string = mPointInt.convertToStringDecimalFormat() + "pt"
        }
        let size1 = 15 * scale
        let size2 = 11 * scale
        let color = UIColor.black
        self.mLabelValueMyPoint.attributedText = setAttributeStringForScore(string: string, color: color, size1: size1, size2: size2)

        let myPoint = (PublicVariables.userInfo.m_point as NSString).intValue
        if myPoint > point {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM, eventName: nil)

            self.mViewNotEnoughPoint.isHidden = true
            self.mViewExchangePoint.isHidden = false
            
            var string = "\(Int(point).convertToStringDecimalFormat())" + "pt"
            var size1 = 19 * scale
            var size2 = 14 * scale
            var color = primaryColor
            self.mLabelPoint.attributedText = setAttributeStringForScore(string: string, color: color, size1: size1, size2: size2)
            
            string = "-\(Int(point).convertToStringDecimalFormat())pt"
            size1 = 15 * scale
            size2 = 11 * scale
            self.mLabelValuePointUsing.attributedText = setAttributeStringForScore(string: string, color: color, size1: size1, size2: size2)
            
            let delta = myPoint - point
            string = "\(Int(delta).convertToStringDecimalFormat())pt"
            size1 = 15 * scale
            size2 = 11 * scale
            color = UIColor.black
            self.mLabelValueResult.attributedText = setAttributeStringForScore(string: string, color: color, size1: size1, size2: size2)
            
        } else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT, eventName: nil)

            self.mViewNotEnoughPoint.isHidden = false
            self.mViewExchangePoint.isHidden = true
            let is_favorite = (dict.object(forKey: "is_favorite") as? String)
            if is_favorite == "0" {
                self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_off"), for: .normal)
                self.mLabelFavorite.text = NSLocalizedString("exchange_point_detail_title_favorite_off", comment: "tip favorite is off")
                self.mImgChecked.isHidden = true
            } else {
                self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_on"), for: .normal)
                self.mLabelFavorite.text = NSLocalizedString("exchange_point_detail_title_favorite_on", comment: "tip favorite is on")
                self.mImgChecked.isHidden = false
            }
        }
    }

    //MARK: - API
    func callAPIUserBoughtItemUpdate() {
        if self.parentViewController != nil && self.itemId != nil {
            MBProgressHUD.showAdded(to: self.parentViewController!.view, animated: true)
            let param: [String: Any] = [
                "login_user_id": PublicVariables.userInfo.m_id,
                "point_item_id": self.itemId!
            ]
            APIBase.shareObject.callAPIUserBoughtItemUpdate(params: param) { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    self.isHidden = false
                    self.mViewSuccessExchange.isHidden = false
                    GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_SUCCESSFULL, eventName: nil)
                    if let body: NSDictionary = result?.value(forKey: "body") as? NSDictionary {
                        if let point: String = body.value(forKey: "point") as? String {
                            PublicVariables.userInfo.m_point = point
                            NotificationCenter.default.post(name: NSNotificationNavbarMainChangeScore, object: point)
                        }
                    }
                } else {
                    if let error = result?.object(forKey: "error") as? NSArray {
                        if let dictError = error.firstObject as? NSDictionary {
                            // Default message
                            var errorMessage: String = "Error"

                            if let errorCode: Int = dictError.object(forKey: "code") as? Int {
                                // Check error 1022
                                if errorCode == 1022 {
                                    errorMessage = NSLocalizedString("exchange_point_detail_over_exchangetime", comment: "")
                                }
                            }

                            // Show alert
                            GlobalMethod.showAlert(errorMessage)
                        }
                    }
                }
                MBProgressHUD.hide(for: self.parentViewController!.view, animated: true)
            }
        }
    }

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
                        self.mLabelFavorite.text = NSLocalizedString("exchange_point_detail_title_favorite_on", comment: "tip favorite is on")
                        self.mImgChecked.isHidden = false
                        newValue = "1"
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_FAVORITE)
                    } else {
                        self.mButtonFavorite.setBackgroundImage(#imageLiteral(resourceName: "favorite_off"), for: .normal)
                        self.mLabelFavorite.text = NSLocalizedString("exchange_point_detail_title_favorite_off", comment: "tip favorite is off")
                        self.mImgChecked.isHidden = true
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_UNFAVORITE)
                    }
                    self.infoItem.setValue(newValue, forKey: "is_favorite")
                    NotificationCenter.default.post(name: NSNotification.Name("ExchangeVCUpdateContent"), object: self.infoItem)
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.mButtonFavorite.isUserInteractionEnabled = true
            })
        }
    }

    func errorAPIAppear(message: String?) {
        let alertController = UIAlertController(title: NSLocalizedString("alert_warning_title", comment: ""), message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: NSLocalizedString("button_cancel_title", comment: ""), style: .cancel, handler:nil)
        alertController.addAction(cancelButton)
        parentViewController?.present(alertController, animated: true, completion: nil)
    }
}
