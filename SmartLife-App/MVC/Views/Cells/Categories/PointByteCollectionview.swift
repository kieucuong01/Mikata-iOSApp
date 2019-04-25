//
//  PointByteCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/19/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol PointByteCollectionViewDelegate : class {
    func clickedPointByteItemFromSender(sender:PointByteCollectionview ,atIndexPath index:IndexPath, object:NSDictionary)
}

class PointByteCollectionview: UICollectionViewCell {
    @IBOutlet weak var btnTotal: UIButton!
    @IBOutlet weak var btnJobList: UIButton!
    @IBOutlet weak var btnResume: UIButton!
    @IBOutlet weak var viewBarSearchCustom: SearchBarCustomView!
    @IBOutlet weak var mTableViewListNotifcation: UITableView!
    @IBOutlet weak var listPointByteCollectonView: UICollectionView!
    
    @IBOutlet weak var mImageEmpty: UIImageView!
    @IBOutlet weak var mImageLabelEmpty: UILabel!

    var arrayFilters: [[(id: String, text: String)]] = [
        [("", ""), ("", "すべて")],
        [("", "地域"), ("東京", "東京エリア"), ("神奈川", "神奈川エリア")],
        [("", "業種")]
    ]
  
    var arrayJobItems: NSMutableArray = NSMutableArray()
    var selectedIndex = 0
    var selectedButton: UIButton? = nil
    var keywordSearching: String = ""
    var selectedFilterIndex: IndexPath = IndexPath(row: 0, section: 0)
    var pageContent: Int = 1
    let limitContent: Int = 20
    var scale = DISPLAY_SCALE
    weak var delegate:PointByteCollectionViewDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setPropertiesForView()

        // Hide filter table
        self.mTableViewListNotifcation.isHidden = true

        // Get job category
        self.callAPIGetByteCategory()

        // Set load more and refresh
        self.listPointByteCollectonView.addPullToRefreshHandler {
            self.pageContent = 1
            self.generateParamAndCallAPI()
        }
        self.listPointByteCollectonView.addInfiniteScrollingWithHandler {
            self.pageContent = self.pageContent + 1
            self.generateParamAndCallAPI()
        }
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
    
    private func setPropertiesForView() {
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE

        listPointByteCollectonView.delegate = self
        listPointByteCollectonView.dataSource = self
        listPointByteCollectonView.register(UINib.init(nibName: "PointByteCell", bundle: nil), forCellWithReuseIdentifier: "itemPointByteCell")
        
        
        self.mTableViewListNotifcation.dataSource = self
        self.mTableViewListNotifcation.delegate = self
        self.mTableViewListNotifcation.register(UINib.init(nibName: "NotficationFilterCell", bundle: nil), forCellReuseIdentifier: "notificationFilterCell")
        
        self.btnTotal.setTitleColor(.white, for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        viewBarSearchCustom.delegate = self
        viewBarSearchCustom.updateConstraintWhenHaveFilterButton()
    }
    
    func generateParamAndCallAPI() {
        if self.pageContent == 1 {
            self.listPointByteCollectonView.setShowsInfiniteScrolling(true)
            self.arrayJobItems.removeAllObjects()
        }

        var params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "page": self.pageContent,
            "limit": self.limitContent
        ]

        // Add filter
        if self.arrayFilters.indices.contains(self.selectedFilterIndex.section) == true {
            if self.arrayFilters[self.selectedFilterIndex.section].indices.contains(self.selectedFilterIndex.row + 1) == true {
                let filterValue: String = self.arrayFilters[self.selectedFilterIndex.section][self.selectedFilterIndex.row + 1].id
                switch self.selectedFilterIndex.section {
                case 1:
                    params["location"] = filterValue
                    break
                case 2:
                    params["work_category"] = filterValue
                    break
                default:
                    break
                }
            }
        }

        if self.selectedIndex == 1 {
            //None set
        } else if self.selectedIndex == 2 {
            params["get_favorite"] = NSNumber.init(value: 1)
        } else if self.selectedIndex == 3 {
            params["get_apply"] = NSNumber.init(value: 1)
        }

        self.callAPIGetByteItems(params: params)
    }

    @IBAction func clickButtonTotal(_ sender: Any) {
        if selectedIndex == 1 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 1
        self.selectedButton = self.btnTotal
        self.mImageLabelEmpty.text = ""
        self.btnTotal.setTitleColor(.white, for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnJobList.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnJobList.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnResume.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnResume.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")

        self.pageContent = 1
        self.generateParamAndCallAPI()
    }

    @IBAction func clickButtonJobList(_ sender: Any) {
        if selectedIndex == 2 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 2
        self.selectedButton = self.btnJobList
        self.mImageLabelEmpty.text = "お気に入りはまだありません"
        self.btnJobList.setTitleColor(.white, for: .normal)
        self.btnJobList.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnTotal.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnResume.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnResume.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")

        self.pageContent = 1
        self.generateParamAndCallAPI()
    }

    @IBAction func clickButtonResume(_ sender: Any) {
        if selectedIndex == 3 {
            return;
        }
        self.endEditing(true)
        selectedIndex = 3
        self.selectedButton = self.btnResume
        self.mImageLabelEmpty.text = "応募済みはまだありません"
        self.btnResume.setTitleColor(.white, for: .normal)
        self.btnResume.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "B89F98")
        self.btnTotal.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnTotal.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")
        self.btnJobList.setTitleColor(GlobalMethod.hexStringToUIColor(hex: "6C5032"), for: .normal)
        self.btnJobList.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "E4D4CD")

        self.pageContent = 1
        self.generateParamAndCallAPI()
    }

    // MARK: - Call API

    func callAPIGetByteItems(params: [String : Any]?) {
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        APIBase.shareObject.callAPIGetListByte(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        self.arrayJobItems.add(item)
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.listPointByteCollectonView.setShowsInfiniteScrolling(false)
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }
            if self.arrayJobItems.count > 0 {
                self.listPointByteCollectonView.isHidden = false
                self.mImageEmpty.isHidden = true
                self.mImageLabelEmpty.isHidden = true
            } else {
                self.listPointByteCollectonView.isHidden = true
                self.mImageEmpty.isHidden = false
                self.mImageLabelEmpty.isHidden = false
            }

            self.listPointByteCollectonView.reloadData()
            self.listPointByteCollectonView.pullToRefreshView?.stopAnimating()
            self.listPointByteCollectonView.infiniteScrollingView?.stopAnimating()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }

    func callAPIGetByteCategory() {
        APIBase.shareObject.callAPIGetListByteCaregory(params: nil) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let body:NSDictionary = result?.object(forKey: "body") as? NSDictionary {
                    let arrays = body.object(forKey: "data") as? NSArray
                    if arrays != nil {
                        for item in arrays! {
                            if let itemDict: NSDictionary = item as? NSDictionary {
                                var id: String = ""
                                if let idFromDict: String = itemDict.object(forKey: "id") as? String {
                                    id = idFromDict
                                }
                                var title: String = ""
                                if let titleFromDict: String = itemDict.object(forKey: "title") as? String {
                                    title = titleFromDict
                                }
                                let category: (id: String, text: String) = (id, title)

                                // Add to array filter
                                if self.arrayFilters.count > 0 {
                                    self.arrayFilters[self.arrayFilters.count - 1].append(category)
                                }
                            }
                        }
                    }
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }

            self.mTableViewListNotifcation.reloadData()
        }
    }
}

extension PointByteCollectionview: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayJobItems.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return UIEdgeInsets(top: 10 * scale, left: 0, bottom: 10 * scale, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        return CGSize(width: 142 * scale, height: 157 * scale)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PointByteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemPointByteCell", for: indexPath) as! PointByteCell
        if self.arrayJobItems.count > indexPath.row {
            if let dict = self.arrayJobItems[indexPath.row] as? NSDictionary {
                cell.delegate = self
                cell.indexPath = indexPath
                cell.updateCellFromDict(dict: dict)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrayJobItems[indexPath.row] as! NSDictionary
        self.delegate?.clickedPointByteItemFromSender(sender: self, atIndexPath: indexPath, object: dict)
    }
}

extension PointByteCollectionview:UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayFilters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayFilters.indices.contains(section) == true {
            return max(0, self.arrayFilters[section].count - 1)
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1 * scale
        }
        return 26 * scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.arrayFilters.indices.contains(section) == true {
            if self.arrayFilters[section].indices.contains(0) == true {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 26 * scale ))
                view.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "6C5032")
                let label = UILabel(frame: CGRect(x: 14 * scale, y: 0, width: SIZE_WIDTH, height: 26 * scale))
                label.textColor = .white
                label.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
                label.text = self.arrayFilters[section][0].text
                view.addSubview(label)
                return view
            }
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * scale
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notificationFilterCell") as? NotficationFilterCell {
            // Update state
            if (self.selectedFilterIndex.section == indexPath.section) && (self.selectedFilterIndex.row == indexPath.row) {
                cell.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#D8C0A4")
                cell.mButtonCheck.isHidden = false
                cell.mLabelContent.textColor = .white
            }
            else {
                cell.backgroundColor = .white
                cell.mLabelContent.textColor = GlobalMethod.hexStringToUIColor(hex: "#6C5032")
                cell.mButtonCheck.isHidden = true
            }

            // Update last line
            if (self.arrayFilters.count == indexPath.section + 1) && (self.arrayFilters.last?.count == indexPath.row + 2) {
                cell.mLastLineView.isHidden = false
            } else {
                cell.mLastLineView.isHidden = true
            }

            // Update leading
            if indexPath.section == 0 {
                cell.mLeadingConstraintLabelContent.constant = 18 * scale
            } else {
                cell.mLeadingConstraintLabelContent.constant = 40 * scale
            }

            // Update text
            cell.mLabelContent.text = ""
            if self.arrayFilters.indices.contains(indexPath.section) == true {
                if self.arrayFilters[indexPath.section].indices.contains(indexPath.row + 1) == true {
                    cell.mLabelContent.text = self.arrayFilters[indexPath.section][indexPath.row + 1].text
                }
            }

            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFilterIndex = indexPath
        self.mTableViewListNotifcation.reloadData()
        self.pageContent = 1
        self.generateParamAndCallAPI()
        self.callbackActionClickedButtonFilter()
    }
}

extension PointByteCollectionview: PointByteCellCellDelegate {
    func clickedFavoritedImageOnPointByteCell(sender: PointByteCell, value: String) {
        if self.selectedButton == self.btnJobList {
            self.refreshContent()
        }
        else {
            if let dict = self.arrayJobItems[sender.indexPath.row] as? NSDictionary {
                let mulDict = NSMutableDictionary(dictionary: dict)
                mulDict.setValue(value, forKey: "is_favorite")
                self.arrayJobItems.replaceObject(at: sender.indexPath.row, with: mulDict)
            }
        }
    }
}

extension PointByteCollectionview:SearchBarCustomViewDelegate{
    func callAPISearchPointItems(keyword: String) {
        self.keywordSearching = keyword
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        self.generateParamAndCallAPI()
    }
    
    func callbackActionClickedButtonFilter() {
        self.mTableViewListNotifcation.isHidden = !self.mTableViewListNotifcation.isHidden
    }
}
