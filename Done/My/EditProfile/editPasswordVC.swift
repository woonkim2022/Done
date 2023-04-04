//
//  editPasswordVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class editPasswordVC: UIViewController {
    
    lazy var dataManager: editPasswordService = editPasswordService()

    //MARK: - Properties
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var checkPwTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet var errorLabel: [UILabel]!

    var textFieldIsValid = [false,false]
    var previousPw = ""
    var newPassword = ""
    
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
        
        print(previousPw)
        
        if let value = UserDefaults.standard.value(forKey: "pw") as? String {
            print("userdefault pw : \(value)")
            previousPw = value
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)),  name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    //MARK: - Actions
    
    @IBAction func editConfirmBtn(_ sender: UIButton) {
        
        self.isEditing = false
        
        if textFieldIsValid[0] == true && textFieldIsValid[1] == true {
    
            
            let input = EditdataModel(new_password: checkPwTextField.text!)
            dataManager.postDatamanager(input, delegate: self)
          
             print("입력한 비밀번호 \(editPasswordData.passwordState)")
             confirmBtn.isEnabled = true
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if editPasswordData.passwordState == true  {
                    UserDefaults.standard.set(self.checkPwTextField.text, forKey: "pw")
                    print("비밀번호 변경 완료하였습니다")
                    print(" 변경된 비밀번호 -------> \(editPasswordData.newPassword)")
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
          }
    
    //MARK: - Helpers
 
    //동의 버튼 설정 매소드
    func setItems(){
   
        confirmBtn.backgroundColor = loginLight
        
    }

    
    // 속성 설정 매소드
    func setUpElements() {
        
        errorLabel[0].alpha = 0
        errorLabel[1].alpha = 0
        errorLabel[2].alpha = 0
        errorLabel[2].text = "현재 비밀번호와 같아요."

        
        // 텍스트필드 언더라인 추가
        Utilities.defaultTextField(checkPwTextField)
        Utilities.defaultTextField(pwTextField)
        
        //버튼 색상
        confirmBtn.titleLabel?.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        confirmBtn.backgroundColor = loginLight

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
                 self.confirmBtn.backgroundColor = .black
                 self.confirmBtn.isEnabled = true
             })
             
         }
         else {
             UIView.animate(withDuration: 0.1, animations: {
                 self.confirmBtn.backgroundColor = self.loginLight
                 self.confirmBtn.isEnabled = false
             })
         }
     }
    
}

//MARK: - 텍스트필드 형식에 따른 버튼 enable

extension editPasswordVC {
    
    // 약관동의 + 이메일, 비번 형식 맞을 시에만 버튼 enable, color 변경 메소드
    func signUpBtnSet() {
        if  textFieldIsValid[0] == true && textFieldIsValid[1] == true  {
            self.confirmBtn.backgroundColor = .black
            self.confirmBtn.isEnabled = true
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
                self.confirmBtn.backgroundColor = self.loginLight
                self.confirmBtn.isEnabled = false
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
                self.confirmBtn.backgroundColor = self.loginLight
                self.confirmBtn.isEnabled = false
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
                    } else if checkPwTextField.text ==  previousPw  {
                        //🪓 같은 닉네임 입력시 버튼 기능 제한
                        self.confirmBtn.backgroundColor = loginLight
                        self.confirmBtn.isEnabled = false
                        errorLabel[2].alpha = 1
                        errorLabel[1].alpha = 0
                        errorLabel[0].alpha = 0
                    } else {
                        errorLabel[2].alpha = 0
                    }
                }
            default:
                return
            }
        }
        
        
    }
}




// MARK: - 텍스트필드 유효성 검사

extension editPasswordVC : UITextFieldDelegate {
    
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
         
        editPasswordData.newPassword = checkPwTextField.text!
        print(editPasswordData.newPassword)
        
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
        

    }
}


extension editPasswordVC {
    
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



