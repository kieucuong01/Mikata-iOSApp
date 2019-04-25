//
//  CreateFromJobByteViewController.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/20/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
protocol CreateFormJobByteViewControllerDelegate {
    func backToTop()
}

class CreateFromJobByteViewController:  BaseViewController {

    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mTableView: TPKeyboardAvoidingTableView!

    var mTextFieldName: UITextField!
    var mTextFieldUFurigana: UITextField!
    var mTextFieldEmail: UITextField!
    var mTextFieldPhone: UITextField!
    var mTextViewNote: UITextView!

    // Error view
    var errorView: UIView? = nil
    var errorLabel : UILabel? = nil
    // Delegate
    var delegate : CreateFormJobByteViewControllerDelegate?

    var listArrayJobApply:[[String:Any?]] = []
    var jobApply:[[String:Any?]] = []

    var listInfoProfile : [[String: String]] = [["name" : NSLocalizedString("createformjobview_label_name", comment: ""), "description" :"" ], ["name" : NSLocalizedString("createformjobview_label_kataname", comment: ""), "description" :"" ], ["name" : NSLocalizedString("createformjobview_label_email", comment: ""), "description" :"" ], ["name" : NSLocalizedString("createformjobview_label_phone", comment: ""), "description" :"" ], ["name" : NSLocalizedString("createformjobview_label_note", comment: ""), "description" :"" ]]

    var pageContent: Int = 1
    let limitContent: Int = 20
    var isError : Bool = false
    var errorMsg : String = ""

    // Profile variables
    var workId : String = ""
    var nameString: String = ""
    var cataNameString : String = ""
    var mailString : String = ""
    var phoneString : String = ""
    var noteString : String = NSLocalizedString("createformjobview_label_note", comment: "")

    var isEditName : Bool = false
    var isEditPhone : Bool = false
    var isEditEmail : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setFontForViews()
        self.createSubviews()
        self.callAPIGetUserProfile()
        // Do any additional setup after loading the view.
        self.generateParamAndCallAPIGetByteItems()

        // Set load more and refresh
        self.mTableView.alwaysBounceVertical = true
        self.mTableView.addInfiniteScrollingWithHandler {
            self.pageContent = self.pageContent + 1
            self.generateParamAndCallAPIGetByteItems()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORM_JOB, eventName: nil)
    }

    var doneCustomView: DoneApplyJobByteView  = {
        let view = Bundle.main.loadNibNamed("DoneApplyJobByteView", owner: self, options: nil)![0] as! DoneApplyJobByteView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()

    var confirmCustomView: ConfirmApplyJobByteView  = {
        let view = Bundle.main.loadNibNamed("ConfirmApplyJobByteView", owner: self, options: nil)![0] as! ConfirmApplyJobByteView
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("createformbyteview_navbar", comment: "")
    }

    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scaleDisplay)
    }

    private func createSubviews() {
        self.view.addSubview(self.doneCustomView)
        self.view.addSubview(self.confirmCustomView)
        self.doneCustomView.delegateView = self
        self.confirmCustomView.delegateView = self
    }

    private func updateListProfile(){
        self.listInfoProfile[0].updateValue(self.mTextFieldName.text!, forKey: "description")
        self.listInfoProfile[1].updateValue(self.mTextFieldUFurigana.text!, forKey: "description")
        self.listInfoProfile[2].updateValue(self.mTextFieldEmail.text!, forKey: "description")
        self.listInfoProfile[3].updateValue(self.mTextFieldPhone.text!, forKey: "description")
        self.listInfoProfile[4].updateValue(self.mTextViewNote.text!, forKey: "description")

        if self.listInfoProfile[4]["description"] == NSLocalizedString("createformjobview_label_note", comment: "") {
            self.listInfoProfile[4].updateValue("", forKey: "description")
        }
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func clickedButtonBack(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - Selector
    @objc func clickedButtonConfirmScreen() {
        if !self.isEditName { self.isEditName = true}
        if !self.isEditPhone { self.isEditPhone = true}
        if !self.isEditEmail { self.isEditEmail = true}

        if isValidInfomationInput() {
            self.updateListProfile()
            self.confirmCustomView.listArrayJobApply = self.jobApply
            self.confirmCustomView.listInfoProfile = self.listInfoProfile
            self.confirmCustomView.mTableView.reloadData()
            self.confirmCustomView.mTableView.layoutIfNeeded()
            self.confirmCustomView.isHidden = false
            //Track Repro
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORM_JOB, eventName: ReproEvent.REPRO_SCREEN_FORM_JOB_ACTION_CONFIRM)
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_CONFIRM, eventName: nil)
        }
        else {
            self.isError = true
            self.errorView?.isHidden = false
            self.errorLabel?.text = self.errorMsg
        }
        self.view.endEditing(true)
    }

    // MARK: - Call API

    func generateParamAndCallAPIGetByteItems() {
        if self.pageContent == 1 {
            self.mTableView.setShowsInfiniteScrolling(true)
            self.listArrayJobApply.removeAll()
        }

        let params: [String : Any] = [
            "user_id": PublicVariables.userInfo.m_id,
            "get_favorite": "1",
            "page": self.pageContent,
            "limit": self.limitContent
        ]

        self.callAPIGetByteItems(params: params)
    }


    func callAPIGetByteItems(params: [String : Any]?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIBase.shareObject.callAPIGetListByte(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                let body:NSDictionary = result?.object(forKey: "body") as! NSDictionary
                let arrays = body.object(forKey: "data") as? NSArray
                if arrays != nil {
                    for item in arrays! {
                        if let itemDict: [String: Any?] = item as? [String: Any?] {
                            self.listArrayJobApply.append(itemDict)
                        }
                    }
                }

                if (arrays == nil) || (arrays!.count < self.limitContent) {
                    self.mTableView.setShowsInfiniteScrolling(false)
                }
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }

            self.mTableView.reloadData()
            self.mTableView.infiniteScrollingView?.stopAnimating()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }


    func callAPIUnFavoriteBytes(at cell: JobSecondGuideTableViewCell) {
        //Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_FORM_JOB, eventName: ReproEvent.REPRO_SCREEN_FORM_JOB_ACTION_UNFAVORITE)

        if let workId: String = cell.jobApply["works_id"] as? String {
            let params: [String : Any] = [
                "user_id": PublicVariables.userInfo.m_id,
                "work_id": workId,
                "disable": "1"
            ]

            MBProgressHUD.showAdded(to: self.view, animated: true)
            APIBase.shareObject.callAPIFavoriteBytes(params: params, completionHandler: { (result, error) in
                let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
                if status == 200 {
                    if let indexPathCell: IndexPath = self.mTableView.indexPath(for: cell) {
                        if self.listArrayJobApply.indices.contains(indexPathCell.row) == true {
                            self.mTableView.beginUpdates()
                            self.listArrayJobApply.remove(at: indexPathCell.row)
                            self.mTableView.deleteRows(at: [indexPathCell], with: UITableViewRowAnimation.automatic)
                            self.mTableView.endUpdates()
                        }
                    }
                }
                else {
                    APIBase.shareObject.showAPIError(result: result)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }


    func callAPIGetUserProfile() {
        let param = ["id":PublicVariables.userInfo.m_id]
        APIBase.shareObject.callAPIGetUserProfile(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                PublicVariables.userInfo = User(dict: result?.value(forKey: "body") as! [String : Any] )

                self.nameString = PublicVariables.userInfo.m_name
                self.mailString = PublicVariables.userInfo.m_email
                self.phoneString = PublicVariables.userInfo.m_phone

                self.mTableView.reloadSections(IndexSet(integer: 2), with: .automatic)

            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
        }
    }

    func callAPIApplyJobByte() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params: [String : Any] = [
            "user_id"   : PublicVariables.userInfo.m_id,
            "work_id"    : self.workId,
            "status_type": "APPLY",
            "name"      : self.nameString,
            "name_kana" : self.cataNameString,
            "email"     : self.mailString,
            "phone"     : self.phoneString,
            "content"   : self.noteString
        ]
        APIBase.shareObject.callAPIApplyJobByte(params: params) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                self.confirmCustomView.isHidden = true
                self.doneCustomView.isHidden = false
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }



    //// MARK : - Private function
    func isValidInfomationInput() -> Bool {
        var isValid = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        // Check phone empty
        if (self.mTextFieldPhone.text!) == "" {
            isValid = false
            self.errorMsg = "電話番号を入力してください"
        }

        // Check mail empty
        if (self.mTextFieldEmail.text!) == "" {
            isValid = false
            self.errorMsg = "メールアドレスを入力してください"
        }
        // Check mail format
        if emailTest.evaluate(with: (self.mTextFieldEmail.text!)) == false {
            //Mail is wrong format
            isValid = false
            self.errorMsg = "メールアドレスを正しく入力してください"
        }

        // Check kataname fomat
        if !(self.mTextFieldUFurigana.text!).isKanjiWhiteSpace {
            isValid = false
            self.errorMsg = "カタカナで入力してください"
        }

        // Check name length
        if (self.mTextFieldName.text!).count > 50 {
            isValid = false
            self.errorMsg = "氏名は50文字以内で入力してください"
        }
        // Check name format
        if (self.mTextFieldName.text!).containsEmoji == true {
            isValid = false
            self.errorMsg = "氏名は50文字以内で入力してください"
        }
        // Check name empty
        if (self.mTextFieldName.text!) == "" {
            isValid = false
            self.errorMsg = "氏名を入力してください"
        }
        return isValid
    }
}





// MARK : - Delegate
extension CreateFromJobByteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if self.mTableView.showsInfiniteScrolling == false {
                return self.listInfoProfile.count
            }
            else {
                return 0
            }
        }
        if section == 1 {
            return self.listArrayJobApply.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if self.listArrayJobApply.count > 0 {
                return 40.0 * scaleDisplay
            }
            else {
                return 0.0001
            }
        } else if section == 2 {
            if self.mTableView.showsInfiniteScrolling == false {
                return 40.0 * scaleDisplay
            }
            else {
                return 0.0001
            }
        }
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            if self.mTableView.showsInfiniteScrolling == false {
                return 110 * scaleDisplay
            }
            else {
                return 0.0001
            }
        }
        return 0.0001
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 40.0 * scaleDisplay))
            view.clipsToBounds = true
            view.backgroundColor = UIColor(red: 216, green: 216, blue: 216)
            
            let label = UILabel(frame: CGRect(x: 0, y: 5.0 * scaleDisplay, width: SIZE_WIDTH, height: 30.0 * scaleDisplay))
            label.backgroundColor = UIColor(red: 216, green: 216, blue: 216)
            label.textColor = grayColor
            
            label.font = UIFont(name: "YuGothic-Bold", size: 15 * scaleDisplay)
            label.textAlignment = .center
            view.addSubview(label)

            if section == 1 {
                label.text = NSLocalizedString("job_apply_screen_text_consideration_list", comment: "consideration list")
            } else if section == 2 {
                label.text = NSLocalizedString("job_apply_screen_text_necsesary_matter", comment: "consideration list")
                // Add error view

                let viewError = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 40.0 * scaleDisplay))
                viewError.clipsToBounds = true
                viewError.backgroundColor = primaryColor

                let label = UILabel(frame: CGRect(x: 0, y: 5.0 * scaleDisplay, width: SIZE_WIDTH, height: 30.0 * scaleDisplay))
                label.backgroundColor = primaryColor
                label.textColor = UIColor.white

                label.font = UIFont(name: "YuGothic-Bold", size: 15 * scaleDisplay)
                label.textAlignment = .center
                label.text = self.errorMsg
                self.errorLabel = label
                self.errorView = viewError
                viewError.addSubview(label)
                viewError.isHidden = !self.isError
                view.addSubview(viewError)
            }


            if section == 1 && self.listArrayJobApply.count <= 0 {
                return UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 0.0001))
            }

            if section == 2 && self.mTableView.showsInfiniteScrolling == true {
                return UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 0.0001))
            }

            return view
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 0.0001))
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 && self.mTableView.showsInfiniteScrolling == false {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 110 * scaleDisplay))
            view.clipsToBounds = true
            view.backgroundColor = .clear

            let button = UIColorButton(frame: CGRect(x: 14 * scaleDisplay, y: 23 * scaleDisplay, width: 292 * scaleDisplay, height: 51 * scaleDisplay))
            button.layer.cornerRadius = 4
            button.titleLabel!.font = UIFont(name: "YuGothic-Bold", size: 17 * scaleDisplay)
            button.setTitle(NSLocalizedString("job_apply_screen_button_go_to_confirm_screen", comment: "consideration list"), for: .normal)
            button.addTarget(self, action: #selector(clickedButtonConfirmScreen) , for: .touchUpInside)
            view.addSubview(button)
            return view

        }
        return UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 0.0001 ))
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell:JobFirstGuideCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "jobCellFirstGuide") as! JobFirstGuideCellTableViewCell
            return cell
        case 1:
            let cell:JobSecondGuideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "jobCellSecondGuide") as! JobSecondGuideTableViewCell
            if self.listArrayJobApply.indices.contains(indexPath.row) == true {
                cell.updateDataWithDictByte(item: listArrayJobApply[indexPath.row])
            }
            cell.delegateView = self
            return cell
        case 2:
            var title : String = ""
            var content : String = ""

            if indexPath.row == 4 {
                let cell:JobFourGuideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "jobCellFourGuide") as! JobFourGuideTableViewCell
                if self.listInfoProfile.count > indexPath.row {
                    cell.contentTextView.delegate = self

                    self.mTextViewNote = cell.contentTextView
                    title = NSLocalizedString("createformjobview_label_note", comment: "")
                    content = noteString

                    cell.updateDataWithObject(title: title, content: content)

                    return cell
                }
            }
            else {
                let cell:JobThirdGuideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "jobCellThirdGuide") as! JobThirdGuideTableViewCell
                if self.listInfoProfile.count > indexPath.row {

                    cell.delegate = self
                    cell.contentTextField.tag = indexPath.row
                    cell.contentTextField.keyboardType = .default

                    switch indexPath.row {
                    case 0:
                        self.mTextFieldName = cell.contentTextField
                        self.mTextFieldName.placeholder = NSLocalizedString("createformjobview_label_name", comment: "")
                        title = NSLocalizedString("createformjobview_label_name", comment: "")
                        content = nameString
                        break
                    case 1:
                        self.mTextFieldUFurigana = cell.contentTextField
                        self.mTextFieldUFurigana.placeholder = NSLocalizedString("createformjobview_label_kataname", comment: "")
                        title = NSLocalizedString("createformjobview_label_kataname", comment: "")
                        content = cataNameString
                        break
                    case 2:
                        self.mTextFieldEmail = cell.contentTextField
                        self.mTextFieldEmail.placeholder = NSLocalizedString("createformjobview_label_email", comment: "")
                        title = NSLocalizedString("createformjobview_label_email", comment: "")
                        content = mailString
                        break
                    case 3:
                        self.mTextFieldPhone = cell.contentTextField
                        self.mTextFieldPhone.placeholder = NSLocalizedString("createformjobview_label_phone", comment: "")
                        self.mTextFieldPhone.keyboardType = .numberPad
                        title = NSLocalizedString("createformjobview_label_phone", comment: "")
                        content = phoneString
                        break
                    default:
                        break
                    }

                    cell.updateDataWithObject(title: title, content: content)

                }
                return cell
            }
            break
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension CreateFromJobByteViewController: ConfirmApplyJobByteViewDelegate {
    func callbackDelegateToClickedButtonCancel(sender: ConfirmApplyJobByteView?) {
        self.confirmCustomView.isHidden = true
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_JOB_CONFIRM_ACTION_CANCEL)
    }

    func callbackDelegateToClickedButtonAccept(sender: ConfirmApplyJobByteView?) {
        self.callAPIApplyJobByte()
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_CONFIRM, eventName: ReproEvent.REPRO_SCREEN_JOB_CONFIRM_ACTION_SEND)
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_DONE, eventName: nil)
    }
}

extension CreateFromJobByteViewController: DoneApplyJobByteViewDelegate {
    func callbackDelegateToClickedCloseButton(sender: DoneApplyJobByteView) {
        self.doneCustomView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }

    func callbackDelegateToClickedButtonTop(sender: DoneApplyJobByteView) {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_JOB_DONE, eventName: ReproEvent.REPRO_SCREEN_JOB_BYTE_DONE_ACTION_GO_TOP)

        self.doneCustomView.isHidden = true
        self.dismiss(animated: true, completion: {
            self.delegate?.backToTop()
        })
    }
}

extension CreateFromJobByteViewController: JobSecondGuideTableViewCellDelegate {
    func callbackDelegateToClickedButtonDelete(sender: JobSecondGuideTableViewCell) {
        self.callAPIUnFavoriteBytes(at: sender)
    }
}

extension CreateFromJobByteViewController: JobThirdGuideTableViewCellDelegate {
    func handleTextFieldChanged(sender: UITextField) {
        let newString: String = (sender.text != nil ? sender.text!: "")

        if sender == mTextFieldName{
            self.isEditName = true
            nameString = newString
        }
        else if sender == mTextFieldUFurigana{
            cataNameString = newString
        }
        else if sender == mTextFieldEmail{
            self.isEditEmail = true
            mailString = newString
        }
        else if sender == mTextFieldPhone{
            self.isEditPhone = true
            phoneString = newString
        }
        else{
            noteString = newString
        }
        
        if self.isValidInfomationInput() {
            self.isError = false
            self.errorView?.isHidden = true
        }
        else {
            self.isError = true
            self.errorView?.isHidden = false
        }
        self.errorLabel?.text = self.errorMsg
    }
}

extension CreateFromJobByteViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newString: String = (textView.text != nil ? textView.text : "")
        noteString = newString
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText = textView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if (updatedText?.isEmpty)! {

            textView.text = NSLocalizedString("createformjobview_label_note", comment: "")
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

            return false
        }

            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor(red: 108, green: 80, blue: 50)
        }

        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
