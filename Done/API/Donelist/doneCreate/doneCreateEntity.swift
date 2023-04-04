//
//  doneCreateEntity.swift
//  Done
//
//  Created by 안현정 on 2022/03/05.
//

import Foundation

struct doneCreateEntity: Decodable  {
    var is_success: Bool?
    var message: Bool?
    var item: DoneNo?
}

// MARK: - Item
struct DoneNo: Decodable   {
    var done_no: Int?
}

