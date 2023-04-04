//
//  LevelViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class LevelViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var levelTableView: UITableView!
    
    // 1. 프로필
    @IBOutlet var levelLb: UILabel!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet var levelMessageLb: UILabel!
    @IBOutlet var previousLb: UILabel!
    @IBOutlet var nextLb: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressView: UIView!
    
    var levelName: String = ""
    var level:  Int = 0
    var levelMessage: String = ""
    var totalDoneCount:  Int = 0
    var dateDoneCount : Int = 0
    
    
    let nameTitle = ["새싹해냄이", "해린이", "프로해냄러", "갓생해린이"]
    let levelTitle = ["LV.1~LV.3", "LV.4~LV.6", "LV.7~LV.8", "LV.9~LV.10"]
    let levelDetail = ["해냄과 함께 기록을 시작하는 단계네요:)", "기록 습관이 생기고 있는 해린이네요!👏🏻", "나만의 던리스트를 꾸준히 만들어가고 있어요!", "진정한 갓생러!"]
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        delegateSet()
        levelDataSet()
    }
    
    
    //MARK: - Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       }
    
    
    //MARK: - Helpers
    
    func levelDataSet() {
        levelLb.text = levelName
        levelImageView.image = UIImage(named: "\(levelName)")
        levelMessageLb.text = levelMessage
        previousLb.text = "LV.\(level)"
        nextLb.text = "LV.\(level + 1)"
        
        progressLevelSet(level: level) // 등급에 따른 프로그래스바
        
    }
    
    func style() {
        levelMessageLb.layer.masksToBounds = true
        levelMessageLb.layer.cornerRadius = 10
        levelTableView.viewShadow()
        progressView.viewShadow()
        
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5 // 뒤에 있는 회색 track
        progressBar.subviews[1].clipsToBounds = true
        progressBar.progressViewStyle = .default
    }
    
    func delegateSet() {
        levelTableView.delegate = self
        levelTableView.dataSource = self
    }
    
    
    func progressLevelSet(level: Int)  {
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

extension LevelViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: levelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "levelTableViewCell", for: indexPath) as! levelTableViewCell
        
        cell.levelName.text = nameTitle[indexPath.row]
        cell.level.text = levelTitle[indexPath.row]
        cell.levelExplain.text = levelDetail[indexPath.row]
        cell.levelImageView.image = UIImage(named: nameTitle[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //cell의 높이 설정
        return 90

    }
    
    
}

