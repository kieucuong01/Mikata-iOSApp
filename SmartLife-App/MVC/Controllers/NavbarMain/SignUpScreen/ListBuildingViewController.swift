//
//  ListBuildingViewController.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/5/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ListBuildingViewControllerDelegate: class {
    func callbackDelegateToSelectOneBuilding(sender:ListBuildingViewController, item: NSDictionary)
}

class ListBuildingViewController: BaseViewController {
    
    //Variable constriant
    
    
    /*Varaible don't allow change value*/
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mCustomSearchBar: SearchBarCustomView!
    /*Varaible  don't  allow change value*/
    

    /*Varaible allow change value*/
    var oldSelectedIndexPath : IndexPath? = nil
    var defaultList: [NSDictionary] = [NSDictionary]()
    var listKabochaBuildings: [NSDictionary] = [NSDictionary]()
    var selectedKabocha: NSDictionary? = nil
    var mKeyboardSearch:String = ""
    weak var delegate: ListBuildingViewControllerDelegate? = nil
    /*Varaible allow change value*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageForView()
        self.setFontForViews()
        self.setPropertiesForViews()
        self.oldSelectedIndexPath = nil
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.callAPIGetListKabochaBuldingAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setLanguageForView(){
        self.mLabelTitle.text = NSLocalizedString("listbuildingview_navigation_title", comment: "")
    }

    private func setFontForViews() {
        self.mLabelTitle.font = UIFont(name: self.mLabelTitle.font.fontName, size: 14 * scaleDisplay)
    }
    
    private func setPropertiesForViews() {
        let nib = UINib(nibName: "NotficationFilterCell", bundle: nil)
        self.mTableView.register(nib , forCellReuseIdentifier: "notificationFilterCell")
        
        self.mCustomSearchBar.delegate = self
    }

    func callAPIGetListKabochaBuldingAll() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.listKabochaBuildings.removeAll()
        var param:[String:Any]? = nil
        if self.mKeyboardSearch.isEmpty == false {
            param = ["keyword":self.mKeyboardSearch]
        }
        APIBase.shareObject.callAPIListKabocha(params: param) { (result, error) in
            let status = (result?.value(forKey: "status") as? NSNumber)?.intValue
            if status == 200 {
                if let array = result?.value(forKey: "body") as? [NSDictionary] {
                    self.listKabochaBuildings = array
                    self.defaultList = array
                }
                
            } else {
                APIBase.shareObject.showAPIError(result: result)
            }
            self.mTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
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
    @IBAction func clickedButtonClose(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    func updateNewListWithKeyWord() {
        if self.mKeyboardSearch.isEmpty {
            self.listKabochaBuildings = defaultList
        } else {
            var newList:[NSDictionary] = [NSDictionary]()
            for item in self.defaultList {
                // Get name strings
                let stringA: String = (item.value(forKey: "name") as? String) ?? ""
                let stringB: String = (item.value(forKey: "hiragana") as? String) ?? ""
                let stringC: String = (item.value(forKey: "katakana") as? String) ?? ""

                // Check contain
                let isContainInA: Bool = stringA.lowercased().contains(self.mKeyboardSearch.lowercased())
                let isContainInB: Bool = stringB.lowercased().contains(self.mKeyboardSearch.lowercased())
                let isContainInC: Bool = stringC.lowercased().contains(self.mKeyboardSearch.lowercased())

                // Check condition to append
                if (isContainInA == true) || (isContainInB == true) || (isContainInC == true) {
                    newList.append(item)
                }
            }
            self.listKabochaBuildings = newList
        }
        self.mTableView.reloadData()
    }
}

extension ListBuildingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listKabochaBuildings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * scaleDisplay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationFilterCell") as! NotficationFilterCell
        
        let dict = listKabochaBuildings[indexPath.row]
        
        if indexPath.row ==  listKabochaBuildings.count - 1 {
            cell.mLastLineView.isHidden = false
        } else {
            cell.mLastLineView.isHidden = true
        }

        if let string = dict.value(forKey: "name") as? String {
            cell.mLabelContent.text = string
        } else {
            cell.mLabelContent.text = "-"
        }
        cell.backgroundColor = .white
        cell.mLabelContent.textColor = grayColor
        cell.mButtonCheck.isHidden = true
        
        if selectedKabocha != nil {
            let selectIndex = (selectedKabocha?.value(forKey: "id") as? NSString)!.intValue
            let currentIndex =  (dict.value(forKey: "id") as? NSString)!.intValue
            if selectIndex == currentIndex {
                cell.backgroundColor = primaryColor
                cell.mButtonCheck.isHidden = false
                cell.mLabelContent.textColor = .white
                
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if oldSelectedIndexPath != nil {
            let oldCell = tableView.cellForRow(at: oldSelectedIndexPath!) as? NotficationFilterCell
            oldCell?.backgroundColor = .white
            oldCell?.mLabelContent.textColor = grayColor
            oldCell?.mButtonCheck.isHidden = true
        }
        oldSelectedIndexPath = indexPath
        
        
        let dict = listKabochaBuildings[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)  as? NotficationFilterCell
        cell?.backgroundColor = primaryColor
        cell?.mButtonCheck.isHidden = false
        cell?.mLabelContent.textColor = .white
        
        //Reset value
        self.selectedKabocha = dict
        self.mKeyboardSearch = ""
        self.mCustomSearchBar.textFieldCell.text = ""
        self.delegate?.callbackDelegateToSelectOneBuilding(sender: self, item: self.listKabochaBuildings[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? NotficationFilterCell
        cell?.backgroundColor = .white
        cell?.mLabelContent.textColor = grayColor
        cell?.mButtonCheck.isHidden = true
        
    }
}

extension ListBuildingViewController: SearchBarCustomViewDelegate {
    func callbackActionClickedButtonFilter() {
    }
    
    func callAPISearchPointItems(keyword: String) {
        self.mKeyboardSearch = keyword
        self.updateNewListWithKeyWord()
    }
}
