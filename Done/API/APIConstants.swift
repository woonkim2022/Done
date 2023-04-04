//
//  APIConstants.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import Foundation


struct APIConstants{
    static let baseURL = "https://done-prd.com"
    
    //로그인
    static let emailCheckURL = baseURL+"/api/auth/check-email"
    static let signupURL = baseURL+"/api/auth/signup"
    static let loginURL = baseURL+"/api/auth/login"
    static let passwordURL = baseURL+"/api/profile/password"

    //던리스트
    static let doneCreateURL = baseURL+"/api/dones"
    static let doneCountURL = baseURL+"/api/dones/count"
    static let todayRecordURL = baseURL+"/api/dones/today-record"
    
    //카테고리
    static let catagoryURL = baseURL+"/api/categories"
    
    //태그,루틴,플랜
    static let tagURL = baseURL+"/api/tags"
    static let routineURL = baseURL+"/api/routines"
    static let planURL = baseURL+"/api/plans"

    //마이페이지
    static let profileURL = baseURL+"/api/profile"
    static let profileTypeURL = baseURL+"/api/profile/type"
    static let forgotPWURL =  baseURL+"/api/auth/password"
    static let editNicknameURL =  baseURL+"/api/profile/nickname"
    static let typeURL =  baseURL+"/api/profile/type"
    
    //스티커
    static let stickerURL = baseURL+"/api/profile/stickers"
    static let allStickerURL = baseURL+"/api/stickers"
    static let newStickerURL = baseURL+"/api/stickers/new"

}


