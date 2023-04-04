//
//  getTypeDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Foundation

struct getTypeDataModel : Decodable {
    var is_success: Bool
    var item: UserType?
}

// MARK: - Profile

struct UserType: Decodable {
    var type: String?
}
