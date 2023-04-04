//
//  String.swift
//  Done
//
//  Created by 안현정 on 2022/02/16.
//

import Foundation

extension String {
    
 //MARK: - 이메일,비밀번호 regular expression 메서드
    
func isValidEmail() -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
}

//패스워드 regular expression
func isValidPassword() -> Bool {

    let regEx = "(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
    let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
    
    return pred.evaluate(with: self)
}
    
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var date: Date? {
        return String.dateFormatter.date(from: self)
    }

    var length: Int {
        return self.count
    }

}
