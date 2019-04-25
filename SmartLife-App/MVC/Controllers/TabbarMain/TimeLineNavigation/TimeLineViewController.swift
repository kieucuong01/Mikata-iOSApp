
//
//  TimeLineViewController.swift
//  SmartTablet
//
//  Created by thanhlt on 7/7/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class TimeLineViewController: UIViewController {


    @IBOutlet weak var botCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewCategory: UIScrollView!
    @IBOutlet weak var collectionView: TPKeyboardAvoidingCollectionView!

    var viewLineCategorySelected: UIView = UIView()
    var viewCategorySelected: UIView = UIView()
    var isGoneTopView : Bool = false
    private var widthContentSize:CGFloat = 0
    var scale:CGFloat = DISPLAY_SCALE
    var arrRectCategory: [CGRect] = []
    var selectedCategory : Int = -1
    var lastOffsetXCategory:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerClassForCollectionViewCell()
        registerNotificationCenter()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.createComponentsScrollView()
        self.heightTopViewConstraint.constant = 51.2 * GlobalMethod.displayScale
        self.botCollectionViewConstraint.constant = 51.2 * GlobalMethod.displayScale
        self.view.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setVisibleForNavbar(isHidden: self.isGoneTopView)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
        NotificationCenter.default.post(name: NSNotificationNavbarMainChangeTitle, object: NSLocalizedString("timelineview_navbar", comment: ""))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollViewCategory.tag = 99
        self.collectionView.tag = 98
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        FirebaseGlobalMethod.tabbarMainVC?.setHideTitleTabar(isHiden: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Getter
    func setGoneTopView(isHidden : Bool) {
        self.isGoneTopView = isHidden
        if isHidden == true {
            self.heightTopViewConstraint.constant = 0.0
            self.botCollectionViewConstraint.constant = 0.0
        }
        else {
            self.heightTopViewConstraint.constant = 51.2 * GlobalMethod.displayScale
            self.botCollectionViewConstraint.constant = 51.2 * GlobalMethod.displayScale
        }

        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }

    func setVisibleForNavbar(isHidden : Bool) {
        self.setHideNavBar(isHiden: isHidden)
        self.setGoneTopView(isHidden: isHidden)
    }

    private func createComponentsScrollView() {
        self.view.layoutIfNeeded()

        // Set attribute for viewCategorySelected
        self.viewLineCategorySelected.backgroundColor = UIColor.black
        self.viewLineCategorySelected.frame = CGRect(x: 0.0, y: self.scrollViewCategory.frame.size.height - 5.0, width: 0.0, height: 2.0)
        self.viewCategorySelected.backgroundColor = primaryColor
        self.viewCategorySelected.frame = CGRect(x: 0.0, y: self.scrollViewCategory.frame.size.height - 8.0, width: 80.0, height: 8.0)

        let arrays = [NSLocalizedString("timelineview_timeline_tab_title", comment: ""),
                      NSLocalizedString("timelineview_getpoint_tab_title", comment: ""),
                      NSLocalizedString("timelineview_exchangepoint_tab_title", comment: ""),
                      NSLocalizedString("timelineview_jobbyte_tab_title", comment: ""),
                      NSLocalizedString("timelineview_jobintroduction_tab_title", comment: "")]
        for i in 0..<arrays.count {
            let label = UILabel()
            label.text = arrays[i]
            label.font = UIFont.boldSystemFont(ofSize: 10 * scale)
            label.textColor = grayColor
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.sizeToFit()
            
            let width:CGFloat = label.frame.size.width + 17.0 * scale
            let hegiht:CGFloat = self.scrollViewCategory.frame.size.height
            let viewSub = UIView(frame: CGRect(x: widthContentSize , y: 0, width: width, height: hegiht))
            viewSub.backgroundColor = .clear
            label.frame = viewSub.bounds

            viewSub.tag = i + 20
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
            viewSub.addGestureRecognizer(tapGesture)
            viewSub.addSubview(label)
            widthContentSize += width
            if i < 7 {
                arrRectCategory.append(viewSub.frame)
            }
            self.scrollViewCategory.addSubview(viewSub)
        }

        self.viewLineCategorySelected.frame.size = CGSize(width: widthContentSize, height: 2.0)
        self.scrollViewCategory.addSubview(self.viewLineCategorySelected)

        self.viewCategorySelected.frame.size = CGSize(width: arrRectCategory[0].width, height: 8.0)
        self.scrollViewCategory.addSubview(self.viewCategorySelected)
        
        self.scrollViewCategory.contentSize = CGSize(width: widthContentSize, height: 0)
        self.lastOffsetXCategory = 0
        
    }
    
    private func registerClassForCollectionViewCell() {
        self.collectionView.register( UINib(nibName: "TimeLineCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "timeLineCollectionView")
        self.collectionView.register( UINib(nibName: "PointGetCollectionView", bundle:nil), forCellWithReuseIdentifier: "listPointGetCollectionView")
        self.collectionView.register( UINib(nibName: "PointExchangeCollectionview", bundle:nil), forCellWithReuseIdentifier: "listPointExchangeCollectionCell")
        self.collectionView.register( UINib(nibName: "PointByteCollectionview", bundle:nil), forCellWithReuseIdentifier: "listPointByteCollectionCell")
        self.collectionView.register( UINib(nibName: "PointJobCollectionview", bundle:nil), forCellWithReuseIdentifier: "listPointJobCollectionCell")
        self.collectionView.register( UINib(nibName: "NotificationLineCollectionView", bundle:nil), forCellWithReuseIdentifier: "listNotificationCollectionView")
        self.collectionView.register( UINib(nibName: "ListJobCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "listJobCollectionCell")
        
        
        self.collectionView.register( UINib(nibName: "NewPointExchangeUICollectionView", bundle:nil), forCellWithReuseIdentifier: "newPointExchangeCollectionCell")
        self.collectionView.register( UINib(nibName: "NewPointGetUICollectionView", bundle:nil), forCellWithReuseIdentifier: "newPointGetCollectionCell")
    }
    
    private func registerNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(TimeLineViewController.showHUDProgress), name: NSNotificationShowHUDProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TimeLineViewController.hideHUDProgress), name: NSNotificationHideHUDProgress , object: nil)
    }
    
    //MARK: - Gesture Recognizer
    @objc func tap(sender: UITapGestureRecognizer?) {
        self.view.endEditing(true)
        if let view = sender?.view {
            print("\(String(describing: view.tag))")

            // view.tag = index + 20
            let indexView: Int = max(0, view.tag - 20)
            self.selectedCategory = indexView
            // Update collection view
            if self.collectionView.numberOfItems(inSection: 0) > indexView {
                let indexPath: IndexPath = IndexPath(item: indexView, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            }
        }
    }
    
    //Obverse
    
    @objc func hideHUDProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    @objc func showHUDProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
}


extension TimeLineViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SIZE_WIDTH, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index:Int = indexPath.row % 6
        switch index {
        case 0:
            // Track Repro Timeline
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_TIMELINE, eventName: nil)
            if let checkCell: TimeLineCollectionCell = cell as? TimeLineCollectionCell {
                if self.selectedCategory == 1 || self.selectedCategory == -1 {
                    checkCell.refreshContent()
                }
            }
            break
        case 1:
            if let checkCell: NewPointGetUICollectionView = cell as? NewPointGetUICollectionView {
                if self.selectedCategory == 1 || self.selectedCategory == -1 {
                    checkCell.refreshContent()
                }
            }
            break
        case 2:
            if let checkCell: NewPointExchangeUICollectionView = cell as? NewPointExchangeUICollectionView {
                if self.selectedCategory == 2  || self.selectedCategory == -1  {
                    checkCell.refreshContent()
                }
            }
            break
        case 3:
            if let checkCell: PointByteCollectionview = cell as? PointByteCollectionview {
                checkCell.selectedFilterIndex = IndexPath(row: 0, section: 0)
                checkCell.mTableViewListNotifcation.reloadData()
                if self.selectedCategory == 3  || self.selectedCategory == -1 {
                    checkCell.refreshContent()
                }
            }
            break
        case 4:
            if let checkCell: PointJobCollectionview = cell as? PointJobCollectionview {
                checkCell.selectedFilterIndex = IndexPath(row: 0, section: 0)
                checkCell.mTableViewListNotifcation.reloadData()
                if self.selectedCategory == 4  || self.selectedCategory == -1 {
                    checkCell.refreshContent()
                }
            }
            break
        default:
            if let checkCell: NotificationLineCollectionView = cell as? NotificationLineCollectionView {
                checkCell.selectedJenreId = 0
                checkCell.filterTableView.reloadData()
                checkCell.refreshContent()
            }
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index:Int = indexPath.row % 6
        switch index {
        case 0:
            let cell:TimeLineCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeLineCollectionView", for: indexPath) as! TimeLineCollectionCell
            cell.parentVC = self
            cell.delegate = self
            return cell
        case 1:

            /* OLD SOURCE
           let cell:PointGetCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "listPointGetCollectionView", for: indexPath) as!PointGetCollectionView
            OLD SOURCE */
             let cell:NewPointGetUICollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "newPointGetCollectionCell", for: indexPath) as!NewPointGetUICollectionView
             cell.delegate = self
            return cell
        case 2:
            /* OLD SOURCE
            let cell:PointExchangeCollectionview = collectionView.dequeueReusableCell(withReuseIdentifier: "listPointExchangeCollectionCell", for: indexPath) as! PointExchangeCollectionview
            OLD SOURCE */
            
            let cell:NewPointExchangeUICollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "newPointExchangeCollectionCell", for: indexPath) as!NewPointExchangeUICollectionView
            cell.delegate = self
            return cell
        case 3:
            /* OLD SOURCE
            let cell:ListJobCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listJobCollectionCell", for: indexPath) as! ListJobCollectionViewCell
             OLD SOURCE*/
            let cell:PointByteCollectionview = collectionView.dequeueReusableCell(withReuseIdentifier: "listPointByteCollectionCell", for: indexPath) as! PointByteCollectionview
            cell.delegate = self
            return cell
        case 4:
            let cell:PointJobCollectionview = collectionView.dequeueReusableCell(withReuseIdentifier: "listPointJobCollectionCell", for: indexPath) as! PointJobCollectionview
            cell.delegate = self
            return cell
        default:
            let cell:NotificationLineCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "listNotificationCollectionView", for: indexPath) as! NotificationLineCollectionView
            cell.delegate = self
            return cell
        }
        
    }
}

//MARK: - Delegate

// - TimeLineCollectionCellDelegate
extension TimeLineViewController: TimeLineCollectionCellDelegate {
    func errorAPIAppear(message: String?) {
        let alertController = UIAlertController(title: NSLocalizedString("alert_warning_title", comment: ""), message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: NSLocalizedString("button_cancel_title", comment: ""), style: .cancel, handler:nil)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//------------Delegate Pointget category
// NEW
extension TimeLineViewController: NewPointGetUICollectionViewDelegate {
    func didSelectedCellPointGetCollection(dict: NSDictionary) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:GetPointDetailViewController = storyboard.instantiateViewController(withIdentifier: "getPointDetailVC") as! GetPointDetailViewController
        vc.infoItem = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// OLD
//extension TimeLineViewController: PointGetCollectionViewDelegate {
//    func didSelectedCellPointGetCollection(dict: NSDictionary) {
//        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
//        let vc:GetPointDetailViewController = storyboard.instantiateViewController(withIdentifier: "getPointDetailVC") as! GetPointDetailViewController
//        vc.infoItem = dict
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//---------Delegate Pointget category




//------------Delegate Point exchange category
// NEW
extension TimeLineViewController: NewPointExchangeUICollectionViewDelegate {
    func didSelectedCellPointExchangeCollection(sender: NewPointExchangeUICollectionView, dict: NSDictionary) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:ExchangePointDetailViewController = storyboard.instantiateViewController(withIdentifier: "exchangePointDetailVC") as! ExchangePointDetailViewController
        vc.infoItem = NSMutableDictionary(dictionary: dict)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didSelectedCellPointExchangeCompleteCollection(sender: NewPointExchangeUICollectionView, dict: NSDictionary) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:ExchangePointDetailCompleteViewController = storyboard.instantiateViewController(withIdentifier: "exchangePointDetailCompleteVC") as! ExchangePointDetailCompleteViewController
        vc.infoItem = NSMutableDictionary(dictionary: dict)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// OLD
//extension TimeLineViewController: PointExchangeCollectionViewDelegate {
//    func clickedItemInCollectionView(sender: PointExchangeCollectionview, dict: NSDictionary) {
//        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
//        let vc:ExchangePointDetailViewController = storyboard.instantiateViewController(withIdentifier: "exchangePointDetailVC") as! ExchangePointDetailViewController
//        vc.infoItem = NSMutableDictionary(dictionary: dict)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//---------Delegate Pointget category

extension TimeLineViewController: PointJobCollectionViewDelegate {
    func clickedPointJobItemFromSender(sender: PointJobCollectionview, atIndexPath index: IndexPath, object: NSDictionary) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:DetailJobIntroductionViewController = storyboard.instantiateViewController(withIdentifier: "detailJobIntroductionVC") as! DetailJobIntroductionViewController
        vc.infoItem = NSMutableDictionary(dictionary: object)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TimeLineViewController: PointByteCollectionViewDelegate {
    func clickedPointByteItemFromSender(sender: PointByteCollectionview, atIndexPath index: IndexPath, object: NSDictionary) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:DetailByteIntroductionViewController = storyboard.instantiateViewController(withIdentifier: "detailByteIntroductionVC") as! DetailByteIntroductionViewController
        vc.infoItem = NSMutableDictionary(dictionary: object)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TimeLineViewController: ListJobCollectionViewCellDelegate {
    func callbackDelegateToSelectItemOfListByte(sender: ListJobCollectionViewCell, index: IndexPath) {
//
//        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
//        let vc:ByteRuleViewController = storyboard.instantiateViewController(withIdentifier: "byteRuleVC") as! ByteRuleViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:DetailJobIntroductionViewController = storyboard.instantiateViewController(withIdentifier: "detailJobIntroductionVC") as! DetailJobIntroductionViewController
//        vc.infoItem = NSMutableDictionary(dictionary: object)
        vc.titleUpdate = "バイト詳細"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TimeLineViewController: NotificationLineCollectionViewDelegate {
    func clickedCellGoToNoteDetailVC(sender: NotificationLineCollectionView, object: NoteObj) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        let vc:NoteTimeLineDetailViewController = storyboard.instantiateViewController(withIdentifier: "noteTimeLineDetailVC") as! NoteTimeLineDetailViewController
        vc.noteObject = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clickedButtonGoToCreateNewPost(sender: NotificationLineCollectionView) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        if let vc:CreateNewNoteViewController = storyboard.instantiateViewController(withIdentifier: "createnewnoteVC") as? CreateNewNoteViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TimeLineViewController: UIScrollViewDelegate {
    func checkAndUpdateScrollViewCategory() {
        if self.viewCategorySelected.frame.origin.x < self.scrollViewCategory.contentOffset.x {
            self.scrollViewCategory.contentOffset.x = self.viewCategorySelected.frame.origin.x

            print( self.scrollViewCategory.contentOffset.x)
        }
        else if (self.viewCategorySelected.frame.origin.x + self.viewCategorySelected.frame.size.width) > (self.scrollViewCategory.contentOffset.x + self.scrollViewCategory.frame.size.width) {
            self.scrollViewCategory.contentOffset.x = (self.viewCategorySelected.frame.origin.x + self.viewCategorySelected.frame.size.width) - self.scrollViewCategory.frame.size.width

            print( self.scrollViewCategory.contentOffset.x)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.view.endEditing(true)
            // Left view
            let leftIndex: Int = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
            let leftWidth: CGFloat = (self.collectionView.frame.size.width * CGFloat(leftIndex + 1)) - self.collectionView.contentOffset.x
            let leftPercent: CGFloat = (leftWidth / self.collectionView.frame.size.width)

            // Right view
            let rightIndex: Int = leftIndex + 1
            let rightWidth: CGFloat = self.collectionView.frame.size.width - leftWidth
            let rightPercent: CGFloat = (rightWidth / self.collectionView.frame.size.width)

            // New X
            var newX: CGFloat = 0.0

            // New Y
            let newY: CGFloat = self.viewCategorySelected.frame.origin.y

            // New width
            var newWidth: CGFloat = 0.0
            if self.arrRectCategory.indices.contains(leftIndex) == true {
                newWidth = newWidth + self.arrRectCategory[leftIndex].width * leftPercent
                newX = (self.arrRectCategory[leftIndex].origin.x + self.arrRectCategory[leftIndex].width) - newWidth
            }
            if self.arrRectCategory.indices.contains(rightIndex) == true {
                newWidth = newWidth + self.arrRectCategory[rightIndex].width * rightPercent
            }

            // New height
            let newHeight: CGFloat = self.viewCategorySelected.frame.size.height

            // Update frame
            let newViewCategorySelectedFrame: CGRect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            self.viewCategorySelected.frame = newViewCategorySelectedFrame
            self.viewCategorySelected.layoutIfNeeded()

            self.checkAndUpdateScrollViewCategory()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.selectedCategory = -1
    }
}
