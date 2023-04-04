//
//  PlanViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import UIKit
import Alamofire


//MARK: - ReadPlanService methods

// 📍 PLAN get 조회 api -> success methods
extension PlanViewController {
    func didReadPlanService(result: Plan) {
        
        //📍 빈배열안에 데이터 넣어줌
        planData = result.plans
        planTableView.reloadData()
    }
}


class PlanViewController: UIViewController {
    
    lazy var planDataManager: readPlanService = readPlanService()
    lazy var donePlanDataManager: donePlanService = donePlanService()
    lazy var deletePlanDataManager: planDeleteService = planDeleteService()


    //MARK: - Properties
    

    @IBOutlet weak var planTableView: UITableView!
    
    //📍 셀 버튼이 편집상태가 되지 않기 위해 만든 변수
    var planEditState = false // 버튼을 편집상태로 바꿔주는 변수
    var firstInputState = false //버튼이 완료상태일 때의 변수
    
    //📍 서버로부터 받아올 유저 plan data 빈배열
    var planData: [PlanList] = [PlanList]()
    
    var planNo : Int = 0
    var fommetDate: String? = nil
    
    private var currentPage: Int = 1
    private var page: Int = 100000
    
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("fommetDate -----> \(fommetDate)")
        
       // style()
        planDataManager.getData(self) //planDataManager get api 호출

        planTableView.rowHeight = UITableView.automaticDimension
        planTableView.separatorStyle = .none

        // 플랜 data reload -> tableview 갱신 + plan get api 업데이트
        NotificationCenter.default.addObserver(self, selector: #selector(editDataReceived),
                                               name: NSNotification.Name(rawValue: "planEditRelaodData"),
                                               object: nil)
        
        // 플랜 data reload -> tableview 갱신 + plan get api 업데이트
        NotificationCenter.default.addObserver(self, selector: #selector(doneDataReceived),
                                               name: NSNotification.Name(rawValue: "planDoneRelaodData"),
                                               object: nil)

    }
    
    
    //MARK: - Actions


    
    //MARK: - Helpers
    

    
    // notificationcenter methods
    @objc fileprivate func editDataReceived() {
        planEditState = true
        print("planVC - datarecived")
        planDataManager.getData(self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appearAddPlanBtn"), object: nil) //플랜추가 버튼 나타나면서 편집상태로 바꿔줌
    }
    
    
    
    
    // notificationcenter methods
    @objc fileprivate func doneDataReceived() {
        print("planVC - planStatemode")
        planDataManager.getData(self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doneState"), object: nil) //플랜추가 버튼 나타나면서 편집상태로 바꿔줌

    }
    
}

    //MARK: - UITableViewDataSource, UITableViewDelegate


extension PlanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            if  currentPage < page  {
                return planData.count + 1
            } else {
                return planData.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 📍 첫번째 테이블뷰 셀 (navigation tableviewcell)
        if indexPath.section == 0 {
            guard let navigation = tableView.dequeueReusableCell(withIdentifier: navigationTableViewCell.identifier, for: indexPath) as? navigationTableViewCell else { return UITableViewCell() }
                                
            navigation.delegate = self
            navigation.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            navigation.selectionStyle = .none
            navigation.addPlanBtn.isHidden = true
            
            
            if planData.count == 0 { // 📍 만약 plandata가 없다면,
                navigation.addPlanBtn.isHidden = false // '플랜추가'버튼 나타내기
                navigation.editBtn.isHidden = true // '편집'(네비게이션 버튼) 버튼 숨기기
                navigation.completeBtn.isHidden = true // '완료'(네비게이션 버튼)버튼 숨기기
            } else { // plandata가 있다면,
                navigation.editBtn.isHidden = false // '편집'버튼 나타내기
            }
            
            return navigation
        } else {

        if currentPage < page {
                    
        if indexPath.row == planData.count {
            
            guard let more = tableView.dequeueReusableCell(withIdentifier: addPlanTableViewCell.identifier,for: indexPath) as? addPlanTableViewCell else {
                return UITableViewCell() }
            
            if planData.count == 0 || firstInputState == true  {
                
                more.addPlanBtn.isHidden = true
            }
            
            more.delegate = self
            //선택 셀 구분선 없애주기
            more.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            more.selectionStyle = .none

         
            return more

        } else {
            guard let plans = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.identifier, for: indexPath) as? PlanTableViewCell else {
                return UITableViewCell() }

            plans.delegate = self
            plans.indexPath = indexPath
            let plan = planData[indexPath.row]
            plans.setCardDatas(catagoryNo: planData[indexPath.row].category_no ?? 0, planNo: planData[indexPath.row].plan_no , content: planData[indexPath.row].content)
           

            plans.selectionStyle = .none
            plans.catagoryImageView.image = UIImage(named: "\(plan.category_no ?? 0)")

            // 플랜 입력완료 시 테이블 셀 edit 상태로 바꾸기
            if planEditState == true { // 변수명 가독성 떨어짐
                plans.editBtn.isHidden = false
                plans.doneBtn.isHidden = true
                plans.deleteBtn.isHidden = false
              //  plans.catagoryImageView.isHidden = true
            } else {
                plans.editBtn.isHidden = true
                plans.doneBtn.isHidden = false
                plans.deleteBtn.isHidden = true
              //  plans.catagoryImageView.isHidden = false

            }
            return plans
        }
        } else {
            guard let plans = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.identifier, for: indexPath) as? PlanTableViewCell else {
                return UITableViewCell() }

            plans.delegate = self
            plans.indexPath = indexPath
            plans.setCardDatas(catagoryNo: planData[indexPath.row].category_no ?? 0, planNo: planData[indexPath.row].plan_no , content: planData[indexPath.row].content)
            
            plans.selectionStyle = .none

            // 플랜 입력완료 시 테이블 셀 edit 상태로 바꾸기
            if planEditState == true {
                plans.editBtn.isHidden = false
                plans.doneBtn.isHidden = true
                plans.deleteBtn.isHidden = false
            } else {
                plans.editBtn.isHidden = true
                plans.doneBtn.isHidden = false
                plans.deleteBtn.isHidden = true
            }
            return plans
        }
        }
    }

 
}



//MARK: - UITableViewButtonSelectedDelegate

extension PlanViewController: UITableViewButtonSelectedDelegate {

    //MARK: - navigationTableViewCell 델리게이트

    func backToCalendarDidTapped() {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterPlanDoneTableReload"), object: nil)
    }
    
    func editButtonDidTapped() {
        print("edit")
    }
    
    func changeToDontTextBottomSheet2() {
        
       planEditState = false //원 상태에서 플랜추가버튼 눌렀을 때. 편집상태 안되게 처리
        
        guard let vcName = UIStoryboard(name: "PlanVC", bundle: nil).instantiateViewController(identifier: "PlanTextVC") as? PlanTextVC else {return}

        vcName.modalPresentationStyle = .overCurrentContext
        vcName.firstEditState = true
        self.present(vcName, animated: true)
    }
    
    
    func changeEdidState() {
       planEditState = false
    }
    

    //MARK: - PlanTableViewCell 델리게이트
    
    //  📍 두번째 셀 삭제버튼 눌렀을 때 동작해야할 함수
    func didTappedDeleteBtn(_ planNo: Int) {
        deletePlanDataManager.deleteData(parameter: planNo, delegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.planEditState = true // '편집'상태 변수를 true로 변경
            self.planDataManager.getData(self)
        }
    }
    
    
    //수정버튼 눌렀을 때 -> 플랜 작성 바텀 시트 나오게하기
    func editPlanButtonTapped(_ planNo: Int, _ catagoryNo: Int, _ content: String) {
        guard let vcName = UIStoryboard(name: "PlanVC", bundle: nil).instantiateViewController(identifier: "PlanTextVC") as? PlanTextVC else {return}
        vcName.modalPresentationStyle = .overCurrentContext
        
        vcName.editTextState = true
        vcName.editTitleText = "플랜수정"
        vcName.catagoryNO = catagoryNo
        vcName.editContent = content
        vcName.planNo = planNo
        vcName.planEditState = true

        self.present(vcName, animated: true)
        
    }
    
    //done버튼 눌렀을 때 -> 플랜 실행
    func DoneBtndidTapped(_ planNo: Int)  {
        
        // 플랜실행 Post api datamodel
        print("done버튼 선택하였습니다")
        donePlanDataManager.postData(parameter: planNo, delegate: self)
        print("입력한 planNo -> \(planNo)")
        print("입력한 planNo -> \(planNo)")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.planDataManager.getData(self) //planDataManager get api 호출
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterPlanDoneTableReload"), object: nil)
//
        }
    }
    
  
    //MARK: - addPlanTableViewCell 델리게이트

    func changeToDontTextBottomSheet() {
        currentPage += 1
        guard let vcName = UIStoryboard(name: "PlanVC", bundle: nil).instantiateViewController(identifier: "PlanTextVC") as? PlanTextVC else {return}

        vcName.modalPresentationStyle = .overCurrentContext
       
        // 📌 플랜TextView에 수정상태 true 넘겨줌
        vcName.planEditState = true
        self.present(vcName, animated: true)
    }
    
    
}
