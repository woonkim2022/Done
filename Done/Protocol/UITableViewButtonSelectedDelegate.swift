//
//  UITableViewButtonSelectedDelegate.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import Foundation

protocol calendarDelegate : AnyObject {
    func changeToCountLb()

}

protocol UITableViewButtonSelectedDelegate: AnyObject {
    
    // 던리스트 작성 바텀시트로 화면전환 할 때
    func changeToDontTextBottomSheet()
    
    // 던리스트 작성 바텀시트로 화면전환 할 때
    func changeToDontTextBottomSheet2()

    // 플랜 수정할 때
    func editPlanButtonTapped(_ planNo: Int, _ catagoryNo : Int, _ content : String)
    
    
    // 이전 화면인 캘린더 화면으로 돌아가는 버튼 눌렀을 때
    func backToCalendarDidTapped()
    
    // 편집하기 버튼 눌렀을 때
    func editButtonDidTapped()
    
    // 플랜 실행할 때
    func DoneBtndidTapped(_ planNo: Int)
    
    //완료버튼 눌렀을 때 편집상태 flase로 처리
    func changeEdidState()
    
    func didTappedDeleteBtn(_ planNo: Int)

}


protocol routineTableViewButtonSelectedDelegate: AnyObject {
    
    // 던리스트 작성 바텀시트로 화면전환 할 때
    func changeToDontTextBottomSheet()
    
    // 던리스트 작성 바텀시트로 화면전환 할 때
    func changeToDontTextBottomSheet2()

    // 루틴 수정할 때
    func editPlanButtonTapped(_ routineNo: Int, _ catagoryNo : Int, _ content : String)
    
    // 이전 화면인 캘린더 화면으로 돌아가는 버튼 눌렀을 때
    func backToCalendarDidTapped()
    
    // 편집하기 버튼 눌렀을 때
    func editButtonDidTapped()
    
    
    func didTappedDeleteBtn(_ routineNo: Int)
//    // 루틴 실행할 때
//    func DoneBtndidTapped(_ routineNo: Int)
    
    //완료버튼 눌렀을 때 편집상태 flase로 처리
    func changeEdidState()

}



protocol donelsitTableViewButtonSelectedDelegate: AnyObject {
    
    // 던리스트 작성 바텀시트로 화면전환 할 때
    func editDropdownState()
    
    func didTappedDeleteBtn(_ doneNo: Int)

    func didTappedEditBtn(_ doneNo: Int, _ catagoryNo : Int, _ content : String, _ row: Int )

}



