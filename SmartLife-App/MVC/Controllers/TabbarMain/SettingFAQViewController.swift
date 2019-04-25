//
//  SettingFAQViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/27/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class SettingFAQViewController: BaseViewController {
    @IBOutlet weak var searchBarCustomView: SearchBarCustomView!
    @IBOutlet weak var FAQTableView: UITableView!

    var listFAQBySection: [FAQGroupObject] = []
    var keywordSearching: String = ""
    var openingQuestion : FAQObject? = nil
    var previousIndexPath : IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarCustomView.delegate = self
        self.callAPIGetFAQ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FAQ, eventName: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Call API

    func callAPIGetFAQ() {
        self.listFAQBySection.removeAll()
        let params: [String: Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching
        ]

        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        APIBase.shareObject.callAPIGetFAQ(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body: NSDictionary = result?.object(forKey: "body") as? NSDictionary {
                    let arrays = body.object(forKey: "data") as? NSArray
                    if arrays != nil {
                        for object in arrays! {
                            if let dictObject: NSDictionary = object as? NSDictionary {

                                let faqObj = FAQObject(dict: dictObject)
                                var isHaveGroup : Bool  = false
                                for i in 0..<self.listFAQBySection.count{
                                    let faqGroup = self.listFAQBySection[i]
                                    if faqGroup.groupName == faqObj.groupName{
                                        self.listFAQBySection[i].listFAQ.append(faqObj)
                                        isHaveGroup = true
                                        break
                                    }
                                }

                                if !isHaveGroup {
                                    let faqNewGroup : FAQGroupObject = FAQGroupObject()
                                    faqNewGroup.groupName = faqObj.groupName
                                    faqNewGroup.listFAQ.append(faqObj)
                                    self.listFAQBySection.append(faqNewGroup)
                                }
                            }
                        }
                    }
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }

            self.FAQTableView.reloadData()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }
}

extension SettingFAQViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listFAQBySection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listFAQBySection[section].listFAQ.count*2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30*scaleDisplay
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView (frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 30*scaleDisplay))
        let lblTitle = UILabel (frame: CGRect(x: 14.5*scaleDisplay, y: 0, width: SIZE_WIDTH, height: 30*scaleDisplay))
        viewHeader.backgroundColor = UIColor.black
        lblTitle.backgroundColor = UIColor.black
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .left
        lblTitle.text = self.listFAQBySection[section].groupName
        lblTitle.font = UIFont (name: "YuGothic-Bold", size: 14.5*scaleDisplay)

        viewHeader.addSubview(lblTitle)
        return viewHeader
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row%2 == 0 {
            return UITableViewAutomaticDimension
        }
        else {
            if self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].isSelected == true {
                return UITableViewAutomaticDimension
            }
            else {
                return 0.1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row%2 == 0 {
            let cell:TopFAQTableCell = tableView.dequeueReusableCell(withIdentifier: "topFAQCell") as! TopFAQTableCell
            if self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].isSelected == true {
                cell.mImageArrow.image = #imageLiteral(resourceName: "arrow_up")
            } else {
                cell.mImageArrow.image = #imageLiteral(resourceName: "arrow_down")
            }
            cell.mLabelTitle.text = self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].question;
            return cell
        } else {
            let cell:ItemFAQTableCell = tableView.dequeueReusableCell(withIdentifier: "itemFAQCell") as! ItemFAQTableCell
            if self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].isSelected == true {
                if (self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].answerHTML == ""){
                    let htmlAnswer : String = self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].answer.html2String
                    self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].answerHTML = htmlAnswer
                    cell.mLabelItem.text = htmlAnswer
                }
                else {
                    cell.mLabelItem.text = self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].answerHTML
                }
            }
            else {
                cell.mLabelItem.text = nil
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row%2 == 0 {
            if self.openingQuestion != nil{
                self.openingQuestion!.isSelected = false
            }
            if !self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].isSelected {
                if self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2] == self.openingQuestion{
                    self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].isSelected = false
                    self.openingQuestion = nil
                }
                else {
                    self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2].isSelected = true
                    self.openingQuestion = self.listFAQBySection[indexPath.section].listFAQ[indexPath.row/2]
                }
            }
            let indexPathQuestion : IndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            let indexPathAnswer : IndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
            if self.previousIndexPath != nil{
                tableView.reloadRows(at: [self.previousIndexPath!, indexPathQuestion, indexPathAnswer], with: .fade)
            }
            else  {
                tableView.reloadRows(at: [indexPathQuestion, indexPathAnswer], with: .fade)
            }
            self.previousIndexPath = indexPathQuestion;
        }
    }
}

extension SettingFAQViewController: SearchBarCustomViewDelegate {
    func callAPISearchPointItems(keyword: String) {
        self.keywordSearching = keyword
        self.callAPIGetFAQ()
    }

    func callbackActionClickedButtonFilter() {
    }
}
