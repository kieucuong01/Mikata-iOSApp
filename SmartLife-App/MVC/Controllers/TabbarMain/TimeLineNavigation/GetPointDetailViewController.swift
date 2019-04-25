//
//  GetPointDetailViewController.swift
//  smart_tablet
//
//  Created by thanhlt on 7/27/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class GetPointDetailViewController: BaseViewController {

    //MARK: - Variable
    // Constraint
    @IBOutlet weak var mTopImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelTitleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mImageAvatarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintButtonAccept: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mWidthConstraintLabelTag: NSLayoutConstraint!
    @IBOutlet weak var mHeightConstraintLabelTag: NSLayoutConstraint!
    @IBOutlet weak var mTopConstrainLabelTagPoint: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelPoint: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintLabelButton: NSLayoutConstraint!
    
    // UIView
    @IBOutlet weak var mLabelTopTitle: UILabel!
    @IBOutlet weak var mLabelTag: UILabel!
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mImgViewGetPoint: UIImageView!
    @IBOutlet weak var mLabelTitleGet: UILabel!
    @IBOutlet weak var mLabelPoint: UILabel!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mLabelPointUnit: UILabel!
    @IBOutlet weak var mButtonGetPoint: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!

    weak var alertClearView: AlertGetPointDetailView? = nil

    // Popup
    var confirmImagePopupView: ConfirmImagePopupVIew? = nil

    // Image picker controller
    let imagePicker: UIImagePickerController = UIImagePickerController()

    let STATUS_NO_CHECKED: String = "0"
    let STATUS_PENDING: String = "1"
    let STATUS_REJECT: String = "2"
    let STATUS_COMPLETE: String = "3"
    
    var infoItem:NSDictionary = NSDictionary()
    // Private variables
    private var scale:CGFloat = DISPLAY_SCALE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure image picker controller
        self.imagePicker.delegate = self
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        
        self.createSubviews()
        self.setLanguageForView()
        self.setConstraintForView()
        self.setFontForView()
        self.setVariablesForViews()
        // Do any additional setup after loading the view.

        // Configure subviews
        self.configureConfirmImagePopupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL, eventName: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /*
     * Created by: hoangnn
     * Description: Configure confirmImagePopupView
     */
    func configureConfirmImagePopupView() {
        // Init popup
        self.view.layoutIfNeeded()
        self.confirmImagePopupView = ConfirmImagePopupVIew(frame: GlobalMethod.screenSize)
        self.confirmImagePopupView?.parentView = GlobalMethod.mainWindow

        // Set attributes
        self.confirmImagePopupView?.delegate = self
    }
    
    // MARK: - Private method
    private func setLanguageForView(){
        self.mLabelTopTitle.text = NSLocalizedString("getpointdetailview_navbar", comment: "")
        self.mLabelTitleGet.text = NSLocalizedString("getpointdetailview_label_titleget", comment: "")
    }

    private func setConstraintForView() {
        self.mTopImageViewConstraint.constant = 9.0 * scale
        self.mTopLabelTitleConstraint.constant = 41.0 * scale
        self.mTopConstraintLabelContent.constant = 11 * scale
        self.mTopConstrainLabelTagPoint.constant = 17.0 * scale
        self.mTopConstraintLabelPoint.constant = 25.0 * scale
        self.mTopConstraintLabelButton.constant = 21.0 * scale
        self.mBottomConstraintButtonAccept.constant = 25.0 * scale
        self.mHeightConstraintLabelTag.constant = 17 * scale
    }
    
    private func setFontForView() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName,size: 17 * scale)
        self.mLabelTopTitle.font = UIFont(name: self.mLabelTopTitle.font.fontName,size: 14 * scale)
        self.mLabelTag.font = UIFont(name: self.mLabelTag.font.fontName,size: 8 * scale)
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName,size: 12 * scale)
        self.mLabelPoint.font = UIFont(name: self.mLabelPoint.font.fontName,size: 34 * scale)
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName,size: 12 * scale)
        self.mLabelPointUnit.font = UIFont(name: self.mLabelPointUnit.font.fontName,size: 22 * scale)
        self.mButtonGetPoint.titleLabel!.font = UIFont(name: self.mButtonGetPoint.titleLabel!.font.fontName,size: 14 * scale)
        
        self.mLabelTitleGet.font = UIFont(name: self.mLabelTitleGet.font.fontName,size: 12 * scale)
        let string = self.mLabelTitleGet.text
        let color = self.mLabelTitleGet.textColor
        let font = self.mLabelTitleGet.font
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 0.3 * font!.lineHeight
        let attributeStr:NSMutableAttributedString = NSMutableAttributedString(string: string!)
        attributeStr.addAttributes([NSAttributedStringKey.font:font ?? 0,
                                    NSAttributedStringKey.foregroundColor:color ?? 0,
                                    NSAttributedStringKey.paragraphStyle:paragraphStyle], range: NSMakeRange(0, string!.count))
        self.mLabelTitleGet.attributedText = attributeStr
    }
    
    func setVariablesForViews() {
        let mission_type:Int = (infoItem.value(forKey: "mission_type") as! NSString).integerValue
        
        switch mission_type {
        case 0:
            self.mButtonGetPoint.setTitle(NSLocalizedString("getpointdetailview_button_getpoint", comment: ""), for: .normal)
            break;
        case 1:
            self.mLabelTag.text = NSLocalizedString("get_point_title_site_access", comment: "")
            break;
        case 2:
            self.mLabelTag.text = NSLocalizedString("get_point_title_questionnaire", comment: "")
            break;
        case 3:
            self.mLabelTag.text = NSLocalizedString("get_point_title_photo_taking", comment: "")
            self.mButtonGetPoint.setTitle(NSLocalizedString("getpointdetailview_button_take_photo", comment: ""), for: .normal)
            break;
        case 4:
            self.mLabelTag.text = NSLocalizedString("get_point_title_site_registration", comment: "")
            break;
        case 9:
            self.mLabelTag.text = NSLocalizedString("get_point_title_mission_after_attendance", comment: "")
            break;
        default:
            self.mLabelTag.text = NSLocalizedString("get_point_title_news", comment: "")
            self.mButtonGetPoint.setTitle(NSLocalizedString("getpointdetailview_button_answer", comment: ""), for: .normal)
            break;
        }
        self.mLabelTag.sizeToFit()
        
        self.mWidthConstraintLabelTag.constant = mLabelTag.frame.size.width + 10 * scale
        
        if let description = infoItem.value(forKey: "description") as? String {
            self.mLabelContent.text = description
        } else {
            self.mLabelContent.text = ""
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval((infoItem.object(forKey: "display_end_date") as! NSString).longLongValue))
        let fommater = DateFormatter()
        fommater.dateFormat = "yyyy.MM.dd まで"
        fommater.locale = Locale(identifier: "en_US_POSIX")
        self.mLabelDate.text = fommater.string(from: date)
        
        self.mLabelTitle.text = infoItem.object(forKey: "title") as? String
        
        self.mLabelPoint.text = "0"
        if let pointString: String = infoItem.object(forKey: "point") as? String {
            if let pointInt: Int = Int(pointString) {
                self.mLabelPoint.text = pointInt.convertToStringDecimalFormat()
            }
        }

        let imageurl: String? = (infoItem.object(forKey: "image_url") as? String)

        self.imageAvatar.setImageForm(urlString: imageurl, placeHolderImage: nil, completion: {
            self.view.layoutIfNeeded()
            if (self.imageAvatar.image?.size == nil) || (self.imageAvatar.image?.size == CGSize.zero) || (self.imageAvatar.image?.size.width == 0.0) {
                self.mImageAvatarHeightConstraint.constant = 8.0 * GlobalMethod.displayScale
            }
            else {
                let ratioHeightImageSize: CGFloat = (self.imageAvatar.image?.size)!.height / (self.imageAvatar.image?.size)!.width
                self.mImageAvatarHeightConstraint.constant = self.imageAvatar.frame.size.width * ratioHeightImageSize
            }
        })

        // GetPointButton
        self.mButtonGetPoint.isHidden = false
        if let userPointWorkStatus: String = infoItem.object(forKey: "user_point_work_status") as? String {
            switch userPointWorkStatus {
            case self.STATUS_NO_CHECKED:
                self.mButtonGetPoint.isHidden = true
                self.mTopConstraintLabelButton.constant = 0 * scale
                self.mBottomConstraintButtonAccept.constant = 0 * scale
                break
            case self.STATUS_PENDING:
                self.mButtonGetPoint.isHidden = true
                self.mTopConstraintLabelButton.constant = 0 * scale
                self.mBottomConstraintButtonAccept.constant = 0 * scale
                break
            case self.STATUS_REJECT:
                self.mButtonGetPoint.isHidden = false
                self.mTopConstraintLabelButton.constant = 21.0 * scale
                self.mBottomConstraintButtonAccept.constant = 25.0 * scale
                break
            case self.STATUS_COMPLETE:
                self.mButtonGetPoint.isHidden = true
                self.mTopConstraintLabelButton.constant = 0 * scale
                self.mBottomConstraintButtonAccept.constant = 0 * scale
                break
            default:
                self.mButtonGetPoint.isHidden = false
                self.mTopConstraintLabelButton.constant = 21.0 * scale
                self.mBottomConstraintButtonAccept.constant = 25.0 * scale
                break
            }
        }
    }
    
    private func createSubviews() {
    }

    private func mButtonGetPointSurvey() {
        // Go to CustomWebView
        if self.infoItem.value(forKey: "set_track_url") as? String != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "TimeLine", bundle: nil)
            if let customWebViewVC: CustomWebViewController = storyboard.instantiateViewController(withIdentifier: "CustomWebViewController") as? CustomWebViewController {
                customWebViewVC.infoItem = self.infoItem
                self.navigationController?.pushViewController(customWebViewVC, animated: true)
            }
        }
    }

    private func mButtonGetPointFillForm() {
        // Go to CustomWebView
        if self.infoItem.value(forKey: "target_page_url") as? String != nil
            || self.infoItem.value(forKey: "target_page_url") as? String != "" {
            let storyboard: UIStoryboard = UIStoryboard(name: "TimeLine", bundle: nil)
            if let customWebViewVC: CustomWebViewController = storyboard.instantiateViewController(withIdentifier: "CustomWebViewController") as? CustomWebViewController {
                customWebViewVC.infoItem = self.infoItem
                self.navigationController?.pushViewController(customWebViewVC, animated: true)
            }
        }
    }

    @IBAction func clickedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedGetPointButton(_ sender: Any) {
        let missionType: String? = infoItem.object(forKey: "mission_type") as? String
        if missionType == "4" {
            self.mButtonGetPointFillForm()
        }
        else if missionType == "3" {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL, eventName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL_ACTION_START_CAPTURE)

            self.showActionSheetChooseCameraOrLibrary()
        }
        else if missionType == "2"{
            self.mButtonGetPointSurvey()
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL, eventName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL_ACTION_START_SURVEY)
        }
        else if missionType == "0"{
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL, eventName: ReproEvent.REPRO_SCREEN_POINT_EARN_DETAIL_ACTION_START_NEWS)
        }
    }

    // MARK: - Call API

    func callAPIUploadImageToServer(image: UIImage) {
        if let pointWorkId: String = self.infoItem.object(forKey: "id") as? String {
            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "point_work_id": pointWorkId
            ]
            let imageParams: [String : UIImage] = [
                "uploaded_image_path": image
            ]

            MBProgressHUD.showAdded(to: self.view, animated: true)
            APIBase.shareObject.callAPIPointWorksUploadImage(params: params, imageParams: imageParams, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let view: AlertGetPointDetailView = (Bundle.main.loadNibNamed("AlertGetPointDetailView", owner: self, options: nil))?[0] as? AlertGetPointDetailView {
                        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
                        self.alertClearView = view
                        self.alertClearView?.delegate = self
                        GlobalMethod.mainWindow?.addSubview(self.alertClearView!)
                    }
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
}

extension GetPointDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate

    /*
     * Created by: hoangnn
     * Description: Did finish picking image from gallery
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.confirmImagePopupView?.confirmImageView.image = self.scaleImage(image: self.normalizeImage(image: pickedImage))
            self.confirmImagePopupView?.showPopup()
        }

        self.dismiss(animated: true, completion: nil)
    }

    /*
     * Created by: hoangnn
     * Description: Did cancel picking image
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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

    // MARK: - Public methods

    /*
     * Created by: hoangnn
     * Description: Show action sheet choose camera or photo library
     */
    func showActionSheetChooseCameraOrLibrary() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        // Cancel action
        let cancelActionTitle: String = NSLocalizedString("common_button_cancel", comment: "")
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelActionTitle, style: UIAlertActionStyle.cancel, handler: nil)

        // Camera action
        let cameraActionTitle: String = NSLocalizedString("button_camera_title", comment: "")
        let cameraAction: UIAlertAction = UIAlertAction(title: cameraActionTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
            self.launchCamera()
        })

        // Photo action
        let photoLibraryActionTitle: String = NSLocalizedString("button_library_title", comment: "")
        let photoLibraryAction: UIAlertAction = UIAlertAction(title: photoLibraryActionTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
            self.goToPhotoLibrary()
        })

        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoLibraryAction)

        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }

    /*
     * Created by: hoangnn
     * Description: Check permission and launch camera
     */
    func launchCamera() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .authorized:
            // Open camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
            break
        case .denied, .restricted:
            break
        case .notDetermined:
            // Ask for permissions
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    // Open camera
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            break
        }
    }

    /*
     * Created by: hoangnn
     * Description: Check permission and open library
     */
    func goToPhotoLibrary() {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Open photo library
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            break
        case .denied, .restricted :
            break
        case .notDetermined:
            // Ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // Open photo library
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                    break
                case .denied, .restricted:
                    break
                case .notDetermined:
                    break
                }
            }
        }
    }
}

extension GetPointDetailViewController : AlertGetPointDetailViewDelegate {
    func closeAlert() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GetPointDetailViewController: ConfirmImagePopupViewDelegate {
    func didConfirmSelectedImage(popup: ConfirmImagePopupVIew, imageSelected: UIImage) {
        self.callAPIUploadImageToServer(image: imageSelected)
    }
}
