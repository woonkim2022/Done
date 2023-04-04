//
//  AlarmVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/18.
//

import UIKit
import DropDown

class AlarmVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var hoursBtn: UIButton!
    @IBOutlet weak var minutesBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet var noticeLabel: UILabel!
    
    @IBOutlet var DayBtn: [yourButton]!
    
    let loginLight = UIColor(named: "LoginColor")
    
    var isChecked  = [false,false,false,false,false,false,false]

    let timeDropDown = DropDown()
    let hoursDropDown = DropDown()
    let minutesDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.timeDropDown,
            self.hoursDropDown,
            self.minutesDropDown
        ]
    }()
    
    let userDefaults = UserDefaults()
    

    //MARK: - Actions
    
    @IBAction func chooseTime(_ sender: AnyObject) {
        timeDropDown.show()
    }
    
    @IBAction func changeHours(_ sender: AnyObject) {
        hoursDropDown.show()
    }
    
    @IBAction func choose(_ sender: AnyObject) {
        minutesDropDown.show()
    }
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpBtn()
        setupDropDowns()
        customizeDropDown()
        
       // 회원가입 이메일,비번 userdefault 값 불러와서 로그인 이메일,비번 값으로 넣어주기

//        if let value = UserDefaults.standard.value(forKey: "emailData") as? String {
//            loginData.email = value
//            print("userdefault 로그인 이메일 : \(value)")
//            print(loginData.email)
//        }
//
//        if let value = UserDefaults.standard.value(forKey: "signupPw") as? String {
//            loginData.pw = value
//            print("userdefault 로그인 비밀번호 : \(value)")
//            print(loginData.pw)
//        }

        
        print(loginData.email)
        print(loginData.pw)

 
    }
    
  
    
    //MARK: - Actions
    
    @IBAction func confirmBtn(_ sender: Any) {
        if isChecked[0] || isChecked[1] || isChecked[2] || isChecked[3] || isChecked[4] || isChecked[5] || isChecked[6]  {
            print("알람 요일 설정 완료하였습니다.")
            self.confirmBtn.backgroundColor = .black
            self.confirmBtn.isEnabled = true
            
            
        } else {
            print("알람 요일 설정 실패하였습니다.")
            self.confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = loginLight
       
        }
    }
    
    
    @IBAction func chaneToCalendarBtn(_ sender: Any) {
        
        if isChecked[0] || isChecked[1] || isChecked[2] || isChecked[3] || isChecked[4] || isChecked[5] || isChecked[6]  {
            

            // 회원가입 때 입력했던, 이메일과 비밀번호 불러와서 로그인 api 적용하기
                LoginService().loginPw()
                print(loginData.email)
               DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if loginData.loginState == true {
                    
                    UserDefaults.standard.set(true, forKey: "autologin")
                    print("\(loginData.jwt)")
                    
                    changeto() // 캘린더 화면으로 전환
                    
                } else {
                    print("회원가입 후 로그인 실패하였습니다.")
                }
            }
            
            func changeto(){
                let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarVC")
                    changeRootViewController(vcName)
            }
        }
    }
    
    @IBAction func ClickedDayButton(_ sender: UIButton) {
        
        switch sender {
        
        case DayBtn[0] :
        if isChecked[0] == false {
            isChecked[0] = true
            DayBtn[0].backgroundColor = .black
            DayBtn[0].titleLabel?.tintColor = .white
            
        } else {
            isChecked[0] = false
            DayBtn[0].backgroundColor = .white
            DayBtn[0].titleLabel?.tintColor = .black
        }
        
        case DayBtn[1] :
        if isChecked[1] == false {
            isChecked[1] = true
            DayBtn[1].backgroundColor = .black
            DayBtn[1].titleLabel?.tintColor = .white
        } else {
            isChecked[1] = false
            DayBtn[1].backgroundColor = .white
            DayBtn[1].titleLabel?.tintColor = .black
        }
            
        case DayBtn[2] :
        if isChecked[2] == false {
            isChecked[2] = true
            DayBtn[2].backgroundColor = .black
            DayBtn[2].titleLabel?.tintColor = .white
        } else {
            isChecked[2] = false
            DayBtn[2].backgroundColor = .white
            DayBtn[2].titleLabel?.tintColor = .black
        }
            
        case DayBtn[3] :
        if isChecked[3] == false {
            isChecked[3] = true
            DayBtn[3].backgroundColor = .black
            DayBtn[3].titleLabel?.tintColor = .white
        } else {
            isChecked[3] = false
            DayBtn[3].backgroundColor = .white
            DayBtn[3].titleLabel?.tintColor = .black
        }
            
        case DayBtn[4] :
        if isChecked[4] == false {
            isChecked[4] = true
            DayBtn[4].backgroundColor = .black
            DayBtn[4].titleLabel?.tintColor = .white
        } else {
            isChecked[4] = false
            DayBtn[4].backgroundColor = .white
            DayBtn[4].titleLabel?.tintColor = .black
        }
            
        case DayBtn[5] :
        if isChecked[5] == false {
            isChecked[5] = true
            DayBtn[5].backgroundColor = .black
            DayBtn[5].titleLabel?.tintColor = .white
        } else {
            isChecked[5] = false
            DayBtn[5].backgroundColor = .white
            DayBtn[5].titleLabel?.tintColor = .black
        }
            
            
        case DayBtn[6] :
        if isChecked[6] == false {
            isChecked[6] = true
            DayBtn[6].backgroundColor = .black
            DayBtn[6].titleLabel?.tintColor = .white
        } else {
            isChecked[6] = false
            DayBtn[6].backgroundColor = .white
            DayBtn[6].titleLabel?.tintColor = .black
        }
        default:
            return
        }
        
    }
    
    //MARK: - Helpers
    

    
    func setUpBtn() {
        
        //선택버튼 커스텀
        confirmBtn.backgroundColor = loginLight
        
        timeBtn.lineSet()
        hoursBtn.lineSet()
        minutesBtn.lineSet()
        
        //알람요일 버튼 설정
        DayBtn[0].lineSet()
        DayBtn[1].lineSet()
        DayBtn[2].lineSet()
        DayBtn[3].lineSet()
        DayBtn[4].lineSet()
        DayBtn[5].lineSet()
        DayBtn[6].lineSet()
  
        
        DayBtn[0].circleSet()
        DayBtn[1].circleSet()
        DayBtn[2].circleSet()
        DayBtn[3].circleSet()
        DayBtn[4].circleSet()
        DayBtn[5].circleSet()
        DayBtn[06].circleSet()
                        
    }
    

    
}


 
// MARK: - dropdown 매소드
 
extension AlarmVC {
    
    //드롭다운 - 다이얼로그 커스터마이즈
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        DropDown.appearance().backgroundColor = UIColor.white
        }
    

    
    func setupDropDowns() {
        setupChooseTimeDropDown()
        setupHoursDropDown()
        setupMinutesDropDown()
    }
    
    // 오전, 오후 드롭다운
    func setupChooseTimeDropDown() {
        timeDropDown.anchorView = timeBtn
        
        timeDropDown.bottomOffset = CGPoint(x: 0, y:(timeDropDown.anchorView?.plainView.bounds.height)!)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        timeDropDown.dataSource = [
            "오전  ",
            "오후  "
        ]
        
        // 다이얼로그에서 선택했을 때 label 폰트 바꿔주기
        timeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            timeBtn.setTitle(item, for: .normal)
            let attributedText = NSAttributedString(string: item, attributes: [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 18)])
            timeBtn.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    
    // 시간 드롭다운
    func setupHoursDropDown() {
        hoursDropDown.anchorView = hoursBtn
        
        hoursDropDown.bottomOffset = CGPoint(x: 0, y:(hoursDropDown.anchorView?.plainView.bounds.height)!)

        hoursDropDown.dataSource = [
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12"
        ]
        
        // 다이얼로그에서 선택했을 때 label 폰트 바꿔주기
        hoursDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            hoursBtn.setTitle(item, for: .normal)
            let attributedText = NSAttributedString(string: item, attributes: [NSAttributedString.Key.font: UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)])
            hoursBtn.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    
    
    // 분 드롭다운
    func setupMinutesDropDown() {
        minutesDropDown.anchorView = minutesBtn
        
        minutesDropDown.bottomOffset = CGPoint(x: 0, y:(minutesDropDown.anchorView?.plainView.bounds.height)!)

        minutesDropDown.dataSource = [
            "00",
            "15",
            "30",
            "45"
        ]
        
        // 다이얼로그에서 선택했을 때 label 폰트 바꿔주기
        minutesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            minutesBtn.setTitle(item, for: .normal)
            let attributedText = NSAttributedString(string: item, attributes: [NSAttributedString.Key.font: UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)])
            minutesBtn.setAttributedTitle(attributedText, for: .normal)
        }
    }
}
