//
//  editNicknameVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class editNicknameVC: UIViewController {
    
    lazy var dataManager: EditNicknameService = EditNicknameService()
    
    //MARK: - Properties
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet var errorLabel: [UILabel]!
    
    var nicknameState = false
    var nicknameString = ""
    
    let loginLight = UIColor(named: "LoginColor")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        nicknameTextField.delegate = self
    }
    
    
    // NotificationCenter에 Observer 등록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        if nicknameState == true {
            confirmBtn.isEnabled = true
            
            let input = EditNicknameDataModel(nickname: nicknameTextField.text )
            dataManager.patchData(input, delegate: self)
            print("변경된 닉네임 -> \(String(describing: nicknameTextField.text) )")
          
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeNickname"), object: nicknameTextField.text)
        }
    }
    
    //MARK: - Helpers
    
    // 속성 설정 매소드
    func setUpElements() {
        errorLabel[0].alpha = 0
        errorLabel[1].alpha = 0
        
        errorLabel[0].text = "5자 이하로 작성해주세요"
        errorLabel[1].text = "현재와 같은 닉네임을 입력했어요."

        Utilities.defaultTextField(nicknameTextField)
        confirmBtn.titleLabel?.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        confirmBtn.backgroundColor = loginLight
    }
    
    // 텍스트필드 5글자 이상 입력안되게 하기
    @objc private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case nicknameTextField:
                if let text = nicknameTextField.text {
                    if text.count > 5 {
                        // 🪓 주어진 인덱스에서 특정 거리만큼 떨어진 인덱스 반환
                        let maxIndex = text.index(text.startIndex, offsetBy: 5)
                        // 🪓 문자열 자르기
                        let newString = String(text[text.startIndex ..< maxIndex])
                        nicknameTextField.text = newString
                        errorLabel[0].alpha = 1
                        errorLabel[0].text = "5자 이하로 작성해주세요 "
                    } else if nicknameTextField.text ==  nicknameString  {
                        //🪓 같은 닉네임 입력시 버튼 기능 제한
                        self.confirmBtn.backgroundColor = loginLight
                        self.confirmBtn.isEnabled = false
                        errorLabel[1].alpha = 1
                        errorLabel[0].alpha = 0
                    } else if nicknameTextField.text == ""  {
                        //🪓 빈배열일 시 버튼 기능 제한
                        self.confirmBtn.backgroundColor = loginLight
                        self.confirmBtn.isEnabled = false
                    } else {
                        errorLabel[0].alpha = 0
                        errorLabel[1].alpha = 0
                        self.confirmBtn.backgroundColor = .black
                        nicknameState = true
                        confirmBtn.isEnabled = true
                    }
                }
            default:
                return
            }
        }
        }
    
}


// MARK: - 텍스트필드 유효성 검사

extension editNicknameVC : UITextFieldDelegate {
    
    // 1) 텍스트필드 입력 시 바텀라인 색상 black으로 변경
    // 2) 텍스트필드 text black으로 변경
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nicknameTextField:
            nicknameTextField.textColor = .black
            Utilities.highlightTextField(nicknameTextField)
        default:
            return
        }
    }
    
    
    // nickname 형식 맞았을 때 바텀라인 색깔 default 되게 하기
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case nicknameTextField:
            if nicknameState == true {
                Utilities.defaultTextField(nicknameTextField)
            } else {
            }
        default:
            return
        }
    }
    
}



extension editNicknameVC {

    
    // 리턴키 눌렀을 때 키보드 제어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nicknameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
}

