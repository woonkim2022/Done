//
//  editProfileVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class editProfileVC: UIViewController {
    //MARK: - Properties
    
    // 1. 프로필
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet var nicknameLb: UILabel!
    @IBOutlet weak var edtiBtn: UIButton!
    
    var nicknameString = ""
    
    // 테이블뷰
    @IBOutlet weak var myTableView: UITableView!
    
    let tableTitle = ["기록유형 설정", "비밀번호 변경"]
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        
        // 대리자 위임
        myTableView.delegate = self
        myTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,  selector: #selector(changeNickname),  name: NSNotification.Name(rawValue: "changeNickname"), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    //MARK: - Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeToEditNicknameVC(_ sender: UIButton) {
        guard let vcName = UIStoryboard(name: "EditMyVC ", bundle: nil).instantiateViewController(identifier: "editNicknameVC") as? editNicknameVC else {return}
        
             vcName.nicknameString = nicknameString
        
            self.navigationController?.pushViewController(vcName, animated: true)
    }
    
    // 로그아웃 전환
    @IBAction func changToLogoutModalPresent(_ sender: UIButton) {
         let storyBoard = UIStoryboard(name: "EditMyVC ", bundle: nil)
         
             if let vc = storyBoard.instantiateViewController(withIdentifier: "LogoutVC") as? LogoutVC  {
     
                 vc.modalPresentationStyle = .overCurrentContext
                 vc.modalTransitionStyle = .crossDissolve
                 self.present(vc, animated: true, completion: nil)
         }
     }

    
    // 회원탈퇴 전환
    @IBAction func changToWithdrawalVCModalPresent(_ sender: UIButton) {
         let storyBoard = UIStoryboard(name: "EditMyVC ", bundle: nil)
         
             if let vc = storyBoard.instantiateViewController(withIdentifier: "WithdrawalVC") as? WithdrawalVC  {
     
                 vc.modalPresentationStyle = .overCurrentContext
                 vc.modalTransitionStyle = .crossDissolve
                 self.present(vc, animated: true, completion: nil)
         }
     }
    
    
    //MARK: - Helpers
    
    func style() {
        nicknameLb.text = nicknameString
    }
    
    
    @objc fileprivate func changeNickname(_ notification: Notification) {
            if let content = notification.object as? String {
                nicknameLb.text = content
            }
        }

    
}


   //MARK: - UITableViewDelegate, UITableViewDataSource


extension editProfileVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableTitle.count
}

 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as! EditProfileTableViewCell
     
     cell.titleLb.text = tableTitle[indexPath.row]
     cell.selectionStyle = .none
     return cell
}

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
        guard let vcName = UIStoryboard(name: "EditMyVC ", bundle: nil).instantiateViewController(identifier: "editTypeVC") as? editTypeVC else {return}
        self.navigationController?.pushViewController(vcName, animated: true)
    } else {
        guard let vcName = UIStoryboard(name: "EditMyVC ", bundle: nil).instantiateViewController(identifier: "editPasswordVC") as? editPasswordVC else {return}
        self.navigationController?.pushViewController(vcName, animated: true)
    }
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //cell의 높이 설정
    return 55
    
}
}
