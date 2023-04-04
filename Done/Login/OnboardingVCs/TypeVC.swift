//
//  TypeVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/18.
//

import UIKit

class TypeVC: UIViewController {
    
    lazy var DataManager: onBoardingService = onBoardingService()

    //MARK: - Properties
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var jTypeBtn: UIButton!
    @IBOutlet weak var pTypeBtn: UIButton!
    @IBOutlet weak var jTypeView: UIView!
    @IBOutlet weak var pTypeView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var isSelected = [false,false]
    var nicknameText: String = ""
    var membertype: String = ""

    let loginLight = UIColor(named: "LoginColor")
  
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }

    
    //MARK: - Actions
    
    // '계획러' 선택했을 때 '즉흥러' 음영처리 + 선택버튼 활성화
    @IBAction func jTypeSelectedBtn(_ sender: UIButton) {
        if isSelected[0] == false  {
            isSelected[0] = true
            isSelected[1] = false
            
            membertype = "j"
            UserDefaults.standard.set(membertype, forKey: "userType")

            // 완료 버튼 커스텀
            self.confirmBtn.backgroundColor = .black
            self.confirmBtn.isEnabled = true
            
            // select시, 버튼 테두리 변화
            jTypeView.layer.borderWidth = 2
            jTypeView.layer.borderColor = CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
            
            pTypeView.layer.borderWidth = 0
        }
        else {
        }
    }
    
    
    // '즉흥러' 선택했을 때 '계획러' 음영처리 + 선택버튼 활성화
    @IBAction func pTypeSelectedBtn(_ sender: UIButton) {
        if isSelected[1] == false {
            isSelected[0] = false
            isSelected[1] = true
            
            membertype = "p"
            UserDefaults.standard.set(membertype, forKey: "userType")

            self.confirmBtn.backgroundColor = .black
            self.confirmBtn.isEnabled = true
            
            // select시, 버튼 테두리 변화
            pTypeView.layer.borderWidth = 2
            pTypeView.layer.borderColor = CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
            
            
            jTypeView.layer.borderWidth = 0

        } else {
            
        }
    }
    
    
    @IBAction func selectedBtn(_ sender: UIButton) {
        
        let patchInput = onBoardingDatamodel(nickname: nicknameText,
                                             member_type: membertype,
                                             alarm_time: "",
                                             alarm_cycle: "")
        
        DataManager.patchData(patchInput, delegate: self)
        
        UserDefaults.standard.set(true, forKey: "changeMainVC")
        
        let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarVC")
            changeRootViewController(vcName)
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       }
    
    
    //MARK: - Helpers
    
    // 속성 설정 매소드
    func setUpElements() {
        
        //타이틀 라벨 text 설정
        self.typeLabel.text = "\(nicknameText), 반가워요! \n평소 기록할 때 어떤 유형인가요?"
        
        //버튼 그림자 넣기
        jTypeView.viewShadow()
        pTypeView.viewShadow()
        
        jTypeView.layer.borderWidth = 0
        pTypeView.layer.borderWidth = 0

        
        //선택버튼 커스텀
        confirmBtn.titleLabel?.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        confirmBtn.backgroundColor = loginLight
        
    }
    

    


}
