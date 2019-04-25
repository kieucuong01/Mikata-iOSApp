
//
//  SelectAvatarUserView.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/24/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
protocol SelectAvatarUserViewDelegate:class {
    func requestMBProgressHUDShow(sender:SelectAvatarUserView)
    func requestMBProgressHUDHide(sender:SelectAvatarUserView)
    func clickedAvatarInList(sender:SelectAvatarUserView, image:String)
    func apiGetListShowError(sender:SelectAvatarUserView, message:String)
}

class SelectAvatarUserView: UIView {
    @IBOutlet weak var mTopConstraintLabelTipTop: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraintLabelTipTop: NSLayoutConstraint!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    @IBOutlet weak var mLabelTipTop: UILabel!
    
    weak var delegate:SelectAvatarUserViewDelegate? = nil
    var arrayAvatar:[AvatarUser] = [ AvatarUser ]()
    /*:
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var scale: CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.mLabelTipTop.text = NSLocalizedString("selectavataruser_popup_label_tiptop", comment: "")
        self.mCollectionView.register(AvatarCollectionViewCell.self, forCellWithReuseIdentifier: "cellAvatar")
        self.mCollectionView.delegate = self
        self.mCollectionView.dataSource = self
    }
    
    private func setConstraintForViews() {
        self.mTopConstraintLabelTipTop.constant = 32 * scale
        self.mBottomConstraintLabelTipTop.constant = 27 * scale
    }
    
    func callAPIGetUser() {
        self.delegate?.requestMBProgressHUDShow(sender: self)
        APIBase.shareObject.callAPIListAvatarIcon(params: nil) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
//                print("result \(result)")
                let array = result?.value(forKey: "body") as! NSArray
                self.arrayAvatar.removeAll()
                for  item in array {
                    let avaUser = AvatarUser(dict: item as! NSDictionary)
                    self.arrayAvatar.append(avaUser)
                }
                if self.arrayAvatar.count > 6 {
                    self.mCollectionView.isScrollEnabled = true
                }
                self.mCollectionView.reloadData()
            } else {
                
                APIBase.shareObject.showAPIError(result: result)
            }
            
            self.delegate?.requestMBProgressHUDHide(sender: self)
        }
    }
    
    func callAPIUpdateAvatarIcon(icon: String) {
        NotificationCenter.default.post(name: NSNotificationShowHUDProgress, object: nil)
        let param : [String: Any] = ["icon_path":icon,"user_id":PublicVariables.userInfo.m_id]
        APIBase.shareObject.callAPIUpdateIcon(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                print("result \(String(describing: result))")
                self.delegate?.clickedAvatarInList(sender: self, image:icon)
            } else {
                
                APIBase.shareObject.showAPIError(result: result)
            }
            
            NotificationCenter.default.post(name: NSNotificationHideHUDProgress, object: nil)
        }

    }
    @IBAction func clickedCloseButton(_ sender: Any) {
        // Track Repro
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT_POPUP_CHANGE_ICON, eventName: ReproEvent.REPRO_SCREEN_PROFILE_EDIT_POPUP_CHANGE_ICON)

        self.isHidden = true
    }

}

extension SelectAvatarUserView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAvatar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72 * scale, height: 72 * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  18 * scale
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25 * scale

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AvatarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAvatar", for: indexPath) as! AvatarCollectionViewCell
        let avaUser:AvatarUser = arrayAvatar[indexPath.row]
        cell.mImageView.image = nil
        cell.mImageView.setImageForm(urlString: avaUser.m_icon_path, placeHolderImage: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isHidden = true
        let avaUser:AvatarUser = arrayAvatar[indexPath.row]
        self.callAPIUpdateAvatarIcon(icon:avaUser.m_icon_path)
    }
}


class AvatarCollectionViewCell: UICollectionViewCell {
    private var _mImageView:UIImageView? = nil
    
    
    override init(frame: CGRect ) {
        super.init(frame: frame)
        
        self.createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter
    var mImageView:UIImageView {
        if _mImageView == nil {
            _mImageView = UIImageView(frame: self.bounds)
            _mImageView?.contentMode = .scaleAspectFill
            _mImageView?.clipsToBounds = true
            _mImageView?.layer.cornerRadius = self.bounds.width/2;
        }
        return _mImageView!
    }
    
    private func createSubviews() {
        self.addSubview(self.mImageView)
    }
}
