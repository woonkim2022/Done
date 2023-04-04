//
//  DoneVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/02.
//

import UIKit
import FSCalendar


//MARK: - API methods

extension DoneVC {
    
    //donelist get api
    func didDonelistService(_ response: donelistDataModel) {
        self.dismissIndicator()
        allDonesList = response.item?.all_dones ?? []
       // print("allDonesList\(allDonesList)")
        
        if !allDonesList.isEmpty {
            dones = allDonesList[0].dones ?? []
            todayRecordContent = allDonesList[0].today_record?.content ?? ""
            stickerNumber = allDonesList[0].today_record?.sticker_no ?? 0
            todayNumber = allDonesList[0].today_record?.today_no ?? 0
                if !dones.isEmpty {
                print("dones 배열이 있습니다.")
                doneCountImage.isHidden = false
                    noDoneImage.isHidden = true
                    noDoneInputBtn.isHidden = true
                    noDoneLabel.isHidden = true
                }
        } else if allDonesList.isEmpty {
            print("dones 배열이 없습니다.")
            stickerNumber = nil
            todayNumber = nil
            todayRecordContent = ""
            doneCountImage.isHidden = true
            noDoneImage.isHidden = false
            noDoneInputBtn.isHidden = false
            noDoneLabel.isHidden = false
            doneTextBtn.isHidden = true
              }
    
        doneTableView.reloadData()
        
        if stickerNumber == nil || todayNumber == nil  {
            stickerNumber = 0
            todayNumber = 0
        }

        // 스티커,텍스트 하나라도 없는 상태 -> cell 1개
        if stickerNumber == 0 || todayRecordContent == "" {
            cellState = false
        } else {
        // 스티커,텍스트 둘다 존재하는 상태 -> cell 2개
            cellState = true
        }
        
        // 스티커, 텍스트 하나도 없는 경우 입력 유도 메시지 출력
        if stickerNumber == 0 && todayRecordContent == "" {
            todayRecordMessage.isHidden = false
        } else {
            todayRecordMessage.isHidden = true
        }

        //테이블뷰 동적높이로 바꿔주기
       DispatchQueue.main.async {
           self.todayRecordTableViewHeight.constant = self.todayRecordTableView.contentSize.height
      }
     
  
        todayRecordTableView.reloadData()
        
    }
    
    //donecount get api
    func didDoneCountService(_ response: doneCountDataModel) {
        doneCounts = response.item?.date_details ?? []  //date & count 받아오는 result
        
        for i in doneCounts {
            if i.count ?? 0 < 10 {
                testDict.updateValue(String(i.count ?? 0) , forKey: i.date ?? "")
            }
        }
        
        // count label에 적용
        for (key,value) in testDict{
            if fommetDate ?? "" == key {
                print("오늘날짜 \(fommetDate)")
                countLB.text = value
            }
        }
    }
}

class DoneVC: UIViewController {
    
    //MARK: - Properties
    lazy var dataManager: donelistService = donelistService()
    lazy var patchDataManager: donePatchService = donePatchService()
    lazy var deleteDataManager: doneDeleteService = doneDeleteService()
    lazy var countDataManager: doneCountService2 = doneCountService2()
    
    
    @IBOutlet weak var countLB: UILabel!
    
    @IBOutlet weak var todayRecordTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayRecordMessage: UILabel!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var doneCountLb: UILabel!
    @IBOutlet weak var doneCountImage: UIImageView!
    @IBOutlet weak var doneTextBtn: UIButton!
    @IBOutlet weak var doneTableView: UITableView!
    @IBOutlet weak var todayRecordTableView: UITableView!
    
    @IBOutlet weak var noDoneInputBtn: UIButton!
    @IBOutlet weak var noDoneLabel: UILabel!
    @IBOutlet weak var noDoneImage: UIImageView!
    @IBOutlet weak var noDoneMessage: UILabel!

    @IBOutlet weak var nextDateBtn: UIButton!
    
    var itemImageFile = ["카테고리운동","카테고리업무"] // 카테고리 이미지 파일
    lazy var popupBackgroundView: UIView = UIView() //bottom sheet 배경 view
    
    // 날짜 변수
    var date: String! //"YY.LL.dd"
    var fommetDate: String!//  "yyyy-MM-dd"
    var fommetDate2: String! // "yyyy-MM"
    var fommetDate3: String! // "yyyy-MM"

    
    //데이터 포메터 변수
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()

    private var currentPage: Date?
    var selectedDate =  Date()
    
    private lazy var today: Date = { return Date()
    }()
    

    // 데이터 모델
    var allDonesList : [AllDone] = []
    var dones: [Done] = [] //donelist response datamodel
    var doneCounts: [DateDetail] = [DateDetail]() //Donecount 데이터모델
    var testDict: [String: String] = [:] //Donecount -> date : count
    
    var todayRecord : [TodayRecord] = []
  
    private var todayRecordContent: String = ""
    private var stickerNumber: Int? = nil
    private var todayNumber: Int? = nil

    
    private var currentTable: Int = 1
    private var page: Int = 100000
    
    //done count N번째 필요 변수
    let nums = [0: "첫",1: "두", 2: "세",3: "네",4:"다섯",5:"여섯",6:"일곱",7:"여덟"]
    var stickerImages = ["","첫 한마디","한눈에 쏙!","소확던(Done)","나만의 습관","나만의 플랜","플랜X10","해냄이 1일차","작심삼일 극복","30일 해냄","DONE100","꾸준함의 힘","다시 시작!","휴식도 필요해","해냄 홀릭","","","",""]
    
    private var counts: Int = 0
    var doneTitleNumber = ""
    var editDoneTitleNumber = ""
    
    
    var cellState: Bool?
    var defaultCellState = false
    
    var mainvc = CalendarVC()
    
    //MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if UserDefaults.standard.bool(forKey: "donelistTutorial") == true {
            print("튜토리얼이 아닙니다")
        } else {
            appTutorial()
        }
    

        print("DoneVC ->>>>>>>> viewDidLoad")
 
        addKeyboardNotifications()
        
        style()
        notificationMethod()
        doneTableView.reloadData() // tableview reload
        // disappearShadowView()
        
        // API 호출
        dataManager.getData(self) //get api 호출
        countDataManager.getData(fommetDate2, self) // donecount api 호출
        // patchDataManager.patchData(donePatchDataModel, delegate: self) //patch api 호출
        
         //테이블뷰 동적높이로 바꿔주기
        DispatchQueue.main.async {
            self.todayRecordTableViewHeight.constant = self.todayRecordTableView.contentSize.height
            
    }
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DoneVC ->>>>>>>> viewDidAppear")
        dataManager.getData(self) //get api 호출
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DoneVC ->>>>>>>> viewWillAppear")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    
    //MARK: - Actions
    
    // 이전 날짜로 넘어가기
    @IBAction func prevBtnTapped(_ sender: UIButton) {
        nextDateBtn.isUserInteractionEnabled = true
        selectedDate = selectedDate.adjust(.day, offset: -1)
        dateFormatter.dateFormat = "YY.LL.dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateLabel.text = dateFormatter.string(from: selectedDate)
        
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        fommetDate = dateFormatter2.string(from: selectedDate)
  
        dateFormatter3.dateFormat = "yyyy-MM"
        fommetDate3 = dateFormatter3.string(from: selectedDate)

        //api
        dataManager.getData(self) //get api 호출
        countDataManager.getData(fommetDate3, self)
        print("dateFormatter.dateFormat ----> \(fommetDate3)")
        print("selectedDate----> \(selectedDate)")

        

    }
    
    // 다음 날짜로 넘어가기
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        
        selectedDate = selectedDate.adjust(.day, offset: +1)
        dateFormatter.locale = Locale(identifier: "ko_KR")

        dateFormatter.dateFormat = "YY.LL.dd"
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        dateFormatter3.dateFormat = "yyyy-MM"
        
        fommetDate = dateFormatter2.string(from: selectedDate)
        fommetDate3 = dateFormatter3.string(from: selectedDate)

        if selectedDate > today {
        nextDateBtn.isUserInteractionEnabled = false
        self.presentBottomAlert(message: "   오늘 이후의 날짜는 아직 작성할 수 없어요   ")
            
        } else {
        nextDateBtn.isUserInteractionEnabled = true
        dataManager.getData(self) //get api 호출
        dateLabel.text = dateFormatter.string(from: selectedDate)
        countDataManager.getData(fommetDate3, self)
        }
     
    }
    
    
    
    @IBAction func changeToPlanVC(_ sender: UIButton) {
        guard let vcName = UIStoryboard(name: "PlanVC", bundle: nil).instantiateViewController(identifier: "PlanViewController") as? PlanViewController else {return}
        vcName.fommetDate = fommetDate
        self.navigationController?.pushViewController(vcName, animated: true)
    }
    //
    
    @IBAction func backButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fommetdateChanged"), object: fommetDate2)
        self.navigationController?.popViewController(animated: true)
        
    }

                                      
    // donelist 작성 창 전환
    @IBAction func sortButton(_ sender: Any) {
        // popupBackgroundView.animatePopupBackground(true)
        
        guard let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "DoneTextVC") as? DoneTextVC else {return}
        
        vcName.modalPresentationStyle = .overCurrentContext
        vcName.fommetDate = fommetDate
        vcName.doneListCount = doneTitleNumber
        print(fommetDate ?? "")
        
        self.present(vcName, animated: true)
    }
    
    
    // 오늘의 한마디 작성 창 전환
    @IBAction func todayRecordChangeBtn(_ sender: Any)  {
        guard let vcName = UIStoryboard(name: "TodayRecordStoryboard", bundle: nil).instantiateViewController(identifier: "TodayRecordVC") as? TodayRecordVC else {return}
        
        vcName.textContent = todayRecordContent
        vcName.fommetDate = fommetDate
        vcName.stickerNumber = stickerNumber
        vcName.todayNumber = todayNumber ?? 0

        print("todayRecordContent ---> \(todayRecordContent)")
        print("stickerNumber ---> \(stickerNumber)")
        
        self.navigationController?.pushViewController(vcName, animated: true)
        
    }
    
    
    @IBAction func clickedNoDoneBtn(_ sender: Any) {
        noDoneImage.isHidden = true
        noDoneInputBtn.isHidden = true
        noDoneLabel.isHidden = true
        noDoneMessage.isHidden = false
        doneTextBtn.isHidden = false
    }
    
    
    
    
    //MARK: - Helpers
    
    func appTutorial() {
        
        let storyBoard = UIStoryboard(name: "guideStoryboard", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "DonelistGuideVC") as? DonelistGuideVC {
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    func notificationMethod() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(afterPlanDataReceived),
                                               name: NSNotification.Name(rawValue: "afterPlanDoneTableReload"),
                                               object: nil)
        
        // 던리스트 작성 시 테이블뷰 reloaddata 노티피케이션 매소드
        // -> tableview 갱신 + get api 호출시키기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dataReceived),
                                               name: NSNotification.Name(rawValue: "notificationName"),
                                               object: nil)
      
        // 바텀시트 창 닫기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissBottomsheet),
                                               name: .init("BottomsheetClose"),
                                               object: nil)
    }
    
    
    @objc func dismissBottomsheet(_ notification: Notification) {
        popupBackgroundView.animatePopupBackground(false)
    }
    
    // 테이블뷰 리로드 notificationcenter methods
    @objc fileprivate func dataReceived() {
        print("donevc - datarecived")
        dataManager.getData(self)
        countDataManager.getData(self.fommetDate2, self)
        
        self.doneTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTitleLb"), object: self.doneTitleNumber)
        }
    }
    
    
    // notificationcenter methods
    @objc fileprivate func afterPlanDataReceived() {
        print("donevc - datarecived")
        dataManager.getData(self)
        self.doneTableView.reloadData()
        
    }
    

    
    // 디자인 속성 매소드
    func style() {
        self.dateLabel.text = date
        planBtn.blueLineSet()
        
        todayRecordTableView.delegate = self
        todayRecordTableView.dataSource = self
        
        doneTableView.delegate = self
        doneTableView.dataSource = self
        
        todayRecordMessage.isHidden = true
        noDoneMessage.isHidden = true

    }
    
    // N번째 donelist 라벨 적용 매소드
    func setDoneCount(){
        for (key,value) in nums{
            if counts == key {
                doneTitleNumber = value
            }
        }
    }
    
    func addKeyboardNotifications(){
        self.myScrollView.scrollRectToVisible(CGRect(x: 100, y: 0, width: 1, height: 1), animated: true)
    }

 
   
    
}



//MARK: -  UITableViewDelegate, UITableViewDataSource

extension DoneVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == doneTableView {
            noDoneMessage.isHidden = true
            counts = dones.count
            setDoneCount()   // N번째 donelist Count 라벨 적용
            
        
            if allDonesList.isEmpty {
                self.doneCountImage.isHidden = true
//                noDoneImage.isHidden = false
//                noDoneInputBtn.isHidden = false
//                noDoneLabel.isHidden = false
                counts = 0
                setDoneCount()
                return 0
            }

            
            if dones.count == 8 {
                print("던리스트 8개입니다")
                doneTextBtn.isHidden = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "donelist8"), object: nil)
            } else {
                doneTextBtn.isHidden = false
            }
            
            return dones.count
            
        } else if tableView == todayRecordTableView {
            if cellState == true  {
                return 2
            } else if cellState == false {
                self.todayRecordTableViewHeight.constant = 130
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == todayRecordTableView {
            if stickerNumber == 0 && todayRecordContent == ""  {
                guard let textCell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
                textCell.selectionStyle = .none
                textCell.todayRecordContent.text = todayRecordContent
                
                return textCell
            }
            
        if todayRecordContent == "" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "StickerTableViewCell", for: indexPath) as? StickerTableViewCell else { return UITableViewCell() }
                  cell.stickerImage.image = UIImage(named: stickerImages[stickerNumber ?? 0])
                 self.todayRecordTableViewHeight.constant = 130
                cell.selectionStyle = .none
                return cell
            } else if stickerNumber == 0  {
                guard let textCell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
                textCell.selectionStyle = .none
                textCell.todayRecordContent.text = todayRecordContent
                
                return textCell
        
            }
            
            else if stickerNumber != 0 && todayRecordContent != ""  {
                
                switch indexPath.row {
                case 0 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StickerTableViewCell", for: indexPath) as! StickerTableViewCell
                    cell.stickerImage.image = UIImage(named: stickerImages[stickerNumber ?? 0])
                    cell.selectionStyle = .none
                    return cell
                case 1 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
                    cell.selectionStyle = .none
                    cell.todayRecordContent.text = todayRecordContent
                    
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
                    cell.selectionStyle = .none
                    cell.todayRecordContent.text = todayRecordContent
                    
                    return cell
                }
            } else {
                return UITableViewCell()
            }
        } else  {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoneTableViewCell", for: indexPath) as? DoneTableViewCell else {  return UITableViewCell() }
            let done = dones[indexPath.row]
            cell.row = indexPath.row
            cell.delegate = self
            cell.doneLabel?.text = done.content
            cell.catagoryImage.image = UIImage(named: "\(done.category_no ?? 0)")
            cell.setCardDatas(doneNo: dones[indexPath.row].done_no ?? 0,
                              catagoryNo: dones[indexPath.row].category_no ?? 0,
                              content: dones[indexPath.row].content ?? "" )
            //print("테이블뷰 안에서 돌고있는 done \(done)")
            
            if dones.isEmpty {
                doneCountImage.isHidden = true
                noDoneImage.isHidden = false
                noDoneInputBtn.isHidden = false
                noDoneLabel.isHidden = false
                doneTextBtn.isHidden = true
            } else {
                doneCountImage.isHidden = false
                noDoneImage.isHidden = true
                noDoneInputBtn.isHidden = true
                noDoneLabel.isHidden = true
                doneTextBtn.isHidden = false
            }
            
            return cell
        }
    }
    

    
}

    extension DoneVC: donelsitTableViewButtonSelectedDelegate {
        
        func didTappedEditBtn(_ doneNo: Int, _ catagoryNo: Int, _ content: String, _ row: Int) {
            
            //1. 해당 던리스트 content 텍스트창에 들어가게
            //2. 카테고리
            for (key,value) in nums{
                if row == key {
                    editDoneTitleNumber = value
                }
            }
            
            guard let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "DoneTextVC") as? DoneTextVC else {return}
            
            vcName.modalPresentationStyle = .overCurrentContext
            vcName.editTextState = true
            vcName.fommetDate = fommetDate
            vcName.editDoneListCount = editDoneTitleNumber
            vcName.editContent = content
            vcName.catagoryNO = catagoryNo
            vcName.cellRow = row
            vcName.doneNo = doneNo
            
            self.present(vcName, animated: true)
            
        }
        
        
        // donelist 삭제
        func didTappedDeleteBtn(_ doneNo: Int) {
            deleteDataManager.deleteData(parameter: doneNo, delegate: self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.dataManager.getData(self) //donelist get api 호출
                self.countDataManager.getData(self.fommetDate2, self)
                print("삭제삭제\(self.fommetDate2)")
                
            }
        }
        
        func editDropdownState() {
            print("수정삭제 dropdown 버튼 나오게하기")
            
        }
        
    }
    


extension DoneVC{
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -200)
                }
            )
        }
    }
}
