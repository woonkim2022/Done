// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let donelistddd = try? newJSONDecoder().decode(Donelistddd.self, from: jsonData)

import Foundation


// MARK: - Welcome
struct donelistDataModel : Decodable {
    var message: String?
    var is_success: Bool?
    var item: Item?
}

// MARK: - Item
struct Item: Decodable{
    var all_dones: [AllDone]?
}

// MARK: - AllDone
struct AllDone: Decodable {
    var date: String?
    var dones: [Done]?
    var today_record: TodayRecord?
}

// MARK: - Done
struct Done : Decodable{
    var done_no: Int?
    var content: String?
    var category_no: Int?
    var tag_no: Int?
    var routine_no: Int?
}

// MARK: - TodayRecord
struct TodayRecord: Decodable {
    var today_no: Int?
    var content: String?
    var sticker_no: Int?
}





