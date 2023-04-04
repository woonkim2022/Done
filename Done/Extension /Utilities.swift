//
//  Utilities.swift
//  Done
//
//  Created by 안현정 on 2022/02/15.
//


import Foundation
import UIKit

class Utilities {
    
    
    
    static func errorTextField(_ textfield:UITextField) {

        // bottom line 만들기
        let bottomLine = CALayer()
        
        // bottom line 위치,크기 잡아주기
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        // bottom line 색상
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        // 텍스트필드 테두리라인 제거
        textfield.borderStyle = .none
        
        // 텍스트필드에 bottom line 추가
        textfield.layer.addSublayer(bottomLine)
    }
    
    
    
    static func defaultTextField(_ textfield:UITextField) {

        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    }
    
    
    
    static func highlightTextField(_ textfield:UITextField) {

        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    }
    
    


}
