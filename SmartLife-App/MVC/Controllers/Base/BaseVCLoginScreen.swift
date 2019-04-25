//
//  BaseVCLoginScreen.swift
//  SmartTablet
//
//  Created by thanhlt on 7/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit


class BaseVCLoginScreen: BaseViewController {

    @IBOutlet weak var viewBorder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewsOnController()
        // Do any additional setup after loading the view.
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

    // MARK: - Private method
    private func setDashedLineForView() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.viewBorder.bounds
        shapeLayer.position = self.viewBorder.center
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [NSNumber(value: 10),NSNumber(value:5)]
        shapeLayer.path = CGMutablePath()
        // Setup the path
        let path = CGMutablePath()
        
//        let x = self.viewBorder.frame.origin.x
        let y = self.viewBorder.frame.origin.y
//        var newx = 0
//        var newy = -self.viewBorder.frame.size.height/2 + y
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: self.viewBorder.frame.size.width/2, y: self.viewBorder.frame.size.height/2 + 40))
        shapeLayer.path = path
        self.viewBorder.layer.addSublayer(shapeLayer)
    }
    
    private func setupViewsOnController() {
        self.setDashedLineForView()
    }
}
