//
//  CreateNewNoteViewController.swift
//  SmartLife-App
//
//  Created by DELL7447 on 9/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class CreateNewNoteViewController: BaseViewController {
    
    @IBOutlet weak var mHeightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewTitleNote: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewSegment: NSLayoutConstraint!
    
    @IBOutlet weak var mTopConstraintButtonCreate: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewListTag: NSLayoutConstraint!
    
    @IBOutlet weak var mViewContainButtonLeftRight: UIView!
    @IBOutlet weak var mButtonRight: UIButton!
    @IBOutlet weak var mButtonLeft: UIButton!
    @IBOutlet weak var mLabelTitleNav: UILabel!
    @IBOutlet weak var mTextFieldTitle: UITextField!
    @IBOutlet weak var mLabelTitleSegment: UILabel!
    @IBOutlet weak var mViewListTag: UIView!
    @IBOutlet weak var mButtonCreate: UIButton!

    var arrayTags: [(name: String, id: Int)] = [
        ("ファッション", 1),
        ("ダイエット", 2),
        ("美容", 3),
        ("グルメ", 6),
        ("音楽・映画", 4),
        ("トラベル", 5),
        ("イベント", 7),
        ("キャリア", 8),
    ]
    var arrayPosition:[CGRect] = [CGRect(x: 0, y: 0, width: 93, height: 26),
                                  CGRect(x: 102 , y: 0  , width: 78 , height: 26),
                                  CGRect(x: 190 , y: 0  , width: 39 , height: 26),
                                  CGRect(x: 240 , y: 0  , width: 53 , height: 26),
                                  CGRect(x: 0   , y: 41 , width: 79   , height: 26),
                                  CGRect(x: 84  , y: 41 , width: 66   , height: 26),
                                  CGRect(x: 156 , y: 41 , width: 66    , height: 26),
                                  CGRect(x: 228 , y: 41  , width: 66    , height: 26)]
    var publicRangeSelected: String = "1"
    var listJenreSelected: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesInViews()
        self.setLayerForViews()
        self.loadListTagInView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK :- Private method 
    private func setConstraintForViews() {
        self.mTopConstraintViewTitleNote.constant = 14 * scaleDisplay
        self.mTopConstraintViewSegment.constant = 17 * scaleDisplay
        self.mTopConstraintButtonCreate.constant = 23 * scaleDisplay
        self.mTopConstraintViewListTag.constant =  23 * scaleDisplay
        
    }
    
    private func setFontForViews() {
        self.mLabelTitleNav.font = UIFont(name: self.mLabelTitleNav.font.fontName, size: 14 * scaleDisplay)
        
        let attributteText = NSAttributedString(string: self.mTextFieldTitle.placeholder!, attributes: [NSAttributedStringKey.font: UIFont(name: "YuGo-Medium", size: 12 * scaleDisplay)!,  NSAttributedStringKey.foregroundColor: GlobalMethod.hexStringToUIColor(hex: "#B89F98") ])
        self.mTextFieldTitle.attributedPlaceholder = attributteText
        
        self.mButtonLeft.titleLabel!.font = UIFont(name: self.mButtonLeft.titleLabel!.font.fontName, size: 14 * scaleDisplay)
        self.mButtonRight.titleLabel!.font = UIFont(name: self.mButtonRight.titleLabel!.font.fontName, size: 14 * scaleDisplay)
    }
    
    private func setLayerForViews() {
        self.mViewContainButtonLeftRight.layer.cornerRadius = 4 * scaleDisplay
    }

    private func loadListTagInView() {
        for i in 0 ..< arrayTags.count {
            self.mViewListTag.addSubview(self.newLabelWithRect(rect: arrayPosition[i], tag: arrayTags[i]))
        }
        
        self.mHeightCollectionView.constant = 58 * scaleDisplay
    }
    
    func newLabelWithRect(rect:CGRect, tag: (name: String, id: Int)) -> UIButton {
        let x = rect.origin.x * scaleDisplay
        let y = rect.origin.y * scaleDisplay
        let w = rect.size.width * scaleDisplay
        let h = rect.size.height * scaleDisplay
        let button = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
        button.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#E4D4CD")
        button.titleLabel?.font = UIFont(name: "YuGothic-Bold", size: 13 * scaleDisplay)
        button.setTitle(tag.name, for: .normal)
        button.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#6C5032"), for: .normal)
        button.tag = tag.id
        
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(CreateNewNoteViewController.clickedButtonTagLable(_:) ), for: .touchUpInside)
        return button
    }
    
    
    private func setPropertiesInViews() {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clickButtonLeft(_ sender: Any) {
        self.mButtonLeft.setTitleColor( .white, for: .normal)
        self.mButtonLeft.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "FD8688")
        
        self.mButtonRight.setTitleColor( GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.mButtonRight.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4C4")

        self.publicRangeSelected = "1"
    }
    
    @IBAction func clickButtonRight(_ sender: Any) {
        self.mButtonRight.setTitleColor( .white, for: .normal)
        self.mButtonRight.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "FD8688")
        
        self.mButtonLeft.setTitleColor( GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.mButtonLeft.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4C4")

        self.publicRangeSelected = "3"
    }
    
    @IBAction func clickedButtonBack(_ sender: Any) {
        let dict:[String:String] = ["lbl_confirm_title": NSLocalizedString("alert_view_new_note_label_confirm", comment: "label for confirm title alert when delete"),
                                    "lbl_button_decline": NSLocalizedString("alert_view_new_note_button_decline", comment: "label for button decline"),
                                    "lbl_button_accept": NSLocalizedString("alert_view_delete_note_button_accept", comment: "label for button accept"),
                                    "action": "1"]
        NotificationCenter.default.post(name: NSNotificationNavbarMainShowAlertCustomView, object: dict)
    }

    @IBAction func clickedButtonDone(_ sender: Any) {
        // Check title
        if self.mTextFieldTitle.text == nil || self.mTextFieldTitle.text == "" {
            self.showError(message: "タイトルを入力してください")
            return
        }

        // Check list jenre
        if self.listJenreSelected.count <= 0 {
            self.showError(message: "ジャンルを選択してください")
            return
        }

        // Get list jenre string
        var listJenreSelectedString: String = ""
        for jenre in self.listJenreSelected {
            if listJenreSelectedString == "" {
                listJenreSelectedString = String(jenre)
            }
            else {
                listJenreSelectedString = listJenreSelectedString + "," + String(jenre)
            }
        }

        // Call API
        self.callAPIAddNote(title: self.mTextFieldTitle.text!, publicRange: self.publicRangeSelected, listJenre: listJenreSelectedString)
    }
    
    @objc func clickedButtonTagLable(_ sender:Any) {
        if let button = sender as? UIButton {
            if button.isSelected == true {
                button.isSelected = false
                button.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "#6C5032"), for: .normal)
                button.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#E4D4CD")
                if let index: Int = self.listJenreSelected.index(of: button.tag) {
                    self.listJenreSelected.remove(at: index)
                }
            } else {
                button.isSelected = true
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#FD8688")
                self.listJenreSelected.append(button.tag)
            }
             print("Status \(button.isSelected)")
        }
    }

    // MARK: - Show API error

    func showError(message: String) {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            // Init alert
            let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
            }))

            // Make title smaller
            alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

            // Show alert
            appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Call API

    func callAPIAddNote(title: String, publicRange: String, listJenre: String) {
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "mikata_building_id": PublicVariables.userInfo.m_kabocha_building_id,
            "title": title,
            "public_range": publicRange,
            "jenre_id": listJenre
        ]

        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIAddNote(params: params, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let dict:[String:String] = ["action": "2",
                                            "lbl_success_title": NSLocalizedString("alert_view_new_note_label_success", comment: "label for success title alert when complete"),
                                            "lbl_button_success": NSLocalizedString("alert_view_new_note_button_success", comment: "label for button accept")]
                NotificationCenter.default.post(name: NSNotificationNavbarMainShowAlertCustomView, object: dict)
            }
            else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
}
