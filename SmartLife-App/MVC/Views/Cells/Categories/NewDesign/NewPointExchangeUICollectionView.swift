//
//  NewPointGetUICollectionView.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/5/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol NewPointExchangeUICollectionViewDelegate: class {
    func didSelectedCellPointExchangeCollection(sender: NewPointExchangeUICollectionView, dict: NSDictionary)
    func didSelectedCellPointExchangeCompleteCollection(sender: NewPointExchangeUICollectionView, dict: NSDictionary)
}

class NewPointExchangeUICollectionView: UICollectionViewCell {
    @IBOutlet weak var mCollectionView: TPKeyboardAvoidingCollectionView!
    @IBOutlet weak var mViewEmpty: UIView!
    @IBOutlet weak var mTextEmpty: UILabel!
    
    @IBOutlet weak var mTopConstraintImageEmpty: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintTextLabel: NSLayoutConstraint!
    /*List avariable*/
    weak var delegate:NewPointExchangeUICollectionViewDelegate? = nil
    
    var scaleDisplay:CGFloat = DISPLAY_SCALE
    
    var arrayWorkItems:NSMutableArray = NSMutableArray()
    var lastContentOffset: CGFloat = 0
    var isDragScrollView : Bool = false

    var selectedIndex = 0
    var selectedButton: UIButton? = nil
    var keywordSearching: String = ""
    var pageContent: Int = 1
    let limitContent: Int = 20

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        scaleDisplay = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setPropertiesForViews()

        // Set load more and refresh
        self.mCollectionView.alwaysBounceVertical = true
        self.mCollectionView.addPullToRefreshHandler {
            self.pageContent = 1
            self.generateParamsAndCallAPI()
        }
        self.mCollectionView.addInfiniteScrollingWithHandler {
            self.pageContent = self.pageContent + 1
            self.generateParamsAndCallAPI()
        }
    }
    
    //MARK: - Private method
    private func setConstraintForViews() {
        self.mTopConstraintImageEmpty.constant = 59 * scaleDisplay
        self.mTopConstraintTextLabel.constant = 21 * scaleDisplay
    }
    
    private func setPropertiesForViews() {
        self.mCollectionView.delegate = self
        self.mCollectionView.dataSource = self
        
        let nib = UINib(nibName: "CustomListButtonCell", bundle: nil)
        self.mCollectionView.register(nib , forCellWithReuseIdentifier: "customListButtonCell")
        
        let nibCell = UINib.init(nibName: "PointExchangeCell", bundle: nil)
        self.mCollectionView.register(nibCell, forCellWithReuseIdentifier: "itemPointExchangeCell")
    }
    
    private func setHideCollectionView() {
        self.mViewEmpty.isHidden = false
        if selectedIndex == 1 {
            self.mTextEmpty.text = NSLocalizedString("exchange_point_notice_empty_all", comment: "text notice empty all")
        } else if selectedIndex == 2 {
            self.mTextEmpty.text = NSLocalizedString("exchange_point_notice_empty_favourite", comment: "text notice empty favourite")
        } else {
            self.mTextEmpty.text = NSLocalizedString("exchange_point_notice_empty_replaced", comment: "text notice empty replaced")
            
        }
    }
    
    func refreshContent() {
        self.selectedIndex = 0
        if self.selectedButton == nil {
            self.callbackDelegateToClickedButonFirst(sender: nil)
        }
        else {
            self.selectedButton?.sendActions(for: UIControlEvents.touchUpInside)
        }
    }

    func generateParamsAndCallAPI() {
        if self.pageContent == 1 {
            self.mCollectionView.setShowsInfiniteScrolling(true)
            self.arrayWorkItems.removeAllObjects()
        }

        var params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "page": self.pageContent,
            "limit": self.limitContent
        ]
        if self.selectedIndex == 1 {
            self.callAPIGetList(params: params)
        }
        else if self.selectedIndex == 2 {
            params["only_favorite"] = NSNumber.init(value: 1)
            self.callAPIGetList(params: params)
        }
        else if self.selectedIndex == 3 {
            let params2: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "keyword": self.keywordSearching,
                "page": self.pageContent,
                "limit": self.limitContent
            ]
            self.callAPIGetExchangedList(params: params2)
        }
    }
    
    func callAPIGetList(params: [String : Any]?) {
        if self.pageContent == 1 {
            NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        }
        APIBase.shareObject.callAPIGetAllPointItemsExchange(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        self.arrayWorkItems.add(item)
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.mCollectionView.setShowsInfiniteScrolling(false)
                }
            }
            if self.arrayWorkItems.count > 0 {
                self.mViewEmpty.isHidden = true
            } else {
                self.setHideCollectionView()
            }

            let indexSet = IndexSet(integer: 1)
            self.mCollectionView.reloadSections(indexSet)
            self.mCollectionView.pullToRefreshView?.stopAnimating()
            self.mCollectionView.infiniteScrollingView?.stopAnimating()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }

    func callAPIGetExchangedList(params: [String : Any]?) {
        if self.pageContent == 1 {
            NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        }
        APIBase.shareObject.callAPIGetAllPointItemsExchanged(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        self.arrayWorkItems.add(item)
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.mCollectionView.setShowsInfiniteScrolling(false)
                }
            }
            if self.arrayWorkItems.count > 0 {
                self.mViewEmpty.isHidden = true
            } else {
                self.setHideCollectionView()
            }

            let indexSet = IndexSet(integer: 1)
            self.mCollectionView.reloadSections(indexSet)
            self.mCollectionView.pullToRefreshView?.stopAnimating()
            self.mCollectionView.infiniteScrollingView?.stopAnimating()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }
}

extension NewPointExchangeUICollectionView: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.arrayWorkItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0 , bottom: 10 * scaleDisplay, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.mCollectionView.frame.size.width, height : 102 * scaleDisplay)
        }
        return CGSize(width: 144 * scaleDisplay, height: 157 * scaleDisplay)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customListButtonCell", for: indexPath) as! CustomListButtonCell
            let title1 = NSLocalizedString("point_exchange_button_title_all_list", comment: "point exchange all")
            let title2 = NSLocalizedString("point_exchange_button_title_favorite", comment: "point exchange favorite")
            let title3 = NSLocalizedString("point_exchange_button_title_replaced", comment: "point exchange replaced")
            cell.setTitles(title1: title1, title2: title2, title3: title3)
            cell.delegate = self
            return cell
        } else {
            let cell:PointExchangeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemPointExchangeCell", for: indexPath) as! PointExchangeCell
            if self.arrayWorkItems.count > indexPath.row {
                if let dict = self.arrayWorkItems[indexPath.row] as? NSDictionary {
                    cell.delegate = self
                    cell.indexPath = indexPath
                    cell.updateDateFromDict(dict: dict)
                }
            }
            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let dict = self.arrayWorkItems[indexPath.row] as! NSDictionary
            if self.selectedIndex == 3 {
                self.delegate?.didSelectedCellPointExchangeCompleteCollection(sender: self, dict: dict)
            }
            else {
                self.delegate?.didSelectedCellPointExchangeCollection(sender: self, dict: dict)
            }
        }
    }
    
}
extension NewPointExchangeUICollectionView : PointExchangeCellDelegate {
    func clickedFavoritedImageOnCell(sender: PointExchangeCell, value: String) {
        if self.selectedIndex == 2 {
            self.refreshContent()
        }
        else {
            if let dict = self.arrayWorkItems[sender.indexPath.row] as? NSDictionary {
                let mulDict = NSMutableDictionary(dictionary: dict)
                mulDict.setValue(value, forKey: "is_favorite")
                self.arrayWorkItems.replaceObject(at: sender.indexPath.row, with: mulDict)
            }
        }

        // Track Repro 
        if value == "1"  {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_ACTION_FAVORITE)
        }
        else {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_ACTION_UNFAVORITE)
        }

    }
}

extension NewPointExchangeUICollectionView:CustomListButtonCellDelegate {
    func callbackDelegateToClickedButonFirst(sender: CustomListButtonCell?) {
        if selectedIndex == 1 { return }
        self.endEditing(true)
        self.selectedIndex = 1
        self.selectedButton = sender?.mButtonFirst

        self.pageContent = 1
        self.generateParamsAndCallAPI()

        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_ACTION_TAB_ALL)
    }

    func callbackDelegateToClickedButonSecond(sender: CustomListButtonCell?) {
        if selectedIndex == 2 { return }
        self.endEditing(true)
        self.selectedIndex = 2
        self.selectedButton = sender?.mButtonSecond

        self.pageContent = 1
        self.generateParamsAndCallAPI()

        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_ACTION_TAB_FAVORITE)
    }

    func callbackDelegateToClickedButonThird(sender: CustomListButtonCell?) {
        if selectedIndex == 3 { return }
        self.endEditing(true)
        self.selectedIndex = 3
        self.selectedButton = sender?.mButtonThird

        self.pageContent = 1
        self.generateParamsAndCallAPI()

        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE, eventName: ReproEvent.REPRO_SCREEN_POINT_EXCHANGE_ACTION_TAB_EXCHANGED)
    }

    func callbackDelegateToFilterSelect(sender: CustomListButtonCell?) {
        
    }
    
    func callbackDelegateToSetKeyword(sender: CustomListButtonCell?, keyword: String) {
        self.keywordSearching = keyword
        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
}

extension NewPointExchangeUICollectionView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
        if self.isDragScrollView == true {
            let navVC = UIApplication.shared.keyWindow?.rootViewController as? NavbarMainViewController
            let topVC = UIApplication.topViewController() as? TimeLineViewController
            if (self.lastContentOffset < scrollView.contentOffset.y) {
                // moved to top
                navVC?.setsetVisibleNavigationBarCustomWithAnimate(isHidden: true)
                topVC?.setGoneTopView(isHidden: true)
                FirebaseGlobalMethod.tabbarMainVC?.setHideTitleTabar(isHiden: false)
            } else if (self.lastContentOffset > scrollView.contentOffset.y) {
                // moved to bottom
                navVC?.setsetVisibleNavigationBarCustomWithAnimate(isHidden: false)
                topVC?.setGoneTopView(isHidden: false)
                FirebaseGlobalMethod.tabbarMainVC?.setHideTitleTabar(isHiden: true)
            } else {
                // didn't move
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
        self.isDragScrollView = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isDragScrollView = false
    }
}
