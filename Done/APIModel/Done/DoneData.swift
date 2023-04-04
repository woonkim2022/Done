//
//  Done.swift
//  Done
//
//  Created by 안현정 on 2022/03/02.
//

import Foundation


struct doneCreateData {
    static var content = ""
    static var date = ""
    static var category_no = 1
    static var tag_no = 1
    static var routine_no = 1
}



struct doneData {
    let content: String
  //  let date : String
   // let category_no: Int
        init(content: String) {
           self.content = content
           //self.date = date
         //  self.category_no = category_no
       }
}


//let tag_no: Int
//let routine_no: Int
//
