//
//  ContractObj.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 1/19/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class ContractObj: NSObject {
    var mID:String = "-"
    var mContractorName:String = "-"
    var mLocation:String = "-"
    var mDurationTime:String = "-"
    var mAutomaticUpdate:String = "-"
    var mStartDate:String = "-"
    var mExpirationDate:String = "-"
    var mMonthlyPayment:String = "-"
    var mRent:String = "-"
    var mCommonService:String = "-"
    var mFee:String = "-"

    init (contractorName:String, location:String,
        durationTime:String, automaticUpdate: String,
        startDate:String, exprirationDate:String,
        monthlyPayment:String, rent:String,
        commonService:String, fee:String) {
        mContractorName = contractorName
        mLocation = location
        mDurationTime = durationTime
        mAutomaticUpdate = automaticUpdate
        mStartDate = startDate
        mExpirationDate = exprirationDate
        mMonthlyPayment = monthlyPayment
        mRent = rent
        mCommonService = commonService
        mFee = fee
    }

    init(dict:NSDictionary) {
        if let id = dict.object(forKey: "id") as? String {
            mID = id
        }
        if let contractorName = dict.object(forKey: "name") as? String {
            mContractorName = contractorName
        }
        if let zipcode = dict.object(forKey: "zipcode1") as? String {
            mLocation = zipcode
        }
        if let address = dict.object(forKey: "address") as? String {
            mLocation = mLocation + "\n" + address
        }
//        if let kabocha_building_name = dict.object(forKey: "mikata_building_name") as? String {
//            mLocation = mLocation + "\n" + kabocha_building_name
//        }
//        if let room_name = dict.object(forKey: "room_name") as? String {
//            mLocation = mLocation + " " + room_name + " 号室"
//        }
//        if let durationTime = dict.object(forKey: "contract_period") as? String {
//            mDurationTime = durationTime
//        }
//        if let automaticUpdate = dict.object(forKey: "is_updated") as? String {
//            mAutomaticUpdate = automaticUpdate
//        }
//        if let startDate = dict.object(forKey: "start_date") as? String {
//            mStartDate = GlobalMethod.getStringDateFromTime(time: Double(startDate)!*1000, with: "YYYY/MM/dd(水)")
//        }
//        if let exprirationDate = dict.object(forKey: "expire_date") as? String {
//            mExpirationDate = GlobalMethod.getStringDateFromTime(time: Double(exprirationDate)!*1000, with: "YYYY/MM/dd(水)")
//        }
//        if let monthlyPayment = dict.object(forKey: "payment_amount") as? String {
//
//            mMonthlyPayment = (Int(monthlyPayment)?.convertToStringDecimalFormat())! + NSLocalizedString("yen", comment: "")
//        }
//        if let rent = dict.object(forKey: "rent") as? String {
//            mRent = (Int(rent)?.convertToStringDecimalFormat())! + NSLocalizedString("yen", comment: "")
//        }
//        if let serviceFee = dict.object(forKey: "service_fee") as? String {
//            mCommonService = (Int(serviceFee)?.convertToStringDecimalFormat())! + NSLocalizedString("yen", comment: "")
//        }
//        if let fee = dict.object(forKey: "fee") as? String {
//            mFee = (Int(fee)?.convertToStringDecimalFormat())! + NSLocalizedString("yen", comment: "")
//        }
    }
}
