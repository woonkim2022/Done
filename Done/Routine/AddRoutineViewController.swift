//
//  AddRoutineViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import UIKit
import SnapKit

//MARK: - AddRoutineService methods

// routine get 조회 api -> success methods
extension AddRoutineViewController {
    func didRoutineService(result: Routine) {
        routineData = result.routines
        routineTableView.reloadData()
    }
}

class AddRoutineViewController: UIViewController {
    
    lazy var routineDataManager: AddRoutineService = AddRoutineService()
    lazy var deleteRoutineDataManager: DeleteRoutineService = DeleteRoutineService()
    
    //MARK: - Properties

    @IBOutlet weak var routineTableView: UITableView!
    
    var routineEditState = false
    var firstInputState = false

    
     var routineData: [RoutineList] = [RoutineList]()
     var routineNo : Int = 0
    
    private var currentPage: Int = 1
    private var page: Int = 100000
    
    var mainVC = DoneTextVC()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        routineDataManager.getData(self) //planDataManager get api 호출
        routineTableView.rowHeight = UITableView.automaticDimension
        
        // 플랜 data reload -> tableview 갱신 + plan get api 업데이트
        NotificationCenter.default.addObserver(self, selector: #selector(editDataReceived),
                                               name: NSNotification.Name(rawValue: "routineEditRelaodData"),
                                               object: nil)
        
        // 플랜 data reload -> tableview 갱신 + plan get api 업데이트
        NotificationCenter.default.addObserver(self, selector: #selector(doneDataReceived),
                                               name: NSNotification.Name(rawValue: "routineFirstRelaodData"),
                                               object: nil)
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "upBottomSheet2"), object: nil)
         self.dismiss(animated: true, completion: nil)

    
      
     }
    

        
    // notificationcenter methods
    @objc fileprivate func editDataReceived() {
        routineEditState = true
        print("planVC - datarecived")
        routineDataManager.getData(self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appearRoutinePlanBtn"), object: nil)
        //플랜추가 버튼 나타나면서 편집상태로 바꿔줌
    }
    
    
    
    
    // notificationcenter methods
    @objc fileprivate func doneDataReceived() {
        print("planVC - planStatemode")
        routineDataManager.getData(self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doneState"), object: nil)
        //플랜추가 버튼 나타나면서 편집상태로 바꿔줌

    }
    

}


   //MARK: - UITableViewDataSource, UITableViewDelegate


extension AddRoutineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            if  currentPage < page  {
                return routineData.count + 1
            } else {
                return routineData.count
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.section == 0 {
           guard let alarm = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
                               
           alarm.delegate = self
           alarm.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
           alarm.selectionStyle = .none
           alarm.addRoutineBtn.isHidden = true
           
           // 루틴 데이터가 0이면, 루틴추가버튼 & 편집 버튼 사라지게하기
           if routineData.count == 0 {
               alarm.addRoutineBtn.isHidden = false
               alarm.editBtn.isHidden = true
               alarm.completeBtn.isHidden = true
           } else {
               alarm.editBtn.isHidden = false
           }
           
           return alarm
       } else {

       if currentPage < page {
                   
       if indexPath.row == routineData.count {
           
           guard let more = tableView.dequeueReusableCell(withIdentifier: AddRoutineTableViewCell.identifier,for: indexPath) as? AddRoutineTableViewCell else {
               return UITableViewCell() }
           
           // 루틴데이터 0인 상태에서 루틴추가 버튼 사라지게하기 (alarm 테이블뷰 셀의 루틴추가버튼 나타낼거기 때문에)
           if routineData.count == 0 || firstInputState == true  {
               more.addRoutineBtn.isHidden = true
           }
           
           
           more.delegate = self
           //선택 셀 구분선 없애주기
           more.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
           more.selectionStyle = .none

           return more

       } else {
           guard let routines = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier, for: indexPath) as? RoutineTableViewCell else {
               return UITableViewCell() }

           routines.delegate = self
           routines.indexPath = indexPath
           let routine = routineData[indexPath.row]
           routines.setCardDatas(catagoryNo: routineData[indexPath.row].category_no ?? 0, routineNo: routineData[indexPath.row].routine_no , content: routineData[indexPath.row].content)
          
           
           routines.selectionStyle = .none
           routines.catagoryImageView.image = UIImage(named: "\(routine.category_no ?? 0)")


           // 루틴 입력완료 시 테이블 셀 edit 상태로 바꾸기
           if routineEditState == true {
               routines.editBtn.isHidden = false
               routines.deleteBtn.isHidden = false

           } else {
               routines.editBtn.isHidden = true
               routines.deleteBtn.isHidden = true
           }
           return routines
       }
       } else {
           guard let routines = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier, for: indexPath) as? RoutineTableViewCell else {
               return UITableViewCell() }

           routines.delegate = self
           routines.indexPath = indexPath
           routines.setCardDatas(catagoryNo: routineData[indexPath.row].category_no ?? 0, routineNo: routineData[indexPath.row].routine_no , content: routineData[indexPath.row].content)
           
           routines.selectionStyle = .none

           // 루틴 입력완료 시 테이블 셀 edit 상태로 바꾸기
           if routineEditState == true {
               routines.editBtn.isHidden = false
               routines.deleteBtn.isHidden = false
    
           } else {
               routines.editBtn.isHidden = true
               routines.deleteBtn.isHidden = true
           }
           return routines
       }
       }
   }





}


//MARK: - UITableViewButtonSelectedDelegate

extension AddRoutineViewController: routineTableViewButtonSelectedDelegate {



    //MARK: - AlarmTableViewCell 델리게이트

    func backToCalendarDidTapped() {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "routineReload"), object: nil)
    }
    
    func editButtonDidTapped() {
        print("edit")
    }
    
    func changeToDontTextBottomSheet2() {
        routineEditState = false
        
        guard let vcName = UIStoryboard(name: "AddRoutineVC", bundle: nil).instantiateViewController(identifier: "RoutineTextViewController") as? RoutineTextViewController else {return}

        vcName.modalPresentationStyle = .overCurrentContext
        vcName.firstEditState = true
        self.present(vcName, animated: true)
    }
    
    func changeEdidState() {
        routineEditState = false
    }


    //MARK: - RoutineTableViewCell 델리게이트
    
    //수정버튼 눌렀을 때 -> 플랜 작성 바텀 시트 나오게하기
    func editPlanButtonTapped(_ routineNo: Int, _ catagoryNo: Int, _ content: String) {
        guard let vcName = UIStoryboard(name: "AddRoutineVC", bundle: nil).instantiateViewController(identifier: "RoutineTextViewController") as? RoutineTextViewController else {return}
        vcName.modalPresentationStyle = .overCurrentContext
        
        vcName.editTextState = true
        vcName.editTitleText = "루틴수정"
        vcName.catagoryNO = catagoryNo
        vcName.editContent = content
        vcName.routineNo = routineNo
        vcName.routineEditState = true

        self.present(vcName, animated: true)
    }
    
    func didTappedDeleteBtn(_ routineNo: Int) {
        deleteRoutineDataManager.deleteData(parameter: routineNo, delegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.routineEditState = true
            self.routineDataManager.getData(self)
        }
    }
    
  
    //MARK: - AddRoutineTableViewCell 델리게이트

    func changeToDontTextBottomSheet() {
        currentPage += 1
        guard let vcName = UIStoryboard(name: "AddRoutineVC", bundle: nil).instantiateViewController(identifier: "RoutineTextViewController") as? RoutineTextViewController else {return}

        vcName.modalPresentationStyle = .overCurrentContext
       
        // 📌 플랜TextView에 수정상태 true 넘겨줌
        vcName.routineEditState = true
        self.present(vcName, animated: true)
    }
    
    
}
