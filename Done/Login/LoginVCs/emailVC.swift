//
//  LoginVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/15.
//

import UIKit

class emailVC: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet var errorLabel: [UILabel]!
    
    var emailState = false
    
    var textFieldIsValid = false
    let loginLight = UIColor(named: "LoginColor")
    
    let userDefaults = UserDefaults()
    
    
    //MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        setUpElements()
    }

    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    
    
    // 이메일 중복 API 연결
    @IBAction func confirmButton(_ sender: UIButton) {
        if textFieldIsValid == true {
            
            emailCheckService().emailCheck() //이메일 중복 api
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
                // 새로운 유저일 때
                if emailCheckData.emailState == true {
                    signupData.email = self.emailTextField.text!
                    
                    changeToPwVC() //회원가입용 비밀번호 페이지로 이동
                    
                    print("email = \(signupData.email)")
                    
                } else if emailCheckData.emailState == false {
                    loginData.email = self.emailTextField.text!
                    changeTologinPwVC() //로그인용 비밀번호 페이지로 이동
                } else {
                }
            }
            
            // 새로운 유저 -  비밀번호 입력(1)페이지로 전환
            func changeToPwVC(){
                print("새로운 유저 - 비밀번호 입력(1)페이지로 전환")
                
                guard let vcName = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(identifier: "pwVC") as? pwVC else {return}
                 self.navigationController?.pushViewController(vcName, animated: true)
            }
            
            // 가입된 유저 - 비밀번호 입력(2)페이지로 전환
            func changeTologinPwVC(){
                print("가입된 유저 - 비밀번호 입력(2)페이지로 전환")
                
                guard let vcName = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(identifier: "loginPwVC") as? loginPwVC else {return}
                 self.navigationController?.pushViewController(vcName, animated: true)
            }
        }
    }
    

    //MARK: - Helpers
    
    
    // 속성 설정 매소드
    func setUpElements() {
        
        loginBtn.isEnabled = false
        
        errorLabel[0].alpha = 0
        errorLabel[1].alpha = 0
        
        // 텍스트필드 언더라인 추가
        Utilities.defaultTextField(emailTextField)
        
        //버튼 색상
  
        loginBtn.backgroundColor = loginLight
  

    }
 
    
    
   // 이메일,비밀번호 형식 둘다 true일 때 로그인 버튼 색깔 변화
   func buttonSetUp() {
   
        if textFieldIsValid == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.loginBtn.backgroundColor = .black
                self.loginBtn.titleLabel?.textColor = .white
                self.loginBtn.isEnabled = true
            })
            
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.loginBtn.backgroundColor = self.loginLight
                self.loginBtn.isEnabled = false
            })
        }
    }
    
    
    
    
}



// MARK: - 텍스트필드 유효성 검사

extension emailVC : UITextFieldDelegate {
   
    // 1) 텍스트필드 입력 시 바텀라인 색상 black으로 변경
    // 2) 텍스트필드 text black으로 변경
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailTextField.textColor = .black
            Utilities.highlightTextField(emailTextField)
            
        default:
            return
        }
    }
    
    // 이메일, 비밀번호 형식 안맞을 때, 오류메시지 띄우기
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailCheckData.email = emailTextField.text!
        
        switch textField {
            
            case emailTextField:
            if emailTextField.text!.isValidEmail() {
                Utilities.defaultTextField(emailTextField)
                textFieldIsValid = true
                errorLabel[0].alpha = 0
                errorLabel[1].alpha = 0
            } else {
                textFieldIsValid = false
                errorLabel[0].alpha = 1
                errorLabel[0].text = "이메일 형식으로 입력해주세요."
                Utilities.errorTextField(emailTextField)
                errorLabel[1].alpha = 0
            }
            
            buttonSetUp()
            
        default:
            return
        }
        
        
        // 이메일, 비밀번호 형식 안맞을 때, 텍스트필드 text 빨간색으로 변경
        switch textField {
        case emailTextField:
        if  textFieldIsValid == false {
            emailTextField.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        } else {
        }
        default:
            return
        }
         

    }
}


extension emailVC {
    
    // 리턴키 눌렀을 때 키보드 제어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 
        self.emailTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
        return true
    }
    
    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
}
