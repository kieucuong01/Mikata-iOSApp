//
//  NotificationLineCollectionView.swift
//  SmartTablet
//
//  Created by thanhlt on 7/19/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol NotificationLineCollectionViewDelegate:class {
    func clickedCellGoToNoteDetailVC(sender:NotificationLineCollectionView, object: NoteObj)
    func clickedButtonGoToCreateNewPost(sender:NotificationLineCollectionView)
}

class NotificationLineCollectionView: UICollectionViewCell {

    @IBOutlet weak var mButtonCreatePost: UIButton!

    @IBOutlet weak var filterTableView: TPKeyboardAvoidingTableView!
    @IBOutlet weak var tableListNotification: TPKeyboardAvoidingTableView!

    @IBOutlet weak var mTopConstraintTableViewNotification: NSLayoutConstraint!
    var arrayPostInNoteItems:[NoteObj] = [NoteObj]()
    var scale : CGFloat = DISPLAY_SCALE
    var selectedIndex: Int = 0
    var isSelectedNote: Int = 1
    var selectedButton: UIButton? = nil
    var keywordSearching: String = ""
    var selectedJenreId: Int = 0
    var pageContent: Int = 1
    let limitContent: Int = 20
    var numberSection = 2

    var arrayFilters:[String] = ["すべて", "ファッション", "ダイエット", "美容", "音楽・映画", "トラベル", "グルメ", "イベント", "キャリア"]
    weak var delegate:NotificationLineCollectionViewDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE


        self.setPropertiesForViews()

        // Load filter table
        self.filterTableView.reloadData()

        // Set load more and refresh
        self.tableListNotification.alwaysBounceVertical = true
        self.tableListNotification.addPullToRefreshHandler {
            self.pageContent = 1
            self.generateParamsAndCallAPI()
        }
        self.tableListNotification.addInfiniteScrollingWithHandler {
            self.pageContent = self.pageContent + 1
            self.generateParamsAndCallAPI()
        }
    }

    //MARK: - Refresh content

    func refreshContent() {
        self.selectedIndex = 0
        if self.selectedButton == nil {
            self.callbackDelegateToClickedButonFirst(sender: nil)
        }
        else {
            self.selectedButton?.sendActions(for: UIControlEvents.touchUpInside)
        }
    }

    func setPropertiesForViews() {
        
        self.mTopConstraintTableViewNotification.constant = 60 * scale
        
        // Hide filter table
        self.filterTableView.isHidden = true
        self.tableListNotification.isHidden = !self.filterTableView.isHidden
        self.mButtonCreatePost.isHidden = (!self.filterTableView.isHidden || self.selectedIndex == 3)
        
        let nib = UINib(nibName: "CustomHeaderCell", bundle: nil)
        self.tableListNotification.register(nib, forCellReuseIdentifier: "customHeaderCell")
        
        let nibFilter = UINib(nibName: "CustomHeaderFilterCell", bundle: nil)
        self.tableListNotification.register(nibFilter, forCellReuseIdentifier: "customHeaderFIlterCell")
        
        
        
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.tableListNotification.delegate = self
        self.tableListNotification.dataSource = self
    }



    @IBAction func clickedButtonCreateNewPost(_ sender: Any) {
        self.delegate?.clickedButtonGoToCreateNewPost(sender: self)
    }

    //MARK:-  Call API

    func generateParamsAndCallAPI() {
        if self.pageContent == 1 {
            self.tableListNotification.setShowsInfiniteScrolling(true)
            self.arrayPostInNoteItems.removeAll()
        }

        var params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "keyword": self.keywordSearching,
            "jenre_id": String(self.selectedJenreId),
            "page": self.pageContent,
            "limit": self.limitContent
        ]

        if self.selectedIndex == 1 {
            self.callAPIGetPostItems(params:params)
        }
        else if self.selectedIndex == 2 {
            self.callAPIGetPostItemsFavorite(params:params)
        }
        else if self.selectedIndex == 3 {
            params["from_admin"] = NSNumber.init(value: 1)

            if self.isSelectedNote == 1 {
                params["note_list"] = NSNumber.init(value: 1)
            } else {
                params["comment_list"] = NSNumber.init(value: 1)
            }

            self.callAPIGetListNotePostComment(params: params)
        }
    }
    
    func reuseTableViewCellForFilterTable(indexPath:IndexPath) -> UITableViewCell {
        var cell = self.filterTableView.dequeueReusableCell(withIdentifier: "notificationFilterCell") as? NotficationFilterCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("NotficationFilterCell", owner: self, options: nil)![0] as? NotficationFilterCell
        }
        
        // Update state
        if self.selectedJenreId == indexPath.row {
            cell?.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#D8C0A4")
            cell?.mButtonCheck.isHidden = false
            cell?.mLabelContent.textColor = .white
        }
        else {
            cell?.backgroundColor = .white
            cell?.mLabelContent.textColor = GlobalMethod.hexStringToUIColor(hex: "#6C5032")
            cell?.mButtonCheck.isHidden = true
        }
        
        if indexPath.row == (arrayFilters.count - 1) {
            cell?.mLastLineView.isHidden = false
        } else {
            cell?.mLastLineView.isHidden = true
        }
        
        if self.arrayFilters.indices.contains(indexPath.row) == true {
            cell?.mLabelContent.text = arrayFilters[indexPath.row]
        }
        return cell!
    }
    
    func reuseTableViewCellForListNote(indexPath:IndexPath) -> UITableViewCell {
        if selectedIndex == 3 && isSelectedNote == 2 {
            var cell: NotificationNoteImageCell? = self.tableListNotification.dequeueReusableCell(withIdentifier: "notificationNoteImageCell") as? NotificationNoteImageCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("NotificationNoteImageCell", owner: self, options: nil)![0] as? NotificationNoteImageCell
            }
            
            cell?.parentClass = self
            cell?.parentTableView = self.tableListNotification
            cell?.cellIndex = indexPath
            
            if self.arrayPostInNoteItems.indices.contains(indexPath.row) == true {
                let dict = self.arrayPostInNoteItems[indexPath.row]
                cell?.updateCellFromDict(note: dict, indexPath: indexPath)
            }
            
            return cell!
        } else {
            var cell = self.tableListNotification.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("NotificationCell", owner: self, options: nil)![0] as? NotificationCell
            }
            
            cell?.parentClass = self
            cell?.parentTableView = self.tableListNotification
            cell?.cellIndex = indexPath
            
            if self.arrayPostInNoteItems.indices.contains(indexPath.row) == true {
                let dict = self.arrayPostInNoteItems[indexPath.row]
                cell!.updateCellFromDict(note: dict)
            }
            if selectedIndex == 3 && isSelectedNote == 1 {
                cell!.mButtonDelete.isHidden = false
            } else {
                cell!.mButtonDelete.isHidden = true
            }
            return cell!
        }
    }
    

    func callAPIGetPostItems(params: [String : Any]?) {
        if self.pageContent == 1 {
            NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        }
        APIBase.shareObject.callAPIGetNotepostListPost(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        self.arrayPostInNoteItems.append(NoteObj(dict: item as! NSDictionary))
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.tableListNotification.setShowsInfiniteScrolling(false)
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }
            
            let indexSet = IndexSet(integer: 2)
            self.tableListNotification.reloadSections(indexSet, with: .automatic)
            self.tableListNotification.pullToRefreshView?.stopAnimating()
            self.tableListNotification.infiniteScrollingView?.stopAnimating()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }

    func callAPIGetPostItemsFavorite(params: [String : Any]?) {
        if self.pageContent == 1 {
            NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        }
        APIBase.shareObject.callAPIGetNotepostListFavorite(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        self.arrayPostInNoteItems.append(NoteObj(dict: item as! NSDictionary))
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.tableListNotification.setShowsInfiniteScrolling(false)
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }
            let indexSet = IndexSet(integer: 2)
            self.tableListNotification.reloadSections(indexSet, with: .automatic)
            self.tableListNotification.pullToRefreshView?.stopAnimating()
            self.tableListNotification.infiniteScrollingView?.stopAnimating()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }


    func callAPIGetListNotePostComment(params: [String : Any]?) {
        if self.pageContent == 1 {
            NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        }
        APIBase.shareObject.callAPIGetNotepostListNoteComment(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body: NSDictionary = result?.object(forKey: "body") as! NSDictionary
                var noteOrComment: NSDictionary? = nil
                if self.isSelectedNote == 1 { noteOrComment = body.object(forKey: "note") as? NSDictionary }
                else { noteOrComment = body.object(forKey: "comment") as? NSDictionary }

                let arrays = noteOrComment?.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        self.arrayPostInNoteItems.append(NoteObj(dict: item as! NSDictionary))
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.tableListNotification.setShowsInfiniteScrolling(false)
                }
            } else {
                // let error = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary
            }
            let indexSet = IndexSet(integer: 2)
            self.tableListNotification.reloadSections(indexSet, with: .automatic)
            self.tableListNotification.pullToRefreshView?.stopAnimating()
            self.tableListNotification.infiniteScrollingView?.stopAnimating()
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }
    }
}

extension NotificationLineCollectionView : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.filterTableView {
            return 1
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.filterTableView {
            return arrayFilters.count
        } else {
            if section == 2 {
                return arrayPostInNoteItems.count
            } else {
                return 1
            }
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.filterTableView {
            return 45 * scale
        } else {
            if indexPath.section == 0 {
                return 102 * scale
            } else if indexPath.section == 1 {
                if selectedIndex == 3 {
                    return 51 * scale
                } else {
                    return 0
                }
            } else {
                return UITableViewAutomaticDimension
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.filterTableView {
            return 45 * scale
        } else {
            if indexPath.section == 0 {
                return 102 * scale
            } else if indexPath.section == 1 {
                if selectedIndex == 3 {
                    return 51 * scale
                } else {
                    return 0
                }
            } else {
                return UITableViewAutomaticDimension
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.filterTableView {
           return self.reuseTableViewCellForFilterTable(indexPath: indexPath)
        }
        else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customHeaderCell") as? CustomHeaderCell
                
                cell?.setFilterButtonForCell()
                let string1 = NSLocalizedString("note_screen_button_title_all_list", comment: "note screen all")
                let string2 = NSLocalizedString("note_screen_button_title_favorite", comment: "note screen favorite")
                let string3 = NSLocalizedString("note_screen_button_title_my_post", comment: "note screen myposst")
                cell?.setTitles(title1: string1, title2: string2, title3: string3)
                cell?.delegate = self
                return cell!
           } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customHeaderFIlterCell") as? CustomHeaderFilterCell
                cell?.delegate = self
                cell?.selectButton = self.isSelectedNote
                cell?.setColorButtonSelected()
                return cell!
           } else {
                return self.reuseTableViewCellForListNote(indexPath: indexPath)
           }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.filterTableView {
            self.selectedJenreId = indexPath.row
            self.filterTableView.reloadData()
            self.pageContent = 1
            self.generateParamsAndCallAPI()
            self.callbackDelegateToFilterSelect(sender: nil)
        } else {
            if indexPath.section == 2 {
                tableView.deselectRow(at: indexPath, animated: true)
                self.delegate?.clickedCellGoToNoteDetailVC(sender: self, object: self.arrayPostInNoteItems[indexPath.row])
            }
        }
    }
}

extension NotificationLineCollectionView: CustomHeaderFilterCellDelegate {
    func callbackDelegateToClickedButtonLeft(sender: CustomHeaderFilterCell?) {
        if self.selectedIndex == 3 && self.isSelectedNote == 1 {return}
        self.endEditing(true)
        self.selectedIndex = 3
        self.isSelectedNote = 1
        self.selectedButton = sender?.mButtonLeft

        let indexSet = IndexSet(integer: 1)
        self.tableListNotification.reloadSections(indexSet, with: .none)
        self.mButtonCreatePost.isHidden = true

        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
    
    func callbackDelegateToClickedButtonRight(sender: CustomHeaderFilterCell?) {
        if self.selectedIndex == 3 && isSelectedNote == 2 {return}
        self.endEditing(true)
        self.selectedIndex = 3
        isSelectedNote = 2
        self.selectedButton = sender?.mButtonRight

        let indexSet = IndexSet(integer: 1)
        self.tableListNotification.reloadSections(indexSet, with: .none)
        self.mButtonCreatePost.isHidden = true

        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
}


extension NotificationLineCollectionView: CustomHeaderCellDelegate {
    func callbackDelegateToClickedButonFirst(sender: CustomHeaderCell?) {
        if selectedIndex == 1 { return }
        self.endEditing(true)
        self.selectedIndex = 1
        self.selectedButton = sender?.mButtonFirst

        let indexSet = IndexSet(integer: 1)
        self.tableListNotification.reloadSections(indexSet, with: .none)
        self.mButtonCreatePost.isHidden = false

        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }

    func callbackDelegateToClickedButonSecond(sender: CustomHeaderCell?) {
        if selectedIndex == 2  { return }
        self.endEditing(true)
        self.selectedIndex = 2
        self.selectedButton = sender?.mButtonSecond

        let indexSet = IndexSet(integer: 1)
        self.tableListNotification.reloadSections(indexSet, with: .none)
        self.mButtonCreatePost.isHidden = false
        
        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
    
    func callbackDelegateToClickedButonThird(sender: CustomHeaderCell?) {
        if selectedIndex == 3 { return }
        self.endEditing(true)
        self.selectedIndex = 3
        self.selectedButton = sender?.mButtonThird

        let indexSet = IndexSet(integer: 1)
        self.tableListNotification.reloadSections(indexSet, with: .none)
        self.mButtonCreatePost.isHidden = true
        
        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
    
    func callbackDelegateToFilterSelect(sender: CustomHeaderCell?) {
        self.endEditing(true)
        self.filterTableView.isHidden = !self.filterTableView.isHidden
        self.mButtonCreatePost.isHidden = (!self.filterTableView.isHidden || self.selectedIndex == 3)

        // Update list
        self.tableListNotification.isScrollEnabled = self.filterTableView.isHidden
        self.tableListNotification.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func callbackDelegateToSetKeyword(sender: CustomHeaderCell?, keyword: String) {
        self.keywordSearching = keyword
        self.pageContent = 1
        self.generateParamsAndCallAPI()
    }
}
