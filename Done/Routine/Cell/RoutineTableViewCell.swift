//
//  RoutineTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//

import UIKit
import SnapKit
import SwiftUI

class RoutineTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "RoutineTableViewCell"
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var catagoryImageView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var routineContentLb: UILabel!
    
    weak var delegate: routineTableViewButtonSelectedDelegate?
    var indexPath: IndexPath?
    var routineNo: Int?
    var catagoryNo: Int?
    
    var editState = false
    
    //MARK: - lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
        notificationMethod()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - Helpers
    
    func notificationMethod() {
        
        //1. 편집 버튼 눌렀을 때 수정,삭제 버튼 나타나게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeEditStateBtn),
                                               name: NSNotification.Name(rawValue: "changeEditDeleteBtn"),
                                               object: nil)
        
        //2. 완료 버튼 눌렀을 때 수정,삭제 버튼 사라지게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hiddenEditDeleteBtn),
                                               name: NSNotification.Name(rawValue: "hiddenEditBtn"),
                                               object: nil)
        
        
        
    }
    
    // notificationcenter methods -> 수정,삭제 버튼 나타나게하기
    @objc fileprivate func changeEditStateBtn() {
        print("수정삭제 버튼 나타나게하기")
        catagoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        //업데이트 코드
        //if layoutifneeded
        //테이블뷰 editmode
        editBtn.isHidden = false
        deleteBtn.isHidden = false
  }
    
    // notificationcenter methods 2 -> 수정,삭제 버튼 사라지게하기
    @objc fileprivate func hiddenEditDeleteBtn() {
        catagoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        editBtn.isHidden = true
        deleteBtn.isHidden = true
    }
    

    
    func style() {
        editBtn.isHidden = true
        editBtn.lineSet()
        deleteBtn.isHidden = true
    }
    
    
    func setCardDatas(catagoryNo: Int, routineNo: Int, content: String) {
        self.catagoryNo = catagoryNo
        self.routineNo = routineNo
        routineContentLb.text = content
    }
    


    
    //MARK: - Actions
    
    // 루틴  수정 버튼 tapped
    @IBAction func goToCommentButtonTapped(_ sender: Any) {
        delegate?.editPlanButtonTapped(routineNo!, catagoryNo!, routineContentLb.text ?? "")
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        delegate?.didTappedDeleteBtn(routineNo!)
    }
}
