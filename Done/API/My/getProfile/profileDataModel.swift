//
//  profileDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import Foundation

struct profileDataModel : Decodable {
    var is_success: Bool
    var item: Profile?
}

// MARK: - Profile

struct Profile: Decodable {
    var nickname: String?
    var level: Int?
    var level_message: String?
    var total_done_count: Int?
    var plan_achievement_rate: Int?
    var this_month_done_count: Int?
}
