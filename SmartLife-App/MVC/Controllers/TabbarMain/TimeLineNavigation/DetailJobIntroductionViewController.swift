//
//  DetailJobIntroductionViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/29/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class DetailJobIntroductionViewController: BaseViewController {

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
    var arrayContentSection1: [String] = [String]()

    var isNeedShowNavTabbar: Bool = true

    var titleUpdate:String = NSLocalizedString("detailjobview_navbar", comment: "")
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
        self.callAPIGetDetailJob()
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        self.isNeedShowNavTabbar = true
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL, eventName:  nil)
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
        self.mButtonAccept.setTitle(NSLocalizedString("detailjobview_button_apply", comment: ""), for: .normal)
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
        self.mLabelTitle.text = self.infoItemDetail.object(forKey: "title") as? String

        // Content
        self.mLabelDescriptTop.text = nil

        // Favorite
        let isFavoriteString: String? = self.infoItemDetail.object(forKey: "is_favorited") as? String
        if isFavoriteString == "1" { self.mButtonFavorite.isSelected = true }
        else { self.mButtonFavorite.isSelected = false }

        // Image
        let imagePath: String? = self.infoItemDetail.object(forKey: "image_path") as? String
        self.mImageJob.setImageForm(urlString: imagePath, placeHolderImage: nil)
        if imagePath != nil && imagePath != "" {
            self.mImageJobHeightConstraint.constant = 184.0 * self.scaleDisplay
        }
        else {
            self.mImageJobHeightConstraint.constant = 0.0
        }


        // ContentDetail
        let contentDetail: String? = self.infoItemDetail.object(forKey: "content") as? String
        self.mLabelDetailDescription.text = contentDetail?.html2String

        self.view.layoutIfNeeded()
    }

    private func loadListDataForArrayContent1() {
        // Event date
        let eventDate: String = self.getStringDateFromTime(time: self.infoItemDetail.object(forKey: "event_date") as? String, with: "MM月dd日(E)")
        let eventStartTime: String = self.getStringDateFromTime(time: self.infoItemDetail.object(forKey: "event_start_time") as? String, with: "HH:mm")
        let eventEndTime: String = self.getStringDateFromTime(time: self.infoItemDetail.object(forKey: "event_end_time") as? String, with: "HH:mm")
        self.arrayContentSection1.append(eventDate + "   " + eventStartTime + "~" + eventEndTime)

        // Place
        if let place: String = self.infoItemDetail.object(forKey: "place") as? String, place != "" {
            self.arrayContentSection1.append(place)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // Fee
        if let fee: String = self.infoItemDetail.object(forKey: "fee") as? String, fee != "" {
            self.arrayContentSection1.append(fee)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // Participant
        if let participant: String = self.infoItemDetail.object(forKey: "participant") as? String, participant != "" {
            self.arrayContentSection1.append(participant)
        }
        else {
            self.arrayContentSection1.append("-")
        }

        // Condition
        if let condition: String = self.infoItemDetail.object(forKey: "condition") as? String, condition != "" {
            self.arrayContentSection1.append(condition)
        }
        else {
            self.arrayContentSection1.append("-")
        }
    }

    private func loadListDataFromInfoDetail() {
        self.arrayTitleSection1.removeAll()
        self.arrayContentSection1.removeAll()
        if let path = Bundle.main.path(forResource: "ListItemJob", ofType: "plist") {
            ////If your plist contain root as Dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let arraySection1 = dic["section1"] as? [String] {
                    self.arrayTitleSection1 = arraySection1
                }
                self.loadListDataForArrayContent1()
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

        self.mHeightConstraintTableList.constant = height
        self.view.layoutIfNeeded()
    }

    private func loadListTagInView() {
        // Tags
        self.arrayTag.removeAll()

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
        view.addSubview(label)
        
        return view
    }

    private func disableButtonAccept (){
        self.mButtonAccept.isEnabled = false
        self.mButtonAccept.setTitle(NSLocalizedString("detailjobview_button_applied", comment: ""), for: .normal)
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
        if let is_favorite = self.infoItemDetail.object(forKey: "is_favorited") as? String {
            self.callAPIFavoriteJobs(currentFavorite: is_favorite)
        }
    }
    
    @IBAction func clickedButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedButtonAccept(_ sender: Any) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL, eventName:  ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL_ACTION_APPLY)

        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        if let vc: CreateFormJobViewController = storyboard.instantiateViewController(withIdentifier: "CreateFormJobViewController") as? CreateFormJobViewController {
            vc.delegate = self

            if let jobsId: String = self.infoItemDetail.object(forKey: "id") as? String{
                vc.jobId = jobsId
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
                formatter.locale = Locale(identifier: "ja_JP")
                return formatter.string(from: date)
            }
            else { return "-" }
        }
        else { return "-" }
    }

    // MARK: - Call API
    
    func callAPIGetDetailJob() {
        if let jobId: String = self.infoItem.object(forKey: "id") as? String {
            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "id": jobId
            ]

            MBProgressHUD.showAdded(to: self.view, animated: true)
            APIBase.shareObject.callAPIGetDetailJob(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let dictDetail: NSDictionary = result?.value(forKey: "body") as? NSDictionary {
                        self.infoItemDetail = NSMutableDictionary(dictionary: dictDetail)

                        if let is_applied = self.infoItemDetail.value(forKey: "is_applied") as? String {
                            if is_applied == "1" {
                                self.disableButtonAccept()
                            }
                        }
                        // Disable button apply depend on is_avalable field
                        if let is_avalable = self.infoItemDetail.value(forKey: "is_available") as? Int {
                            if is_avalable == 0 {
                                self.mButtonAccept.isHidden = true
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

    func callAPIFavoriteJobs(currentFavorite: String) {
        if let jobsId: String = self.infoItemDetail.object(forKey: "id") as? String {
            self.mButtonFavorite.isUserInteractionEnabled = false

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "job_id": jobsId,
                "disable": currentFavorite
            ]

            APIBase.shareObject.callAPIFavoriteJobs(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    var newValue:String = "0"
                    if currentFavorite == "1" {
                        self.mButtonFavorite.isSelected = false
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL, eventName:  ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL_ACTION_UNFAVORITE)
                    } else {
                        self.mButtonFavorite.isSelected = true
                        newValue = "1"
                        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL, eventName:  ReproEvent.REPRO_SCREEN_JOB_INTRODUCTION_DETAIL_ACTION_FAVORITE)
                    }
                    self.infoItemDetail.setValue(newValue, forKey: "is_favorited")
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.mButtonFavorite.isUserInteractionEnabled = true
            })
        }
    }
}

extension DetailJobIntroductionViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitleSection1.count
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
        label.text = NSLocalizedString("detailjobview_section_requireinfo", comment: "")
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
        let cell:ItemDetallJobCell = tableView.dequeueReusableCell(withIdentifier: "itemJobCell") as! ItemDetallJobCell
        cell.updateWith(title: arrayTitleSection1[indexPath.row], content: arrayContentSection1[indexPath.row])
        return cell
    }
}

extension DetailJobIntroductionViewController : CreateFormJobViewControllerDelegate {
    func backToTop() {
        self.navigationController?.popViewController(animated: true)
    }
}


class ItemDetallJobCell : UITableViewCell {
    
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
