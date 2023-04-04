//
//  CatagoryDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/19.
//

import Foundation

struct CatagoryDataModel: Codable  {
    let isSuccess: Bool
    let item: Category
    
    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
        self.item = (try? values.decode(Category.self, forKey: .item))!
        self.isSuccess = (try? values.decode(Bool.self, forKey: .isSuccess)) ?? false
   }
    
    enum CodingKeys: String, CodingKey {
        case item
        case isSuccess = "is_success"
    }
}

// MARK: - Item
struct Category: Codable  {
    let categories: [Categorylist]
}

// MARK: - Category
struct Categorylist: Codable  {
    let category_no: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case category_no = "category_no"
        case name
    }
}
