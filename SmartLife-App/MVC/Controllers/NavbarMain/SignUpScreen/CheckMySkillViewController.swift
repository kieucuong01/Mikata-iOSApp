//
//  CheckMySkillViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class CheckMySkillViewController: BaseViewController {

    @IBOutlet weak var mTitleNavBar: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mLabelTipCheckSkill: UILabel!
    @IBOutlet weak var nextButtonView: UIView!

    @IBOutlet weak var mImagePageSkill: UIImageView!
    @IBOutlet weak var scrollViewListContent: UIScrollView!
    @IBOutlet weak var mTableListSkill: UITableView!
    @IBOutlet weak var mCollectionListSkill: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!

    // Constraint
    @IBOutlet weak var view1TopConstraint: NSLayoutConstraint!

    var lastYContentOffSet: CGFloat = 0.0
    var isShowFromSetting:Bool = false

    var dictSkillPageOne:[String:Any?] = [String:Any?]()
    var arrGroupsPageOne:[MySkillInfo] = [MySkillInfo]()
    var dictSkillPageTwo:[String:Any?] = [String:Any?]()
    var arrGroupsPageTwo:[MySkillInfo] = [MySkillInfo]()

    var isSkipPageOne: Bool = false
    var dictUpdateSkills:NSMutableDictionary = NSMutableDictionary()

    private var viewNote:NoticeSelectSkillView = {
        let view:NoticeSelectSkillView = (Bundle.main.loadNibNamed("NoticeSelectSkillView", owner: self, options: nil))?[0] as! NoticeSelectSkillView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setFontForViews()
        self.setPropertiesForView()
        self.createSubview()
        self.callAPIGetListSkillUser()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        if let layout = self.mCollectionListSkill.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_1, eventName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Public Methods

    func moveHeaderView(_ distance: CGFloat) {
        let minDistance: CGFloat = -GlobalMethod.screenSize.width * (115.0 / 375.0)
        if self.view1TopConstraint != nil {
            var realDistance: CGFloat = self.view1TopConstraint.constant + distance
            if realDistance > 0.0 { realDistance = 0.0 }
            else if realDistance < minDistance { realDistance = minDistance }
            self.view1TopConstraint.constant = realDistance
        }
    }

    func moveUpHeaderView() {
        let minDistance: CGFloat = -GlobalMethod.screenSize.width * (115.0 / 375.0)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view1TopConstraint.constant = minDistance
            self.view.layoutIfNeeded()
        })
    }

    func moveDownHeaderView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view1TopConstraint?.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    // MARK: - Private Methods

    private func setLanguageForView(){
        self.mTitleNavBar.text = NSLocalizedString("checkmyskillview_label_top", comment: "")
        self.mLabelTipCheckSkill.text = NSLocalizedString("checkmyskillview_label_tip_checkskill", comment: "")

        self.doneButton.setTitle(NSLocalizedString("checkmyskillview_button_next", comment: ""), for: UIControlState.normal)
    }
    private func setFontForViews() {
        self.mLabelTipCheckSkill.font = UIFont(name: self.mLabelTipCheckSkill.font.fontName, size : 13.0 * scaleDisplay)
    }

    private func createSubview() {
        self.view.addSubview(self.viewNote)
    }

    private func setPropertiesForView() {
        self.mCollectionListSkill.register(UINib.init(nibName: "CheckSkillTypeMultiCell", bundle: nil), forCellWithReuseIdentifier: "checkMultiCell");
        self.mCollectionListSkill.register(HeaderViewForCheckSkill.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCollectionView")
        self.viewNote.delegate = self
        self.nextButton.tintColor = UIColor(red: 114, green: 84, blue: 53)
        self.backButton.tintColor = UIColor(red: 114, green: 84, blue: 53)
//        self.nextButton.imageEdgeInsets = UIEdgeInsetsMake(15*scaleDisplay, 3*scaleDisplay, 15*scaleDisplay, 0)
//        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(15*scaleDisplay, 0, 15*scaleDisplay, 3*scaleDisplay)

        if !isShowFromSetting {
            self.backButtonView.isHidden = true
            self.backImage.isHidden = false
            self.backButton.setImage(UIImage(named:""), for: .normal)
            self.backButton.setTitle(NSLocalizedString("checkmyskillview_button_back", comment: ""), for: .normal)
        }
    }

    @IBAction func clickButtonSentAnswer(_ sender: Any) {
        if self.scrollViewListContent.contentOffset.x == 0 {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_1, eventName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_ACTION_NEXT)
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_2, eventName: nil)

            if !isShowFromSetting {
                self.nextButtonView.isHidden = true
                self.backButtonView.isHidden = false
            }
            else {
                self.nextImage.isHidden = true
                self.nextButton.setImage(UIImage(named:"icon_close_brown"), for: .normal)
                self.nextButton.setTitle("", for: .normal)
                self.backImage.isHidden = false
                self.backButton.setImage(UIImage(named:""), for: .normal)
                self.backButton.setTitle(NSLocalizedString("checkmyskillview_button_back", comment: ""), for: .normal)
            }
            self.doneButton.setTitle(NSLocalizedString("checkmyskillview_button_done", comment: ""), for: UIControlState.normal)
            self.scrollViewListContent.setContentOffset(CGPoint(x: 320 * scaleDisplay, y: 0), animated: true)
            self.mImagePageSkill.image = #imageLiteral(resourceName: "img_second_progress")
            self.isSkipPageOne = false

        } else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_2, eventName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_ACTION_DONE)

            self.fillterSkillGroup()
            self.callAPIUpdateSkillUserChanged()
        }
    }

    private func callAPIGetListSkillUser() {
        let param:[String:Any] = ["login_user_id":PublicVariables.userInfo.m_id,"get_all_skills":"1"]
        APIBase.shareObject.callAPIGetMyPageSkill(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.value(forKey: "body") as? NSDictionary {

                    if let skills = body.value(forKey: "skills") as? NSArray {
                        if skills.count > 0 {
                            self.sortListSkill(arrays:skills)
                            self.mTableListSkill.reloadData()
                            self.mCollectionListSkill.reloadData()
                        }
                    }
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    private func callAPIUpdateSkillUserChanged() {
        if dictUpdateSkills.allKeys.count > 0 {
            var str = ""
            var num = 0
            for  key in dictUpdateSkills.allKeys {
                num = num + 1
                str = str + "" + (key as! String) + ":" + (dictUpdateSkills[key] as! String) + ""
                if num < dictUpdateSkills.allKeys.count {
                    str = str + ","
                }
            }
            str = str + ""
            let param:[String:Any] = ["data":str,"user_id":PublicVariables.userInfo.m_id,"ios":"1"]
            APIBase.shareObject.callAPIUpdateSkillUser(params: param) { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    self.viewNote.changeToSuccessView()
                    self.viewNote.isHidden = false
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } else {
            self.viewNote.changeToSuccessView()
            self.viewNote.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    private func fillterSkillGroup() {
        self.dictUpdateSkills.removeAllObjects()

        for skillGroup in self.arrGroupsPageOne {
            let arrs:[MySkillInfo] = self.dictSkillPageOne[skillGroup.m_id_skill_group] as! [MySkillInfo]
            for  skill in arrs {
                if skill.m_skill_value.isEmpty == false {
                    dictUpdateSkills.setValue(skill.m_skill_value, forKey: skill.m_id_skill)
                }
            }
        }

        for  skillGroup in self.arrGroupsPageTwo{
            let arrs:[MySkillInfo] = self.dictSkillPageTwo[skillGroup.m_id_skill_group] as! [MySkillInfo]
            for  skill in arrs {
                if  skill.m_skill_value.isEmpty == false {
                    dictUpdateSkills.setValue(skill.m_skill_value, forKey: skill.m_id_skill)
                }
            }
        }
    }

    private func sortListSkill(arrays:NSArray) {
        for i in 0 ... arrays.count - 1 {
            let objSkill = MySkillInfo(dict: arrays[i] as! NSDictionary)
            // Devine page
            if objSkill.m_page_skill_group_setting == "1" {
                //Page 1
                //Key group
                let key = objSkill.m_id_skill_group
                if var arrs:[MySkillInfo] = dictSkillPageOne[key] as? [MySkillInfo] {
                    //Key exits
                    arrs.append(objSkill)
                    dictSkillPageOne[key] = arrs
                } else {
                    //New key
                    var arrs:[MySkillInfo] = [MySkillInfo]()
                    arrs.append(objSkill)
                    arrGroupsPageOne.append(objSkill)
                    dictSkillPageOne[key] = arrs;
                }
            } else {
                //Page 2
                //Key group
                let key = objSkill.m_id_skill_group
                if var arrs:[MySkillInfo] = dictSkillPageTwo[key] as? [MySkillInfo] {
                    //Key exits
                    arrs.append(objSkill)
                    dictSkillPageTwo[key] = arrs
                } else {
                    //New key
                    var arrs:[MySkillInfo] = [MySkillInfo]()
                    arrs.append(objSkill)
                    arrGroupsPageTwo.append(objSkill)

                    dictSkillPageTwo[key] = arrs;
                }
            }
        }
    }

    @IBAction func clickBackButton(_ sender: UIButton) {
        if self.scrollViewListContent.contentOffset.x == 0{
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_1, eventName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_ACTION_FORWARD)

            if self.isShowFromSetting == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_2, eventName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_ACTION_FORWARD)
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_1, eventName: nil)

            if !isShowFromSetting {
                self.backButtonView.isHidden = true
                self.nextButtonView.isHidden = false
            }
            else{
                self.backImage.isHidden = true
                self.backButton.setImage(UIImage(named:"icon_close_brown"), for: .normal)
                self.backButton.setTitle("", for: .normal)
                self.nextImage.isHidden = false
                self.nextButton.setImage(UIImage(named:""), for: .normal)
                self.nextButton.setTitle(NSLocalizedString("checkmyskillview_button_next", comment: ""), for: .normal)
            }

            self.doneButton.setTitle(NSLocalizedString("checkmyskillview_button_next", comment: ""), for: UIControlState.normal)
            self.mTableListSkill.contentOffset.y = 0.0
            self.moveDownHeaderView()
            self.lastYContentOffSet = 0.0
            self.mImagePageSkill.image = #imageLiteral(resourceName: "img_first_progress")

            self.scrollViewListContent.setContentOffset(CGPoint(x: 0.0, y: 0), animated: true)
        }
    }

    @IBAction func clickSkipScreen(_ sender: Any) {
        if self.scrollViewListContent.contentOffset.x == 0 {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_1, eventName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_ACTION_NEXT)
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_2, eventName: nil)

            if !isShowFromSetting {
                self.nextButtonView.isHidden = true
                self.backButtonView.isHidden = false
            }
            else {
                self.nextImage.isHidden = true
                self.nextButton.setImage(UIImage(named:"icon_close_brown"), for: .normal)
                self.nextButton.setTitle("", for: .normal)
                self.backImage.isHidden = false
                self.backButton.setImage(UIImage(named:""), for: .normal)
                self.backButton.setTitle(NSLocalizedString("checkmyskillview_button_back", comment: ""), for: .normal)
            }

            self.doneButton.setTitle(NSLocalizedString("checkmyskillview_button_done", comment: ""), for: UIControlState.normal)
            self.mCollectionListSkill.contentOffset.y = 0.0
            self.moveDownHeaderView()
            self.lastYContentOffSet = 0.0
            self.mImagePageSkill.image = #imageLiteral(resourceName: "img_second_progress")
            self.isSkipPageOne = false

            self.scrollViewListContent.setContentOffset(CGPoint(x: 320 * scaleDisplay, y: 0), animated: true)
        }
        else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_PAGE_2, eventName: ReproEvent.REPRO_SCREEN_SKILL_CHECK_ACTION_NEXT)

            if self.isShowFromSetting == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension CheckMySkillViewController:NoticeSelectSkillViewDelegate {
    func finishedProgressCheckSkill() {
        if self.isShowFromSetting == true {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let vcLogin: TabbarMainViewController = storyboard.instantiateViewController(withIdentifier: "tabbarMainVC") as? TabbarMainViewController {
                self.navigationController?.pushViewController(vcLogin, animated: true)
            }
        }
    }
}

extension CheckMySkillViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrGroupsPageOne.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mySkill = self.arrGroupsPageOne[section]
        let arrs:[MySkillInfo] = self.dictSkillPageOne[mySkill.m_id_skill_group] as! [MySkillInfo]
        return arrs.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26.0 * scaleDisplay + 14.0 * scaleDisplay
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0 * scaleDisplay
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 20.0 * scale))
        view.backgroundColor = .white
        return view
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mySkill = self.arrGroupsPageOne[section]
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: SIZE_WIDTH, height: 40.0 * scaleDisplay))
        headerView.backgroundColor = .white

        // Title View
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 26.0 * scaleDisplay))
        titleView.backgroundColor = UIColor(red: 190, green: 190, blue: 190)
        let label = UILabel(frame: CGRect(x: 14.0 * scaleDisplay, y: 0.0, width: SIZE_WIDTH, height: 26.0 * scaleDisplay))
        label.font = UIFont(name: "YuGothic-Bold", size: 12.0 * scaleDisplay)
        label.textColor = .white
        label.text = mySkill.m_name_skill_group
        headerView.addSubview(titleView)
        titleView.addSubview(label)

        // Description Labels View
        let descriptionLabelWidth: CGFloat = SIZE_WIDTH * 62.0/375.0
        let descriptionLabelHeight: CGFloat = 13.0 * scaleDisplay
        let descriptionLabelY: CGFloat = 27.0 * scaleDisplay

        // Description LabelA
        let labelA = UILabel(frame: CGRect(x: SIZE_WIDTH - 10.0 - (3.0 * descriptionLabelWidth), y: descriptionLabelY, width: descriptionLabelWidth, height: descriptionLabelHeight))
        labelA.font = self.mLabelTipCheckSkill.font.withSize(11.0 * scaleDisplay)
        labelA.textColor = .black
        labelA.textAlignment = .center
        labelA.text = "未経験"
        headerView.addSubview(labelA)

        // Description LabelB
        let labelB = UILabel(frame: CGRect(x: SIZE_WIDTH - 10.0 - (2.0 * descriptionLabelWidth), y: descriptionLabelY, width: descriptionLabelWidth, height: descriptionLabelHeight))
        labelB.font = self.mLabelTipCheckSkill.font.withSize(11.0 * scaleDisplay)
        labelB.textColor = .black
        labelB.textAlignment = .center
        labelB.text = "1〜3年"
        headerView.addSubview(labelB)

        // Description LabelC
        let labelC = UILabel(frame: CGRect(x: SIZE_WIDTH - 10.0 - descriptionLabelWidth, y: descriptionLabelY, width: descriptionLabelWidth, height: descriptionLabelHeight))
        labelC.font = self.mLabelTipCheckSkill.font.withSize(11.0 * scaleDisplay)
        labelC.textColor = .black
        labelC.textAlignment = .center
        labelC.text = "3年以上"
        headerView.addSubview(labelC)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * scaleDisplay
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CheckSkillTypeSelectionCell? = tableView.dequeueReusableCell(withIdentifier: "checkTypeSelectionCell") as? CheckSkillTypeSelectionCell
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("CheckSkillTypeSelectionCell", owner: self, options: nil))![0] as? CheckSkillTypeSelectionCell
        }
        cell!.delegate = self
        cell!.indexPath = indexPath

        let myKey = self.arrGroupsPageOne[indexPath.section]
        let arrs:[MySkillInfo] = self.dictSkillPageOne[myKey.m_id_skill_group] as! [MySkillInfo]
        let mySkill = arrs[indexPath.row]
        cell!.mLabelTitle.text = mySkill.m_name_skill
        cell!.updateButtonAnswers(strAnswer: mySkill.m_skill_value)
        cell?.updateViewTitle(isHideTitle: true)
        return cell!
    }
}

extension CheckMySkillViewController: CheckSkillTypeSelectionCellDelegate {
    func clickedButtonCheckSkill(sender: CheckSkillTypeSelectionCell, strAnswer: String, index: IndexPath) {
        let myKey = self.arrGroupsPageOne[index.section]
        var arrs:[MySkillInfo] = self.dictSkillPageOne[myKey.m_id_skill_group] as! [MySkillInfo]
        let mySkill = arrs[index.row]
        mySkill.m_skill_value = strAnswer
        arrs[index.row] = mySkill
        self.dictSkillPageOne[myKey.m_id_skill_group] = arrs
    }
}

extension CheckMySkillViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.arrGroupsPageTwo.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let mySkill = self.arrGroupsPageTwo[section]
        let arrs:[MySkillInfo] = self.dictSkillPageTwo[mySkill.m_id_skill_group] as! [MySkillInfo]
        return arrs.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SIZE_WIDTH, height: 26 * scaleDisplay)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let mySkill = self.arrGroupsPageTwo[indexPath.section]
            let reusableView:HeaderViewForCheckSkill = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionView", for: indexPath) as! HeaderViewForCheckSkill
            reusableView.mLabelTitle.text = mySkill.m_name_skill_group
            return reusableView
        }
        return  UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell:CheckSkillTypeMultiCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "checkMultiCell", for: indexPath) as? CheckSkillTypeMultiCell

        let myKey = self.arrGroupsPageTwo[indexPath.section]
        let arrs:[MySkillInfo] = self.dictSkillPageTwo[myKey.m_id_skill_group] as! [MySkillInfo]
        let mySkill = arrs[indexPath.row];
        cell!.mLabelTitle.text = mySkill.m_name_skill
        if mySkill.m_skill_value.isEmpty {
            cell!.mImageCheckBox.image = #imageLiteral(resourceName: "ic_multi_check")
        } else {
            cell!.mImageCheckBox.image = #imageLiteral(resourceName: "ic_multi_check_selected")
        }
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.0, height: 35 * scaleDisplay)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 7 * scaleDisplay, left: 0 * scaleDisplay, bottom: 0 * scaleDisplay, right: 0 * scaleDisplay)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 * scaleDisplay
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 * scaleDisplay
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:CheckSkillTypeMultiCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "checkMultiCell", for: indexPath) as? CheckSkillTypeMultiCell


        let myKey = self.arrGroupsPageTwo[indexPath.section]
        var arrs:[MySkillInfo] = self.dictSkillPageTwo[myKey.m_id_skill_group] as! [MySkillInfo]
        let mySkill = arrs[indexPath.row]
        if mySkill.m_skill_value.isEmpty == true {
            mySkill.m_skill_value = "1"
            cell!.mImageCheckBox.image = #imageLiteral(resourceName: "ic_multi_check_selected")
        } else {
            mySkill.m_skill_value = ""
            cell!.mImageCheckBox.image = #imageLiteral(resourceName: "ic_multi_check")
        }
        collectionView.reloadItems(at: [indexPath])
        arrs[indexPath.row] = mySkill
        self.dictSkillPageOne[myKey.m_id_skill_group] = arrs
    }
}

// MARK: - UIScrollViewDelegate

extension CheckMySkillViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (scrollView == self.mTableListSkill) || (scrollView == self.mCollectionListSkill) {
            self.view2.isUserInteractionEnabled = false
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView == self.mTableListSkill) || (scrollView == self.mCollectionListSkill) {
            if decelerate == false {
                self.view2.isUserInteractionEnabled = true
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.mTableListSkill) || (scrollView == self.mCollectionListSkill) {
            self.view2.isUserInteractionEnabled = true
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.mTableListSkill) || (scrollView == self.mCollectionListSkill) {
            let maxContentOffset: CGFloat = scrollView.contentSize.height - scrollView.bounds.height
            if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= maxContentOffset {
                let distance: CGFloat = -(scrollView.contentOffset.y - self.lastYContentOffSet) / 3.0
                self.moveHeaderView(distance)
                self.lastYContentOffSet = scrollView.contentOffset.y
            }
        }
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if (scrollView == self.mTableListSkill) || (scrollView == self.mCollectionListSkill) {
            self.moveDownHeaderView()
            self.lastYContentOffSet = 0.0
        }
    }
}

class HeaderViewForCheckSkill: UICollectionReusableView {

    var mLabelTitle:UILabel = {
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel(frame: CGRect(x: 14 * scale, y: 0, width: SIZE_WIDTH, height: 26 * scale))
        label.font = UIFont(name: "YuGothic-Bold", size: 12 * scale)
        label.textColor = .white
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 190, green: 190, blue: 190)
        self.createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.addSubview(self.mLabelTitle)
    }
    
}
