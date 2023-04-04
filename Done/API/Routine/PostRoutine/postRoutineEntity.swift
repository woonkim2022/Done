//
//  postRoutineEntity.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//

import Foundation


struct postRoutineEntity: Decodable {
    var message: String?
    var is_success : Bool?
    var item: AddRoutine?


}

// MARK: - Item
struct AddRoutine: Decodable {
    var routine_no: Int?
    
}



