//
//  MyPageSkillViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/24/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class MyPageSkillViewController: BaseViewController {

    @IBOutlet weak var mLabelTittle: UILabel!
    @IBOutlet weak var mLabelCategory: UILabel!
    
    @IBOutlet weak var mButtonMyPage: UIButton!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var dictSkill:[String:Any?] = [String:Any?]()
    var arrGroups:[MySkillInfo] = [MySkillInfo]()
    var indexSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPropertiesForViews()
        self.setFontForViews()
        self.setLanguageForView()
        self.btnBack.isHidden = true
        self.btnNext.isHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        self.dictSkill.removeAll()
        self.arrGroups.removeAll()
        self.callAPIGetListSkillUser()

        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_MY_SKILL, eventName: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }

    private func setLanguageForView(){
        self.mLabelTittle.text = NSLocalizedString("mypageskillview_navbar", comment: "")

        self.mButtonMyPage.setTitle(NSLocalizedString("mypageskillview_button_mypage", comment: ""), for: .normal)
    }

    private func setFontForViews() {
        self.mLabelTittle.font = UIFont(name: self.mLabelTittle.font.fontName, size: 12 * scaleDisplay)
        self.mLabelCategory.font = UIFont(name: self.mLabelTittle.font.fontName, size: 12 * scaleDisplay)
        self.mButtonMyPage.titleLabel?.font = UIFont(name: (self.mButtonMyPage.titleLabel?.font.fontName)!, size: 12 * scaleDisplay)
    }

    @IBAction func clickedButtonSkill(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_MY_SKILL, eventName: ReproEvent.REPRO_SCREEN_MY_SKILL_ACTION_EDIT)

        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let checkMyPage:CheckMySkillViewController  = storyboard.instantiateViewController(withIdentifier: "checkMySkillVC") as! CheckMySkillViewController
        checkMyPage.isShowFromSetting = true
        self.navigationController?.present(checkMyPage, animated: true, completion: { 
            
        })
    }
    @IBAction func clickedButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickedButtonPrevious(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_MY_SKILL, eventName: ReproEvent.REPRO_SCREEN_MY_SKILL_ACTION_FORWARD)

        let newOffset = self.mCollectionView.contentOffset.x - SIZE_WIDTH

        if newOffset < 0 {
            self.mCollectionView.contentOffset.x = 0
            
        } else {
           self.mCollectionView.contentOffset.x = newOffset
            
        }
    }
    @IBAction func clickedButtonNext(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_MY_SKILL, eventName: ReproEvent.REPRO_SCREEN_MY_SKILL_ACTION_NEXT)

        let newOffset = self.mCollectionView.contentOffset.x + SIZE_WIDTH
        
        if newOffset >  (SIZE_WIDTH * CGFloat(arrGroups.count - 1))  {
            self.mCollectionView.contentOffset.x =
                SIZE_WIDTH * CGFloat(arrGroups.count - 1)
            
            
        } else {
            self.mCollectionView.contentOffset.x = newOffset
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func getPropertiesForViews() {
        self.mCollectionView.register(UINib.init(nibName: "PageSkillCell", bundle: nil), forCellWithReuseIdentifier: "pageSkillCell")
    }
    
    private func callAPIGetListSkillUser() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param:[String:Any] = ["user_id":PublicVariables.userInfo.m_id,"get_all_skills":"1"]
        APIBase.shareObject.callAPIGetMyPageSkill(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body = result?.value(forKey: "body") as? NSDictionary {
                    if let skills = body.value(forKey: "skills") as? NSArray {
                        if skills.count > 0 {
                            self.sortListSkill(arrays:skills)
                            self.mCollectionView.reloadData()
                        }
                    }
                }
            } else {
                
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func sortListSkill(arrays:NSArray) {
        for i in 0 ... arrays.count - 1 {
            let objSkill = MySkillInfo(dict: arrays[i] as! NSDictionary)
            let key = objSkill.m_page_skill_group_mypage
            if var arrs:[MySkillInfo] = dictSkill[key] as? [MySkillInfo] {
                //Key exits
                arrs.append(objSkill)
                dictSkill[key] = arrs
            } else {
                //New key
                var arrs:[MySkillInfo] = [MySkillInfo]()
                arrs.append(objSkill)
                arrGroups.append(objSkill)
                dictSkill[key] = arrs;
            }
            
        }
        if self.arrGroups.indices.contains(self.indexSelected) == true {
            self.mLabelCategory.text = arrGroups[self.indexSelected].m_name_skill_group
        }
    }
}

extension MyPageSkillViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PageSkillCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageSkillCell", for: indexPath) as! PageSkillCell
        let objectSkill = arrGroups[indexPath.row];
        cell.updateArraySkill(array: dictSkill[objectSkill.m_page_skill_group_mypage] as! [MySkillInfo] )
        if objectSkill.m_page_skill_group_setting == "1" {
            cell.noticeView.isHidden = false
        } else {
            cell.noticeView.isHidden = true
        }
        let string = String(indexPath.row + 1) + "/" + String(self.arrGroups.count)
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttributes([NSAttributedStringKey.foregroundColor:lightGrayColor], range: NSRange(location: 0, length: string.count) )
        attributeString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YuGothic-Bold", size: 20.5 * scaleDisplay)!  , range: NSRange(location: 0, length: String(indexPath.row+1).count))
        attributeString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YuGo-Medium", size: 14 * scaleDisplay)!, range: NSRange(location: String(indexPath.row+1).count, length: 3))
        cell.mLabelTopPage.attributedText = attributeString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mCollectionView.frame.size.width,height: self.mCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/SIZE_WIDTH) + 1
        if(index == 1) {
            self.btnBack.isHidden = true
            self.btnNext.isHidden = false
        } else if (index == arrGroups.count) {
            self.btnBack.isHidden = false
            self.btnNext.isHidden = true
        } else {
            self.btnBack.isHidden = false
            self.btnNext.isHidden = false
        }
        self.indexSelected = index - 1
        if self.arrGroups.indices.contains(self.indexSelected) == true {
            self.mLabelCategory.text = arrGroups[self.indexSelected].m_name_skill_group
        }
    }
}

