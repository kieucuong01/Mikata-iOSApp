//
//  PointGetCollectionViewCollectionViewCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol PointGetCollectionViewDelegate:class {
    func didSelectedCellPointGetCollection(dict: NSDictionary)
}

class PointGetCollectionView: UICollectionViewCell {

    @IBOutlet weak var btnTotal: UIButton!
    @IBOutlet weak var btnIncomplete: UIButton!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var mLabelEmpty: UILabel!

    @IBOutlet weak var viewBarSearchCustom: SearchBarCustomView!
    var selectedIndex = 0
    var selectedButton: UIButton? = nil
    var keywordSearching: String = ""

    private var scale = DISPLAY_SCALE
    @IBOutlet weak var listPointGetCollectonView: UICollectionView!
    @IBOutlet weak var mTopViewSearchBarConstraint: NSLayoutConstraint!
//    @IBOutlet weak var mTopTableViewWithButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintImageEmpty: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelEmpty: NSLayoutConstraint!

    var delegate:PointGetCollectionViewDelegate? = nil

    var arrayWorkItems:NSArray = NSArray()
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setConstraintForViews()
        self.setFontForViews()
        listPointGetCollectonView.delegate = self
        listPointGetCollectonView.dataSource = self
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.btnTotal.setTitleColor(.white, for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")

        listPointGetCollectonView.register(UINib.init(nibName: "PointGetCell", bundle: nil), forCellWithReuseIdentifier: "itemPointGetCell")

        viewBarSearchCustom.delegate = self
    }

    private func setConstraintForViews() {
//        self.mTopViewSearchBarConstraint.constant = 15.0 * scale
//        self.mTopTableViewWithButtonConstraint.constant = 12.0 * scale
        self.mTopTableViewConstraint.constant = 15.0 * scale
        self.mTopConstraintImageEmpty.constant = 58.0 * scale
        self.mTopConstraintLabelEmpty.constant = 21.0 * scale
        
        self.btnTotal.layer.cornerRadius = 4
        self.btnIncomplete.layer.cornerRadius = 4
        self.btnPending.layer.cornerRadius = 4
    }

    private func setFontForViews() {
        self.mLabelEmpty.font = UIFont(name: self.mLabelEmpty.font.fontName, size: 12 * scale)

        self.btnTotal.setTitle(NSLocalizedString("get_point_button_title_all_list", comment: "Get Point Title All list"), for: .normal)
        self.btnTotal.titleLabel?.font = UIFont(name: self.btnTotal.titleLabel!.font.fontName, size: 12 * scale)
        self.btnIncomplete.setTitle(NSLocalizedString("get_point_button_title_incomplete", comment: "Get Point Title Incomplete"), for: .normal)
        self.btnIncomplete.titleLabel?.font = UIFont(name: self.btnIncomplete.titleLabel!.font.fontName, size: 12 * scale)
        self.btnPending.setTitle(NSLocalizedString("get_point_button_title_pending", comment: "Get Point Title Pending"), for: .normal)
        self.btnPending.titleLabel?.font = UIFont(name: self.btnPending.titleLabel!.font.fontName, size: 12 * scale)


    }

    //MARK: - Refresh content

    func refreshContent() {
        self.selectedIndex = 0
        if self.selectedButton == nil {
            self.btnTotal.sendActions(for: UIControlEvents.touchUpInside)
        }
        else {
            self.selectedButton?.sendActions(for: UIControlEvents.touchUpInside)
        }
    }

    //MARK: - Selector UIButton
    @IBAction func clickBtnTotal(_ sender: Any) {
        if selectedIndex == 1 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 1
        self.selectedButton = self.btnTotal
        self.btnTotal.setTitleColor(.white, for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnIncomplete.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnIncomplete.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnPending.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnPending.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")

        //Call API
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching
        ]
        self.callAPIGetListPointWork(params: params)

    }

    @IBAction func clickBtnIncomplete(_ sender: Any) {
        if selectedIndex == 2 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 2
        self.selectedButton = self.btnIncomplete
        self.btnIncomplete.setTitleColor(.white, for: .normal)
        self.btnIncomplete.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnTotal.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnPending.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnPending.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "get_list_work_new": NSNumber.init(value: 1)
        ]
        self.callAPIGetListPointWork(params: params)
    }


    @IBAction func clickBtnPending(_ sender: Any) {
        if selectedIndex == 3 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 3
        self.selectedButton = self.btnPending
        self.btnPending.setTitleColor(.white, for: .normal)
        self.btnPending.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnTotal.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnIncomplete.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnIncomplete.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")

        //Call API
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "get_list_work_pending": NSNumber.init(value: 1)
        ]
        self.callAPIGetListPointWork(params: params)
    }

    private func setHideCollectionView() {
        self.listPointGetCollectonView.isHidden = true
        if selectedIndex == 1 {
            self.mLabelEmpty.text = NSLocalizedString("get_point_notice_empty_all_work", comment: "text notice empty all work")
        } else if selectedIndex == 2 {
            self.mLabelEmpty.text = NSLocalizedString("get_point_notice_empty_imcomplete_work", comment: "text notice empty incomplete")
        } else {
            self.mLabelEmpty.text = NSLocalizedString("get_point_notice_empty_waiting_work", comment: "text notice empty pending")
            
        }
    }

    func callAPIGetListPointWork(params: [String : Any]?) {
        
        self.arrayWorkItems = NSArray()
        APIBase.shareObject.callAPIGetAllGetPoint(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    if arrays!.count > 0 {
                        self.listPointGetCollectonView.isHidden = false
                        self.arrayWorkItems = NSArray(array: arrays!)
                    } else {
                        self.setHideCollectionView()
                    }
                } else {
                    self.setHideCollectionView()
                }
            }
            self.listPointGetCollectonView.reloadData()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }
}

extension PointGetCollectionView: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.arrayWorkItems.count > 0) {
            return self.arrayWorkItems.count
        }
        return self.arrayWorkItems.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return UIEdgeInsets(top:0, left: 0 , bottom: 10 * scale, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return CGSize(width: 144 * scale, height: 157 * scale)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = self.arrayWorkItems[Int(indexPath.row)] as! NSDictionary
        let cell:PointGetCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "itemPointGetCell", for: indexPath) as? PointGetCell)!
        cell.updateCellFromDict(dict:dict)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrayWorkItems[Int(indexPath.row)] as! NSDictionary
        self.delegate?.didSelectedCellPointGetCollection(dict: dict)
    }
}

extension PointGetCollectionView:SearchBarCustomViewDelegate{
    func callAPISearchPointItems(keyword: String) {
        self.keywordSearching = keyword
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        var params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": keyword
        ]

        if self.selectedIndex == 2 {
            params["get_list_work_new"] = NSNumber.init(value: 1)
        }
        else if self.selectedIndex == 3 {
            params["get_list_work_pending"] = NSNumber.init(value: 1)
        }

        self.callAPIGetListPointWork(params: params)
    }
    func callbackActionClickedButtonFilter() {

    }
}
