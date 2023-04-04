//
//  doneCountDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/09.
//

import Foundation

struct doneCountDataModel: Codable {
    let is_success: Bool?
    let item: Count?
    
    enum CodingKeys: String, CodingKey {
        case is_success = "is_success"
        case item
    }
}

struct Count: Codable {
    let total_count: Int?
    let date_details: [DateDetail]?
    
    enum CodingKeys: String, CodingKey {
        case total_count = "total_count"
        case date_details
    }

}

struct DateDetail: Codable {
    let date: String?
    let count: Int?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case count = "count"
    }

}
