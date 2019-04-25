//
//  BaseVCTutorialScreen.swift
//  SmartTablet
//
//  Created by thanhlt on 6/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class BaseVCTutorialScreen: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var mConstraintButtonSkip: NSLayoutConstraint!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var scrollViewTutorial: UIScrollView!
    @IBOutlet weak var btnSkip: UIButton!
    private var _viewSelectedPage1:UIView? = nil
    private var _viewSelectedPage2:UIView? = nil
    private var _viewSelectedPage3:UIView? = nil
    private var _viewSelectedPage4:UIView? = nil
    private var _btnSkip:UIButton? = nil
    
    private var _lastContentOffset:CGFloat = 0
    private var isStopScroll:Bool = false
    
    private var arrayImagesTutorial:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_INTRODUCTION, eventName:  nil)
        // Do any additional setup after loading the view, typically from a nib.
        self.createSubViews()
        self.setActionForViews()
        self.mConstraintButtonSkip.constant = 35 * scaleDisplay
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Getter
    var viewSelectedPage1:UIView {
        if _viewSelectedPage1 == nil {
            let size = IS_IPAD ? 20.0 * scaleDisplay : 10.0 * scaleDisplay
            var y = 490.0 * scaleDisplay
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 554.0 * scaleDisplay
            }
            let x = 136.0 * scaleDisplay
            _viewSelectedPage1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage1?.center = CGPoint(x: x, y: y)
            _viewSelectedPage1?.backgroundColor = UIColor(red: 252, green: 107, blue: 42)
            _viewSelectedPage1?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage1!
    }
    
    var viewSelectedPage2:UIView {
        if _viewSelectedPage2 == nil {
            let size = IS_IPAD ? 16.0 * scaleDisplay : 8.0 * scaleDisplay
            var y = 490.0 * scaleDisplay
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 554.0 * scaleDisplay
            }
            let x = 152.0 * scaleDisplay
            _viewSelectedPage2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage2?.center = CGPoint(x: x, y: y)
            _viewSelectedPage2?.backgroundColor = UIColor(red: 123, green: 122, blue: 122)
            _viewSelectedPage2?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage2!
    }
    
    var viewSelectedPage3:UIView {
        if _viewSelectedPage3 == nil {
            let size = IS_IPAD ? 16.0 * scaleDisplay : 8.0 * scaleDisplay
            let x = 169.0 * scaleDisplay
            var y = 490.0 * scaleDisplay
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 554.0 * scaleDisplay
            }
            _viewSelectedPage3 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage3?.center = CGPoint(x: x, y: y)
            _viewSelectedPage3?.backgroundColor = UIColor(red: 123, green: 122, blue: 122)
            _viewSelectedPage3?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage3!
    }
    
    var viewSelectedPage4:UIView {
        if _viewSelectedPage4 == nil {
            let size = IS_IPAD ? 16.0 * scaleDisplay : 8.0 * scaleDisplay
            var y = 490.0 * scaleDisplay
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 554.0 * scaleDisplay
            }
            let x = 186.0 * scaleDisplay
            _viewSelectedPage4 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage4?.center = CGPoint(x: x, y: y)
            _viewSelectedPage4?.backgroundColor = UIColor(red: 123, green: 122, blue: 122)
            _viewSelectedPage4?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage4!
    }
    
    
    //MARK: - Private method
    private func createSubViews() {
        self.view.addSubview(self.viewSelectedPage1)
        self.view.addSubview(self.viewSelectedPage2)
        self.view.addSubview(self.viewSelectedPage3)
        self.view.addSubview(self.viewSelectedPage4)
    }
    private func setActionForViews(){
        self.btnStart.addTarget(self, action: #selector(clickButtonStart), for: .touchUpInside)
        self.btnSkip.addTarget(self, action: #selector(clickButtonToSkipTutorial), for: .touchUpInside)
    }

    //MARK: - Selector
    @objc func clickButtonToSkipTutorial() {
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_INTRODUCTION, eventName:  ReproEvent.REPRO_SCREEN_INTRODUCTION_ACTION_SKIP)
    }

    @objc func clickButtonStart(){
        GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_INTRODUCTION_FINISH, eventName:  ReproEvent.REPRO_SCREEN_INTRODUCTION_FINISH_ACTION_START)
    }
    
    //MARK: - ScrollView Delegate
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
            self.checkScrollWhenRightDirection()

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>){
            self.trackRepro()
    }

    private func checkScrollWhenRightDirection() {
        let sizeSelected = IS_IPAD ? 20.0 * scaleDisplay : 10.0 * scaleDisplay
        let sizeNormal = IS_IPAD ? 16.0 * scaleDisplay : 8.0 * scaleDisplay
        self.viewSelectedPage4.frame.size = CGSize(width: sizeNormal, height: sizeNormal)
        self.viewSelectedPage3.frame.size = CGSize(width: sizeNormal, height: sizeNormal)
        self.viewSelectedPage2.frame.size = CGSize(width: sizeNormal, height: sizeNormal)
        self.viewSelectedPage1.frame.size = CGSize(width: sizeNormal, height: sizeNormal)

        self.viewSelectedPage4.backgroundColor = UIColor(red: 123, green: 122, blue: 122)
        self.viewSelectedPage3.backgroundColor = UIColor(red: 123, green: 122, blue: 122)
        self.viewSelectedPage2.backgroundColor = UIColor(red: 123, green: 122, blue: 122)
        self.viewSelectedPage1.backgroundColor = UIColor(red: 123, green: 122, blue: 122)

        let centerXContenOffset: CGFloat = scrollViewTutorial.contentOffset.x + (scrollViewTutorial.frame.size.width / 2.0)
        let currentPage: Int = Int(centerXContenOffset / scrollViewTutorial.frame.size.width)
        if  currentPage == 3 {
            self.viewSelectedPage4.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage4.backgroundColor = UIColor(red: 252, green: 107, blue: 42)
            self.btnStart.isHidden = false
            self.btnSkip.isHidden = true

        } else if currentPage == 2 {
            self.viewSelectedPage3.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage3.backgroundColor = UIColor(red: 252, green: 107, blue: 42)
            self.btnStart.isHidden = true
            self.btnSkip.isHidden = false

        } else if currentPage == 1 {
            self.viewSelectedPage2.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage2.backgroundColor = UIColor(red: 252, green: 107, blue: 42)
            self.btnStart.isHidden = true
            self.btnSkip.isHidden = false

        } else {
            self.viewSelectedPage1.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage1.backgroundColor = UIColor(red: 252, green: 107, blue: 42)
            self.btnStart.isHidden = true
            self.btnSkip.isHidden = false
        }

        self.updateViewSelectedPage()
    }

    private func updateViewSelectedPage() {
        self.viewSelectedPage4.layer.cornerRadius = self.viewSelectedPage4.frame.size.width / 2.0
        self.viewSelectedPage3.layer.cornerRadius = self.viewSelectedPage3.frame.size.width / 2.0
        self.viewSelectedPage2.layer.cornerRadius = self.viewSelectedPage2.frame.size.width / 2.0
        self.viewSelectedPage1.layer.cornerRadius = self.viewSelectedPage1.frame.size.width / 2.0

        var y = 490.0 * scaleDisplay
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
            y = 554.0 * scaleDisplay
        }
        let x1 = 136.0 * scaleDisplay
        let x2 = 152.0 * scaleDisplay
        let x3 = 169.0 * scaleDisplay
        let x4 = 186.0 * scaleDisplay
        self.viewSelectedPage1.center = CGPoint(x: x1, y: y)
        self.viewSelectedPage2.center = CGPoint(x: x2, y: y)
        self.viewSelectedPage3.center = CGPoint(x: x3, y: y)
        self.viewSelectedPage4.center = CGPoint(x: x4, y: y)
    }

    private func trackRepro() {
        let centerXContenOffset: CGFloat = scrollViewTutorial.contentOffset.x + (scrollViewTutorial.frame.size.width / 2.0)
        let currentPage: Int = Int(centerXContenOffset / scrollViewTutorial.frame.size.width)
        if  currentPage == 3 {
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_INTRODUCTION_FINISH, eventName:  nil)

        } else if currentPage == 0{
            GlobalMethod.sendEventToRepro(screenName: ReproEvent.REPRO_SCREEN_INTRODUCTION, eventName:  nil)
            
        }
    }
}
