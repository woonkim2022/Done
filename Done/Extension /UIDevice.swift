//
//  UIDevice.swift
//  Done
//
//  Created by 안현정 on 2022/04/03.
//

import UIKit

extension UIDevice {
    
    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 568 && UIScreen.main.bounds.size.width == 320) {
            return true
        }
        return false
    }
    
    public var isiPhoneSE2: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 667 && UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }
    
    public var isiPhone8Plus: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 736 || UIScreen.main.bounds.size.width == 414) {
            return true
        }
        return false
    }
    
    public var isiPhone12mini: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 812 && UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }
    
    public var isiPone12Pro: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && (UIScreen.main.bounds.size.height == 2532 && UIScreen.main.bounds.size.width == 390) {
            return true
        }
        return false
    }
}
