//
//  routineDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/13.
//


import Foundation

// MARK: - Donelistddd
struct routineDataModel: Codable {
    let isSuccess: Bool
    let message : String
    let item: Routine


    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
        self.item = (try? values.decode(Routine.self, forKey: .item))!
        self.isSuccess = (try? values.decode(Bool.self, forKey: .isSuccess)) ?? false
        self.message = (try? values.decode(String.self, forKey: .message)) ?? ""
   }
    
    enum CodingKeys: String, CodingKey {
        case item
        case isSuccess = "is_success"
        case message = "message"
    }
}

// MARK: - Item
struct Routine: Codable {
    let routines: [RoutineList]
}

// MARK: - Routine
struct RoutineList: Codable {
    let content: String
    let routine_no: Int
    let category_no: Int?

    enum CodingKeys: String, CodingKey {
        case content
        case routine_no = "routine_no"
        case category_no = "category_no"
    }
}

