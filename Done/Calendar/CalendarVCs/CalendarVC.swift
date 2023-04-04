//
//  CalendarVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/23.
//

import UIKit
import FSCalendar
import SnapKit
import Toast_Swift

// get 조회 api -> success methods
extension CalendarVC {

    //MARK: - countDataManager 성공 메서드
    
    //메소드 이름 변경
    func didDoneCountService(_ response: doneCountDataModel) {
        totalCount = response.item?.total_count ?? 0 //
        doneCounts = response.item?.date_details ?? []  //date & count 받아오는 result
        print("dateCounts -----> \(doneCounts.count)")
        doneDateCount.dateCounts = doneCounts.count
        userDefaults.set(doneDateCount.dateCounts, forKey: "dateCounts")
        
         doneTotalCountLb.text = String("이번달 Done \(totalCount)개 👍🏻")
        
        // 📣 api로부터 date,count를 켈린더 셀의 날짜와 매칭시켜 나타내주는 방법
        // 📌 캘린더 날짜에 맞는 count를 나타내주기 위해 빈배열에 count, date 추가
        for i in doneCounts {
            if i.count ?? 0 < 9 {
                datelist.append(i.date ?? "") // 날짜 배열
                testDict.updateValue(String(i.count ?? 0) , forKey: i.date ?? "") //딕셔너리
            }
        }
        

        print("datelist------>\(datelist)")
        print(testDict)
        //stringCountlist = Array(countlist).map {String($0)}
        
        let attributedStr = NSMutableAttributedString(string: doneTotalCountLb.text!)
        attributedStr.addAttribute(.foregroundColor, value: orangeColor, range: (doneTotalCountLb.text! as NSString).range(of: "\(totalCount)"))
        attributedStr.addAttribute(.font, value: fontSize, range: (doneTotalCountLb.text! as NSString).range(of: "\(totalCount)"))
        doneTotalCountLb.attributedText = attributedStr
          
        calendarView.reloadData()
    }
    
    //MARK: - newStickerDataManager 성공 메서드
     
    func didNewStickerService(_ response: newStickerDatamodel) {
        
        //viewdidappear에도 추가하기
        stickerList =  response.item?.stickers ?? []
        print(stickerList)
        
        // 스티커 획득 시 팝업창 나오게 하기
        if !stickerList.isEmpty {
            let storyBoard = UIStoryboard(name: "StickerStoryboard", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "getStickerPopupVC") as? getStickerPopupVC {
                vc.stickerName = stickerList[0].name ?? ""
                vc.stickerExplain = stickerList[0].explanation ?? ""
                vc.stickerNo = stickerList[0].sticker_no ?? 0
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func didStickerService(_ response: myStickerDataModel) {
        myStickerList =  response.item?.stickers ?? []
        
        for i in myStickerList {
            stickername.append(i.name ?? "")
        }
    
        print("stickername \(stickername)")
    }
}




class CalendarVC: UIViewController {
        
    //MARK: - Data Properties
    
    lazy var countDataManager: doneCountService = doneCountService()
    lazy var doneListDataManager: donelistService2 = donelistService2()
    lazy var newStickerDataManager: newStickerService = newStickerService()
    lazy var getDataManager: myStickerService2 = myStickerService2()
    lazy var checkStickerDataManager: checkStickerService = checkStickerService()


    let userDefaults = UserDefaults()
    let defaults = UserDefaults.standard
    
    // donecount 데이터 변수
    var totalCount : Int = 0
    var doneCounts: [DateDetail] = [DateDetail]() //donelist response datamodel
    var dateCounts: [AllDone] = [AllDone]()
    var dateCount: Int = 0
    var testDict: [String: String] = [:] //이번달
    var lastDict: [String: String] = [:] //지난달
    
    fileprivate var datelist = [String]()
    fileprivate var lastMonthDatelist = [String]()
    fileprivate var countlist: [Int] = []
    fileprivate var stringCountlist: [String] = [] // string으로 변환한 countlist
    
    // sticker 데이터 변수
    var stickerList : [NewStickerlist] = []
    var stickername = [String]()
    var myStickerList : [MyStickerlist] = []
   
    //MARK: - Outlets
    
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet weak var headerLb: UILabel!
    @IBOutlet weak var stickerBtn: UIButton!
    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var doneTotalCountLb: UILabel!
    @IBOutlet weak var dateStackview: UIStackView!
    @IBOutlet weak var calendarBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var ddd: UILabel!
    
    var membertype: String = ""
    let gregorian = Calendar(identifier: .gregorian)
    
    let dateFormatter = DateFormatter()  //데이터 포멧터 생성
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var selectedDate = Date()

    var countDate = Date()
    
    var backDate: String!
    var backState = false
    
    var fommetDate: String? = nil
    var fommetDate2: String? = nil

    
    let orangeColor = UIColor(red: 255/255, green: 107/255, blue: 0/255, alpha: 1.0)
    let fontSize = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
    
    // Date() 자료형으로 인스턴스를 생성하면 현재 날짜와 시간을 반환
    // 이때 얻은 Date는 "2020-08-13 09:14:48 +0000" 이러한 형태로 넘어온다.
    private var currentPage: Date?
    
    private lazy var today: Date = { return Date()
    }()
    
    // fscalendar 년도/월 헤더 설정
    private lazy var headerDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR") // ko_KR 한국 기준의 시간
        df.dateFormat = "YY.LL"
        return df
   
    }()
    
    // fscalendar 년도/월 헤더 설정
    private lazy var countDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR") // ko_KR 한국 기준의 시간
        df.dateFormat = "yyyy-MM"
        return df
       }()

  
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        if UserDefaults.standard.bool(forKey: "jtypeTutorial") == true || UserDefaults.standard.bool(forKey: "PTypeTutorial") == true  {
            print("튜토리얼이 아닙니다")
        } else {
            appTutorial() //회월탈퇴, 로그아웃 때 제거하기
            print("튜토리얼이 맞습")
        }
    
       
        //api 호출
        countDateSetup()
        newStickerDataManager.getData(self)
        getDataManager.getData(self)
        
        //캘린더 delegate
        calendarView.delegate = self
        calendarView.dataSource = self
        
        //디자인,기능 세팅
        setCalendar()
        setCalendarStyle() //캘린더 디자인 속성 정의 메소드
        style() // 버튼 커스텀 매소드
        setupMainLayout()
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCalendar()

        // donelist 삭제,추가 실시간 배열 반영
//        datelist.removeAll()
//        testDict.removeAll()
        print("viewWillAppear")
        
        // donevc -> calendarvc로 왔을 때, 현재 달로 get api 요청
        NotificationCenter.default.addObserver(self, selector: #selector(changeFommetdate),  name: NSNotification.Name(rawValue: "fommetdateChanged"),  object: nil)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        newStickerDataManager.getData(self)

    }
    
    
    @objc fileprivate  func toast() {
     print("ddd")
       
    }
    
    
    
    func setupMainLayout() {
        view.addSubview(dateStackview)
        view.addSubview(calendarView)
        
        if UIDevice.current.isiPhoneSE2{
            dateStackview.snp.makeConstraints { make in make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43)
                make.centerX.equalToSuperview()
            }
            calendarView.snp.makeConstraints { make in
                make.top.equalTo(225)
            }
            calendarBottomAnchor.constant = 1
            
        }  else {
            dateStackview.snp.makeConstraints { make in make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(108)
                make.centerX.equalToSuperview()
            }
            calendarView.snp.makeConstraints { make in
                make.top.equalTo(350)
            }
            calendarBottomAnchor.constant = 50
        }
        
        if UIDevice.current.isiPhone12mini {
            dateStackview.snp.makeConstraints { make in make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(108)
                make.centerX.equalToSuperview()
            }
            calendarView.snp.makeConstraints { make in
                make.top.equalTo(320)
            }
            calendarBottomAnchor.constant = 30
        }
        
    }
    
    
    
    
    @objc fileprivate func changeFommetdate(_ notification: Notification) {
      
        if let fommetdate = notification.object as? String {
            backDate = fommetdate
            countDataManager.getData(backDate, self)
        }
    }
    
    
    @objc fileprivate func caelndargetdata()
  {
      countDateSetup()
  }
    //MARK: - Actions
    
    // 이전 달로 스와이프 버튼 액션 메서드
    @IBAction func prevBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: true)
      // datelist.removeAll()
    }
    
    // 다음 달로 스와이프 버튼 액션 메서드
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: false)
      // datelist.removeAll()
    
    }
    
    // my탭 페이지로 이동
    @IBAction func changToMyVC(_ sender: UIButton) {
        guard let vcName = UIStoryboard(name: "MyVC", bundle: nil).instantiateViewController(identifier: "MyVC") as? MyVC else {return}
        
        self.navigationController?.pushViewController(vcName, animated: true)
    }
    
    
    // 스티커 탭 페이지로 이동
    @IBAction func changToStickerVC(_ sender: UIButton) {
        guard let vcName = UIStoryboard(name: "StickerStoryboard", bundle: nil).instantiateViewController(identifier: "StickerVC") as? StickerVC else {return}
        vcName.stickername = stickername
        self.navigationController?.pushViewController(vcName, animated: true)
    }

    
    //MARK: - Helpers
    
    
    func appTutorial() {
        if let value = UserDefaults.standard.value(forKey: "userType") as? String {
            print("membertype-----------\(value)")
            if value == "j" {
                print("j입니다")
                let storyBoard = UIStoryboard(name: "guideStoryboard", bundle: nil)
                if let vc = storyBoard.instantiateViewController(withIdentifier: "JTypePopupVC") as? JTypePopupVC {
                    
                    dateFormatter.dateFormat = "YY.LL.dd"
                    let string = dateFormatter.string(from: today)
                    
                    dateFormatter2.dateFormat = "yyyy-MM-dd"
                    fommetDate = dateFormatter2.string(from: today)
                    
                    dateFormatter3.dateFormat = "yyyy-MM"
                    fommetDate2 = dateFormatter3.string(from: today)
                    
                    
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.fommetDate = fommetDate
                    vc.fommetDate2 = fommetDate2
                    vc.datefommet = string
                    self.present(vc, animated: true, completion: nil)

                }
            } else {
                print("p입니다")

                let storyBoard = UIStoryboard(name: "guideStoryboard", bundle: nil)
                if let vc = storyBoard.instantiateViewController(withIdentifier: "pTypePopupVC") as? pTypePopupVC {
                    
                    dateFormatter.dateFormat = "YY.LL.dd"
                    let string = dateFormatter.string(from: today)
                    
                    dateFormatter2.dateFormat = "yyyy-MM-dd"
                    fommetDate = dateFormatter2.string(from: today)
                    
                    dateFormatter3.dateFormat = "yyyy-MM"
                    fommetDate2 = dateFormatter3.string(from: today)
                    
                    
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.fommetDate = fommetDate
                    vc.fommetDate2 = fommetDate2
                    vc.datefommet = string
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    // 현재 달에서 total count 보여주기
    func countDateSetup() {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM"
        let dateStr = df.string(from: date)
 
        countDataManager.getData(dateStr, self)
    }
    

    
    // 디자인 속성 매소드
    func style() {
        stickerBtn.lineSet()
        myBtn.lineSet()
        myBtn.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(stickernameGet), name: NSNotification.Name(rawValue: "stickernameGet"), object: nil)
    }

    @objc fileprivate func stickernameGet() {
        newStickerDataManager.getData(self)
    }
    
    // 버튼을 이용해 페이지 이동 함수
    private func scrollCurrentPage(isPrev: Bool) {
        
        // Calendar.current를 사용해, 현재 사용하고 있는 달력을 확인
        let cal = Calendar.current
        
        //DateComponents 인스턴스를 만들어서 새로운 날짜를 만들고 날짜 계산을 할 수 있다.
        var dateComponents = DateComponents()
        
        //currentPage를 dateComponent.month에 -1 또는 1을 더해주면서 현재 페이지를 설정
        dateComponents.month = isPrev ? -1 : 1
        
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
        
        let string2 = self.countDateFormatter.string(from: calendarView.currentPage)
        countDataManager.getData(string2, self) //donelistService get api 호출
        
    }

  
    
    // MARK: - Calendar Set Functions
    
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.headerHeight = 0 //헤더 높이 0으로 만들기
        calendarView.scope = .month
        // 헤더 라벨의 텍스트를 캘린더 뷰의 현재 페이지의 date로 설정해서 초기화
        let string = self.headerDateFormatter.string(from: calendarView.currentPage)
        headerLb.text = string
        
        // 'CalendarCell' 캘린더 셀 등록
        calendarView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        
    }
    

    
    //캘린더 디자인 속성 정의 메소드
    func setCalendarStyle() {
        calendarView.locale = Locale(identifier: "ko_KR") //언어 한국어로 변경
        calendarView.appearance.weekdayFont = UIFont(name: "SpoqaHanSansNeo-Regular", size: 15) //요일 폰트 변경
        calendarView.appearance.titleFont = UIFont(name: "SpoqaHanSansNeo-Regular", size: 15)
        // 달력의 평일 날짜 색깔
        calendarView.appearance.titleDefaultColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1.0)
        calendarView.appearance.titlePlaceholderColor = .lightGray
        // 달력의 토,일 날짜 색깔
        calendarView.appearance.titleWeekendColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1.0)
        
        calendarView.today = nil
        // 뷰 전환되고 다시 돌아왔을 때, 날짜 title color 그대로
        
        calendarView.placeholderType = .fillHeadTail
        calendarView.weekdayHeight = 20
        calendarView.headerHeight = 10
        
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleSelectionColor = nil
        calendarView.allowsMultipleSelection = false
        
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        }


    
    // 현재 페이지가 변환되면 헤더 라벨의 텍스트를 갱신
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.headerLb.text = self.headerDateFormatter.string(from: calendar.currentPage)
        
    }
    

}
    


// MARK: - fscaelndar Methods

extension CalendarVC:  FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    

    
    // 지정된 셀이 캘린더에에 표시되려고 함을 델리게이터에게 전달
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let customCell = cell as? CalendarCell else {
            return
        }
        customCell.cellDate = date
    }
    
    
    // 캘린더 셀 등록
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: "CalendarCell",
            for: date,
            at: position
        ) as? CalendarCell else { return FSCalendarCell() }

        configure(cell: cell, for: date, at: position)
        
        cell.cellDate = date
        return cell
    }

  
    // 📌 캘린더 셀에 사용자가 해낸 done count를 나타내주기 위한 메서드
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let cell = cell as? CalendarCell else { return }

        var selectedType = SelectionType.none
        let formattedDate = date.toString(of: .year)
        
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        // Calendar.current를 사용해, 현재 사용하고 있는 달력을 확인
        let cal = Calendar.current
        
        //DateComponents 인스턴스를 만들어서 새로운 날짜를 만들고 날짜 계산을 할 수 있다.
        var dateComponents = DateComponents()
        
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
        
        let string2 = self.dateFormatter2.string(from: calendarView.currentPage)
        
        // 📌 빈 배열(datelist)의 날짜와 딕셔너리의 날짜가 같은지 확인
        if datelist.contains(formattedDate) {
            // datelist 배열이 요소의 count만큼 반복된다
            // datelist 배열의 요소(날짜)의 값과 testdict key값이 일치하는 날에만 text label 적용하게끔
            
            for(key,value) in testDict {
                if formattedDate == key { //datelist 날짜와 testdict key값의 날짜가 같다면

                    cell.countLabel.text = "\(value)" // 셀의 label에 testdict value값을 넣어준다
                    selectedType = .single
                    
                    if key > string2 {
                        print("이후임 \(key) \(string2)")
                    }
              }
            }
         }
        
        cell.selectionType = selectedType
        }
    
    
    
    // 캘린더 날짜 선택했을 때, 콜백 메소드
    // 선택한 날짜,요일,오전/오후 출력
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        
        if selectedDate > today {
            print("")
            
        } else {
            guard let vc = self.storyboard?.instantiateViewController(identifier: "DoneVC") as? DoneVC else { return }
            
            // 날짜를 원하는 형식으로 저장하기 위한 방법
            dateFormatter.dateFormat = "YY.LL.dd"
            let string = dateFormatter.string(from: date)
            vc.date = dateFormatter.string(from: date)

            dateFormatter3.dateFormat = "yyyy-MM"
            let string3 = dateFormatter.string(from: date)
            print("\(string3)")
            vc.fommetDate2 = dateFormatter3.string(from: date)
            
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            let string2 = dateFormatter2.string(from: date)
            print("전달해야하는 날짜 -> \(string2)")
            vc.fommetDate = dateFormatter2.string(from: date)
            
            vc.selectedDate = selectedDate
            

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool
    
    {
        selectedDate = date
        
        if selectedDate > today
        {
            self.presentBottomAlert(message: "   오늘 이후의 날짜는 아직 작성할 수 없어요   ")
            print("오늘 이후의 날짜입니다.")
            return false
        } else
        {
            
            return true
        }
    }

}

extension CalendarVC: calendarDelegate {
    func changeToCountLb() {
        print("ddd")
    }
    

    
}

//        // 특정 날짜에 이미지 세팅
//        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//
//            let imageDateFormatter = DateFormatter()
//            imageDateFormatter.dateFormat = "yyyy-MM-dd"
//            let dateStr = imageDateFormatter.string(from: date)
//
//            let stickerImage = UIImage(named: "스티커")
//            let resizeImage = stickerImage?.resized(toWidth: 28)
//
//            return datelist.contains(dateStr) ? resizeImage : nil
//            }
//
//
        
