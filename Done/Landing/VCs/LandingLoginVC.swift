//
//  LandingLoginVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/15.
//

import UIKit
import SnapKit
import SafariServices

class LandingLoginVC: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    @IBOutlet weak var loginBtnStack: UIStackView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var appleLoginBtn: UIButton!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var TermsofUseBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    
    let deviceBound = UIScreen.main.bounds.height/812.0
    @IBOutlet weak var containViewHeight: NSLayoutConstraint!
    //let logoImage = UIImageView()
    
    //색상 프로퍼티
    let yellow = UIColor(named: "KakaoYellow")
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "emailData") //제거
        setUpBtn()
        setConstraints()
    }
    
    //MARK: - Actions
    
    @IBAction func changToLoginBtn(_ sender: Any) {
        guard let vcName = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(identifier: "emailVC") as? emailVC else {return}
        
        self.navigationController?.pushViewController(vcName, animated: true)
    }
    
    @IBAction func termofuseClicked(_ sender: Any) {
        let url = NSURL(string: "https://spark-myth-3c9.notion.site/f7c405f9a9a644a8964ad6046530d08f")
        let blogSafariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
        self.present(blogSafariView, animated: true, completion: nil)
    }
    
    
    @IBAction func privacyClicked(_ sender: Any) {
        let url = NSURL(string: "https://spark-myth-3c9.notion.site/95812922d5cc4f9aa47f32936f5e9919")
        let blogSafariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
        self.present(blogSafariView, animated: true, completion: nil)
    }
    
    
  
    //MARK: - Helpers
    
    func setConstraints(){
        containViewHeight.constant = 340*deviceBound
        
        var text:String = "시작하기 버튼 클릭 시\n"
        var text2:String = "및 개인정보정책에 동의하게 됩니다."
        let attributedString = NSMutableAttributedString.init(string: "\(text)이용약관 \(text2)")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:  NSRange.init(location: text.count, length: 4))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:  NSRange.init(location: text2.count, length: 7))
        message.attributedText = attributedString
        
                                                       
        }


    
    func setUpBtn() {
        
        //kakaoLoginBtn.backgroundColor = yellow
        //appleLoginBtn.backgroundColor = .black
        loginBtn.lineSet()
        loginBtn.backgroundColor = .white
        
    }

 

}

