//
//  forgotPwVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import UIKit

class forgotPwVC: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!

    @IBOutlet var errorLabel: UILabel!
    
    var emailState = false
    var textFieldIsValid = false
    let loginLight = UIColor(named: "LoginColor")


    
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
    
    
    
    @IBAction func confirmButton(_ sender: UIButton) {
       print("forgotEmailData.email \(forgotEmailData.email)")
        forgotPwService().postDatamanager()
    }

    
    //MARK: - Helpers
    
    // 속성 설정 매소드
    func setUpElements() {
        
        confirmBtn.isEnabled = false
        
        errorLabel.alpha = 0
        
        // 텍스트필드 언더라인 추가
        Utilities.defaultTextField(emailTextField)
        
        //버튼 색상
        confirmBtn.backgroundColor = loginLight
    }
    
    
    
    // 이메일 형식 true일 때 로그인 버튼 색깔 변화
    func buttonSetUp() {
    
         if textFieldIsValid == true {
             UIView.animate(withDuration: 0.3, animations: {
                 self.confirmBtn.backgroundColor = .black
                 self.confirmBtn.titleLabel?.textColor = .white
                 self.confirmBtn.isEnabled = true
             })
             
         }
         else{
             UIView.animate(withDuration: 0.3, animations: {
                 self.confirmBtn.backgroundColor = self.loginLight
                 self.confirmBtn.isEnabled = false
             })
         }
     }
    
}


// MARK: - 텍스트필드 유효성 검사

extension forgotPwVC : UITextFieldDelegate {
    
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
        forgotEmailData.email = emailTextField.text!
        
        switch textField {
            
            case emailTextField:
            if emailTextField.text!.isValidEmail() {
                Utilities.defaultTextField(emailTextField)
                textFieldIsValid = true
                errorLabel.alpha = 0
            } else {
                textFieldIsValid = false
                errorLabel.alpha = 1
                errorLabel.text = "이메일 형식으로 입력해주세요."
                Utilities.errorTextField(emailTextField)
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



extension forgotPwVC {
    
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
