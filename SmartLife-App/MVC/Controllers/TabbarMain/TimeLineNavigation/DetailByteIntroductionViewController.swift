//
//  DetailByteIntroductionViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/29/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class DetailByteIntroductionViewController: BaseViewController {

    @IBOutlet weak var mLabelNavTitle: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelDescriptTop: UILabel!
    @IBOutlet weak var mViewContentTag: UIView!
    @IBOutlet weak var mButtonFavorite: UIButton!
    @IBOutlet weak var mImageJob: UIImageView!
    @IBOutlet weak var mLabelDetailDescription: UILabel!
    @IBOutlet weak var mTableListDetail: UITableView!
    @IBOutlet weak var mButtonAccept: UIButton!

    @IBOutlet weak var mImageJobHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelDescripTop: NSLayoutConstraint!
    @IBOutlet weak var mHeightConstraintViewContentTag: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintImageJob: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelDetailDescription: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintTableListDetail: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonAccept: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonAccept: NSLayoutConstraint!
    @IBOutlet weak var mHeightConstraintTableList: NSLayoutConstraint!

    var infoItem: NSMutableDictionary = [:]
    var infoItemDetail: NSMutableDictionary = [:]
    var arrayTag :[String] = []
    var arrayTitleSection1: [String] = [String]()
    var arrayTitleSection2: [String] = [String]()
    var arrayContentSection1: [String] = [String]()
    var arrayContentSection2: [String] = [String]()

    var isNeedShowNavTabbar: Bool = true

    var titleUpdate:String = NSLocalizedString("detailbyteview_navbar", comment: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainScrollView.isHidden = true
        self.setConstraintForViews()
        self.setLanguageForView()
        self.mLabelNavTitle.text = titleUpdate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callAPIGetDetailByte()
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        self.isNeedShowNavTabbar = true

        //Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL, eventName: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isNeedShowNavTabbar == true {
            NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    private func setLanguageForView(){
        self.mButtonAccept.setTitle(NSLocalizedString("detailbyteview_button_apply", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        //
        self.mImageJobHeightConstraint.constant = 184.0 * scaleDisplay
        self.mTopConstraintLabelTitle.constant = 8 * scaleDisplay
        self.mTopConstraintLabelDescripTop.constant = 8 * scaleDisplay
        
        self.mHeightConstraintViewContentTag.constant = 30 * scaleDisplay
        self.mTopConstraintImageJob.constant = 10 * scaleDisplay
        self.mTopConstraintLabelDetailDescription.constant = 3 * scaleDisplay
        self.mTopConstraintButtonAccept.constant = 26 * scaleDisplay
        self.mBottomConstraintButtonAccept.constant = 34 * scaleDisplay
        self.mTopConstraintTableListDetail.constant = 26 * scaleDisplay
    }

    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName , size: 17 * scaleDisplay)
        self.mLabelDescriptTop.font = UIFont(name: self.mLabelDescriptTop.font.fontName , size: 12 * scaleDisplay)
        self.mLabelDetailDescription.font = UIFont(name: self.mLabelDetailDescription.font.fontName , size: 12 * scaleDisplay)
        self.mButtonAccept.titleLabel?.font = UIFont(name: self.mButtonAccept.titleLabel!.font.fontName , size: 14 * scaleDisplay)
    }

    private func loadTopContent() {
        // Title
        self.mLabelTitle.text = self.infoItemDetail.object(forKey: "tbasicitemp_jobtypedtl") as? String

        // Content
        let content: String? = self.infoItemDetail.object(forKey: "tbasicitemp_compnm") as? String
        self.mLabelDescriptTop.text = content?.html2String

        // Favorite
        let isFavoriteString: String? = self.infoItemDetail.object(forKey: "is_favorite") as? String
        if isFavoriteString == "1" { self.mButtonFavorite.isSelected = true }
        else { self.mButtonFavorite.isSelected = false }

        // Image
        let imagePath: String? = self.infoItemDetail.object(forKey: "image_main") as? String
        self.mImageJob.setImageForm(urlString: imagePath, placeHolderImage: nil)
        if imagePath != nil && imagePath != "" {
            self.mImageJobHeightConstraint.constant = 184.0 * self.scaleDisplay
        }
        else {
            self.mImageJobHeightConstraint.constant = 0.0
        }


        // ContentDetail
        let contentDetail: String? = self.infoItemDetail.object(forKey: "tbasicitemp_wkcontdtl") as? String
        self.mLabelDetailDescription.text = contentDetail?.html2String

        self.view.layoutIfNeeded()
    }

    private func loadListDataForArrayContent1() {
        // Salary
        if let salary: String = self.infoItemDetail.object(forKey: "tbasicitemp_paydtl") as? String, salary != "" {
            self.arrayContentSection1.append(salary)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // WorkingTime
        if let workingTime: String = self.infoItemDetail.object(forKey: "tbasicitemp_offihrdtl") as? String, workingTime != "" {
            self.arrayContentSection1.append(workingTime)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // Location
        if let location: String = self.infoItemDetail.object(forKey: "mpref_prefnm") as? String, location != "" {
            self.arrayContentSection1.append(location)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // NearestStation
        if let nearestStation: String = self.infoItemDetail.object(forKey: "tbasicitemp_trafdtl") as? String, nearestStation != "" {
            self.arrayContentSection1.append(nearestStation)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // ApplicationCondition
        if let applicationCondition: String = self.infoItemDetail.object(forKey: "tbasicitemp_recrsn") as? String, applicationCondition != "" {
            self.arrayContentSection1.append(applicationCondition)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // WorkingHoliday
        if let workingHoliday: String = self.infoItemDetail.object(forKey: "tbasicitemp_holiday") as? String, workingHoliday != "" {
            self.arrayContentSection1.append(workingHoliday)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // Treatment
        if let treatment: String = self.infoItemDetail.object(forKey: "tbasicitemp_treat") as? String, treatment != "" {
            self.arrayContentSection1.append(treatment)
        }
        else {
            self.arrayContentSection1.append("-")
        }
    }

    private func loadListDataForArrayContent2() {
        // CompanyName
        if let companyName: String = self.infoItemDetail.object(forKey: "tbasicitemp_compnm") as? String, companyName != "" {
            self.arrayContentSection2.append(companyName)
        }
        else {
            self.arrayContentSection2.append("-")
        }

        // Address
        if let address: String = self.infoItemDetail.object(forKey: "tbasicitemp_adr") as? String, address != "" {
            self.arrayContentSection2.append(address)
        }
        else {
            self.arrayContentSection2.append("-")
        }

        // BusinessContent
        if let businessContent: String = self.infoItemDetail.object(forKey: "tbasicitemp_bizcont") as? String, businessContent != "" {
            self.arrayContentSection2.append(businessContent)
        }
        else {
            self.arrayContentSection2.append("-")
        }

        // RelatedUrl
        if let relatedUrl: String = self.infoItemDetail.object(forKey: "tbasicitemp_url") as? String, relatedUrl != "" {
            self.arrayContentSection2.append(relatedUrl)
        }
        else {
            self.arrayContentSection2.append("-")
        }
    }

    private func loadListDataFromInfoDetail() {
        self.arrayTitleSection1.removeAll()
        self.arrayTitleSection2.removeAll()
        self.arrayContentSection1.removeAll()
        self.arrayContentSection2.removeAll()
        if let path = Bundle.main.path(forResource: "ListItemByte", ofType: "plist") {
            ////If your plist contain root as Dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let arraySection1 = dic["section1"] as? [String] {
                    self.arrayTitleSection1 = arraySection1
                }
                if let arraySection2 = dic["section2"] as? [String] {
                    self.arrayTitleSection2 = arraySection2
                }
                self.loadListDataForArrayContent1()
                self.loadListDataForArrayContent2()
            }
        }
        self.countHeightTableView()
        self.mTableListDetail.reloadData()
        self.viewWillLayoutSubviews()
    }

    private func countHeightTableView() {
        let widthEstimate: CGFloat = 293.0 * scaleDisplay
        var fontEstimate: UIFont = UIFont.systemFont(ofSize: 12.0 * scaleDisplay)
        if let font: UIFont = UIFont(name: "YuGo-Medium", size: 12.0 * scaleDisplay) {
            fontEstimate = font
        }

        var height:CGFloat = 47 * scaleDisplay
        for i in 0 ..< arrayContentSection1.count {
            height = height + 32 * scaleDisplay
            let heightEstimate: CGFloat = arrayContentSection1[i].html2String.height(withConstrainedWidth: widthEstimate, font: fontEstimate)
            height = height + heightEstimate
        }

        height = height + 47 * scaleDisplay
        for i in 0 ..< arrayContentSection2.count {
            height = height + 32 * scaleDisplay
            let heightEstimate: CGFloat = arrayContentSection2[i].html2String.height(withConstrainedWidth: widthEstimate, font: fontEstimate)
            height = height + heightEstimate
        }

        self.mHeightConstraintTableList.constant = height
        self.view.layoutIfNeeded()
    }

    private func loadListTagInView() {
        // Tags
        self.arrayTag.removeAll()
        if let jobCategoryString: String = self.infoItemDetail.object(forKey: "tbiemptypp_emptypnm") as? String {
            if jobCategoryString != "-" {
                let arrayCategory: [String] = jobCategoryString.components(separatedBy: ",")
                for category in arrayCategory {
                    let categoryAfterTrim: String = category.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.arrayTag.append(categoryAfterTrim)
                }
            }
        }

        // Date
        let dateString: String = self.getStringDateFromTime(time: self.infoItemDetail.object(forKey: "updated") as? String, with: "yyyy.MM.dd")
        self.arrayTag.append("更新日:" + dateString)

        var x:CGFloat = 0
        var y:CGFloat = 0
        let distance = 4 * scaleDisplay
        var index = 0
        for text in arrayTag {
            let view = newLabelWithText(string: text, oldX: x, oldY: y,index: index)
            x = view.frame.origin.x + view.frame.size.width + distance
            y = view.frame.origin.y
            self.mViewContentTag.addSubview(view)
            index = index + 1
        }
        self.mHeightConstraintViewContentTag.constant = y + 17 * scaleDisplay
    }

    func newLabelWithText(string:String,oldX: CGFloat, oldY: CGFloat, index:Int) -> UIView {
        let view = UIButton(frame: CGRect(x: oldX, y:oldY , width: 0, height: 0 ))
        view.backgroundColor = UIColor(red: 216, green: 216, blue: 216)
        let label = UILabel(frame: CGRect(x: 5 * scaleDisplay, y:5 * scaleDisplay , width: 0, height: 0 ))
        
        label.textColor = grayColor
        label.font = UIFont(name: "YuGothic-Bold", size: 8 * scaleDisplay)
        if index == arrayTag.count - 1 {
            
            view.backgroundColor = .clear
            label.textColor = lightGrayColor
        }
        
        label.text = string
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        
        var frame = label.frame
        frame.origin.x = oldX
        frame.origin.y = oldY
        frame.size.width = frame.size.width + 10 * scaleDisplay
        frame.size.height = 17 * scaleDisplay
        if frame.size.width > (mViewContentTag.frame.size.width) {
            frame.origin.x = 0
            if oldX > 0 {
                frame.origin.y = frame.origin.y + 21 * scaleDisplay
            }
            frame.size.width = mViewContentTag.frame.size.width
        } else {
            if (frame.size.width + frame.origin.x) > (mViewContentTag.frame.size.width) {
                frame.origin.x = 0
                frame.origin.y = frame.origin.y + 21 * scaleDisplay
            }
        }
        view.frame = frame
        view.layer.cornerRadius = 1
//        button.addTarget(self, action: #selector(CreateNewNoteViewController.clickedButtonTagLable(_:) ), for: .touchUpInside)
        view.addSubview(label)
        
        return view
    }

    private func disableButtonAccept (){
        self.mButtonAccept.isEnabled = false
    self.mButtonAccept.setTitle(NSLocalizedString("detailbyteview_button_applied", comment: ""), for: .normal)
        self.mButtonAccept.backgroundColor = UIColor.lightGray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickedButtonFavorite(_ sender: Any) {
        if let is_favorite = self.infoItemDetail.object(forKey: "is_favorite") as? String {
            self.callAPIFavoriteBytes(currentFavorite: is_favorite)
        }
    }
    
    @IBAction func clickedButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedButtonAccept(_ sender: Any) {
        //Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL, eventName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL_ACTION_ACCEPT)

        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        if let vc: CreateFromJobByteViewController = storyboard.instantiateViewController(withIdentifier: "CreateFromJobByteViewController") as? CreateFromJobByteViewController {
            vc.delegate = self

            // send jobApply to confirmView
            var dictJobApply = [String: Any?]()
            for (key, value) in self.infoItem {
                if key as? String != nil {
                    dictJobApply [key as! String] = value
                }
            }
            vc.jobApply.append(dictJobApply)

            // send work id
            if let workId: String = self.infoItemDetail.object(forKey: "id") as? String{
                vc.workId = workId
            }
            self.isNeedShowNavTabbar = false
            self.present(vc, animated: true, completion: nil)
        }

    }

    // MARK: - Get String Date

    func getStringDateFromTime(time: String?, with formatDate: String) -> String {
        if let dateString: String = time, dateString != "" {
            if let dateDouble: Double = TimeInterval(dateString) {
                let date: Date = Date(timeIntervalSince1970: dateDouble)
                let formatter: DateFormatter = DateFormatter()
                formatter.dateFormat = formatDate
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter.string(from: date)
            }
            else { return "-" }
        }
        else { return "-" }
    }

    // MARK: - Call API

    func callAPIGetDetailByte() {
        if let byteId: String = self.infoItem.object(forKey: "works_id") as? String {
            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "id": byteId
            ]

            MBProgressHUD.showAdded(to: self.view, animated: true)
            APIBase.shareObject.callAPIGetDetailByte(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let dictDetail: NSDictionary = result?.value(forKey: "body") as? NSDictionary {
                        self.infoItemDetail = NSMutableDictionary(dictionary: dictDetail)

                        if let is_applied = self.infoItemDetail.value(forKey: "is_applied") as? String {
                            if is_applied == "1" {
                                self.disableButtonAccept()
                            }
                        }
                    }
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.loadTopContent()
                self.loadListTagInView()
                self.loadListDataFromInfoDetail()
                self.mainScrollView.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }

    func callAPIFavoriteBytes(currentFavorite: String) {
        if let bytesId: String = self.infoItemDetail.object(forKey: "id") as? String {
            self.mButtonFavorite.isUserInteractionEnabled = false

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "work_id": bytesId,
                "disable": currentFavorite
            ]

            APIBase.shareObject.callAPIFavoriteBytes(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    var newValue:String = "0"
                    if currentFavorite == "1" {
                        //Track Repro
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL, eventName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL_ACTION_UNFAVORITE)

                        self.mButtonFavorite.isSelected = false
                    } else {
                        //Track Repro
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL, eventName: ReproEvent.REPRO_SCREEN_BYTE_DETAIL_ACTION_FAVORITE)

                        self.mButtonFavorite.isSelected = true
                        newValue = "1"
                    }
                    self.infoItemDetail.setValue(newValue, forKey: "is_favorite")
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.mButtonFavorite.isUserInteractionEnabled = true
            })
        }
    }
}

extension DetailByteIntroductionViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayTitleSection1.count
        } else {
            return arrayTitleSection2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47 * scaleDisplay
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 47 * scaleDisplay ))
        headerview.backgroundColor = .clear
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 30 * scaleDisplay))
        let label = UILabel(frame: CGRect(x: 5 * scaleDisplay, y: 0, width: SIZE_WIDTH, height: 30 * scaleDisplay ))
        label.font = UIFont(name: "YuGo-Medium", size: 12 * scaleDisplay)
        label.textColor = grayColor
        contentView.backgroundColor = UIColor(red: 216, green: 216, blue: 216)
        if section == 0 {
            label.text = NSLocalizedString("detailbyteview_section_requireinfo", comment: "")
        } else {
            label.text = NSLocalizedString("detailbyteview_button_companyinfo", comment: "")
        }
        contentView.center = headerview.center
        headerview.addSubview(contentView)
        contentView.addSubview(label)
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ItemDetallByteCell = tableView.dequeueReusableCell(withIdentifier: "itemByteCell") as! ItemDetallByteCell
        
        if indexPath.section == 0 {
            cell.updateWith(title: arrayTitleSection1[indexPath.row], content: arrayContentSection1[indexPath.row])
        } else {
            cell.updateWith(title: arrayTitleSection2[indexPath.row], content: arrayContentSection2[indexPath.row])
        }
        return cell
    }
}

extension DetailByteIntroductionViewController : CreateFormJobByteViewControllerDelegate {
    func backToTop() {
        self.navigationController?.popViewController(animated: true)
    }
}

class ItemDetallByteCell : UITableViewCell {
    
    @IBOutlet weak var mTopConstraintTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintContentLabel: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintContentLabel: NSLayoutConstraint!
    
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mLabelTitle: UILabel!
    var scale : CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
    }
    
    private func setConstraintForViews() {
        self.mTopConstraintTitleLabel.constant = 8 * scale
        self.mBottomConstraintContentLabel.constant = 8 * scale
        self.mTopConstraintContentLabel.constant = 3 * scale
    }
    
    private func setFontForViews() {
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 12 * scale)
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 12 * scale)
    }
    
    func updateWith(title: String, content: String) {
        self.mLabelTitle.text = title.html2String
        if title == "URL" {
            let multipleAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor: UIColor.blue,
                NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue ]
            let myAttrString = NSAttributedString(string: content, attributes: multipleAttributes)
            self.mLabelContent.attributedText = myAttrString

            // Add tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapURL))
            self.mLabelContent.isUserInteractionEnabled = true
            self.mLabelContent.addGestureRecognizer(tap)
        }
        else{
            self.mLabelContent.text = content.html2String
        }
    }

    @objc func tapURL() {
        guard let url = URL(string: (self.mLabelContent.attributedText?.string)!) else {
            return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
