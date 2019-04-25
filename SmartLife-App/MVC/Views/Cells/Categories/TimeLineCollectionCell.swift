//
//  TimeLineCollectionCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/11/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import ICSPullToRefresh
import PullToRefresh
import TPKeyboardAvoiding

protocol TimeLineCollectionCellDelegate : class {
    func errorAPIAppear(message:String?)
}

class TimeLineCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    var delegate:TimeLineCollectionCellDelegate? = nil
    var arrayItemAll: [TimeLineObject] = []
    var pageContent: Int = 1
    let limitContent: Int = 10
    var lastContentOffset: CGFloat = 0
    var isHideNavbar : Bool = false
    var isDragScrollView : Bool = false
    var rowsHeight : [Int:CGFloat] = [:]
    var additionalRowsHeight : [Int:CGFloat] = [:]
    var imagesHeight : [String:CGFloat] = [:]
    
    @IBOutlet weak var mViewEmpty: UIView!
    var parentVC: UIViewController? = nil
    var selectedIndex : Int = 0
    var selectedButton: UIButton? = nil
    var keyword : String = ""
    
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableView()
        // Set load more and refresh
        self.tableView.alwaysBounceVertical = true
        self.initalData()
        let refresher = PullToRefresh()
        self.tableView.addPullToRefresh(refresher) {
            self.pageContent = 1
            self.additionalRowsHeight.removeAll()
            self.generateParamsAndCallAPI()
        }
        self.tableView.addInfiniteScrollingWithHandler {
            self.pageContent = self.pageContent + 1
            self.generateParamsAndCallAPI()
        }
    }
    
    func setupTableView(){
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "searchTableViewCell")
        
        self.tableView.register(UINib(nibName: "TimeLineFirstLayoutCell", bundle: nil), forCellReuseIdentifier: "cellLayoutTLine1")
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
    
    func initalData(){
        self.selectedIndex = 1
        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
    
    // - MARK : API
    
    func generateParamsAndCallAPI() {
        if self.pageContent == 1 {
            self.tableView.setShowsInfiniteScrolling(true)
            self.arrayItemAll.removeAll()
        }
        
        var params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "page": self.pageContent,
            "limit": self.limitContent,
            "keyword" : self.keyword
        ]
        
        if self.selectedIndex == 2 {
            params["get_timeline_favorite"] = NSNumber.init(value: 1)
        }
        
        self.callAPIGetTimeLine(params: params)
    }
    
    func callAPIGetTimeLine(params : [String : Any]) {
        if self.pageContent == 1 {
            NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        }
        APIBase.shareObject.callAPIGetTimeLine(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                if self.pageContent == 1 {
                    self.arrayItemAll.removeAll()
                }
                // Update point
                if let point: String = body.value(forKey: "point") as? String {
                    PublicVariables.userInfo.m_point = point
                    NotificationCenter.default.post(name: NSNotificationNavbarMainChangeScore, object: point)
                }
                // Get list news
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for object in arrays! {
                        if let dictObject: NSDictionary = object as? NSDictionary {
                            self.arrayItemAll.append(TimeLineObject(dict: dictObject))
                        }
                    }
                }
                
                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.tableView.setShowsInfiniteScrolling(false)
                }
                
                if self.arrayItemAll.count > 0 {
                    self.mViewEmpty.isHidden = true
                } else {
                    self.mViewEmpty.isHidden = false
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            
            if self.pageContent == 1 {
                self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.fade)
            }
            else {
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.none)
                }
            }
            self.tableView.infiniteScrollingView?.stopAnimating()
            self.tableView.endAllRefreshing()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.arrayItemAll.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if let height = self.rowsHeight[indexPath.row] {
                if let loadMoreHeight = self.additionalRowsHeight[indexPath.row]{
                    return height + loadMoreHeight
                }
                return height
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if let height = self.rowsHeight[indexPath.row] {
                if let loadMoreHeight = self.additionalRowsHeight[indexPath.row]{
                    return height + loadMoreHeight
                }
                return height
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
            let title1 = NSLocalizedString("timelineview_button_all", comment: "")
            let title2 = NSLocalizedString("timelineview_button_favorite", comment: "")
            cell.setTitles(title1: title1, title2: title2)
            cell.delegate = self
            return cell
        }
        else {
            if self.arrayItemAll.indices.contains(indexPath.row) == true {
                let timeLineObject = self.arrayItemAll[indexPath.row]
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cellLayoutTLine1") as? TimeLineFirstLayoutCellTableViewCell {
                    cell.delegate = self
                    cell.parentVC = self.parentVC
                    cell.parentTableView = tableView
                    cell.indexPath = indexPath
                    cell.updateDataFromDict(timeLineObject: timeLineObject)
                    if let imageHeight = self.imagesHeight[timeLineObject.image_url] {
                        cell.mHeightImageConstraintAvatar.constant = imageHeight
                    }
                    if timeLineObject.image_url != ""{
                        cell.imageAvatar.af_setImage(
                            withURL:  URL(string: timeLineObject.image_url)!,
                            placeholderImage: #imageLiteral(resourceName: "NoImgBackground"),
                            filter: nil,
                            imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                            runImageTransitionIfCached: false) {
                                // Completion closure
                                response in
                                // Geted Image
                                DispatchQueue.main.async {
                                    // initial rows height
                                    let ratioHeightImageSize: CGFloat = (cell.imageAvatar.image?.size.height)! / (cell.imageAvatar.image?.size)!.width
                                    let imageHeight = cell.imageAvatar.frame.size.width * ratioHeightImageSize
                                    
                                    self.rowsHeight[indexPath.row] = imageHeight + 160 * GlobalMethod.displayScale
                                    self.imagesHeight[timeLineObject.image_url] = imageHeight
                                    cell.mHeightImageConstraintAvatar.constant = imageHeight
                                    //Check if the image isn't already cached
                                    if response.response != nil {
                                        // Force the cell update
                                        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                                    }
                                }
                        }
                    }
                    else {
                        cell.imageAvatar.image = #imageLiteral(resourceName: "NoImgBackground")
                        cell.mHeightImageConstraintAvatar.constant = 0
                        self.rowsHeight[indexPath.row] = 160 * GlobalMethod.displayScale
                    }
                    
                    return cell
                }
                else {
                    return UITableViewCell()
                }
            }
            else {
                return UITableViewCell()
            }
        }
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension TimeLineCollectionCell: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //        for indexPath in indexPaths {
        //            // Cached images before call cellForRowAt delegate
        //            let timelineObj = self.arrayItemAll[indexPath.row]
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellLayoutTLine1") as? TimeLineFirstLayoutCellTableViewCell{
        //                cell.imageAvatar.af_setImage(
        //                    withURL:  URL(string: timelineObj.image_url)!,
        //                    placeholderImage: #imageLiteral(resourceName: "NoImgBackground"),
        //                    filter: nil,
        //                    imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
        //                    runImageTransitionIfCached: false) {
        //                        // Completion closure
        //                        response in
        //                        DispatchQueue.main.async {
        //                            //Check if the image isn't already cached
        //                            if response.response != nil {
        //                                // Force the cell update
        //                                print(String.init(format: "prefetchRowsAt #%i", indexPath.row))
        //                                let ratioHeightImageSize: CGFloat = (cell.imageAvatar.image?.size.height)! / (cell.imageAvatar.image?.size)!.width
        //                                let imageHeight = cell.imageAvatar.frame.size.width * ratioHeightImageSize
        //                                self.rowsHeight[indexPath.row] = imageHeight + 160 * GlobalMethod.displayScale
        //                                self.imagesHeight[timelineObj.image_url] = imageHeight
        //                            }
        //                        }
        //                }
        //            }
        //        }
    }
}

extension TimeLineCollectionCell : SearchTableViewCellDelegate {
    func callbackDelegateToClickedButonFirst(sender: SearchTableViewCell?) {
        if selectedIndex == 1 { return }
        self.endEditing(true)
        self.selectedIndex = 1
        self.selectedButton = sender?.mButtonFirst
        self.pageContent = 1
        self.additionalRowsHeight.removeAll()
        self.generateParamsAndCallAPI()
    }
    
    func callbackDelegateToClickedButonSecond(sender: SearchTableViewCell?) {
        if selectedIndex == 2 { return }
        self.endEditing(true)
        self.selectedIndex = 2
        self.selectedButton = sender?.mButtonSecond
        self.pageContent = 1
        self.additionalRowsHeight.removeAll()
        self.generateParamsAndCallAPI()
    }
    
    func callbackDelegateToSetKeyword(sender: SearchTableViewCell?, keyword: String) {
        self.keyword = keyword
        self.pageContent = 1
        self.rowsHeight.removeAll()
        self.additionalRowsHeight.removeAll()
        self.generateParamsAndCallAPI()
    }
    
    func callbackDelegateToFilterSelect(sender: SearchTableViewCell?) {
        
    }
}

extension TimeLineCollectionCell: TimeLineFirstLayoutCellTableViewCellDelegate {
    func clickedFavoritedImageOnCell(sender: TimeLineFirstLayoutCellTableViewCell, value: String) {
        if self.selectedIndex == 2 {
            self.refreshContent()
        }
        else {
            self.arrayItemAll[sender.indexPath.row].is_favorite = value
        }
    }
    
    func clickedLoadMore(sender:
        TimeLineFirstLayoutCellTableViewCell, heightAdditionalText: CGFloat?) {
        self.tableView.beginUpdates()
        self.additionalRowsHeight[sender.indexPath.row] = heightAdditionalText!
        self.tableView.endUpdates()
    }
}

extension TimeLineCollectionCell : UIScrollViewDelegate {
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
