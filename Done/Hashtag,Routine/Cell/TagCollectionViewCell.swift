//
//  TagCollectionViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/12.


import Foundation
import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var tagBackground: RoundedView!
    @IBOutlet weak var tagBtn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagBackground.backgroundColor =  UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
    
        //입력버튼 누른 후, 해시태그 컬러(블루) 다시 원상복구
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeBlueTag),
                                               name: NSNotification.Name(rawValue: "changeToBlue"),
                                               object: nil)
        
    }

    func selectTag() {
        tagBtn.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        tagBackground.backgroundColor =  UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
    }
        
    
    func unSelectTag() {
        tagBtn.textColor = .white
        tagBackground.backgroundColor =  UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
    }
       
    
    @objc fileprivate func changeBlueTag() {
        unSelectTag()
        }
    
    }

  
