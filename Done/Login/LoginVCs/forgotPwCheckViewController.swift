//
//  forgotPwCheckViewController.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import UIKit

class forgotPwCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backToLoginVC(_ sender: UIButton) {
    guard let vcName = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(identifier: "emailVC") as? emailVC else {return}
     self.navigationController?.pushViewController(vcName, animated: true)
    }
}
