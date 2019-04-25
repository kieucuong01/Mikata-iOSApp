//
//  ReproEventNames.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 10/14/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import Foundation

class ReproEvent {
    // Common event
    static let REPRO_ACTION_FAVORITE: String = "お気に入り追加"
    static let REPRO_ACTION_UNFAVORITE: String = "お気に入り外す"

    // Splash screen
    static let REPRO_SCREEN_SPLASH: String = "フラッシュ"


    // Introduction screen
    static let REPRO_SCREEN_INTRODUCTION: String = "チュートリアル"
    static let REPRO_SCREEN_INTRODUCTION_ACTION_SKIP: String = "SKIP チュートリアル"
    static let REPRO_SCREEN_INTRODUCTION_FINISH: String = "チュートリアル終了"
    static let REPRO_SCREEN_INTRODUCTION_FINISH_ACTION_START: String = "はじめる"


    // Signup screen
    static let REPRO_SCREEN_SIGNUP: String = "新規登録"
    static let REPRO_SCREEN_SIGNUP_ACTION_SHOW_PASSWORD: String = "パスワード表示"
    static let REPRO_SCREEN_SIGNUP_ACTION_HIDE_PASSWORD: String = "パスワード非表示"
    static let REPRO_SCREEN_SIGNUP_ACTION_CONFIRM: String = "確認する"
    static let REPRO_SCREEN_SIGNUP_ACTION_BACK_TO_LOGIN: String = "すでにアカウントを待ちの方はこちら"

    static let REPRO_SCREEN_SIGNUP_CONFIRM: String = "新規登録確認"
    static let REPRO_SCREEN_SIGNUP_CONFIRM_ACTION_OK: String = "OK"
    static let REPRO_SCREEN_SIGNUP_CONFIRM_ACTION_CANCEL: String = "キャンセル"

    static let REPRO_SCREEN_SIGNUP_SUCCESSFULL: String = "新規登録完了"
    static let REPRO_SCREEN_SIGNUP_SUCCESSFULL_ACTION_OK: String = "OK"


    // Login screen
    static let REPRO_SCREEN_LOGIN: String = "ログイン"
    static let REPRO_SCREEN_LOGIN_ACTION_SHOW_PASSWORD: String = "パスワード表示"
    static let REPRO_SCREEN_LOGIN_ACTION_HIDE_PASSWORD: String = "パスワード非表示"
    static let REPRO_SCREEN_LOGIN_ACTION_FORGET_PASSWORD: String = "パスワードを忘れた方はこちら"
    static let REPRO_SCREEN_LOGIN_ACTION_LOGIN: String = "ログイン"
    static let REPRO_SCREEN_LOGIN_ACTION_SIGNIN: String = "新規登録"
    static let REPRO_SCREEN_LOGIN_ACTION_SHOW_TERM: String = "利用規約"


    // Forget password
    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_MAIL: String = "パスワード再発行"
    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_MAIL_ACTION_SEND: String = "送信"

    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_CODE: String = "パスワード再発行コード入力"
    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_CODE_ACTION_NEXT: String = "次へ"

    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD: String =
    "パスワード再発行新しいパスワード入力"
    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD_ACTION_SHOW_PASSWORD: String = "パスワード表示"
    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD_ACTION_HIDE_PASSWORD: String = "パスワード非表示"
    static let REPRO_SCREEN_FORGET_PASSWORD_INPUT_NEW_PASSWORD_ACTION_SEND: String = "送信"


    // Skill check
    static let REPRO_SCREEN_SKILL_CHECK_PAGE_1: String = "スキルチェック１"
    static let REPRO_SCREEN_SKILL_CHECK_PAGE_2: String = "スキルチェック２"
    static let REPRO_SCREEN_SKILL_CHECK_ACTION_HELP: String = "スキルチェックヘルプ"
    static let REPRO_SCREEN_SKILL_CHECK_ACTION_FORWARD: String = "戻る"
    static let REPRO_SCREEN_SKILL_CHECK_ACTION_NEXT: String = "次へ"
    static let REPRO_SCREEN_SKILL_CHECK_ACTION_DONE: String = "完了"


    // Timeline
    static let REPRO_SCREEN_TIMELINE: String = "タイムライン"

    // Point earn
    static let REPRO_SCREEN_POINT_EARN: String = "ポイント獲得"
    static let REPRO_SCREEN_POINT_EARN_TAB_ALL: String = "ポイント獲得・すべて"
    static let REPRO_SCREEN_POINT_EARN_TAB_INCOMPLETE: String = "ポイント獲得・未完了"
    static let REPRO_SCREEN_POINT_EARN_TAB_WAITING: String = "ポイント獲得・判定待ち"

    static let REPRO_SCREEN_POINT_EARN_ACTION_TAB_ALL: String = "すべて"
    static let REPRO_SCREEN_POINT_EARN_ACTION_TAB_INCOMPLETE: String = "未完了"
    static let REPRO_SCREEN_POINT_EARN_ACTION_TAB_WAITING: String = "判定待ち"


    // Point earn detail
    static let REPRO_SCREEN_POINT_EARN_DETAIL: String = "ポイント獲得詳細"

    static let REPRO_SCREEN_POINT_EARN_DETAIL_ACTION_START_NEWS: String = "ポイントGET"
    static let REPRO_SCREEN_POINT_EARN_DETAIL_ACTION_START_SURVEY: String = "回答する"
    static let REPRO_SCREEN_POINT_EARN_DETAIL_ACTION_START_CAPTURE: String = "撮影する"


    // Point exchange
    static let REPRO_SCREEN_POINT_EXCHANGE: String = "ポイント交換"
    static let REPRO_SCREEN_POINT_EXCHANGE_TAB_ALL: String = "ポイント交換・すべて"
    static let REPRO_SCREEN_POINT_EXCHANGE_TAB_FAVORITE: String = "ポイント交換・お気に入り"
    static let REPRO_SCREEN_POINT_EXCHANGE_TAB_EXCHANGED: String = "ポイント交換・交換済み"

    static let REPRO_SCREEN_POINT_EXCHANGE_ACTION_TAB_ALL: String = "すべて"
    static let REPRO_SCREEN_POINT_EXCHANGE_ACTION_TAB_FAVORITE: String = "お気に入り"
    static let REPRO_SCREEN_POINT_EXCHANGE_ACTION_TAB_EXCHANGED: String = "応募済み"

    static let REPRO_SCREEN_POINT_EXCHANGE_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_POINT_EXCHANGE_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE


    // Point exchange detail
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL: String = "ポイント交換詳細"

    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_ACTION_EXCHANGE: String = "交換する"

    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT: String = "ポイントが足りません"
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_NOT_ENOUGH_POINT_ACTION_GO_TO_GET_POINT: String = "ポイント獲得へ"

    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM: String = "アイテム交換確認"
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM_ACTION_ACCEPT: String = "決定"
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_CONFIRM_ACTION_CANCEL: String = "キャンセル"

    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_SUCCESSFULL: String = "手続き完了"
    static let REPRO_SCREEN_POINT_EXCHANGE_DETAIL_POPUP_EXCHANGE_SUCCESSFULL_ACTION_GO_TO_POINT_EXCHANGE: String = "ポイント交換TOPへ"


    // Job introduction
    static let REPRO_SCREEN_JOB_INTRODUCTION: String = "イベント"
    static let REPRO_SCREEN_JOB_INTRODUCTION_TAB_ALL: String = "イベント・すべて"
    static let REPRO_SCREEN_JOB_INTRODUCTION_TAB_FAVORITE: String = "イベント・お気に入り"
    static let REPRO_SCREEN_JOB_INTRODUCTION_TAB_APPLY: String = "イベント・応募済み"

    static let REPRO_SCREEN_JOB_INTRODUCTION_ACTION_TAB_ALL: String = "すべて"
    static let REPRO_SCREEN_JOB_INTRODUCTION_ACTION_TAB_FAVORITE: String = "お気に入り"
    static let REPRO_SCREEN_JOB_INTRODUCTION_ACTION_TAB_APPLY: String = "応募済み"

    static let REPRO_SCREEN_JOB_INTRODUCTION_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_JOB_INTRODUCTION_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE
    static let REPRO_SCREEN_JOB_INTRODUCTION_ACTION_FILTER: String = "絞り込み"


    // Job introduction filter
    static let REPRO_SCREEN_JOB_INTRODUCTION_FILTER: String = "イベント・絞り込み"
    static let REPRO_SCREEN_JOB_INTRODUCTION_FILTER_ACTION_CHOOSE_ALL: String = "すべて"
    static let REPRO_SCREEN_JOB_INTRODUCTION_FILTER_ACTION_CHOOSE_AREA: String = "地域"
    static let REPRO_SCREEN_JOB_INTRODUCTION_FILTER_ACTION_CHOOSE_CATEGORY: String = "業種"


    // Job introduction detail
    static let REPRO_SCREEN_JOB_INTRODUCTION_DETAIL: String = "イベント詳細"

    static let REPRO_SCREEN_JOB_INTRODUCTION_DETAIL_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_JOB_INTRODUCTION_DETAIL_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE
    static let REPRO_SCREEN_JOB_INTRODUCTION_DETAIL_ACTION_APPLY: String = "応募する"


    // Note
    static let REPRO_SCREEN_NOTE_TAB_ALL: String = "住人ノート・すべて"
    static let REPRO_SCREEN_NOTE_TAB_FAVORITE: String = "住人ノート・お気に入り"
    static let REPRO_SCREEN_NOTE_TAB_MY_NOTE: String = "住人ノート・自分の投稿・ノート"
    static let REPRO_SCREEN_NOTE_TAB_MY_COMMENT: String = "住人ノート・自分の投稿・コメント"

    static let REPRO_SCREEN_NOTE_ACTION_TAB_ALL: String = "すべて"
    static let REPRO_SCREEN_NOTE_ACTION_TAB_FAVORITE: String = "お気に入り"
    static let REPRO_SCREEN_NOTE_ACTION_TAB_MY_NOTE_AND_COMMENT: String = "自部の投稿"
    static let REPRO_SCREEN_NOTE_ACTION_TAB_MY_NOTE: String = "ノート"
    static let REPRO_SCREEN_NOTE_ACTION_TAB_MY_COMMENT: String = "コメント"


    static let REPRO_SCREEN_NOTE_ACTION_FILTER: String = "絞り込み"
    static let REPRO_SCREEN_NOTE_ACTION_ADD_NOTE: String = "ノート作成"
    static let REPRO_SCREEN_NOTE_ACTION_DELETE_MY_NOTE: String = "削除"
    static let REPRO_SCREEN_NOTE_ACTION_DELETE_MY_COMMENT: String = "削除"


    // Note detail
    static let REPRO_SCREEN_NOTE_DETAIL: String = "住人ノート詳細"

    static let REPRO_SCREEN_NOTE_DETAIL_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_NOTE_DETAIL_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE
    static let REPRO_SCREEN_NOTE_DETAIL_ACTION_ADD_COMMENT: String = "コメントする"


    // Add note
    static let REPRO_SCREEN_ADD_NOTE: String = "新規ノート作成"

    static let REPRO_SCREEN_ADD_NOTE_ACTION_CHOOSE_RANGE_ALL: String = "全体"
    static let REPRO_SCREEN_ADD_NOTE_ACTION_CHOOSE_RANGE_BUILDING_LIMIT: String = "建物限定"
    static let REPRO_SCREEN_ADD_NOTE_ACTION_CREATE: String = "作成する"


    // Add note comment
    static let REPRO_SCREEN_ADD_NOTE_COMMENT: String = "コメント作成"

    static let REPRO_SCREEN_ADD_NOTE_COMMENT_ACTION_COMMENT: String = "コメントする"
    static let REPRO_SCREEN_ADD_NOTE_COMMENT_ACTION_CHOOSE_GALLERY: String = "写真選択"
    static let REPRO_SCREEN_ADD_NOTE_COMMENT_ACTION_CAPTURE: String = "写真撮る"

    static let REPRO_SCREEN_ADD_NOTE_COMMENT_SUCCESSFULL: String = "コメント完了"


    // Add new chat
    static let REPRO_SCREEN_ADD_NEW_CONSULTATION: String = "チャット相談"

    static let REPRO_SCREEN_ADD_NEW_CONSULTATION_ACTION_CHOOSE_JOB: String = "お仕事のこと"
    static let REPRO_SCREEN_ADD_NEW_CONSULTATION_ACTION_CHOOSE_HOUSE: String = "お家のこと"


    // Alert
    static let REPRO_SCREEN_ALERT: String = "お知らせ"
    static let REPRO_SCREEN_ALERT_TAB_ALL: String = "お知らせ・すべて"
    static let REPRO_SCREEN_ALERT_TAB_UNREAD: String = "お知らせ・未読"
    static let REPRO_SCREEN_ALERT_TAB_READ: String = "お知らせ・既読"

    static let REPRO_SCREEN_ALERT_ACTION_TAB_ALL: String = "すべて"
    static let REPRO_SCREEN_ALERT_ACTION_TAB_UNREAD: String = "未読"
    static let REPRO_SCREEN_ALERT_ACTION_TAB_READ: String = "既読"

    // Alert detail
    static let REPRO_SCREEN_ALERT_DETAIL: String = "お知らせ詳細"

    // My page
    static let REPRO_SCREEN_MY_PAGE: String = "マイページ"

    static let REPRO_SCREEN_MY_PAGE_ACTION_EDIT_PROFILE: String = "プロフィール編集"
    static let REPRO_SCREEN_MY_PAGE_ACTION_GO_POINT_EARN: String = "ポイント獲得"
    static let REPRO_SCREEN_MY_PAGE_ACTION_GO_POINT_EXCHANGE: String = "ポイント交換"
    static let REPRO_SCREEN_MY_PAGE_ACTION_GO_BYTE: String = "バイト"
    static let REPRO_SCREEN_MY_PAGE_ACTION_GO_JOB_INTRODUCTION: String = "イベント"
    static let REPRO_SCREEN_MY_PAGE_ACTION_GO_NOTE: String = "住人ノート"
    static let REPRO_SCREEN_MY_PAGE_ACTION_GO_MY_SKILL: String = "MYスキル"


    // Profile edit
    static let REPRO_SCREEN_PROFILE_EDIT: String = "プロフィール"

    static let REPRO_SCREEN_PROFILE_EDIT_ACTION_CHANGE_ICON: String = "アイコン変更"
    static let REPRO_SCREEN_PROFILE_EDIT_ACTION_CANCEL: String = "キャンセル"
    static let REPRO_SCREEN_PROFILE_EDIT_ACTION_SAVE: String = "保存"


    // Profile edit - popup change icon
    static let REPRO_SCREEN_PROFILE_EDIT_POPUP_CHANGE_ICON: String = "アイコン選択"
    static let REPRO_SCREEN_PROFILE_EDIT_POPUP_CHANGE_ICON_ACTION_CLOSE: String = "閉じる"


    // My skill
    static let REPRO_SCREEN_MY_SKILL: String = "マイスキル"

    static let REPRO_SCREEN_MY_SKILL_ACTION_EDIT: String = "編集"
    static let REPRO_SCREEN_MY_SKILL_ACTION_NEXT: String = "次へ"
    static let REPRO_SCREEN_MY_SKILL_ACTION_FORWARD: String = "戻る"


    // Setting menu
    static let REPRO_SCREEN_SETTING_MENU: String = "設定"

    static let REPRO_SCREEN_SETTING_MENU_ACTION_GO_TERM: String = "利用規約"
    static let REPRO_SCREEN_SETTING_MENU_ACTION_GO_PRIVACY: String = "プライバシーポリシー"
    static let REPRO_SCREEN_SETTING_MENU_ACTION_GO_FAQ: String = "FAQ"
    static let REPRO_SCREEN_SETTING_MENU_ACTION_LOGOUT: String = "ログアウト"


    // Term
    static let REPRO_SCREEN_TERM: String = "利用規約"

    // Privacy
    static let REPRO_SCREEN_PRIVACY: String = "プライバシーポリシー"

    // FAQ
    static let REPRO_SCREEN_FAQ: String = "FAQ"

    // Logout
    static let REPRO_SCREEN_LOGOUT_CONFIRM: String = "ログアウト確認"

    static let REPRO_SCREEN_LOGOUT_ACTION_OK: String = "OK"
    static let REPRO_SCREEN_LOGOUT_ACTION_CANCEL: String = "キャンセル"

    static let REPRO_SCREEN_LOGOUT_SUCCESSFULL: String = "ログアウトした"


    // Point passbook
    static let REPRO_SCREEN_POINT_PASSBOOK: String = "ポイント通帳"
    static let REPRO_SCREEN_POINT_PASSBOOK_ACTION_EXCHANGE_POINT: String = "ポイント交換する"


    // Loading
    static let REPRO_SCREEN_LOADING: String = "ローディング"


    // Photo detail
    static let REPRO_SCREEN_PHOTO_DETAIL: String = "写真詳細"


    // Byte
    static let REPRO_SCREEN_BYTE: String = "バイト"
    static let REPRO_SCREEN_BYTE_TAB_ALL: String = "バイト・すべて"
    static let REPRO_SCREEN_BYTE_TAB_FAVORITE: String = "バイト・お気に入り"
    static let REPRO_SCREEN_BYTE_TAB_APPLY: String = "バイト・応募済み"

    static let REPRO_SCREEN_BYTE_ACTION_TAB_ALL: String = "すべて"
    static let REPRO_SCREEN_BYTE_ACTION_TAB_FAVORITE: String = "お気に入り"
    static let REPRO_SCREEN_BYTE_ACTION_TAB_APPLY: String = "応募済み"
    static let REPRO_SCREEN_BYTE_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_BYTE_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE
    static let REPRO_SCREEN_BYTE_ACTION_FILTER: String = "絞り込み"
    
    
    // Byte detail
    static let REPRO_SCREEN_BYTE_DETAIL: String = "バイト詳細"
    static let REPRO_SCREEN_BYTE_DETAIL_ACTION_FAVORITE: String = ReproEvent.REPRO_ACTION_FAVORITE
    static let REPRO_SCREEN_BYTE_DETAIL_ACTION_UNFAVORITE: String = ReproEvent.REPRO_ACTION_UNFAVORITE
    static let REPRO_SCREEN_BYTE_DETAIL_ACTION_ACCEPT: String = "応募する"

    // FORM JOB
    static let REPRO_SCREEN_FORM_JOB: String = "応募フォーム"
    static let REPRO_SCREEN_FORM_JOB_ACTION_UNFAVORITE: String = "応募フォーム"
    static let REPRO_SCREEN_FORM_JOB_ACTION_CONFIRM: String = "確認画面へ"

    // JOB CONFIRM
    static let REPRO_SCREEN_JOB_CONFIRM: String = "応募フォーム"
    static let REPRO_SCREEN_JOB_CONFIRM_ACTION_CANCEL: String = "キャンセル"
    static let REPRO_SCREEN_JOB_CONFIRM_ACTION_SEND: String = "送信"

    // JOB DONE
    static let REPRO_SCREEN_JOB_DONE: String = "応募完了"
    static let REPRO_SCREEN_JOB_DONE_ACTION_GO_TOP: String = "イベントTOPへ"
    static let REPRO_SCREEN_JOB_BYTE_DONE_ACTION_GO_TOP: String = "バイトTOPへ"

    // TAB CHAT
    static let REPRO_SCREEN_TAB_CHAT: String = "メッセージ一覧"

    // CHAT HOUSE
    static let REPRO_SCREEN_CHAT_HOUSE: String = "お家相談"
    static let REPRO_SCREEN_CHAT_HOUSE_ACTION_CAMERA: String = "カメラ"
    static let REPRO_SCREEN_CHAT_HOUSE_ACTION_GALLERY: String = "写真選択"
    static let REPRO_SCREEN_CHAT_HOUSE_ACTION_SEND: String = "送信"

    // CHAT JOB
    static let REPRO_SCREEN_CHAT_JOB: String = "お仕事相談"
    static let REPRO_SCREEN_CHAT_JOB_ACTION_CAMERA: String = "カメラ"
    static let REPRO_SCREEN_CHAT_JOB_ACTION_GALLERY: String = "写真選択"
    static let REPRO_SCREEN_CHAT_JOB_ACTION_SEND: String = "送信"

    static let REPRO_SCREEN_POPUP_USER: String = "スタッフとチャット確認"
    static let REPRO_SCREEN_POPUP_USER_ACTION_SEND_MESSAGE: String = "メッセージを送る"
}
