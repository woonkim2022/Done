//
//  AlarmTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    static let identifier: String = "AlarmTableViewCell"
    
    weak var delegate: routineTableViewButtonSelectedDelegate?
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var messageLb: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var addRoutineBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        style()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Helpers
    
    func style() {
        
        editBtn.lineSet()
        
        completeBtn.lineSet()
        completeBtn.backgroundColor = .black
        completeBtn.isHidden = true
        
        addRoutineBtn.isHidden = true
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.backToCalendarDidTapped()
    }
    
    
    // 📍루틴추가 버튼 눌렀을 때 -> 바텀시트 띄우기
    @IBAction func addPlanButtonTapped(_ sender: Any) {
        delegate?.changeToDontTextBottomSheet2()
    }
    
    
    // 📍네비게이션바에 편집버튼 눌렀을 때
    @IBAction func editButtonTapped(_ sender: Any) {
        //편집 버튼 눌렀을 때 루틴 추가 버튼 나타나게하기 -> AddRoutineTableViewCell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appearRoutinePlanBtn"), object: nil)
        //편집 버튼 눌렀을 때 수정,삭제 버튼 나타나게하기 -> RoutineTableViewCell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeEditDeleteBtn"), object: nil)

        editBtn.isHidden = true
        completeBtn.isHidden = false
    }
    
    // 📍네비게이션바에 완료버튼 눌렀을 때
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        //완료 버튼 눌렀을 때, 편집모드 해제하기
        delegate?.changeEdidState()
        
        //완료 버튼 눌렀을 때 루틴추가 버튼 사라지게하기-> AddRoutineTableViewCell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenRoutinePlanBtn"), object: nil)
        //완료 버튼 눌렀을 때 수정,삭제 버튼 사라지게하기 -> RoutineTableViewCell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenEditBtn"), object: nil)
        editBtn.isHidden = false
        completeBtn.isHidden = true
    }

}



