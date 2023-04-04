//
//  RoutineCollectionViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/13.
//

import Foundation
import UIKit

class RoutineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var routineLb: UILabel!
    @IBOutlet weak var routineBackground: RoundedView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        routineBackground.backgroundColor =  UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
        
        //입력버튼 누른 후, 해시태그 컬러(블루) 다시 원상복구
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeBlueTag),
                                               name: NSNotification.Name(rawValue: "routinTagBlue"),
                                               object: nil)
    }
    
    @objc fileprivate func changeBlueTag() {
        unSelectTag()
        }
    
    
    func selectTag() {
        routineLb.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        routineBackground.backgroundColor =  UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
    }
    
    
    func unSelectTag() {
        routineLb.textColor = .white
        routineBackground.backgroundColor =  UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
    }
    

    
}
