//
//  readPlanDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import Foundation

// MARK: - readPlanDataModel

struct readPlanDataModel: Codable {
    let isSuccess: Bool
    let item: Plan
    
    enum CodingKeys: String, CodingKey {
        case item
        case isSuccess = "is_success"
    }
}

// MARK: - Item
struct Plan: Codable {
    let plans: [PlanList]
}

// MARK: - Plan
struct PlanList: Codable {
    var plan_no: Int
    let content: String
    let category_no: Int?

    enum CodingKeys: String, CodingKey {
        case plan_no = "plan_no"
        case content
        case category_no = "category_no"
    }
}
