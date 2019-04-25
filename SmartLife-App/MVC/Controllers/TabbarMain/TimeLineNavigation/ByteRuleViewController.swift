//
//  ByteRuleViewController.swift
//  SmartLife-App
//
//  Created by thanhlt on 10/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ByteRuleViewController: BaseViewController {

    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerClassViewForTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: true) )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotificationNavbarMainHideNavbar, object: NSNumber(value: false) )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerClassViewForTableView() {
        let nibTop = UINib(nibName: "ByteDetailTopCell", bundle: nil)
        self.mTableView.register(nibTop, forCellReuseIdentifier: "byteDetailTopCell")
        let nibProperties = UINib(nibName: "ByteDetailPropertiesCell", bundle: nil)
        self.mTableView.register(nibProperties, forCellReuseIdentifier: "byteDetailPropertiesCell")
        let nibListButton = UINib(nibName: "ByteDetailCustomCell", bundle: nil)
        self.mTableView.register(nibListButton, forCellReuseIdentifier: "byteRuleListButtonCell")
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ByteRuleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "byteDetailTopCell") as! ByteDetailTopCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "byteDetailPropertiesCell") as! ByteDetailPropertiesCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "byteRuleListButtonCell") as! ByteDetailCustomCell
            return cell
        }
    }
}
