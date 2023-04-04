//
//  Segue.swift
//  Done
//
//  Created by 안현정 on 2022/02/15.
//


import UIKit

class NewSegue: UIStoryboardSegue {
    
   override func perform () {
       let srcUVC = self.source
       let destUVC = self.destination
       
       UIView.transition(from: srcUVC.view, to: destUVC.view, duration: 0.4, options: .transitionCrossDissolve)
   }
}
