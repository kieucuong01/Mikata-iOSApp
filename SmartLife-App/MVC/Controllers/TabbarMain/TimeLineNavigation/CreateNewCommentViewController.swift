//
//  CreateNewCommentViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/18/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class CreateNewCommentViewController: BaseViewController {

    @IBOutlet weak var mTableViewComment: UITableView!
    @IBOutlet weak var mTopConstraintInputCustomView: NSLayoutConstraint!
    @IBOutlet weak var mInputCustomView: InputImageTextCustomView!
    @IBOutlet weak var mLabelTitleNav: UILabel!

    var alertCustomView: AlertConfirmCustomView = {
        let view: AlertConfirmCustomView = (Bundle.main.loadNibNamed("AlertConfirmCustomView", owner: self, options: nil))?[0] as! AlertConfirmCustomView
        view.frame = CGRect(x:0 , y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()

    var noteId: String? = nil

    var arrayComment:[CommentText] = []
    var nextImageIndex: Int? = nil
    var currentTextViewIndex: IndexPath? = nil
    var currentImageViewIndex: IndexPath? = nil
    var lastTextViewIndex: IndexPath? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.checkPhotoLibraryCanUse()
        self.checkCameraCanUse()
        self.addObserverForViewController()
        self.mInputCustomView.delegate = self
        self.getFakeData()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createSubviews() {
        self.view.addSubview(self.alertCustomView)
        self.alertCustomView.delegate = self

        // Add tap gesture to table
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        self.mTableViewComment.addGestureRecognizer(tapGesture)
    }

    //MARK: - Gesture Recognizer
    @objc func tap(sender: UITapGestureRecognizer?) {
        if self.lastTextViewIndex != nil {
            if let lastTextViewCell: NoteTextViewCell = self.mTableViewComment.cellForRow(at: self.lastTextViewIndex!) as? NoteTextViewCell {
                lastTextViewCell.mTextView.becomeFirstResponder()
                let newPosition = lastTextViewCell.mTextView.endOfDocument
                lastTextViewCell.mTextView.selectedTextRange = lastTextViewCell.mTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }

    private func getFakeData() {
        let commentDate = CommentText()
        commentDate.m_type = "text"
        commentDate.m_content = ""
        arrayComment.append(commentDate)

        self.lastTextViewIndex = nil
        self.mTableViewComment.reloadData()
        self.mTableViewComment.layoutIfNeeded()
        self.tap(sender: nil)
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    private func checkPhotoLibraryCanUse() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()

        if (status == .authorized) {
            // Access has been granted.
            self.mInputCustomView.mButtonImage.isEnabled = true
        }

        else if (status == .denied) {
            // Access has been denied.
            self.mInputCustomView.mButtonImage.isEnabled = false
        }

        else if (status == .notDetermined) {

            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in

                if (newStatus == .authorized) {

                    self.mInputCustomView.mButtonImage.isEnabled = true
                }

                else {

                    self.mInputCustomView.mButtonImage.isEnabled = false
                }
            })
        }

        else if (status == .restricted) {
            // Restricted access - normally won't happen.
            self.mInputCustomView.mButtonImage.isEnabled = false
        }
    }

    private func checkCameraCanUse() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    print("access granted")
                    self.mInputCustomView.mButtonCamera.isEnabled = true
                }
                else {
                    print("access denied")
                    self.mInputCustomView.mButtonCamera.isEnabled = false
                }
            }
        case .authorized:
            print("Access authorized")
            self.mInputCustomView.mButtonCamera.isEnabled = true
        case .denied, .restricted:
            print("restricted")
            self.mInputCustomView.mButtonCamera.isEnabled = false

        }
    }

    private func addObserverForViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewCommentViewController.keyboardIsChangeFrame), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    @objc func keyboardIsChangeFrame(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            // Get frame and animation
            if let endFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN: NSNumber? = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw: UInt = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)

                // Update views
                let newMTopConstraintInputCustomView: CGFloat = (SIZE_HEIGHT - endFrame.origin.y)
                self.mTopConstraintInputCustomView.constant = max(0.0, newMTopConstraintInputCustomView)

                // Animation
                UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }

    @IBAction func clickedButtonCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func clickedButtonBack(_ sender: Any) {
        let dict:[String:String] = ["lbl_confirm_title": NSLocalizedString("alert_view_new_comment_label_confirm", comment: "label for confirm title alert when delete"),
                                    "lbl_button_decline": NSLocalizedString("alert_view_new_comment_button_decline", comment: "label for button decline"),
                                    "lbl_button_accept": NSLocalizedString("alert_view_delete_comment_button_accept", comment: "label for button accept"),
                                    "action": "1"]
        self.alertCustomView.updateAlertViewWithDict(dict: dict)
        self.alertCustomView.isHidden = false
        self.view.endEditing(true)
    }

    // MARK: - Check and update list comment

    func checkAndUpdateListComment() {
        if self.arrayComment.count >= 2 {
            for index in 1..<self.arrayComment.count {
                let leftComment: CommentText = self.arrayComment[index - 1]
                let rightComment: CommentText = self.arrayComment[index]
                if leftComment.m_type == "text" && rightComment.m_type == "text" {
                    let leftText: String? = leftComment.m_content as? String
                    let rightText: String? = rightComment.m_content as? String
                    if rightText != nil && rightText != "" {
                        if leftText != nil && leftText != "" {
                            leftComment.m_content = leftText! + "\n" + rightText!
                        }
                        else {
                            leftComment.m_content = rightText!
                        }
                    }

                    self.arrayComment.remove(at: index)
                    self.checkAndUpdateListComment()
                    break
                }
            }
        }
    }

    // MARK: - Call API

    func callAPIAddNoteComment() {
        if noteId != nil && self.arrayComment.count > 0 {
            var params: [String: Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "note_id": noteId!
            ]
            var imageParams: [String: UIImage] = [:]

            var textIndex: Int = 0
            var imageIndex: Int = 0
            for index in 0..<self.arrayComment.count {
                let commentObj: CommentText = self.arrayComment[index]
                // Text
                if commentObj.m_type == "text" {
                    if let textSend: String = commentObj.m_content as? String {
                        params["text_" + String(textIndex)] = textSend
                        textIndex = textIndex + 1
                    }
                }
                // Image
                if commentObj.m_type == "image" {
                    if let imageSend: UIImage = commentObj.m_content as? UIImage {
                        imageParams["image_" + String(imageIndex)] = imageSend
                        imageIndex = imageIndex + 1
                    }
                }
            }

            MBProgressHUD.showAdded(to: self.view, animated: true)
            APIBase.shareObject.callAPIAddNoteComment(params: params, imageParams: imageParams, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    let dict:[String:String] = ["action": "2",
                                                "lbl_success_title": NSLocalizedString("alert_view_new_comment_label_success", comment: "label for success title alert when complete"),
                                                "lbl_button_success": NSLocalizedString("alert_view_new_comment_button_success", comment: "label for button accept")]
                    self.alertCustomView.updateAlertViewWithDict(dict: dict)
                    self.alertCustomView.isHidden = false
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }

    // MARK: - Adjust Image

    /*
     * Created by: hoangnn
     * Description: Normalize image
     */
    func normalizeImage(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        else {
            UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
            image.draw(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: image.size))
            var normalizeImage = image
            if UIGraphicsGetImageFromCurrentImageContext() != nil {
                normalizeImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            UIGraphicsEndImageContext()
            return normalizeImage
        }
    }

    /*
     * Created by: hoangnn
     * Description: Scale image to under 1MB
     */
    func scaleImage(image: UIImage) -> UIImage {
        let sizeScale: Int = (1024 * 1024) / 2 // 1MB on server
        var imageData = UIImageJPEGRepresentation(image, 1.0)!
        var scaleImage = image
        var adjustment: CGFloat = 0.9

        // Check and resize data image <= 1MB
        if (imageData.count > sizeScale) {
            while (imageData.count > sizeScale) {
                NSLog("While start - The imagedata size is currently: %f KB", roundf(Float(imageData.count / 1024)))

                // Update adjustment
                adjustment = CGFloat(sizeScale) / CGFloat(imageData.count)
                if adjustment < 0.5 { adjustment = 0.5 }
                if adjustment > 0.95 { adjustment = 0.95 }

                // While the imageData is too large scale down the image

                // Resize the image
                let newSize = CGSize(width: scaleImage.size.width * adjustment, height: scaleImage.size.height * adjustment)
                let rect = CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                scaleImage.draw(in: rect)
                if UIGraphicsGetImageFromCurrentImageContext() != nil {
                    scaleImage = UIGraphicsGetImageFromCurrentImageContext()!
                }
                UIGraphicsEndImageContext()

                // Pass the NSData out again
                imageData = UIImageJPEGRepresentation(scaleImage, 1.0)!
            }
        }
        
        return scaleImage
    }
}

extension CreateNewCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayComment.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrayComment.indices.contains(indexPath.row) == true {
            let commentObject: CommentText = self.arrayComment[indexPath.row]
            // Text cell
            if commentObject.m_type == "text" {
                if let cell: NoteTextViewCell = tableView.dequeueReusableCell(withIdentifier: "noteTextViewCell") as? NoteTextViewCell {
                    cell.delegate = self
                    cell.indexPath = indexPath

                    // Check placeholder
                    if indexPath.row == 0 && self.arrayComment.count <= 1 { cell.placeHolderString = "コメントを書く" }
                    else { cell.placeHolderString = "" }

                    // Set text
                    cell.setTextForTextView(text: commentObject.m_content as? String)

                    // Get last cell
                    if indexPath.row == self.arrayComment.count - 1 {
                        self.lastTextViewIndex = indexPath
                    }

                    return cell
                }
            }
                // Image cell
            else if commentObject.m_type == "image" {
                if let cell: NoteImageCell = tableView.dequeueReusableCell(withIdentifier: "noteImageCell") as? NoteImageCell {
                    cell.delegate = self
                    cell.indexPath = indexPath
                    cell.setImageForCell(image: commentObject.m_content as? UIImage)
                    if self.currentImageViewIndex?.row == indexPath.row {
                        cell.mViewBackground.isHidden = false
                    } else {
                        cell.mViewBackground.isHidden = true
                    }

                    return cell
                }
            }
        }

        // Default
        return UITableViewCell()
    }
}

extension CreateNewCommentViewController: InputImageTextCustomViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func callbackClickedButtonImage(sender: InputImageTextCustomView) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.nextImageIndex = self.currentTextViewIndex?.row
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func callbackClickedButtonCamera(sender: InputImageTextCustomView) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.nextImageIndex = self.currentTextViewIndex?.row
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func callbackClickedButtonSent(sender: InputImageTextCustomView) {
        self.view.endEditing(true)
        var isEmptyMessage: Bool = false

        // Check empty message
        if self.arrayComment.count <= 1 {
            let firstComment: CommentText? = self.arrayComment.first
            if firstComment == nil {
                isEmptyMessage = true
            }
            else {
                let firstCommentContent: String? = firstComment?.m_content as? String
                if (firstComment?.m_type == "text") && (firstCommentContent == nil || firstCommentContent == "") {
                    isEmptyMessage = true
                }
            }
        }

        if isEmptyMessage == true {
            // Init alert
            let alertController: UIAlertController = UIAlertController(title: nil, message: "コメントを入力してください", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
            }))

            // Make title smaller
            alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

            // Show alert
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.callAPIAddNoteComment()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // New image
            let newImageComment = CommentText()
            newImageComment.m_type = "image"
            newImageComment.m_content = self.scaleImage(image: self.normalizeImage(image: image))

            // New text
            let newTextComment = CommentText()
            newTextComment.m_type = "text"
            newTextComment.m_content = ""

            if self.nextImageIndex == nil {
                self.arrayComment.append(newImageComment)
                self.arrayComment.append(newTextComment)
            }
            else {
                self.arrayComment.insert(newImageComment, at: self.nextImageIndex! + 1)
                self.arrayComment.insert(newTextComment, at: self.nextImageIndex! + 2)
            }

            // Reload table
            self.lastTextViewIndex = nil
            self.mTableViewComment.reloadData()
            self.mTableViewComment.layoutIfNeeded()

            if self.nextImageIndex == nil {
                if self.lastTextViewIndex != nil {
                    self.mTableViewComment.scrollToRow(at: self.lastTextViewIndex!, at: .none, animated: true)
                }
            }
            else {
                let insertIndexPath: IndexPath = IndexPath(row: self.nextImageIndex! + 1, section: 0)
                self.mTableViewComment.scrollToRow(at: insertIndexPath, at: .none, animated: true)
            }

            dismiss(animated:true, completion: nil)
        }
    }
}

extension CreateNewCommentViewController: NoteTextViewCellDelegate {
    func didBeginEditTextView(sender: NoteTextViewCell) {
        if self.currentImageViewIndex != nil {
            if let imageCell: NoteImageCell = self.mTableViewComment.cellForRow(at: self.currentImageViewIndex!) as? NoteImageCell {
                imageCell.mViewBackground.isHidden = true
            }
        }
        self.currentImageViewIndex = nil
        self.currentTextViewIndex = sender.indexPath
        if self.currentTextViewIndex != nil {
            self.mTableViewComment.scrollToRow(at: self.currentTextViewIndex!, at: .none, animated: true)
        }
    }

    func didEndEditTextView(sender: NoteTextViewCell) {
        self.currentTextViewIndex = nil
    }

    func didChangeValueTextView(sender: NoteTextViewCell) {
        self.mTableViewComment.beginUpdates()
        self.mTableViewComment.endUpdates()
        if self.arrayComment.indices.contains(sender.indexPath.row) == true {
            self.arrayComment[sender.indexPath.row].m_content = sender.mTextView.text
            self.mTableViewComment.scrollToRow(at: sender.indexPath, at: .none, animated: false)
        }
    }
}

extension CreateNewCommentViewController: NoteImageCellDelegate {
    func clickedImageCellView(sender: NoteImageCell) {
        self.view.endEditing(true)

        // Remove view older
        if self.currentImageViewIndex != nil {
            if let imageCell: NoteImageCell = self.mTableViewComment.cellForRow(at: self.currentImageViewIndex!) as? NoteImageCell {
                imageCell.mViewBackground.isHidden = true
            }
        }
        self.currentTextViewIndex = nil
        if self.currentImageViewIndex?.row != sender.indexPath.row {
            //Show new view
            self.currentImageViewIndex = sender.indexPath
            sender.mViewBackground.isHidden = false
            if self.currentImageViewIndex != nil {
                self.mTableViewComment.scrollToRow(at: self.currentImageViewIndex!, at: .none, animated: true)
            }
        }
        else {
            self.currentImageViewIndex = nil
        }
    }

    func didCloseButtonCell(sender: NoteImageCell) {
        if self.arrayComment.indices.contains(sender.indexPath.row) == true {
            self.arrayComment.remove(at: sender.indexPath.row)
            self.currentImageViewIndex = nil
            self.checkAndUpdateListComment()
            self.lastTextViewIndex = nil
            self.mTableViewComment.reloadData()
        }
    }
}

extension CreateNewCommentViewController: AlertConfirmCustomViewDelegate {
    func callbackActionClickedButtonAccept() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callbackActionClickedButtonDecline() {
        self.alertCustomView.isHidden = true
    }
    
    func callbackActionClickedButtonSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
}
