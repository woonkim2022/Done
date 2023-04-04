//
//  LogoutVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class LogoutVC: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor =  UIColor(red: 36.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.7)
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func logout(_ sender: Any) {
            UserDefaults.standard.set(false, forKey: "autologin")
            UserDefaults.standard.removeObject(forKey: "emailData") //제거
            UserDefaults.standard.removeObject(forKey: "signupPw") //제거
            UserDefaults.standard.removeObject(forKey: "pw") //제거
            UserDefaults.standard.set(false, forKey: "changeMainVC")

           let vcName = UIStoryboard(name: "LandingStoryboard ", bundle: nil).instantiateViewController(identifier: "LandingVC")
            changeRootViewController(vcName)
        }
    

    @IBAction func backButton(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
      }
    
    
    //MARK: - Helpers
 


}
