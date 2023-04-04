//
//  todayRecordEntity.swift
//  Done
//
//  Created by 안현정 on 2022/03/28.
//

import Foundation

struct todayRecordEntity: Decodable  {
    var is_success: Bool?
    var message: Bool?
    var item: TodayNo?
}

// MARK: - Item
struct TodayNo: Decodable   {
    var today_no: Int?
}

