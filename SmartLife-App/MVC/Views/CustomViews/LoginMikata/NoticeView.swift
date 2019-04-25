//
//  NoticeView..swift
//  SmartLife-App
//
//  Created by thanhlt on 8/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol NoticeViewDelegate: class {
    func closeNotice()
}

class NoticeView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contractorNameTitleLabel: UILabel!
    @IBOutlet weak var contractorNameLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationTimeTitleLabel: UILabel!
    @IBOutlet weak var duraationTimeLabel: UILabel!
    @IBOutlet weak var automaticUpdateTitleLabel: UILabel!
    @IBOutlet weak var automaticUpdateLabel: UILabel!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var exprirationDateTitleLabel: UILabel!
    @IBOutlet weak var monthlyPaymentTitleLabel: UILabel!
    @IBOutlet weak var commonServiceTitleLabel: UILabel!
    @IBOutlet weak var rentTitleLabel: UILabel!
    @IBOutlet weak var feeTitleLabel: UILabel!

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var exprirationDateLabel: UILabel!
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var commonServiceLabel: UILabel!
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!

    @IBOutlet weak var boundFormView: UIView!
    @IBOutlet weak var boundExpirationDateView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate:NoticeViewDelegate? = nil
    private var scale:CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setLanguageForView()
        self.setAttributesForConfirmView()
    }
    
    @IBAction func clickCloseButton(_ sender: Any) {
        self.isHidden = true
    }
    @IBAction func clickCancelButton(_ sender: UIButton) {
        self.isHidden = true
    }
    @IBAction func clickOKButton(_ sender: UIButton) {
        self.isHidden = true
        self.delegate?.closeNotice()
    }

    private func setLanguageForView(){
        self.titleLabel.text = NSLocalizedString("loginmikata_label_register_complete_title", comment: "")
//        self.subTitleLabel.text = NSLocalizedString("loginmikata_label_register_complete_subtitle", comment: "")
        self.contractorNameTitleLabel.text = NSLocalizedString("loginmikata_label_contractor_name", comment: "")
        self.locationTitleLabel.text = NSLocalizedString("loginmikata_label_location", comment: "")
        self.durationTimeTitleLabel.text = NSLocalizedString("loginmikata_label_during_contract", comment: "")
        self.automaticUpdateTitleLabel.text = NSLocalizedString("loginmikata_label_automatic_update", comment: "")
        self.startDateTitleLabel.text = NSLocalizedString("loginmikata_label_contract_start_date", comment: "")
        self.exprirationDateTitleLabel.text = NSLocalizedString("loginmikata_label_contract_expriration_date", comment: "")
        self.monthlyPaymentTitleLabel.text = NSLocalizedString("loginmikata_label_monthly_payment", comment: "")
        self.commonServiceTitleLabel.text = NSLocalizedString("loginmikata_label_common_service", comment: "")
        self.rentTitleLabel.text = NSLocalizedString("loginmikata_label_rent", comment: "")
        self.feeTitleLabel.text = NSLocalizedString("loginmikata_label_fee", comment: "")
        self.cancelBtn.setTitle(NSLocalizedString("common_button_back", comment: ""), for: .normal)
        self.okBtn.setTitle(NSLocalizedString("common_button_ok", comment: ""), for: .normal)
    }

    private func setAttributesForConfirmView() {
        // TitleLabel
        self.titleLabel.font = self.titleLabel.font.withSize(13.5 * self.scale)
        // Set border for view
        self.boundFormView.layer.borderWidth = 0.5
        self.boundFormView.layer.borderColor = UIColor(red: 108, green: 80, blue: 50).cgColor
    }

    public func updateContent(contractObj : ContractObj){
        self.contractorNameLabel.text = contractObj.mContractorName
        self.duraationTimeLabel.text = contractObj.mDurationTime
        self.automaticUpdateLabel.text = contractObj.mAutomaticUpdate
        self.startDateLabel.text = contractObj.mStartDate
        self.exprirationDateLabel.text = contractObj.mExpirationDate
        self.monthlyPaymentLabel.text = contractObj.mMonthlyPayment
        self.commonServiceLabel.text = contractObj.mCommonService
        self.rentLabel.text = contractObj.mRent
        self.feeLabel.text = contractObj.mFee

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points
        self.locationLabel.attributedText = NSMutableAttributedString(string: contractObj.mLocation,attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle]);
    }
}
