//
//  LoginEntity.swift
//  Done
//
//  Created by 안현정 on 2022/02/23.
//

import Foundation

struct loginEntity: Decodable {
    var message: String?
    var is_success : Bool?
    var item : LoginResult?
}

struct LoginResult: Decodable {
    var access_token : String?
}
