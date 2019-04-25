//
//  ExchangePointDetailCompleteViewController
//  SmartLife-App
//
//  Created by thanhlt on 9/1/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ExchangePointDetailCompleteViewController: BaseViewController {

    @IBOutlet weak var mLabelTitleTop: UILabel!
    @IBOutlet weak var mLabelExchangeCodeTitle: UILabel!
    @IBOutlet weak var mLabelShipmentDate: UILabel!
    @IBOutlet weak var mLabelExpirationDate: UILabel!
    @IBOutlet weak var mLabelExchangeDate: UILabel!
    @IBOutlet weak var mLabelTitleNav: UILabel!
    @IBOutlet weak var mButtonGiftCode: UIButton!
    
    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelPoint: UILabel!
    
    @IBOutlet weak var mLabelTitleContent: UILabel!
    @IBOutlet weak var mLabelDescription: UILabel!

    @IBOutlet weak var mHeightButtonGiftCode: NSLayoutConstraint!
    @IBOutlet weak var mConstrantHeightViewTop: NSLayoutConstraint!
    @IBOutlet weak var mConstraintLeadingLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopLabelPoint: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopTitleContent: NSLayoutConstraint!
    @IBOutlet weak var mConstraintTopLabelDescription: NSLayoutConstraint!
    @IBOutlet weak var mConstraintBottomViewContent: NSLayoutConstraint!
    @IBOutlet weak var mConstraintBottomScrollView: NSLayoutConstraint!

    var statusMessageString:String = ""
    var point:Int = 0
    var infoItem: NSMutableDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ExchangePointDetailViewController.updateVariableContent(notification:)), name: NSNotification.Name("ExchangeVCUpdateContent"), object: nil)

        self.callAPIGetPointItemDetailExchange()
        self.setLanguageForView()
        self.setPropertiesForView()
        self.setConstraintForViews()
        self.setVariablesForViews()
        self.setFontForViews()
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
    private func setPropertiesForView(){
        self.mButtonGiftCode.backgroundColor = .clear
        self.mButtonGiftCode.layer.borderWidth = 1 * scaleDisplay
        self.mButtonGiftCode.layer.borderColor = UIColor.black.cgColor
        self.mButtonGiftCode.titleEdgeInsets.left = 8 * scaleDisplay;
    }
    private func setLanguageForView(){
        self.mLabelTitleTop.text = NSLocalizedString("ExchangeDetailCompleteView_label_titletop", comment: "")
        self.mLabelExchangeCodeTitle.text = NSLocalizedString("ExchangeDetailCompleteView_label_exchangecode", comment: "")
        self.mLabelShipmentDate.text = NSLocalizedString("ExchangeDetailCompleteView_label_shipmentdate_title", comment: "")
        self.mLabelExpirationDate.text = NSLocalizedString("ExchangeDetailCompleteView_label_expirationdate_title", comment: "")
        self.mLabelExchangeDate.text = NSLocalizedString("ExchangeDetailCompleteView_label_exchangedate_title", comment: "")

        self.mLabelTitleNav.text = NSLocalizedString("exchangepointdetailview_navbar", comment: "")
        self.mLabelTitleContent.text = NSLocalizedString("exchangepointdetailview_label_titlecontent", comment: "")
    }

    private func setConstraintForViews() {
        self.mConstraintBottomViewContent.constant = 34 * scaleDisplay
        self.mConstraintLeadingLabelTitle.constant = 14 * scaleDisplay
        self.mConstraintTopLabelTitle.constant = 8 * scaleDisplay
        self.mConstraintTopLabelPoint.constant = 11 * scaleDisplay
        self.mConstraintTopTitleContent.constant = 25 * scaleDisplay
        self.mConstraintTopLabelDescription.constant = 8 * scaleDisplay
        self.mConstrantHeightViewTop.constant = 213 * scaleDisplay
        self.mConstraintBottomScrollView.constant = 51 * scaleDisplay
        self.mHeightButtonGiftCode.constant = 35 * scaleDisplay
    }

    @objc func updateVariableContent(notification: Notification) {
        if let dict: NSMutableDictionary = notification.object as? NSMutableDictionary {
            self.infoItem = dict
        }
    }
    
    private func setVariablesForViews() {
        // Set up top title
        if infoItem.value(forKey: "is_giftee") != nil {
        if let is_giftee = infoItem.value(forKey: "is_giftee") as? String{
            if is_giftee == "1"{
                self.mLabelTitleTop.text = NSLocalizedString("ExchangeDetailCompleteView_label_titletop2", comment: "")
                self.mButtonGiftCode.addTarget(self, action: #selector(tapURL), for: .touchUpInside)
            }
            else {
                self.mLabelTitleTop.text = NSLocalizedString("ExchangeDetailCompleteView_label_titletop", comment: "")
            }
        }
        }
        // Set up giftcode
        if infoItem.value(forKey: "gift_code") != nil{
            if let giftCode = infoItem.value(forKey: "gift_code") as? String {
                self.mButtonGiftCode.setTitle(giftCode, for: .normal)
            }
            else{
                self.mButtonGiftCode.setTitle("", for: .normal)
            }
        }else {
            self.mButtonGiftCode.setTitle("", for: .normal)
        }

        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        formater.timeZone = TimeZone(secondsFromGMT: 9*3600)
        formater.locale = Locale(identifier: "en_US_POSIX")
        // Set up Exchange Date
        if infoItem.value(forKey: "created") != nil {
            if let exchangeDateString = infoItem.value(forKey: "created") as? String {
                let exchangeDate = Date(timeIntervalSince1970: TimeInterval((exchangeDateString as NSString).longLongValue))
                self.mLabelExchangeDate.text = String(format: "%@ %@", NSLocalizedString("ExchangeDetailCompleteView_label_exchangedate_title", comment: ""), formater.string(from: exchangeDate))
            }
            else {
                self.mLabelExchangeDate.text = String(format: "%@ %@", NSLocalizedString("ExchangeDetailCompleteView_label_exchangedate_title", comment: ""), "-")
            }
        }
        // Set up Shipment Date
        if infoItem.value(forKey: "send_date") != nil {
            if let exchangeDateString = infoItem.value(forKey: "send_date") as? String {
                let exchangeDate = Date(timeIntervalSince1970: TimeInterval((exchangeDateString as NSString).longLongValue))
                self.mLabelShipmentDate.text = String(format: "%@ %@", NSLocalizedString("ExchangeDetailCompleteView_label_shipmentdate_title", comment: ""), formater.string(from: exchangeDate))
            }
            else {
                self.mLabelShipmentDate.text = String(format: "%@ %@", NSLocalizedString("ExchangeDetailCompleteView_label_shipmentdate_title", comment: ""), "-")
            }
        }
        // Set up Expriration Date
        if infoItem.value(forKey: "limit_date") != nil {
            if let exchangeDateString = infoItem.value(forKey: "limit_date") as? String {
                let exchangeDate = Date(timeIntervalSince1970: TimeInterval((exchangeDateString as NSString).longLongValue))
                self.mLabelExpirationDate.text = String(format: "%@ %@", NSLocalizedString("ExchangeDetailCompleteView_label_expirationdate_title", comment: ""), formater.string(from: exchangeDate))
            }
            else {
                self.mLabelExpirationDate.text = String(format: "%@ %@", NSLocalizedString("ExchangeDetailCompleteView_label_expirationdate_title", comment: ""), "-")
            }
        }


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
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 17 * scaleDisplay)
        self.mLabelTitleContent.font = UIFont(name: self.mLabelTitleContent.font.fontName, size: 12 * scaleDisplay)
        self.mLabelDescription.font = UIFont(name: self.mLabelDescription.font.fontName, size: 12 * scaleDisplay)
        self.mLabelTitleTop.font = UIFont(name: self.mLabelTitleTop.font.fontName, size: 12 * scaleDisplay)
        self.mLabelExchangeCodeTitle.font = UIFont(name: self.mLabelExchangeCodeTitle.font.fontName, size: 12 * scaleDisplay)
        self.mLabelExchangeDate.font = UIFont(name: self.mLabelExchangeDate.font.fontName, size: 12 * scaleDisplay)
        self.mLabelShipmentDate.font = UIFont(name: self.mLabelShipmentDate.font.fontName, size: 12 * scaleDisplay)
        self.mLabelExpirationDate.font = UIFont(name: self.mLabelExpirationDate.font.fontName, size: 12 * scaleDisplay)
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

    @objc func tapURL() {
        guard let url = URL(string: (self.mButtonGiftCode.titleLabel?.text)!) else {
            return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    // MARK: - Call API

    func callAPIGetPointItemDetailExchange() {
        var params: [String : Any] = [:]
        if let id = infoItem.value(forKey: "id") as? String{
            params["id"] = id
        }

        APIBase.shareObject.callAPIGetPointItemDetailExchanged(params: params, completionHandler: { (result, error) in
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
