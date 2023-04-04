//
//  donePlanDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/16.
//
import Foundation

struct donePlanDataModel: Decodable {
    var message: String?
    var is_success : Bool?
    var item: DONEPLAN?


}

// MARK: - Item
struct DONEPLAN: Decodable {
    var done_no: Int?
    

}
