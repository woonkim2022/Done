//
//  SignUpVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/17.
//

import UIKit

class pwVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var checkPwTextField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!

    @IBOutlet var errorLabel: [UILabel]!

    var textFieldIsValid = [false,false]
    let loginLight = UIColor(named: "LoginColor")

    let userDefaults = UserDefaults()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPwTextField.delegate = self
        pwTextField.delegate = self
        
        setUpElements()
        setItems()
        setUpTextField()
        
        if let value = UserDefaults.standard.value(forKey: "emailData") as? String {
            signupData.email = value
            loginData.email = value
            print("userdefault email : \(value)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)),  name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        
        self.isEditing = false
        
        if textFieldIsValid[0] == true && textFieldIsValid[1] == true {
            signUpBtn.isEnabled = true
            userDefaults.set(checkPwTextField.text, forKey: "signupPw")
            UserDefaults.standard.set(signupData.email, forKey: "emailData")

            signupService().signup()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if signupData.signupState == true  {
                    print("회원가입 완료하였습니다")
                    loginData.email = signupData.email
                    loginData.pw = signupData.pw
                    UserDefaults.standard.set(self.checkPwTextField.text, forKey: "pw")
                    self.autuLogin()
                }
            }
        }
    }
    
    
    func autuLogin() {
        LoginService().loginPw()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
         if loginData.loginState == true {
             
             print("가입된 이메일 = \(loginData.email)")
             print("가입된 비밀번호 = \(loginData.pw)")
             print("로그인 토큰 = \(loginData.jwt)")
             
             UserDefaults.standard.set(true, forKey: "autologin")
          

             changeToOnboardingVC() // 캘린더 화면으로 전환
             
         } else {
             print("회원가입 후 로그인 실패하였습니다.")
         }
    }
        
         func changeToOnboardingVC() {
             print("회원가입/로그인 성공하였습니다 - 닉네임 페이지 전환")
             
             guard let vcName = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(identifier: "NicknameVC") as? NicknameVC else {return}
             self.navigationController?.pushViewController(vcName, animated: true)
             
         }
    }
/**
 if loginData.loginState == true {
     UserDefaults.standard.set(true, forKey: "autologin")
     print("로그인 TOKEN \(loginData.jwt)")
     
     changeToOnboardingVC() // 닉네임 화면으로 전환
 } else {
     print("회원가입 후, 로그인 실패했습니다.")
 }
 */
    
    //MARK: - Helpers
    
    //동의 버튼 설정 매소드
    func setItems(){
   
        signUpBtn.backgroundColor = loginLight
        
    }

    
    // 속성 설정 매소드
    func setUpElements() {
        
        errorLabel[0].alpha = 0
        errorLabel[1].alpha = 0
        
        // 텍스트필드 언더라인 추가
        Utilities.defaultTextField(checkPwTextField)
        Utilities.defaultTextField(pwTextField)
        
        //버튼 색상
        signUpBtn.titleLabel?.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        signUpBtn.backgroundColor = loginLight

    }
    
    
    // Textfield 유효성 메서드
    func setUpTextField() {
        checkPwTextField.addTarget(self, action: #selector(textFieldEdited), for:
                                    UIControl.Event.editingChanged)
        pwTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
    }

    
    
    // 이메일,비밀번호 형식 둘다 true일 때 로그인 버튼 색깔 변화 + enable
    func buttonSetUp() {
             
         if  textFieldIsValid[0] == true && textFieldIsValid[1] == true {
             UIView.animate(withDuration: 0.1, animations: {
                 self.signUpBtn.backgroundColor = .black
                 self.signUpBtn.isEnabled = true
             })
             
         }
         else {
             UIView.animate(withDuration: 0.1, animations: {
                 self.signUpBtn.backgroundColor = self.loginLight
                 self.signUpBtn.isEnabled = false
             })
         }
     }
    
}

//MARK: - 텍스트필드 형식에 따른 버튼 enable

extension pwVC {
    
    // 약관동의 + 이메일, 비번 형식 맞을 시에만 버튼 enable, color 변경 메소드
    func signUpBtnSet() {
        if  textFieldIsValid[0] == true && textFieldIsValid[1] == true  {
            self.signUpBtn.backgroundColor = .black
            self.signUpBtn.isEnabled = true
        } else {
            
        }
    }
    
    // 텍스트필드 형식에 따른 버튼 조건 매소드
    @objc func textFieldEdited(textField: UITextField) {
        
        if textField == pwTextField{
            if pwTextField.text!.isValidPassword()
            {
                textFieldIsValid[1] = true
            }
            else {
                textFieldIsValid[1] = false
                self.signUpBtn.backgroundColor = self.loginLight
                self.signUpBtn.isEnabled = false
            }
        }
        else if textField == checkPwTextField{
            if checkPwTextField.text! == pwTextField.text!
            {
                textFieldIsValid[0] = true
                signUpBtnSet()
            }
            else {
                textFieldIsValid[0] = false
                self.signUpBtn.backgroundColor = self.loginLight
                self.signUpBtn.isEnabled = false
            }
        }
    }
    
    
    
    // 텍스트필드 20글자 이상 입력안되게 하기
    @objc private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case pwTextField:
                if let text = pwTextField.text {
                    if text.count > 20 {
                        // 🪓 주어진 인덱스에서 특정 거리만큼 떨어진 인덱스 반환
                        let maxIndex = text.index(text.startIndex, offsetBy: 20)
                        // 🪓 문자열 자르기
                        let newString = String(text[text.startIndex ..< maxIndex])
                        pwTextField.text = newString
                    }
                }
            case checkPwTextField:
                if let text = checkPwTextField.text {
                    if text.count > 20 {
                        // 🪓 주어진 인덱스에서 특정 거리만큼 떨어진 인덱스 반환
                        let maxIndex = text.index(text.startIndex, offsetBy: 20)
                        // 🪓 문자열 자르기
                        let newString = String(text[text.startIndex ..< maxIndex])
                        checkPwTextField.text = newString
                    }
                }
            default:
                return
            }
        }
        
        
    }
}




// MARK: - 텍스트필드 유효성 검사

extension pwVC : UITextFieldDelegate {
    
     // 1) 텍스트필드 입력 시 바텀라인 색상 black으로 변경
     // 2) 텍스트필드 text black으로 변경
     func textFieldDidBeginEditing(_ textField: UITextField) {
         switch textField {
         case checkPwTextField:
             checkPwTextField.textColor = .black
             Utilities.highlightTextField(checkPwTextField)
             
         case pwTextField:
             pwTextField.textColor = .black
             Utilities.highlightTextField(pwTextField)
             
         default:
             return
         }
     }
    
    
    // 이메일, 비밀번호 형식 안맞을 때, 오류메시지 띄우기 + 바텀라인 색상 red로 변경
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        signupData.pw = checkPwTextField.text!
        loginData.pw = checkPwTextField.text!

    
        switch textField {
            
            case checkPwTextField:
            if checkPwTextField.text! == pwTextField.text! {
                Utilities.defaultTextField(checkPwTextField)
                Utilities.defaultTextField(pwTextField)
                errorLabel[0].alpha = 0
                errorLabel[1].alpha = 0
            } else {
                errorLabel[0].alpha = 1
                errorLabel[0].text = "두 비밀번호가 일치하지 않아요."
                Utilities.errorTextField(checkPwTextField)
                Utilities.errorTextField(pwTextField)
                errorLabel[1].alpha = 0
            }
            
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
        
        
//        // 이메일, 비밀번호 형식 안맞을 때, 텍스트필드 text 빨간색으로 변경
//        switch textField {
//        case checkPwTextField:
//        if  textFieldIsValid[0] == false {
//            checkPwTextField.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
//        } else {
//        }
//        default:
//            return
//        }
    }
}


extension pwVC {
    
    // 리턴키 눌렀을 때 키보드 제어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkPwTextField.resignFirstResponder()
        self.pwTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
}


/*
@objc func firstCheckBoxTapped(){
    //모두동의 버튼 탭 했을 때, 아래 동의버튼 2개 동시에 체크 버튼으로 변경
    
    if isChecked[0] == false  {
        checkBoxes[0].image = UIImage(named: "radioCheck")
        checkBoxes[1].image = UIImage(named: "radioCheck")
        checkBoxes[2].image = UIImage(named: "radioCheck")
        isChecked[0] = true
        isChecked[1] = true
        isChecked[2] = true
        buttonSetUp()
        
    }
    else{
        checkBoxes[0].image = UIImage(named: "radioUncheck")
        checkBoxes[1].image = UIImage(named: "radioUncheck")
        checkBoxes[2].image = UIImage(named: "radioUncheck")
        isChecked[0] = false
        isChecked[1] = false
        isChecked[2] = false
        signUpBtn.backgroundColor = loginLight
        self.signUpBtn.isEnabled = false
    }
    
}
*/
