//
//  navigationTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/15.
//

import UIKit


class navigationTableViewCell: UITableViewCell {
    static let identifier: String = "navigationTableViewCell"
    
    weak var delegate: UITableViewButtonSelectedDelegate?
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var messageLb: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var addPlanBtn: UIButton!

        
    override func awakeFromNib() {
        super.awakeFromNib()

        style()
        
        NotificationCenter.default.addObserver(self,
                                                       selector: #selector(hiddenNavigationBtn),
                                                       name: NSNotification.Name(rawValue: "hiddenNavigationBtn"),
                                                       object: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK: - Helpers
    
    @objc fileprivate func hiddenNavigationBtn() {
        completeBtn.isHidden = true
        
    }
      
    
    func style() {
        
        
        editBtn.lineSet()
        
        completeBtn.lineSet()
        completeBtn.backgroundColor = .black
        completeBtn.isHidden = true
        
        addPlanBtn.isHidden = true
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.backToCalendarDidTapped()
    }
    
    
    @IBAction func addPlanButtonTapped(_ sender: Any) {
        delegate?.changeToDontTextBottomSheet2()
    }
    
    
    // 📍 편집버튼 action method
    @IBAction func editButtonTapped(_ sender: Any) {
        
        //편집 버튼 눌렀을 때 두번째 셀의 '수정','삭제' 버튼 나타나게하기 (PlanTableViewCell)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeEditBtn"), object: nil)
        
        //편집 버튼 눌렀을 때 세번째 셀의 '플랜추가' 버튼 나타나게하기 (addPlanTableViewCell)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appearAddPlanBtn"), object: nil)
       
        
        editBtn.isHidden = true // 네비게이션의 '수정'버튼 숨기기
        completeBtn.isHidden = false // 네비게이션의 '완료'버튼 나타내기
    }
    
    
    //📍 완료버튼 action method
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        //완료 버튼 눌렀을 때, 편집모드 해제하기
        delegate?.changeEdidState()
        
        //완료 버튼 눌렀을 때 두번째 셀의 수정,삭제 버튼 숨기기 (PlanTableViewCell)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenEditDeleteBtn"), object: nil)
        //완료 버튼 눌렀을 때 세번째 셀의 '플랜추가' 버튼 숨기기 (addPlanTableViewCell)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenAddPlanBtn"), object: nil)
   
        editBtn.isHidden = false // 네비게이션의 '수정'버튼 나타내기
        completeBtn.isHidden = true // 네비게이션의 '완료'버튼 숨기기
    }

}



