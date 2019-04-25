//
//  BaseViewcontrollers.swift
//  SmartTablet
//
//  Created by thanhlt on 6/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var isSetForegroundView:Bool = false
    private var _foregroundKeyboardView:UIView? = nil
    
    
    var scaleDisplay:CGFloat = DISPLAY_SCALE
    
    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isSetForegroundView = false;
        scaleDisplay = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Getter
    var foregroundKeyboardView:UIView {
        if _foregroundKeyboardView == nil {
            _foregroundKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT))
            let tapView: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BaseViewController.hideForegroundKeyboardView))
            _foregroundKeyboardView!.addGestureRecognizer(tapView)
            _foregroundKeyboardView!.isHidden = true
        }
        return _foregroundKeyboardView!
    }
    
    //MARK:- Public method
    
    func addForegroundKeyboard(parentView:UIView) {
        if isSetForegroundView == false {
            parentView.addSubview(self.foregroundKeyboardView)
            isSetForegroundView = true
        }
    }
    
    @objc func hideForegroundKeyboardView() {
        self.setEditing(false, animated: false)
        
    }
    func showForegroundKeyboardView() {
        self.foregroundKeyboardView.isHidden = false
        
    }
    
    func errorAPIAppear(message: String?) {
        let alertController = UIAlertController(title: NSLocalizedString("alert_warning_title", comment: ""), message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: NSLocalizedString("button_cancel_title", comment: ""), style: .cancel, handler:nil)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAPIError(result: NSDictionary?) {
        if let error: NSDictionary = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary {
            if let errorMessage: String = error.object(forKey: "message") as? String {
                // Init alert
                let alertController: UIAlertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: UIAlertActionStyle.default, handler: { (alert) in
                }))

                // Make title smaller
                alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

                // Show alert
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
