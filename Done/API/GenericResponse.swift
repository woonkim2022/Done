////
////  GenericResponse.swift
////  Done
////
////  Created by 안현정 on 2022/03/06.
////
////
//
import Foundation

struct GenericResponse<T: Codable>: Codable {
    var status: Int
    var is_success: Bool
    var message: String
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case is_success = "is_success"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        is_success = (try? values.decode(Bool.self, forKey: .is_success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        
    }
    
    
}
