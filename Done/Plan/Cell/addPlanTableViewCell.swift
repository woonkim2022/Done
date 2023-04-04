//
//  addPlanTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import UIKit


class addPlanTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var addPlanBtn: UIButton!
    
    static let identifier: String = "addPlanTableViewCell"
    weak var delegate: UITableViewButtonSelectedDelegate?
        
    
    //MARK: - lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPlanBtn.isHidden = true
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
        
        //1. 편집 버튼 눌렀을 때 플랜추가 버튼 나타나게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appearAddPlanBtn),
                                               name: NSNotification.Name(rawValue: "appearAddPlanBtn"),
                                               object: nil)
        //2. 완료 버튼 눌렀을 때 플랜추가 버튼 사라지게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hiddenAddPlanBtn),
                                               name: NSNotification.Name(rawValue: "hiddenAddPlanBtn"),
                                               object: nil)
    }
    
    // notificationcenter methods 1
    @objc fileprivate func appearAddPlanBtn() {
        print("'플랜추가'버튼 나타내기")
        addPlanBtn.isHidden = false
    }
    
    // notificationcenter methods 2
    @objc fileprivate func hiddenAddPlanBtn() {
        print("'플랜추가'버튼 숨기기")
        addPlanBtn.isHidden = true
    }
    

}

