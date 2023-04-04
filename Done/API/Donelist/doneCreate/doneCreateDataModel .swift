//
//  doneCreateDataModel .swift
//  Done
//
//  Created by 안현정 on 2022/03/05.
//

import Foundation

// Datamodel 만들어주기

struct doneCreateDataModel : Encodable {

    let content: String?
    let date: String?
    let category_no: Int?
    let tag_no: Int?
    let routine_no : Int?
    
    
}
