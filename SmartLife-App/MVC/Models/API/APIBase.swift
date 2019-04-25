//
//  GetSupportCenterInfo.swift
//  SOS
//
//  Created by DucLA on 4/11/17.
//  Copyright © 2017 VCC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper

class APIBase {


    static let shareObject = APIBase()

    var header: HTTPHeaders!
    var manager: SessionManager!

    init() {
        header = [String : String]()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30

        manager = Alamofire.SessionManager(configuration: configuration)
    }

    func commonParam() -> Parameters {
        PublicVariables.api_auth_date = Date().toMillis().description
        PublicVariables.api_auth_key = ("smarttablet" + PublicVariables.api_auth_date).md5()
        return ["api_auth_date": PublicVariables.api_auth_date ,"api_auth_key": PublicVariables.api_auth_key]
    }

    func getHeader() -> [String:String] {
        let accessToken: String = (UserDefaults.standard.object(forKey: kUserDefaultAccessToken) as? String) ?? ""
        let userId: String = (UserDefaults.standard.object(forKey: kUserDefaultUserId) as? String) ?? ""
        return ["Authorization": accessToken, "User-Id": userId]
    }
    
    /*
     * Created by: hoangnn
     * Description: callAPIRequest
     */
    func callAPIRequest(requestURL:String, method:HTTPMethod, param: Parameters?, imageParams: [String: UIImage]? = nil, header: HTTPHeaders?,
                        completionHandler: @escaping(NSDictionary?,NSError?) -> ()) {
        // Call API
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            // Images
            if imageParams != nil {
                for imageParamChild in imageParams! {
                    if let imageData: Data = UIImagePNGRepresentation(imageParamChild.value) {
                        multipartFormData.append(imageData, withName: imageParamChild.key, fileName: "file.png", mimeType: "image/png")
                    }
                }
            }

            // Texts
            if param != nil {
                for paramChild in param! {
                    let valueStringData: String? = String(describing: paramChild.value)
                    if let valueData: Data = valueStringData?.data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: paramChild.key)
                    }
                }
            }
        }, to: requestURL, headers: header) { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                break
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress: Progress) in
                }).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let JSON):
                        let resultJSON = JSON as? NSDictionary

                        // Check notification flag new
                        self.checkNotificationFlagNew(resultJSON: resultJSON)

                        if let status = resultJSON?.object(forKey: "status") as? Int {
                            if status == 401 {
                                let storyboardLogin: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                if let loginVC: LoginViewController = storyboardLogin.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
                                    let rootNavigationController: NavbarMainViewController = NavbarMainViewController()
                                    rootNavigationController.automaticallyAdjustsScrollViewInsets = false
                                    rootNavigationController.isNavigationBarHidden = true
                                    rootNavigationController.setViewControllers([loginVC], animated: true)
                                    UIApplication.shared.keyWindow?.rootViewController = rootNavigationController
                                }
                            }
                            else {
                                completionHandler(resultJSON, nil)
                            }
                        }
                        else {
                            completionHandler(resultJSON, nil)
                        }
                    case .failure(let error):
                        print("\(error)")
                        if (error as NSError).code == -1009 {
                            GlobalMethod.showAlert("インターネット接続がありません。接続を確認してください。", completion: {
                                completionHandler(nil, error as NSError)
                            })
                        }
                        else {
                            GlobalMethod.showAlert("エラーが発生しました。もう一度試してください。")
                            completionHandler(nil, error as NSError)
                        }
                    }
                })
                break
            }
        }
    }

    func callAPIFavoritePointItem(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_FAVORITE_POINT_ITEM)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIFavoriteUserWork(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_FAVORITE_USER_WORK)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIFavoriteBytes(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_FAVORITE_BYTES)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIFavoriteJobs(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_FAVORITE_JOBS)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIFavoriteNotes(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_FAVORITE_NOTES)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIPointHistory(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_POINT_HISTORY)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }


    //MARK: - SKILL API
    func callAPIGetAllSkill(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {

        let requestURL = "\(APP_BASE_URL)\(API_GET_MYSKILL_ALL)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }

    }

    /*
     * Created by: hoangnn
     * Description: Call API with JSONType
     */


    func callAPIUpdateSkillUser(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let requestURL = "\(APP_BASE_URL)\(API_UPDATE_SKILL_USER)"
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        print("API is calling :\(requestURL)")


        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }

    }


    func callAPIGetAllGetPoint(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_POINTWORKS)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetPointWorksActionLogs(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_POINTWORKS_ACTION_LOGS)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIPointWorksUploadImage(params: Parameters?, imageParams: [String: UIImage], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_POINTWORKS_UPLOAD_IMAGE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, imageParams: imageParams, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetAllPointItemsExchange(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_POINTITEMS)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetAllPointItemsExchanged(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_EXCHANGED_POINTITEMS)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetPointItemDetailExchanged(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_EXCHANGED_POINTITEM_DETAIL)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetPointItemDetailExchange(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_POINTITEM_DETAIL)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetListByteCaregory(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_BYTECATEGORY)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetListByte(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_BYTELIST)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetDetailByte(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_BYTEDETAIL)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetListJobCaregory(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_JOBCATEGORY)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetListJob(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_JOBLIST)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetDetailJob(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_JOBDETAIL)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetNotepostListPost(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_NOTEPOST_LISTPOST)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetNotepostListFavorite(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_NOTEPOST_LISTFAVORITE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetNotepostListNoteComment(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_NOTEPOST_LISTNOTECOMMENT)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetDetailNote(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_NOTEDETAIL)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIAddNote(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_ADD_NOTE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIAddNoteComment(params: Parameters?, imageParams: [String: UIImage], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_ADD_NOTE_COMMENT)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, imageParams: imageParams, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIDeleteNote(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_DELETE_NOTE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIDeleteNoteComment(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_DELETE_NOTE_COMMENT)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIChatUploadImage(params: Parameters?, imageParams: [String: UIImage], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_CHAT_UPLOAD_IMAGE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, imageParams: imageParams, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    //MARK: - WEBVIEW
    func callAPIGetUserTerm(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_USER_TERM)"
        print("API is calling :\(requestURL)")


        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIGetPrivacyPolicy(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_PRIVACY_POLICY)"
        print("API is calling :\(requestURL)")


        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: nil) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIApplyJob(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_APPLY_JOB)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }

    func callAPIApplyJobByte(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in params!.keys {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_APPLY_JOB_BYE)"
        print("API is calling :\(requestURL)")

        self.callAPIRequest(requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIGetDoorInfomation(params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_DOOR_INFOMATION)"
        print("API is calling :\(requestURL)")
        
        
        self.callAPIRequest(requestURL: requestURL, method: .get, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }



    // MARK: - Show API error

    func showAPIError(result: NSDictionary?, in viewController: UIViewController? = nil) {
        if let error: NSDictionary = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary {
            if let errorMessage: String = error.object(forKey: "message") as? String {
                if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                    // Init alert
                    let alertController: UIAlertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    }))

                    // Make title smaller
                    alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

                    // Show alert
                    if viewController != nil { viewController?.present(alertController, animated: true, completion: nil) }
                    else { appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil) }
                }
            }
        }
    }

    // MARK: - Check notification flag new

    func checkNotificationFlagNew(resultJSON: NSDictionary?) {
        if let bodyJSON: [String: Any] = resultJSON?.value(forKey: "body") as? [String: Any] {
            PublicVariables.userInfo.updateAndCheckNotificationFlagNew(flagNew: (bodyJSON["flag_new"] as? String))
        }
    }
}
