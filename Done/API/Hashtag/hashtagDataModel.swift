//
//  hashtagDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/12.
//

import Foundation


// MARK: - hashtagDataModel

struct hashtagDataModel: Codable {
    let isSuccess: Bool
    let item: Tag
    
    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
        self.item = (try? values.decode(Tag.self, forKey: .item))!
        self.isSuccess = (try? values.decode(Bool.self, forKey: .isSuccess)) ?? false
   }
    
    enum CodingKeys: String, CodingKey {
        case item
        case isSuccess = "is_success"
    }
}

// MARK: - Item
struct Tag: Codable {
    let tags: [Taglist]
}

// MARK: - Tag
struct Taglist: Codable {
    let tagNo : Int?
    let category_no: Int?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case tagNo  = "tag_no"
        case category_no = "category_no"
        case name
    }
}
