//
//  ListJobCollectionViewCell.swift
//  SmartTablet
//
//  Created by thanhlt on 7/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ListJobCollectionViewCellDelegate:class {
    func callbackDelegateToSelectItemOfListByte(sender:ListJobCollectionViewCell,index:IndexPath)
}

class ListJobCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableListJob: UITableView!
    weak var delegate:ListJobCollectionViewCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableListJob.delegate = self
        self.tableListJob.dataSource = self
    }
    
    //MARK: - Private method
    
}

extension ListJobCollectionViewCell : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        default:
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120.0 * DISPLAY_SCALE
        } else if indexPath.section == 1 {
            return 123.0 * DISPLAY_SCALE
        } else{
            return 128.0 * DISPLAY_SCALE
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            self.delegate?.callbackDelegateToSelectItemOfListByte(sender: self, index: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.createViewCellForFirstSection(indexPath: indexPath)

        case 1:
            return self.createViewCellForSecondSection(indexPath: indexPath)

        default:
            return self.createViewCellForThirdSection(indexPath: indexPath)

        }
    }
    

    
    func createViewCellForFirstSection(indexPath: IndexPath) -> UITableViewCell {
        var cell = tableListJob.dequeueReusableCell(withIdentifier: "jobFirstCell") as? JobFirstCell
        if cell != nil{
            return cell!;
        } else {
            cell = Bundle.main.loadNibNamed("JobFirstCell", owner: self, options: nil)![0] as? JobFirstCell
            return cell!;
        }
    }
    
    func createViewCellForSecondSection(indexPath: IndexPath) -> UITableViewCell {
        var cell = tableListJob.dequeueReusableCell(withIdentifier: "jobSecondCell") as? JobSecondCell
        if cell == nil{
            cell = Bundle.main.loadNibNamed("JobSecondCell", owner: self, options: nil)![0] as? JobSecondCell
        }
        let dict = tempDataDictionary()
        cell!.updateDateFromDictionary(dict: dict)
        return cell!;
    }
    
    func createViewCellForThirdSection(indexPath: IndexPath) -> UITableViewCell {
        var cell = tableListJob.dequeueReusableCell(withIdentifier: "jobThirdCell") as? JobThirdCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("JobThirdCell", owner: self, options: nil)![0] as? JobThirdCell
        }
        return cell!
    }
    
    
    //TempDataa
    private func tempDataDictionary() -> NSDictionary {
        let dict: NSDictionary = [ "universities" : [["name_university":"東京理科大","num_of_person":"8","array":[["gender":"female","year_std":"3年"],["gender":"male","year_std":"3年"],["gender":"male","year_std":"3年"],["gender":"female","year_std":"3年"],["gender":"male","year_std":"2年"],["gender":"male","year_std":"2年"],["gender":"female","year_std":"2年"],["gender":"male","year_std":"1年"]]],["name_university":"早大","num_of_person":"4","array":[["gender":"female","year_std":"3年"],["gender":"male","year_std":"2年"],["gender":"female","year_std":"2年"],["gender":"male","year_std":"1年"]]]]]
        return dict
    }
}
