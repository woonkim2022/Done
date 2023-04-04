//
//  signupData.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import Foundation
import UIKit

struct emailCheckData {
    static var emailState = false
    static var email = ""
}


struct signupData {
    static var signupState = false
    static var email = ""
    static var pw = ""
}


struct loginData {
    static var loginState = false
    static var jwt = ""
    static var email = ""
    static var pw = ""
}

struct forgotEmailData {
    static var email = ""
}

struct editPasswordData {
    static var newPassword = ""
    static var passwordState = false
}



struct userInfoData {
    static var infoState = false
    static var nickname = ""
    static var type = ""
}


struct doneDateCount {
    static var dateCounts = 0

}
