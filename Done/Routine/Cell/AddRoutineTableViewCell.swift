//
//  AddRoutineTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//

import UIKit

class AddRoutineTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var addRoutineBtn: UIButton!
    
    static let identifier: String = "AddRoutineTableViewCell"
    weak var delegate: routineTableViewButtonSelectedDelegate?
        
    
    //MARK: - lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addRoutineBtn.isHidden = true
        notificationMethods()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
    //MARK: - Actions

    @IBAction func moreButtonTapped(_ sender: Any) {
        delegate?.changeToDontTextBottomSheet()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTitle"), object: nil)
    }
    
    
    
    //MARK: - Helpers
    
    func notificationMethods() {
        
        //1. 편집 버튼 눌렀을 때 루틴추가 버튼 나타나게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appearAddRoutineBtn),
                                               name: NSNotification.Name(rawValue: "appearRoutinePlanBtn"),
                                               object: nil)
        //2. 완료 버튼 눌렀을 때 루틴추가 버튼 사라지게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hiddenAddRoutineBtn),
                                               name: NSNotification.Name(rawValue: "hiddenRoutinePlanBtn"),
                                               object: nil)
    }
    
    // notificationcenter methods 1
    @objc fileprivate func appearAddRoutineBtn() {
        addRoutineBtn.isHidden = false
    }
    
    // notificationcenter methods 2
    @objc fileprivate func hiddenAddRoutineBtn() {
        addRoutineBtn.isHidden = true
    }
    

}

