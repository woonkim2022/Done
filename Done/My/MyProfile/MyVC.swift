//
//  MyVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/03.
//

import UIKit
import SafariServices

extension MyVC {
    
    func didProfileService(_ response: profileDataModel) {
        userNickname = response.item?.nickname ?? ""
        userLevel = response.item?.level ?? 0
        userLevelMessage = response.item?.level_message ?? ""
        totalDoneCount = response.item?.total_done_count ?? 0
        
        nicknameLb.text = userNickname
        cheerUpMessageLb.text = userLevelMessage
        previousLb.text = "LV.\(userLevel)"
        nextLb.text = "LV.\(userLevel + 1)"
        
        levelSwitch(level: userLevel) //등급 name 지정
        progressLevelSet(level: userLevel) // 등급에 따른 프로그래스바
    }
    
    func didUserTypeService(_ response: getTypeDataModel) {
        userType = response.item?.type ?? ""
        userInfoData.type = userType

        if userType == "j" {
            typeLb.text = "계획러"
        } else if userType == "p" {
            typeLb.text = "즉흥러"
        }
    }
    
}


class MyVC: UIViewController {
    
    lazy var profileGetDataManager: profileService = profileService()
    lazy var typeGetDataManager: getTypeService = getTypeService()


    //MARK: - Properties
    
    //데이터 변수
    var myProfileList : [Profile] = []
    var userNickname: String = ""
    var userLevel:  Int = 0
    var userLevelMessage: String = ""
    var totalDoneCount:  Int = 0
    var dateDoneCount : Int = 0
    var levelName: String = ""
    var userType : String = ""

    
    // 네비게이션바
    @IBOutlet weak var notificationBtn: UIButton!

    // 1. 프로필
    @IBOutlet weak var typeLb: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet var nicknameLb: UILabel!
    @IBOutlet var levelLb: UILabel!
    @IBOutlet weak var planTypeImage: UIImageView!
    @IBOutlet weak var freeTypeImage: UIImageView!
    @IBOutlet weak var detailProfileBtn: UIButton!
    @IBOutlet weak var premiumImage: UIImageView!
    
    // 레벨 프로그래스바
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet var cheerUpMessageLb: UILabel!
    @IBOutlet var previousLb: UILabel!
    @IBOutlet var nextLb: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressView: UIView!
    
    // 마이리포트
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var reportBtn: yourButton!
        
    // 테이블뷰
    @IBOutlet weak var myTableView: UITableView!
    
    let tableTitle = ["프리미엄", "공지사항", "문의하기", "이용약관", "개인정보 보호약관", "버전"]
    
    
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        profileGetDataManager.getData(self)
        typeGetDataManager.getData(self)
        
        style()
        setElements()
        
        // 대리자 위임
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileGetDataManager.getData(self)
        typeGetDataManager.getData(self)

    }
    
    
    
    //MARK: - Actions

    @IBAction func changeToLevelVC(_ sender: Any) {
        guard let vc = UIStoryboard(name: "MyVC", bundle: nil).instantiateViewController(identifier: "LevelViewController") as? LevelViewController else {return}
        
        vc.levelName =  levelName
        vc.levelMessage = userLevelMessage
        vc.level = userLevel
        vc.totalDoneCount = totalDoneCount
        vc.dateDoneCount = dateDoneCount

        print(userLevelMessage)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeToEditProfileVC(_ sender: Any) {
        guard let vc = UIStoryboard(name: "EditMyVC ", bundle: nil).instantiateViewController(identifier: "editProfileVC") as? editProfileVC else {return}
        vc.nicknameString = userNickname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       }
    
    
    //MARK: - Helpers

    func setElements() {
   
    }
    
    
    func style() {
        cheerUpMessageLb.layer.masksToBounds = true
        cheerUpMessageLb.layer.cornerRadius = 10
        progressView.viewShadow()
        reportBtn.titleLabel?.textColor = .white
        
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5 // 뒤에 있는 회색 track
        progressBar.subviews[1].clipsToBounds = true
        progressBar.progressViewStyle = .default
        
        typeLb.layer.masksToBounds = true
        typeLb.layer.cornerRadius = 9
        
        premiumImage.isHidden = true
    }
    
    func changeVC() {
        let vc = UIStoryboard(name: "LandingStoryboard ", bundle: nil).instantiateViewController(identifier: "LandingVC")
        changeRootViewController(vc)
    }
    
    
    //등급에 따라 이름 지정 메소드
    func levelSwitch(level: Int) {
     
            switch level {
            case 0 :
                levelImageView.image = UIImage(named: "level0")
            case 1..<4:
                levelName = "새싹해냄이"
                levelLb.text = "\(levelName) LV.\(userLevel)"
                levelImageView.image = UIImage(named: "\(levelName)")
            case 4..<7:
                levelName = "해린이"
                levelLb.text = "\(levelName) LV.\(userLevel)"
                levelImageView.image = UIImage(named: "\(levelName)")
            case 7..<9:
                levelName = "프로해냄러"
                levelLb.text = "\(levelName) LV.\(userLevel)"
                levelImageView.image = UIImage(named: "\(levelName)")
            case 9..<11:
                levelName = "갓생해린이"
                levelLb.text = "\(levelName) LV.\(userLevel)"
                levelImageView.image = UIImage(named: "\(levelName)")
            default:
                levelName = ""
            }
    }
    
    
    func progressLevelSet(level: Int)  {
        
        if let value = UserDefaults.standard.value(forKey: "dateCounts") as? Int {
            dateDoneCount = value
        }

       switch level {
        case 0:
            progressBar.progress = Float(totalDoneCount) / 1
        case 1:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 59
        case 2:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 90
        case 3:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 170
        case 4:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 100
        case 5:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 100
        case 6:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 280
        case 7:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 250
        case 8:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 1020
        case 9:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 1090
        default:
            progressBar.progress = Float(totalDoneCount + dateDoneCount) / 59
        }
    }
    
}


  //MARK: - UITableViewDelegate, UITableViewDataSource


extension MyVC: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        
        if indexPath.row == 5 {
            cell.titleLb.text = tableTitle[indexPath.row]
            cell.selectionStyle = .none
            cell.versionLb.isHidden = false
            cell.detailBtn.isHidden = true
            return cell
            
        } else {
               // Cell Label의 내용 지정
        cell.titleLb.text = tableTitle[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let vcName = UIStoryboard(name: "MyVC", bundle: nil).instantiateViewController(identifier: "PremiumViewController") as? PremiumViewController else {return}
                   self.navigationController?.pushViewController(vcName, animated: true)
        } else if indexPath.row == 1 {
            //공지사항
            let url = NSURL(string: "https://spark-myth-3c9.notion.site/f6a726345199494cbd2225ea8dfdd898")
            let blogSafariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
            self.present(blogSafariView, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            //문의하기
            let url = NSURL(string: "https://spark-myth-3c9.notion.site/59aa9d72a8104a4eb73daa31a77cdb82")
            let blogSafariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
            self.present(blogSafariView, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            //이용약관
            let url = NSURL(string: "https://spark-myth-3c9.notion.site/f7c405f9a9a644a8964ad6046530d08f")
            let blogSafariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
            self.present(blogSafariView, animated: true, completion: nil)
            
        } else if indexPath.row == 4 {
            //개인정보
            let url = NSURL(string: "https://spark-myth-3c9.notion.site/95812922d5cc4f9aa47f32936f5e9919")
            let blogSafariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
            self.present(blogSafariView, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //cell의 높이 설정
        return 55

    }
}
