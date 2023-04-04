//
//  pTypePopupVC.swift
//  Done
//
//  Created by 안현정 on 2022/04/04.
//

import UIKit

class pTypePopupVC: UIViewController {

    
    var fommetDate: String? = nil
    var fommetDate2: String? = nil
    var datefommet : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "PTypeTutorial")
        
        self.view.backgroundColor =  UIColor(red: 36.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.7)
    }
    
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changToDonelistBtn(_ sender: Any) {
        
        guard let presentingVC = self.presentingViewController as? UINavigationController else { return }
        self.dismiss(animated: true) {
            
            guard let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "DoneVC") as? DoneVC else {return}
            vcName.fommetDate = self.fommetDate
            vcName.fommetDate2 = self.fommetDate2
            vcName.date = self.datefommet
            presentingVC.pushViewController(vcName, animated: true)
        }
        
    }
}

