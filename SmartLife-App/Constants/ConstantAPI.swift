//
//  ConstantAPI.swift
//  SmartTablet
//
//  Created by thanhlt on 7/17/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import Foundation

#if STAGING
    let APP_BASE_URL = "http://va21.ocdev.me/api/public/"
    let FIREBASE_SERVER_KEY = "key=AAAAtYR5XIA:APA91bEGVSuPLGW_WJArSDqhLnO4avPf_CE3R53I_GRQD_FSvPnI6SbTIx03L0KgAbNO2QqFGdTPV7KsaC06JP3BkW9Dd2ctFsywAowNR_lOP4ySh3O8jJJYcmwZsC03CTFlHnYIFhEv"
#else
    let APP_BASE_URL = "https://mikata.smart-campus.jp/api/public/"
    let FIREBASE_SERVER_KEY = "key=AAAALZxXeaQ:APA91bFpcz973E9nJm5XH8Ud1nC9epb_IcH-lMmCckdB5hjmV0RsBg-X1HNuG9YhWoMNf5i14cnH19VNjs-ptLf0XubYHA9Uu5xWtmjBUMfAU1QqvXRVj2VX25kG-yJgpeBxFXCbwJvd"
#endif

let API_GET_ADD_UPDATE_USER         = "users/addupdate"
let API_GET_LOGIN                   = "users/login"
let API_GET_LOGIN_MIKATA            = "usertmps/login"
let API_GET_REGISTER_MIKATA         = "usertmps/register"
let API_GET_USER_VALIDATE           = "users/validateuser"

let API_GET_TIMELINE                = "mobile/timelines"
let API_GET_POINTWORKS              = "pointworks/all"
let API_GET_POINTWORKS_ACTION_LOGS  = "userspointworksactionlogs/addupdate"
let API_POINTWORKS_UPLOAD_IMAGE     = "pointworks/uploadimage"
let API_GET_POINTITEMS              = "pointitems/search"
let API_GET_POINTITEM_DETAIL        = "pointitems/detail"
let API_GET_EXCHANGED_POINTITEMS    = "userboughtitems/all"
let API_GET_EXCHANGED_POINTITEM_DETAIL = "userboughtitems/detail"
let API_GET_JOBLIST                 = "jobs/all"
let API_GET_JOBDETAIL               = "jobs/detail"
let API_GET_JOBCATEGORY             = "jobcategories/all"

let API_GET_BYTELIST                = "works/all"
let API_GET_BYTEDETAIL              = "works/detail"
let API_GET_BYTECATEGORY            = "workcategories/all"

//let API_GET_NOTEPOST_LISTPOST       = "noteposts/listpost"
let API_GET_NOTEPOST_LISTPOST           = "notes/all"
let API_GET_NOTEPOST_LISTFAVORITE       = "notes/listfavorite"
let API_GET_NOTEPOST_LISTNOTECOMMENT    = "notes/listnotecomment"
let API_GET_NOTEDETAIL                  = "notes/detail"
let API_ADD_NOTE                        = "notes/addupdate"
let API_ADD_NOTE_COMMENT                = "sm/notecomments/addupdate"
let API_DELETE_NOTE                     = "notes/removenote"
let API_DELETE_NOTE_COMMENT             = "sm/notecomments/removecomment"

let API_GET_KABOCHA_ALL             = "mikatabuildings/all"

let API_GET_MYSKILL_ALL         =   "skills/all"
let API_GET_MY_PAGE_SKILL_ALL   =   "users/mypages"
let API_UPDATE_SKILL_USER       =   "userskills/add"
let API_GET_LIST_AVATAR_ICON    =   "configdefaulticons/all"
let API_UPDATE_AVATAR_ICON      =   "users/updateavatar"
let API_GET_USER_PROFILES       =   "users/profile"
let API_GET_USER_TERM           =   "useterms/page"
let API_GET_PRIVACY_POLICY      =   "privatepolicy/page"

let API_USER_BOUGHT_ITEM_UPDATE = "userboughtitems/addupdate"
let API_USER_GET_FAQ = "faqs/all"
let API_UNREGISTER_PUSH = "userdevices/unregister"
let API_REGISTER_PUSH = "userdevices/register"

let API_FAVORITE_POINT_ITEM = "pointitemfavorites/add"
let API_FAVORITE_USER_WORK = "userworkfavorites/addupdate"
let API_FAVORITE_BYTES = "userworkfavorites/addupdate"
let API_FAVORITE_JOBS = "jobfavorites/addupdate"
let API_FAVORITE_NOTES = "sm/notefavorites/addupdate"
let API_FAVORITE_TIMELINE = "timelinefavorites/addupdate"

let API_GET_NOTIFICATIONS           = "usernotifications/all"
let API_SET_READ_NOTIFICATIONS      = "usernotificationreads/addupdate"

let API_GET_POINT_HISTORY           = "userpointlogs/monthlog"
let API_USER_FORGETPASSWORD         = "users/forgetpassword"
let API_USER_ACTIVATION             = "useractivations/check"
let API_USER_UPDATE_PASSWORD        = "users/updatepassword"
let API_USER_TOTAL_USER_BY_BUILDING = "users/totaluserbybuilding"

let API_APPLY_JOB = "jobapplylogs/addupdate"
let API_APPLY_JOB_BYE = "workapplylogs/addupdate"

let API_CHAT_UPLOAD_IMAGE = "chatimages/addupdate"
let API_GET_CHAT_TIME_OUT = "chattimeouts/chattimeconfig"

let API_GET_DOOR_INFOMATION = "users/keywecheckavailablekey"

// MARK: - API Constant

final class APIGlobal {
    // MARK: - ReplyAIService server
    static let replyAIServiceServer: String = "https://api.repl-ai.jp/v1/"
    static var replyAIServiceAPIKey: String = "DAJ26NL6Kh3FsfDUMXNl22EDSjgH6xsdPFpJJ5r3"
    static var replyAIServiceAPIBotId: String = "b4gttwc2zyoows1"
    static var replyAIServiceTopicGreetingId: String = "s4guo2db9hp2cx2"
    static var replyAIServiceTopicTopic2Id: String = "s4gyqvisikt8gl2"

    // MARK: - FundaNote List API
    static let replyAIServiceAPIRegistration: String = APIGlobal.replyAIServiceServer + "registration"
    static let replyAIServiceAPIDialogue: String = APIGlobal.replyAIServiceServer + "dialogue"

    // MARK: - Firebase API
    static let chatAPISendNotification: String = "https://fcm.googleapis.com/fcm/send"
}
