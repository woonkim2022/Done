//
//  emailCheckEntity.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import Foundation

struct emailCheckEntity: Decodable {
    var message: String?
    var is_success : Bool?
}

struct signupEntity: Decodable {
    var message: String?
    var is_success : Bool?
}
