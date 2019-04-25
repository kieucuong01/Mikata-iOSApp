//
//  NavbarForgesPassViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit


class NavbarForgetPassViewController: UINavigationController {

    private var navBarView:UIView = {
        let tempScale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 51 * tempScale + GlobalMethod.getTopPadding()))
        view.backgroundColor = UIColor.white
        view.dropShadow()
        return view
    }()
    
    private var buttonBack:UIButton = {
        let tempScale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let height = 43 * tempScale
        let y = GlobalMethod.getTopPadding() + 4 * tempScale
        let btn = UIButton(frame: CGRect(x: 0, y:  y, width: height, height: height))
        btn.addTarget(self, action: #selector(NavbarForgetPassViewController.clickedButtonBack(sender:)), for: .touchUpInside)
        btn.setBackgroundImage(#imageLiteral(resourceName: "button_back_2"), for: .normal)
        
        return btn
    }()
    
    var titleNav:UILabel = {
        let tempScale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        let label = UILabel(frame: CGRect(x: 50, y: GlobalMethod.getTopPadding(), width: SIZE_WIDTH - 100 * tempScale , height: 51 * tempScale))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "YuGothic-Bold", size: 14 * tempScale)
        label.text = NSLocalizedString("forgetpasswordview_navbar", comment: "")
        return label
    }()
    
    var scale:CGFloat = DISPLAY_SCALE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Do any additional setup after loading the view.
        self.createSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NavbarForgetPassViewController.finishedEditting))
        self.navBarView.addGestureRecognizer(tap)
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
    private func createSubviews() {
        self.view.addSubview(self.navBarView)
        self.navBarView.addSubview(self.buttonBack)
        self.navBarView.addSubview(self.titleNav)
    }
    
    //MARK: - Selector
    @objc func clickedButtonBack(sender:Any) {
        if self.viewControllers.count > 1 {
           self.popViewController(animated: true)
        } else {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func finishedEditting() {
        if self.viewControllers.count > 0 {
            if let vc = self.viewControllers[self.viewControllers.count - 1] as? ForgetPasswordViewController {
                vc.hideForegroundKeyboardView()
            } else {
                self.view.endEditing(true)
            }
        }
        
        
    }
}
