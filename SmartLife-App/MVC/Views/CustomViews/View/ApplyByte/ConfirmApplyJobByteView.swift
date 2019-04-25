//
//  ConfirmApplyJobByteView.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ConfirmApplyJobByteViewDelegate:class {
    func callbackDelegateToClickedButtonCancel(sender:ConfirmApplyJobByteView?)
    func callbackDelegateToClickedButtonAccept(sender:ConfirmApplyJobByteView?)
}

class ConfirmApplyJobByteView: UIView {
    
    @IBOutlet weak var mTopConstraintView: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintView: NSLayoutConstraint!
    
    @IBOutlet weak var mTableView: UITableView!
    
    weak var delegateView:ConfirmApplyJobByteViewDelegate? = nil
    var listArrayJobApply:[[String:Any?]] = [[String:Any?]]()
    var listInfoProfile:[[String:String]] = [[String:String]]()
    var scale:CGFloat = DISPLAY_SCALE
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setPropertiesForViews()
        self.setConstraintForViews()
        self.loadDataWithDict()
        
    }

    private func setConstraintForViews() {
        self.mTopConstraintView.constant = 48 * scale
        self.mBottomConstraintView.constant = 55 * scale
    }
    
    private func loadDataWithDict() {
        if let path = Bundle.main.path(forResource: "ListItemJobProfile", ofType: "plist") {
            if let array = NSMutableArray(contentsOfFile: path) as? [[String: String]] {
                self.listInfoProfile = array
            }
        }
        self.mTableView.reloadData()
    }
    private func setPropertiesForViews() {
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        self.mTableView.allowsSelection = false

        let nibHeader = UINib(nibName: "ConfirmJobHeaderCell", bundle: nil)
        self.mTableView.register(nibHeader, forCellReuseIdentifier: "confirmJobHeaderCell")
        
        let nibElement = UINib(nibName: "ConfirmJobElementCell", bundle: nil)
        self.mTableView.register(nibElement, forCellReuseIdentifier: "confirmJobElementCell")
        
        let nibProperties = UINib(nibName: "ConfirmJobPropertiesCell", bundle: nil)
        self.mTableView.register(nibProperties, forCellReuseIdentifier: "confirmJobPropertiesCell")
    }
    
    //MARK: - Selector
    @objc func clickedButtonCancel() {
        self.delegateView?.callbackDelegateToClickedButtonCancel(sender: self)
    }
    
    @objc func clickedButtonAccept() {
        self.delegateView?.callbackDelegateToClickedButtonAccept(sender: self)
    }
}

extension ConfirmApplyJobByteView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return self.listInfoProfile.count
        } else if section == 1 {
            return self.listArrayJobApply.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 69 * scale
        } else {
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 78 * scale
        } else {
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width:  278 * scale, height: 69 * scale ))
            view.backgroundColor = .clear
            
            let label = UILabel(frame: CGRect(x: 0, y: 32 * scale, width:  278 * scale, height: 20 * scale))
            label.textAlignment = .center
            label.font = UIFont(name: "YuGothic-Bold", size: 16 * scale)
            label.text = NSLocalizedString("confirmapplyjobview_section_necessary_info", comment: "")
            label.textColor = grayColor
            
            view.addSubview(label)
            return view
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001 ))
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 278 * scale, height: 78 * scale ))
            view.backgroundColor = .clear
            
            let btn1 = UIBorderButton(frame: CGRect(x: 27 * scale, y: 25 * scale, width: 108 * scale, height: 44 * scale))
            btn1.titleLabel!.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
            btn1.setTitle(NSLocalizedString("common_button_cancel", comment: ""), for: .normal)
            btn1.addTarget(self, action: #selector(clickedButtonCancel) , for: .touchUpInside)
            
            let btn2 = UIColorButton(frame: CGRect(x: 142 * scale, y: 25 * scale, width: 108 * scale, height: 44 * scale))
            btn2.titleLabel!.font = UIFont(name: "YuGothic-Bold", size: 14 * scale)
            btn2.setTitle(NSLocalizedString("confirmapplyjobview_button_send", comment: ""), for: .normal)
            btn2.addTarget(self, action: #selector(clickedButtonAccept) , for: .touchUpInside)
            
            view.addSubview(btn1)
            view.addSubview(btn2)
            return view
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001 ))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.mTableView.dequeueReusableCell(withIdentifier: "confirmJobHeaderCell") as? ConfirmJobHeaderCell
            cell?.delegateView = self
            return cell!
        } else if indexPath.section == 1 {
            let cell = self.mTableView.dequeueReusableCell(withIdentifier: "confirmJobElementCell") as? ConfirmJobElementCell
            cell?.updateDataWithDictByte(item: listArrayJobApply[indexPath.row])
            cell?.updateConstraintsIfNeeded()
            return cell!
        } else if indexPath.section == 2 {
            let cell = self.mTableView.dequeueReusableCell(withIdentifier: "confirmJobPropertiesCell") as? ConfirmJobPropertiesCell
            let item = self.listInfoProfile[indexPath.row]
            cell?.updateDataWithDict(item: item)
            return cell!
        }
        return UITableViewCell()
    }
}

extension ConfirmApplyJobByteView: ConfirmJobHeaderCellDelegate {
    func callbackDelegateToClickedButtonClose(sender: ConfirmJobHeaderCell?) {
        self.clickedButtonCancel()
    }
}
