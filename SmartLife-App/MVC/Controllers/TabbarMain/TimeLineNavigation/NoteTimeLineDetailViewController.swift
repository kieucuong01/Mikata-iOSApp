//
//  NoteTimeLineDetailViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/13/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NoteTimeLineDetailViewController: BaseViewController {
    
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var mLabelTitleNav: UILabel!
    @IBOutlet weak var mLabelTitleNote: UILabel!
    
    @IBOutlet weak var mLabelNumberComment: UILabel!
    @IBOutlet weak var mLabelNumberHeart: UILabel!
    @IBOutlet weak var mLabelDate: UILabel!
    
    @IBOutlet weak var mViewTag: UIView!
    @IBOutlet weak var mButtonFavorite: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    
    @IBOutlet weak var mHeightConstraintViewTag: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelNote: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelNote: NSLayoutConstraint!
    @IBOutlet weak var mLeadingConstraintLabelNote: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintButtonFavorite: NSLayoutConstraint!
    @IBOutlet weak var mTrailingConstraintViewTag: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintViewTag: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintViewTag: NSLayoutConstraint!
    
    @IBOutlet weak var mBottomConstraintCreateNewComment: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintTableViewListComment: NSLayoutConstraint!

    var noteObject: NoteObj? = nil
    var noteItemDetail: NSMutableDictionary = [:]
    var listComment: [NSDictionary] = []
    var listCommentImageSize: [[String: CGSize]] = []
    var pageContent: Int = 1
    let limitContent: Int = 20
    
    var arrayTags:[String] = []
    var arrayHeight:[CGFloat] = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topContentView.isHidden = true
        self.mTableView.isHidden = true
        self.setFontForViews()
        self.setConstraintForViews()
        // Do any additional setup after loading the view.

        // Set load more and refresh
        self.mTableView.addPullToRefreshHandler {
            self.pageContent = 1
            self.callAPIGetDetailNote()
        }
        self.mTableView.addInfiniteScrollingWithHandler {
            self.pageContent = self.pageContent + 1
            self.callAPIGetDetailNote()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        self.pageContent = 1
        self.callAPIGetDetailNote()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setFontForViews() {
        self.mLabelTitleNav.font = UIFont(name: self.mLabelTitleNav.font.fontName, size: 14 * scaleDisplay)
        self.mLabelTitleNote.font = UIFont(name: self.mLabelTitleNote.font.fontName, size: 14 * scaleDisplay)
        self.mLabelNumberComment.font = UIFont(name: self.mLabelNumberComment.font.fontName, size: 8 * scaleDisplay)
        self.mLabelNumberHeart.font = UIFont(name: self.mLabelNumberHeart.font.fontName, size: 8 * scaleDisplay)
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName, size: 8 * scaleDisplay)
        self.mButtonFavorite.titleLabel!.font = UIFont(name: self.mButtonFavorite.titleLabel!.font.fontName, size: 14 * scaleDisplay)
    }
    
    private func setConstraintForViews() {
        self.mBottomConstraintLabelNote.constant = 12 * scaleDisplay
        self.mTopConstraintLabelNote.constant = 7 * scaleDisplay
        self.mLeadingConstraintLabelNote.constant = 14 * scaleDisplay
        self.mTrailingConstraintButtonFavorite.constant = 14 * scaleDisplay
        self.mTrailingConstraintViewTag.constant = 14 * scaleDisplay
        self.mTopConstraintViewTag.constant = 8 * scaleDisplay
        self.mBottomConstraintViewTag.constant = 11 * scaleDisplay
        self.mBottomConstraintTableViewListComment.constant = 14 * scaleDisplay
        self.mBottomConstraintCreateNewComment.constant = 70 * scaleDisplay
    }

    private func loadTopContent() {
        // Title
        self.mLabelTitleNote.text = self.noteItemDetail.object(forKey: "title") as? String

        // NumberComment
        self.mLabelNumberComment.text = "0"
        let numberCommentString: String? = self.noteItemDetail.object(forKey: "comment_count") as? String
        if numberCommentString != nil && numberCommentString != "" {
            if let numberCommentInt: Int = Int(numberCommentString!) {
                if numberCommentInt > 999 {
                    self.mLabelNumberComment.text = "999+"
                }
                else {
                    self.mLabelNumberComment.text = String(numberCommentInt)
                }
            }
        }

        // NumberHeart
        self.mLabelNumberHeart.text = "0"
        let numberHeartString: String? = self.noteItemDetail.object(forKey: "counts_favorite") as? String
        if numberHeartString != nil && numberHeartString != "" {
            if let numberHeartInt: Int = Int(numberHeartString!) {
                if numberHeartInt > 999 {
                    self.mLabelNumberHeart.text = "999+"
                }
                else {
                    self.mLabelNumberHeart.text = String(numberHeartInt)
                }
            }
        }

        // Date
        let dateString: String = self.getStringDateFromTime(time: self.noteItemDetail.object(forKey: "created") as? String, with: "yyyy.MM.dd")
        self.mLabelDate.text = dateString

        // Favorite
        let isFavoriteString: String? = self.noteItemDetail.object(forKey: "favorite_status") as? String
        if isFavoriteString == "1" { self.mButtonFavorite.isSelected = true }
        else { self.mButtonFavorite.isSelected = false }
    }

    private func loadListTagInView() {
        // Tags
        self.arrayTags.removeAll()
        if let noteJenreString: String = self.noteItemDetail.object(forKey: "jenre_name") as? String {
            if noteJenreString != "-" {
                let arrayJenre: [String] = noteJenreString.components(separatedBy: ",")
                for jenre in arrayJenre {
                    let jenreAfterTrim: String = jenre.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.arrayTags.append(jenreAfterTrim)
                }
            }
        }

        var x:CGFloat = 0
        var y:CGFloat = 0
        let distance = 4 * scaleDisplay
        for text in arrayTags {
            let view = newLabelWithText(string: text, oldX: x, oldY: y)
            x = view.frame.origin.x + view.frame.size.width + distance
            y = view.frame.origin.y
            self.mViewTag.addSubview(view)
        }
        self.mHeightConstraintViewTag.constant = y + 17 * scaleDisplay
    }
    
    func createListHeight(isUpdateIndex: Int?) {
        if isUpdateIndex == nil {
            self.arrayHeight.removeAll()
            var i = 0
            for comment in self.listComment {
                var listContent: [NSDictionary] = []
                if let listContentFromComment: [NSDictionary] = comment.object(forKey: "content") as? [NSDictionary] {
                    listContent = listContentFromComment
                }
                let height = self.getHeightInOneCell(title: String(i), listContent: listContent, listContentImageSize: self.listCommentImageSize[i])
                arrayHeight.append(height)
                i = i + 1
            }
        }
        else {
            let comment: NSDictionary = self.listComment[isUpdateIndex!]
            var listContent: [NSDictionary] = []
            if let listContentFromComment: [NSDictionary] = comment.object(forKey: "content") as? [NSDictionary] {
                listContent = listContentFromComment
            }
            self.arrayHeight[isUpdateIndex!] = self.getHeightInOneCell(title: String(isUpdateIndex!), listContent: listContent, listContentImageSize: self.listCommentImageSize[isUpdateIndex!])
        }
    }
    
    func newLabelWithText(string:String,oldX: CGFloat, oldY: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: oldX, y:oldY , width: 0, height: 0 ))
        view.backgroundColor = GlobalMethod.hexStringToUIColor(hex: "#B89F98")
        let label = UILabel(frame: CGRect(x: 5 * scaleDisplay, y:5 * scaleDisplay , width: 0, height: 0 ))
        label.font = UIFont(name: "YuGothic-Bold", size: 8 * scaleDisplay)
        label.text = string
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        
        var frame = label.frame
        frame.origin.x = oldX
        frame.origin.y = oldY
        frame.size.width = frame.size.width + 10 * scaleDisplay
        frame.size.height = 17 * scaleDisplay
        if frame.size.width > (223 * scaleDisplay) {
            frame.origin.x = 0
            if oldX > 0 {
                frame.origin.y = frame.origin.y + 21 * scaleDisplay
            }
            frame.size.width = 223 * scaleDisplay
        } else {
            if (frame.size.width + frame.origin.x) > (223 * scaleDisplay) {
                frame.origin.x = 0
                frame.origin.y = frame.origin.y + 21 * scaleDisplay
            }
        }
        view.frame = frame
        view.addSubview(label)
        
        return view
    }
    
    
    func getHeightInOneCell(title:String, listContent: [NSDictionary], listContentImageSize: [String: CGSize]) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 14 * scaleDisplay, y: 14 * scaleDisplay, width: 200 * scaleDisplay, height: 14 * scaleDisplay ))
        label.font = UIFont(name: "YuGothic-Bold", size: 14 * scaleDisplay)
        label.numberOfLines = 0
        label.text = title
        label.sizeToFit()

        var curY:CGFloat = label.frame.size.height + 28 * scaleDisplay

        var contentIndex: Int = 0
        for content in listContent {
            // Check content
            if let text = content.object(forKey: "content") as? String {
                let tempLabel = UILabel(frame: CGRect(x: 14 * scaleDisplay, y: curY , width: 292 * scaleDisplay, height: 14 * scaleDisplay ))
                tempLabel.font = UIFont(name: "YuGo-Medium", size: 14 * scaleDisplay)
                tempLabel.text = text
                tempLabel.numberOfLines = 0
                tempLabel.sizeToFit()
                curY = tempLabel.frame.size.height + curY + 7 * scaleDisplay
            }

            // Check image
            if let imagePath: String = content.object(forKey: "image_path") as? String, imagePath != "" {
                let imageSize: CGSize? = listContentImageSize["index" + String(contentIndex)]
                if imageSize == nil || imageSize == CGSize.zero {
                    curY = curY + 7.0 * self.scaleDisplay
                }
                else {
                    let maxWidth: CGFloat = 292 * scaleDisplay
                    let imageWidthNew: CGFloat = min(imageSize!.width, maxWidth)
                    let imageHeightNew: CGFloat = imageSize!.height * imageWidthNew / imageSize!.width
                    curY = curY + imageHeightNew + 7.0 * self.scaleDisplay
                }
            }

            // Update index
            contentIndex = contentIndex + 1
        }
        return curY
    }

    @IBAction func clickedButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedButtonFavorite(_ sender: Any) {
        if let is_favorite = self.noteItemDetail.object(forKey: "favorite_status") as? String {
            self.callAPIFavoriteNotes(currentFavorite: is_favorite)
        }
    }

    // MARK: - Get String Date

    func getStringDateFromTime(time: String?, with formatDate: String) -> String {
        if let dateString: String = time {
            if let dateDouble: Double = TimeInterval(dateString) {
                let date: Date = Date(timeIntervalSince1970: dateDouble)
                let formatter: DateFormatter = DateFormatter()
                formatter.dateFormat = formatDate
                return formatter.string(from: date)
            }
            else { return "-" }
        }
        else { return "-" }
    }
    
    // MARK: - Call API

    func callAPIGetDetailNote() {
        var noteId: String? = nil
        if self.noteObject?.m_note_id != "" { noteId = self.noteObject?.m_note_id }
        else { noteId = self.noteObject?.m_id }

        if noteId != nil && noteId != "" {
            if self.pageContent == 1 {
                self.mTableView.setShowsInfiniteScrolling(true)
                self.listComment.removeAll()
                self.listCommentImageSize.removeAll()
            }

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "id": noteId!,
                "page": self.pageContent,
                "limit": self.limitContent
            ]

            MBProgressHUD.showAdded(to: self.view, animated: true)
            APIBase.shareObject.callAPIGetDetailNote(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let dictDetail: NSDictionary = result?.value(forKey: "body") as? NSDictionary {
                        self.noteItemDetail = NSMutableDictionary(dictionary: dictDetail)
                        // Get list comment
                        if let commentByNote: NSDictionary = self.noteItemDetail.object(forKey: "comment_by_note") as? NSDictionary {
                            if let listComment: [NSDictionary] = commentByNote.object(forKey: "data") as? [NSDictionary] {
                                self.listComment = self.listComment + listComment
                                for _ in listComment { self.listCommentImageSize.append([:]) }

                                if listComment.count < self.limitContent {
                                    self.mTableView.setShowsInfiniteScrolling(false)
                                }
                            }
                            else {
                                self.mTableView.setShowsInfiniteScrolling(false)
                            }
                        }
                    }
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.loadTopContent()
                self.loadListTagInView()
                self.createListHeight(isUpdateIndex: nil)
                self.mTableView.reloadData()
                self.topContentView.isHidden = false
                self.mTableView.isHidden = false
                self.mTableView.pullToRefreshView?.stopAnimating()
                self.mTableView.infiniteScrollingView?.stopAnimating()
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }

    func callAPIFavoriteNotes(currentFavorite: String) {
        if let notesId: String = self.noteItemDetail.object(forKey: "id") as? String {
            self.mButtonFavorite.isUserInteractionEnabled = false

            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "note_id": notesId,
                "disable": currentFavorite
            ]

            APIBase.shareObject.callAPIFavoriteNotes(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    // Get numberHeart
                    var numberHeart: Int = 0
                    let numberHeartString: String? = self.noteItemDetail.object(forKey: "counts_favorite") as? String
                    if numberHeartString != nil && numberHeartString != "" {
                        if let numberHeartInt: Int = Int(numberHeartString!) {
                            numberHeart = numberHeartInt
                        }
                    }

                    var newValue:String = "0"
                    if currentFavorite == "1" {
                        self.mButtonFavorite.isSelected = false
                        numberHeart = numberHeart - 1
                    } else {
                        self.mButtonFavorite.isSelected = true
                        numberHeart = numberHeart + 1
                        newValue = "1"
                    }

                    // Set new value
                    self.noteItemDetail.setValue(newValue, forKey: "favorite_status")
                    self.noteItemDetail.setValue(String(numberHeart), forKey: "counts_favorite")
                    self.loadTopContent()
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }

                self.mButtonFavorite.isUserInteractionEnabled = true
            })
        }
    }

     // MARK: - Selectors

    @IBAction func addCommentButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "TimeLine", bundle: nil)
        if let vc:CreateNewCommentViewController = storyboard.instantiateViewController(withIdentifier: "createNewCommentVC") as? CreateNewCommentViewController {
            if self.noteObject?.m_id != nil {
                vc.noteId = self.noteObject?.m_id
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension NoteTimeLineDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHeight.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrayHeight.indices.contains(indexPath.row) == true {
            return arrayHeight[indexPath.row]
        }
        else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:NoteDetailTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellNoteDetail") as? NoteDetailTableViewCell
        if cell == nil {
            cell = NoteDetailTableViewCell(style: .default, reuseIdentifier: "cellNoteDetail")
        }
        cell?.indexPath = indexPath
        cell?.delegate = self

        if self.listComment.indices.contains(indexPath.row) == true {
            cell?.updateCellWithData(indexPath: indexPath, commentDetail: self.listComment[indexPath.row], listContentImageSize: self.listCommentImageSize[indexPath.row])
        }

        return cell!
    }
}

extension NoteTimeLineDetailViewController: NoteDetailTableViewCellDelegate {
    func didDownloadedImage(sender: NoteDetailTableViewCell, newImage: UIImage?, contentIndex: Int) {
        if let indexPath: IndexPath = sender.indexPath {
            if self.listCommentImageSize.indices.contains(indexPath.row) == true {
                if newImage == nil {
                    self.listCommentImageSize[indexPath.row]["index" + String(contentIndex)] = CGSize.zero
                }
                else {
                    self.listCommentImageSize[indexPath.row]["index" + String(contentIndex)] = newImage?.size
                }
                self.createListHeight(isUpdateIndex: indexPath.row)
                self.mTableView.checkAndReloadCell(with: indexPath)
            }
        }
    }
}
