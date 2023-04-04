//
//  newStickerDatamodel.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Foundation

struct newStickerDatamodel : Decodable {
    var message: String?
    var is_success: Bool?
    var item: NewSticker?
}

// MARK: - Item
struct NewSticker: Decodable{
    var stickers: [NewStickerlist]?
    
}

// MARK: - AllDone
struct NewStickerlist: Decodable {
    var sticker_no: Int?
    var name: String?
    var explanation: String?
    var term: String?
    var classify: String?
}
