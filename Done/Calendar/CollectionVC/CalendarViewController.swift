//
//  CalendarViewController.swift
//  Done
//
//  Created by 안현정 on 2022/02/28.
//

import UIKit

protocol CalendarViewControllerDeleagte {
    func didSelectDate(dateString: String)
}

class CalendarViewController: UIViewController {

    static let identifier: String = "CalendarVC"
    
    var totalDates = [String]()
    // 캘린더
    var index: IndexPath? // 오늘 날짜 인덱스 저장 변수
    var nextDate : Int = 0 // 다음 날짜 초기화
    var returnvalue: Int = 0
    var months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0 //(일-토: 1-7)
    var lastWeekDayOfMonth = 0
    var currentMonthIndexConstant = 0
    var delegate: CalendarViewControllerDeleagte?

    @IBOutlet weak var dateCollectionView: UICollectionView!

    // Button settings
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!


    // calendarView 전체 모양 설정
    @IBOutlet weak var calendarView: UIView! {
        didSet {
            calendarView.layer.cornerRadius = 20
            calendarView.layer.shadowRadius = 10
            calendarView.layer.shadowColor = UIColor.gray.cgColor
            calendarView.layer.shadowOffset = CGSize(width: 1, height: 1)
            calendarView.layer.shadowOpacity = 0.5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()



    }






    @IBAction func previousMonth(_ sender: Any) {
        currentMonthIndex -= 1
        self.nextDate = 0
        // 1월 전으로 가면 달 리셋
        if currentMonthIndex < 0 {
            currentMonthIndex = 11
            currentYear -= 1
        }
        monthLabel.text = "(\(currentYear)년 \(months[currentMonthIndex])"

        // 2월 일 수 처리
        if currentMonthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[currentMonthIndex] = 29
            } else {
                numOfDaysInMonth[currentMonthIndex] = 28
            }
//        }
        firstWeekDayOfMonth = getFirstWeekDay()
        dateCollectionView.reloadData()
     //   classDateList.removeAll()
    }
    }



        @IBAction func nextMonth(_ sender: Any) {
        currentMonthIndex += 1
        self.nextDate = 0
        // 12월 넘어가면 달 리셋
        if currentMonthIndex > 11 {
            currentMonthIndex = 0
            currentYear += 1
        }
        monthLabel.text = "(\(currentYear)년 \(months[currentMonthIndex])"

        // 2월 일 수 처리
        if currentMonthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[currentMonthIndex] = 29
            } else {
                numOfDaysInMonth[currentMonthIndex] = 28
            }
        }
        firstWeekDayOfMonth = getFirstWeekDay()
        dateCollectionView.reloadData()
      //  classDateList.removeAll()
    }



}



extension CalendarViewController {
    
    
    
    func setupViewControllerUI() {
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
    
    }
    
    func setupCalendar() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentMonthIndexConstant = Calendar.current.component(.month, from: Date()) // 바뀌지 않는 이번달 변수
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date()) // 오늘 날짜
        currentMonthIndex -= 1
        
        firstWeekDayOfMonth = getFirstWeekDay() //4
        lastWeekDayOfMonth = getLastWeekDay()
        print("마지막 요일", lastWeekDayOfMonth)
        
        // 2월 날짜 처리
        if currentMonthIndex == 1 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        // 현재 년, 월 타이틀에 보이기
        monthLabel.text = "(\(currentYear)년 \(months[currentMonthIndex])"
    }
    
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    func getLastWeekDay() -> Int {
        let lastDay = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.lastDayOfTheMonth.weekday)!
        return lastDay
    }
    
    
    
}



extension CalendarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarCell = CalenderCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        
        let currentMonthCalendarIndex = currentMonthIndex + 1
        let currentDateCalendarIndex = todaysDate
        print("바뀔때", currentMonthCalendarIndex, currentDateCalendarIndex)
        
            // 다음 달로 넘어가면 선택한 날짜 색 초기화
            calendarCell.dateView.backgroundColor = UIColor.white
            // 이전 달 cell 표시
            if indexPath.item <= firstWeekDayOfMonth - 2 {
                calendarCell.isHidden = false
                calendarCell.dateLabel.textColor = UIColor.red
                let prevDate = indexPath.row-firstWeekDayOfMonth+(numOfDaysInMonth[currentMonthIndex-1]+2)
                print("첫째 요일", firstWeekDayOfMonth)
                calendarCell.dateLabel.text="\(prevDate)"
                calendarCell.isUserInteractionEnabled = false
                
                calendarCell.stickerImage.image = nil
          
                
                return calendarCell
            } // 이후 달 표시
            else if indexPath.item >= firstWeekDayOfMonth + (numOfDaysInMonth[currentMonthIndex]-1) {
                
                calendarCell.dateLabel.textColor = UIColor.red
                
                calendarCell.stickerImage.image = nil
                //34
                
                // 셀이 그 배열의 달 날짜 일수와 레이블이 일치하면 그 자리의 인덱스 리턴
                // 그 인덱스 + 1 인 자리부터 1++ 해주기
                // 캘린더가 옆으로 넘어갈때, 서버에서 한번 reloadData 될때 0으로 리셋해주기
                nextDate += 1
                calendarCell.dateLabel.text = "\(nextDate)"
                calendarCell.isUserInteractionEnabled = false
                return calendarCell
            } // 이번달 표시
            else {
                let calcDate = indexPath.row-firstWeekDayOfMonth+2
                calendarCell.isHidden = false
                calendarCell.dateLabel.textColor = UIColor.black
                calendarCell.dateLabel.text="\(calcDate)"
                calendarCell.dateLabel.textColor = UIColor.black
                calendarCell.isUserInteractionEnabled = true
                calendarCell.backgroundColor = UIColor.white
                
                calendarCell.stickerImage.image = nil
          
                
                // 오늘 날짜인 셀 찾아서 셀렉해놓기
                if String(currentDateCalendarIndex) == calendarCell.dateLabel.text && String(currentMonthIndexConstant) == String(currentMonthIndex+1) {
                    calendarCell.dateView.backgroundColor = UIColor.white
                 //   calendarCell.dateView.image = UIImage(named: "dot")
                    calendarCell.dateLabel.textColor = UIColor.red
                 //   calendarCell.todayImage.image = UIImage(named: "dot")
                    // 오늘 날짜 인덱스 저장
                    self.index = indexPath
                }
            }
            
            return calendarCell
        }
    

func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? CalenderCollectionViewCell
    
    // 다른 날짜 선택 시 다시 색 원래대로 바뀌기
    // 오늘 날짜일때는 다시 보라색으로 돌아오기
    if indexPath == index {
        cell?.dateView.backgroundColor = UIColor.red
        cell?.dateLabel.textColor = UIColor.white
    } else {
        cell?.dateView.backgroundColor = UIColor.white
        cell?.dateLabel.textColor = UIColor.black
        // 클래스 리스트 한 번 초기화
        //classDateList.removeAll()
    }
    
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.dateCollectionView {
            return CGSize(width: collectionView.frame.width/7.5 , height: collectionView.frame.width/7.5 )
        } else {
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height/1.5 )
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    
    
    
    
}
