//
//  JTypePopupVC.swift
//  Done
//
//  Created by 안현정 on 2022/04/04.
//

import UIKit

class JTypePopupVC: UIViewController {

    
    var fommetDate: String? = nil
    var fommetDate2: String? = nil
    var datefommet : String? = nil
    
    
    @IBOutlet weak var xmarkBtn: UIButton!
    @IBOutlet weak var morePlanBtn: UIButton!
    @IBOutlet weak var planTextBtn: yourButton!
    @IBOutlet weak var doneListbtn: yourButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor =  UIColor(red: 36.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.7)
        
        
        UserDefaults.standard.set(true, forKey: "jtypeTutorial")
        morePlanBtn.setUnderline()
    }
    
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changToPalnBtn(_ sender: Any) {
        guard let presentingVC = self.presentingViewController as? UINavigationController else { return }
        self.dismiss(animated: true) {
            
            guard let vcName = UIStoryboard(name: "PlanVC", bundle: nil).instantiateViewController(identifier: "PlanViewController") as? PlanViewController else {return}
        
            presentingVC.pushViewController(vcName, animated: true)
        }
        
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
