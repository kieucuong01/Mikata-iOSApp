//
//  PointPassbookViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol PointPassbookViewControllerDelegate {
    func mButtonSelectTouchUpInside()
}
class PointPassbookViewController: BaseViewController {
    //Set constraint variable and label
    @IBOutlet weak var mTopConstraintLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonSelectMonth: NSLayoutConstraint!
    @IBOutlet weak var mHeightConstraintIconArrowDown: NSLayoutConstraint!
    @IBOutlet weak var mWidthConstraintIconArrowDown: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintButtonSelect: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonSelect: NSLayoutConstraint!
    @IBOutlet weak var mHeightConstraintForTableView: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintForImageViewIcon: NSLayoutConstraint!
    
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelTipRight: UILabel!
    @IBOutlet weak var mLabelTipLeft: UILabel!
    
    @IBOutlet weak var mTableView: UITableView!
    //Avariable allow change value
    
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mContentViewOfScrollView: UIView!
    @IBOutlet weak var viewForegroundPickerView: UIView!
    @IBOutlet weak var mViewContentPickerView: UIView!
    @IBOutlet weak var mPickerView: UIPickerView!
    @IBOutlet weak var mLabelPoint: UILabel!
    @IBOutlet weak var mLabelDateSelect: UILabel!
    @IBOutlet weak var mButtonSelect: UIButton!
    @IBOutlet weak var mButtonPickerDate: UIView!

    // MARK:- Delegate
    var delegate:PointPassbookViewControllerDelegate?

    var arrayRawMonth = ["01月","02月","03月","04月","05月","06月","07月","08月",
                      "09月","10月","11月","12月"]
    var arrayMonth:[String] = [String]()
    var arrayYear:[String] = [String]()
    var arrayList: NSMutableArray = NSMutableArray()

    var selectMonth:Int = 0
    var selectYear:Int = 0
    var shouldIncreaseContentSize:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setFontForViews()
        self.setConstraintForViews()
        self.setPropertiesForViews()
        self.loadListDataFromPlist()
        self.createListYearWithCurrentYear()
        self.setActionForObject()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_PASSBOOK, eventName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    //MARK : - Private method
    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("pointpassbookview_navbar", comment: "")
        self.mLabelTipRight.text = NSLocalizedString("pointpassbookview_label_tipright", comment: "")
        self.mLabelTipLeft.text = NSLocalizedString("pointpassbookview_label_tipleft", comment: "")

        self.mButtonSelect.setTitle(NSLocalizedString("pointpassbookview_button_select", comment: ""), for: .normal)
    }

    private func setConstraintForViews() {
        self.mTopConstraintLabelTitle.constant = 28 * scaleDisplay
        self.mTopConstraintButtonSelectMonth.constant = 6 * scaleDisplay
        self.mWidthConstraintIconArrowDown.constant = 10 * scaleDisplay
        self.mHeightConstraintIconArrowDown.constant = 6 * scaleDisplay
        self.mTopConstraintButtonSelectMonth.constant = 19 * scaleDisplay
        self.mTopConstraintTableView.constant = 14 * scaleDisplay
        self.mTopConstraintButtonSelect.constant = 34 * scaleDisplay
        self.mBottomConstraintButtonSelect.constant = 20.0
        self.mTrailingConstraintForImageViewIcon.constant = 10 * scaleDisplay
    }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scaleDisplay)
        self.mLabelTipLeft.font =  UIFont(name: self.mLabelTipLeft.font.fontName, size: 14 * scaleDisplay)
        self.mLabelTipRight.font =  UIFont(name: self.mLabelTipRight.font.fontName, size: 14 * scaleDisplay)
        self.mLabelPoint.font =  UIFont(name: self.mLabelTipLeft.font.fontName, size: 30 * scaleDisplay)
        self.mLabelDateSelect.font = UIFont(name: self.mLabelDateSelect.font.fontName, size: 14 * scaleDisplay)
        self.mButtonSelect.titleLabel!.font = UIFont(name: self.mButtonSelect.titleLabel!.font.fontName, size: 14 * scaleDisplay)
    }

    private func setActionForObject(){
        self.mButtonSelect.addTarget(self, action: #selector(self.mButtonSelectTouchUpInside), for: .touchUpInside)
    }
    
    private func getHeightForString(string:String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 136 * scaleDisplay, height: 0 ))
        label.numberOfLines = 0
        label.text = string
        label.font = UIFont(name: "YuGo-Medium", size: 10 * scaleDisplay)
        label.sizeToFit()
        return label.frame.size.height + 6

    }
    
    private func loadListDataFromPlist() {
        if let pointInt: Int = Int(PublicVariables.userInfo.m_point) {
            self.mLabelPoint.text  = pointInt.convertToStringDecimalFormat()
        }

        let date = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let result = formatter.string(from: date)
        self.callAPIPointHistory(month: result, page : 1)

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy年MM月"
        formatter2.locale = Locale(identifier: "en_US_POSIX")
        self.mLabelDateSelect.text = formatter2.string(from: date)

        self.mTableView.reloadData()
    }

    private func callAPIPointHistory(month: String, page : Int) {
        var height:CGFloat = 0.0

        self.mHeightConstraintForTableView.constant = height + 36 * scaleDisplay

        let params: [String : Any] = [
            "login_user_id": PublicVariables.userInfo.m_id,
            "month": month,
            "page": page,
            "limit": "10"
        ]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIPointHistory(params: params, completionHandler: { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil && arrays?.count != 0{

                    self.arrayList.addObjects(from: arrays as! [Any])

                    for i in 0..<self.arrayList.count{
                        let dict = self.arrayList[i] as! NSDictionary
                        if let content : String = (dict.object(forKey: "point_item_name") as? String){
                            height += content.height(withConstrainedWidth: 125 * GlobalMethod.displayScale, font: UIFont(name: "YuGothic-Bold", size: 10.0 * GlobalMethod.displayScale)!) + 3
                        }
                        else if let content2 : String = (dict.object(forKey: "point_get_name") as? String){
                            height += content2.height(withConstrainedWidth: 125 * GlobalMethod.displayScale, font: UIFont(name: "YuGothic-Bold", size: 10.0 * GlobalMethod.displayScale)!) + 3
                        }
                        else {
                            //Font scale for device
                            height += 10 * self.scaleDisplay + 6
                        }
                    }

                    self.mTableView.reloadData()
                    self.mHeightConstraintForTableView.constant = self.mHeightConstraintForTableView.constant + height
                    self.mTableView.layoutIfNeeded()

                    if(self.arrayList.count % 10 == 0 && self.arrayList.count > 0){
                        self.callAPIPointHistory(month: month, page: page+1)
                    }

                }
            }
            else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    private func createListYearWithCurrentYear() {
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.dateComponents([.month,.year], from: Date())
        let year = component.year
        let month = component.month
        self.selectMonth = month! - 1
        self.selectYear = 0
        for i in 0 ... 5 {
            arrayYear.append(String(year! - i))
        }
        
        for i in 0 ... self.selectMonth {
           arrayMonth.append(arrayRawMonth[i])
        }
    }
    
    private func setPropertiesForViews() {
        self.mTableView.register(UINib.init(nibName: "PointPassbookCell", bundle: nil), forCellReuseIdentifier: "pointPassbookCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PointPassbookViewController.hideForegroundContainPickerView))
        self.viewForegroundPickerView.addGestureRecognizer(tap)
        
        self.mButtonSelect.layer.cornerRadius = 4 * scaleDisplay
        self.mButtonPickerDate.layer.cornerRadius = 4 * scaleDisplay
        
    }

    //MARK ACTION
    @objc func mButtonSelectTouchUpInside() {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_PASSBOOK, eventName: ReproEvent.REPRO_SCREEN_POINT_PASSBOOK_ACTION_EXCHANGE_POINT)

        self.dismiss(animated: true, completion: nil)
        self.delegate?.mButtonSelectTouchUpInside()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func hideForegroundContainPickerView() {
        self.viewForegroundPickerView.isHidden = true
        self.mViewContentPickerView.isHidden = true
        if shouldIncreaseContentSize == true {
            self.mScrollView.isScrollEnabled = false
            self.mScrollView.contentSize.height = self.mScrollView.contentSize.height - 50 * scaleDisplay
        }
    }
    
    func showForegroundContainPickerView() {
        
        self.viewForegroundPickerView.isHidden = false
        self.mViewContentPickerView.isHidden = false
        if shouldIncreaseContentSize == true {
            self.mScrollView.isScrollEnabled = false
            self.mScrollView.contentSize.height = self.mScrollView.contentSize.height + 50 * scaleDisplay
        }
    }
    
    @IBAction func clickCancelButton(_ sender: Any) {
        self.hideForegroundContainPickerView()
    }
    
    @IBAction func clickDoneButton(_ sender: Any) {
        self.hideForegroundContainPickerView()
        self.selectYear = self.mPickerView.selectedRow(inComponent: 0)
        self.selectMonth = self.mPickerView.selectedRow(inComponent: 1)
        let month = self.mPickerView.selectedRow(inComponent: 1)
        let year = self.mPickerView.selectedRow(inComponent: 0)
        self.mLabelDateSelect.text = String(format: "%@年%02d月", arrayYear[year], month + 1)
        self.arrayList.removeAllObjects();
        self.callAPIPointHistory(month: String(format: "%@%02d", arrayYear[year], month + 1), page : 1)
    }

    @IBAction func clickedButtonSelectDate(_ sender: Any) {
        self.mPickerView.selectRow(self.selectYear, inComponent:0, animated:false)
        self.mPickerView.selectRow(self.selectMonth, inComponent:1, animated:false)

        self.showForegroundContainPickerView()
    }
    @IBAction func clickedButtonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension PointPassbookViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28 * scaleDisplay
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8 * scaleDisplay
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let view =  Bundle.main.loadNibNamed("PointPassbookHeaderView", owner: self, options: nil)?[0] as? PointPassbookHeaderView {
            view.emptyContent()
            return view
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view =  Bundle.main.loadNibNamed("PointPassbookHeaderView", owner: self, options: nil)?[0] as? PointPassbookHeaderView {
            return view
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointPassbookCell") as? PointPassbookCell
        let dict = arrayList[indexPath.row] as! NSDictionary

        //Date Title
        if let strTimeString = dict.object(forKey: "created") as? String {
            let timestamp = Double(strTimeString)
            let date = Date(timeIntervalSince1970: timestamp!)
            let formaterDate = DateFormatter()
            formaterDate.dateFormat = "yyyy/MM/dd"
            formaterDate.locale = Locale(identifier: "en_US_POSIX")
            cell?.mLabelDate.text = formaterDate.string(from: date)
        } else {
            cell?.mLabelDate.text = "-"
        }
        var content = ""
        if ((dict.object(forKey: "point_item_name") as? String) != nil) {
            content = (dict.object(forKey: "point_item_name") as? String)!
        }
        else{
            content = (dict.object(forKey: "point_get_name") as? String)!
        }
        cell?.mLabelContent.text = content

        if let point: Int = Int((dict.object(forKey: "point") as? String)!) {
            cell?.mLabelBalancesOfPayment.text = point.convertToStringDecimalFormat()
        }

        if let remaining_points: Int = Int((dict.object(forKey: "remaining_points") as? String)!) {
            cell?.mLabelBalance.text = remaining_points.convertToStringDecimalFormat()
        }

        let strValue = dict.object(forKey: "point") as? String
        if let value = Double(strValue!) {
            if value < 0 {
                cell?.mLabelBalancesOfPayment.textColor = GlobalMethod.hexStringToUIColor(hex: "#FE3636")
            } else {

                cell?.mLabelBalancesOfPayment.textColor = UIColor.black
            }
        }
        return cell!
    }
    
}

extension PointPassbookViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return arrayMonth.count
        }
        return arrayYear.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return arrayMonth[row]
        } else {
            return String(format : "%@年",arrayYear[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            print("Month \(row)")
        } else {
            arrayMonth.removeAll()
            if row == 0 {
                for i in 0 ... selectMonth {
                    arrayMonth.append(arrayRawMonth[i])
                }
            } else if row == arrayYear.count - 1 {
                for i in selectMonth ..< arrayRawMonth.count {
                    arrayMonth.append(arrayRawMonth[i])
                }
            } else {
                for i in 0 ..< arrayRawMonth.count {
                    arrayMonth.append(arrayRawMonth[i])
                }
            }
            pickerView.reloadComponent(1)
        }
    }
}
