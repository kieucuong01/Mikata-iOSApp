//
//  PointExchangeCollectionview.swift
//  SmartTablet
//
//  Created by thanhlt on 7/12/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol PointExchangeCollectionViewDelegate:class {
    func clickedItemInCollectionView(sender:PointExchangeCollectionview, dict:NSDictionary)
}

class PointExchangeCollectionview: UICollectionViewCell {
    
    @IBOutlet weak var btnTotal: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnReplace: UIButton!
    
    @IBOutlet weak var mLabelEmpty: UILabel!
    @IBOutlet weak var viewBarSearchCustom: SearchBarCustomView!
    
    @IBOutlet weak var mTopConstraintImageViewEmpty: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelEmpty: NSLayoutConstraint!
    
    weak var delegate:PointExchangeCollectionViewDelegate? = nil
    
    var selectedIndex = 0
    var selectedButton: UIButton? = nil
    var keywordSearching: String = ""
    var arrayExchangeItems:NSMutableArray = NSMutableArray()
    private var scale = DISPLAY_SCALE
    @IBOutlet weak var listPointExchangeCollectonView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
        self.setPropertiesForViews()
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
    
    private func setPropertiesForViews() {
        
        listPointExchangeCollectonView.delegate = self
        listPointExchangeCollectonView.dataSource = self
        viewBarSearchCustom.delegate = self
        self.btnTotal.setTitleColor(.white, for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        listPointExchangeCollectonView.register(UINib.init(nibName: "PointExchangeCell", bundle: nil), forCellWithReuseIdentifier: "itemPointExchangeCell")
    }
    
    private func setConstraintForViews() {
        self.mTopConstraintImageViewEmpty.constant = 58 * scale
        self.mTopConstraintLabelEmpty.constant = 21 * scale
        
    }
    
    private func setFontForViews() {
        self.mLabelEmpty.font = UIFont(name: self.mLabelEmpty.font.fontName, size: 12 * scale)
        
        self.btnTotal.titleLabel!.font = UIFont(name: self.btnTotal.titleLabel!.font.fontName, size: 12 * scale)
        self.btnTotal.setTitle(NSLocalizedString("point_exchange_button_title_all_list", comment: "total all list"), for: .normal)
        
        self.btnList.titleLabel!.font = UIFont(name: self.btnList.titleLabel!.font.fontName, size: 12 * scale)
        self.btnList.setTitle(NSLocalizedString("point_exchange_button_title_favorite", comment: "total favorite"), for: .normal)
        
        self.btnReplace.titleLabel!.font = UIFont(name: self.btnReplace.titleLabel!.font.fontName, size: 12 * scale)
        self.btnReplace.setTitle(NSLocalizedString("point_exchange_button_title_replaced", comment: "total replaced"), for: .normal)
    }
    
    
    //MARK: Selector UIButton
    @IBAction func clickButtonTotal(_ sender: Any) {
        if selectedIndex == 1 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 1
        self.selectedButton = self.btnTotal
        self.btnTotal.setTitleColor(.white, for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnList.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnList.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnReplace.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnReplace.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching
        ]
        self.callAPIGetExchangeItems(params: params)
    }
    
    @IBAction func clickButtonList(_ sender: Any) {
        if selectedIndex == 2 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 2
        self.selectedButton = self.btnList
        self.btnList.setTitleColor(.white, for: .normal)
        self.btnList.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnTotal.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnReplace.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnReplace.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "only_favorite": NSNumber.init(value: 1)
        ]
        self.callAPIGetExchangeItems(params: params)
    }
    
    @IBAction func clickButtonReplay(_ sender: Any) {
        if selectedIndex == 3 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 3
        self.selectedButton = self.btnReplace
        self.btnReplace.setTitleColor(.white, for: .normal)
        self.btnReplace.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnTotal.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnList.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal) 
        self.btnList.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "only_log": NSNumber.init(value: 1)
        ]
        self.callAPIGetExchangeItems(params: params)
    }
    
    private func setHideCollectionView() {
        self.listPointExchangeCollectonView.isHidden = true
        if selectedIndex == 1 {
            self.mLabelEmpty.text = NSLocalizedString("exchange_point_notice_empty_all", comment: "text notice empty favourite")
        } else if selectedIndex == 2 {
            self.mLabelEmpty.text = NSLocalizedString("exchange_point_notice_empty_favourite", comment: "text notice empty favourite")
        } else {
            self.mLabelEmpty.text = NSLocalizedString("exchange_point_notice_empty_replaced", comment: "text notice empty replace")
            
        }
        
        
    }
    
    func callAPIGetExchangeItems(params: [String : Any]?) {
        self.arrayExchangeItems.removeAllObjects()
        APIBase.shareObject.callAPIGetAllPointItemsExchange(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    if arrays!.count > 0 {
                        self.listPointExchangeCollectonView.isHidden = false
                        self.arrayExchangeItems = NSMutableArray(array: arrays!)
                    } else {
                        self.setHideCollectionView()
                    }
                } else {
                    self.setHideCollectionView()
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }
            self.listPointExchangeCollectonView.reloadData()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }
}

extension PointExchangeCollectionview: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayExchangeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return UIEdgeInsets(top: 10 * scale, left: 0, bottom: 10 * scale, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return CGSize(width: 144 * scale, height: 157 * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = self.arrayExchangeItems[indexPath.row] as! NSDictionary
        let cell:PointExchangeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemPointExchangeCell", for: indexPath) as! PointExchangeCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.updateDateFromDict(dict: dict)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrayExchangeItems[indexPath.row] as! NSDictionary
        self.delegate?.clickedItemInCollectionView(sender: self, dict: dict)
    }
}

extension PointExchangeCollectionview : PointExchangeCellDelegate {
    func clickedFavoritedImageOnCell(sender: PointExchangeCell, value: String) {
        if self.selectedButton == self.btnList {
            self.refreshContent()
        }
        else {
            if let dict = self.arrayExchangeItems[sender.indexPath.row] as? NSDictionary {
                let mulDict = NSMutableDictionary(dictionary: dict)
                mulDict.setValue(value, forKey: "is_favorite")
                self.arrayExchangeItems.replaceObject(at: sender.indexPath.row, with: mulDict)
            }
        }
    }
}

extension PointExchangeCollectionview:SearchBarCustomViewDelegate{
    func callAPISearchPointItems(keyword: String) {
        self.keywordSearching = keyword
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        var params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": keyword
        ]

        if self.selectedIndex == 2 {
            params["only_favorite"] = NSNumber.init(value: 1)
        }
        else if self.selectedIndex == 3 {
            params["only_log"] = NSNumber.init(value: 1)
        }
        
        self.callAPIGetExchangeItems(params: params)
    }
    func callbackActionClickedButtonFilter() {
        
    }
}
