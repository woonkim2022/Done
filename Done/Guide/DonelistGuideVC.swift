//
//  DonelistGuideVC.swift
//  Done
//
//  Created by 안현정 on 2022/04/04.
//

import UIKit

class DonelistGuideVC: UIViewController {

    @IBOutlet weak var guideImageView: UIImageView!
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var btnTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "donelistTutorial")
        
        if UIDevice.current.isiPhoneSE2{
            topConstraints.constant = 20
             bottomConstraints.constant = -50
            leadingConstraints.constant = 0
          //  trailingConstraints.constant = 20
            guideImageView.contentMode = .scaleAspectFit
            btnTop.constant = 30

        }
        
        
        self.view.backgroundColor =  UIColor(red: 36.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.7)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
     }
 

}
