//
//  editTypeVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class editTypeVC: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var jTypeBtn: UIButton!
    @IBOutlet weak var pTypeBtn: UIButton!
    @IBOutlet weak var jTypeView: UIView!
    @IBOutlet weak var pTypeView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    var isSelected = [false,false]
    var selectState = false
    var nicknameText: String = ""
    var membertype: String = ""

    let loginLight = UIColor(named: "LoginColor")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        print("userInfoData.type -------\(userInfoData.type)")

    
    }
    
    //MARK: - Actions
    
    // '계획러' 선택했을 때 '즉흥러' 음영처리 + 선택버튼 활성화
    @IBAction func jTypeSelectedBtn(_ sender: UIButton) {
        
        jTypeView.layer.borderWidth = 2
        jTypeView.layer.borderColor = CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
        
        pTypeView.layer.borderWidth = 0

        membertype = "j"
        if userInfoData.type == "j"  {
            self.confirmBtn.backgroundColor =  loginLight
            self.confirmBtn.isEnabled = false // 버튼 비활성화
        } else if userInfoData.type == "p" {
            
            self.confirmBtn.isEnabled = true // 버튼 비활성화
            self.confirmBtn.backgroundColor = .black
        }
    }
    
    
    // '즉흥러' 선택했을 때 '계획러' 음영처리 + 선택버튼 활성화
    @IBAction func pTypeSelectedBtn(_ sender: UIButton) {
        
        pTypeView.layer.borderWidth = 2
        pTypeView.layer.borderColor = CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
        
        jTypeView.layer.borderWidth = 0
        
        membertype = "p"
        
        if userInfoData.type == "p"  {
            self.confirmBtn.backgroundColor =  loginLight
            self.confirmBtn.isEnabled = false // 버튼 비활성화
        }
        else if userInfoData.type == "j" {
            
            self.confirmBtn.isEnabled = true // 버튼 비활성화
            self.confirmBtn.backgroundColor = .black
        }
    }

    @IBAction func selectedBtn(_ sender: UIButton) {
        userInfoData.type = membertype
        EditTypeService().patchData()
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
          }
    
    //MARK: - Helpers
    
    // 속성 설정 매소드
    func setUpElements() {
        
        //버튼 그림자 넣기
        jTypeView.viewShadow()
        pTypeView.viewShadow()
        
        userTypeFilterSet()

        //선택버튼 커스텀
        confirmBtn.titleLabel?.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        confirmBtn.backgroundColor = loginLight
    }
    
    
    func userTypeFilterSet() {
        if userInfoData.type == "j" {
            pTypeView.layer.borderWidth = 0
            jTypeView.layer.borderWidth = 2
            jTypeView.layer.borderColor = CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
            

        } else if userInfoData.type == "p" {
            jTypeView.layer.borderWidth = 0
            pTypeView.layer.borderWidth = 2
            pTypeView.layer.borderColor = CGColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)

        }


    }
    

}
