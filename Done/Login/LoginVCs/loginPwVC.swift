//
//  loginPwVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import UIKit

class loginPwVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var loginBtn: yourButton!

    @IBOutlet weak var forgotPwBtn: UIButton!
    
    @IBOutlet var errorLabel: [UILabel]!

    var textFieldIsValid = false
    var loginEmail = ""
    
    let loginLight = UIColor(named: "LoginColor")
    
    let userDefaults = UserDefaults()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pwTextField.delegate = self
        
        setUpTextField()
        setItems()
        
        if let value = UserDefaults.standard.value(forKey: "emailData") as? String {
            loginData.email = value
            print("userdefault email : \(value)")
            print( loginData.email)
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        
        self.isEditing = false
        
        if  textFieldIsValid == true {
            loginBtn.isEnabled = true
            LoginService().loginPw()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if loginData.loginState == true {
           
                    UserDefaults.standard.set(true, forKey: "autologin")
                    changeToMainVC()
                    
                    print("email = \(loginData.email)")
                    print("pw = \(loginData.pw)")
                    
                } else {
                    print("로그인 실패")
                    self.errorLabel[0].alpha = 1
                    self.errorLabel[0].text = "비밀번호를 다시 한번 확인해주세요."
                    
                }
            }

            func changeToMainVC(){
                print("로그인 성공하였습니다 - 캘린더VC 전환")
                
                 let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarVC")
                changeRootViewController(vcName)
                
            }
            
            
        }
    }

    
    
    //MARK: - Helpers
    
    //동의 버튼 설정 매소드
    func setItems(){
   
        loginBtn.backgroundColor = loginLight
        loginBtn.isEnabled = false
        
        errorLabel[0].alpha = 0
        errorLabel[1].alpha = 0
        
        // 텍스트필드 언더라인 추가
        Utilities.defaultTextField(pwTextField)
        
        
    }

    
    // Textfield 유효성 메서드
    func setUpTextField() {
        pwTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
    }

    
    
    // 텍스트필드 형식에 따른 버튼 조건 매소드
    @objc func textFieldEdited(textField: UITextField) {
        
        if textField == pwTextField{
            if pwTextField.text!.isValidPassword()
            {
                textFieldIsValid = true
                signUpBtnSet()
            }
            else {
                textFieldIsValid = false
                self.loginBtn.backgroundColor = self.loginLight
                self.loginBtn.isEnabled = false
            }
        }
        else {
        }
    }
    

    // 약관동의 + 이메일, 비번 형식 맞을 시에만 버튼 enable, color 변경 메소드
    func signUpBtnSet() {
        if  textFieldIsValid == true  {
            self.loginBtn.backgroundColor = .black
            self.loginBtn.isEnabled = true
        } else {
            
        }
    }
    
 }


// MARK: - 텍스트필드 유효성 검사

extension loginPwVC : UITextFieldDelegate {
    
    // 1) 텍스트필드 입력 시 바텀라인 색상 black으로 변경
    // 2) 텍스트필드 text black으로 변경
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case pwTextField:
            pwTextField.textColor = .black
            Utilities.highlightTextField(pwTextField)
            errorLabel[0].alpha = 0
            errorLabel[1].alpha = 0
        default:
            return
        }
    }
    
    // 이메일, 비밀번호 형식 안맞을 때, 오류메시지 띄우기
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        loginData.pw = pwTextField.text!
        UserDefaults.standard.set(pwTextField.text, forKey: "pw")
        
        switch textField {
            
        case pwTextField:
        if pwTextField.text!.isValidPassword() {
            Utilities.defaultTextField(pwTextField)
            errorLabel[1].alpha = 0
            errorLabel[0].alpha = 0
        } else {
            errorLabel[1].alpha = 1
            errorLabel[0].alpha = 0
            errorLabel[1].text = "비밀번호 형식으로 입력해주세요."
            Utilities.errorTextField(pwTextField)
        }
        default:
            return
        }
    

    }
}



extension loginPwVC {
    
    // 리턴키 눌렀을 때 키보드 제어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pwTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
}
