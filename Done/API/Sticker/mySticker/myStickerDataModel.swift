//
//  myStickerDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/29.
//

import Foundation


struct myStickerDataModel : Decodable {
    var message: String?
    var is_success: Bool?
    var item: MySticker?
}

// MARK: - Item
struct MySticker: Decodable{
    var stickers: [MyStickerlist]?
    
}

// MARK: - AllDone
struct MyStickerlist: Decodable {
    var sticker_no: Int?
    var name: String?
    var explanation: String?
    var term: String?
    var classify: String?
}
