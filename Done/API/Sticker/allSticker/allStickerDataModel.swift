//
//  allStickerDataModel.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import Foundation

struct allStickerDataModel : Decodable {
    var item: allSticker?
    var is_success: Bool?
}

// MARK: - Item
struct allSticker: Decodable{
    var stickers: [allStickerList]?
    
}

// MARK: - AllDone
struct allStickerList: Decodable {
    var sticker_no: Int?
    var name: String?
    var explanation: String?
    var term: String?
    var classify: String?
}
