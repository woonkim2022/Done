//
//  MenuCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/10.
//

import UIKit
import PagingKit

class MenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    
    ///  The text color when selecred
    public var focusColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0) {
        didSet {
            if isSelected {
                titleLabel.textColor = focusColor
            }
        }
    }
    
    /// The normal text color.
    public var normalColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0){
        didSet {
            if !isSelected {
                titleLabel.textColor = normalColor
            }
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = focusColor
            } else {
                titleLabel.textColor = normalColor
            }
        }
    }
    
    
    
}
