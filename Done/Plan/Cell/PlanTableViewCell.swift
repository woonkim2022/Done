//
//  PlanTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import UIKit

class PlanTableViewCell: UITableViewCell {
    
    //MARK: - Properties

    static let identifier: String = "PlanTableViewCell"

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var catagoryImageView: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var planContentLb: UILabel!

    weak var delegate: UITableViewButtonSelectedDelegate?
    var indexPath: IndexPath?
    var planNo: Int?
    var catagoryNo: Int?


    //MARK: - lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
        notificationMethod()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helpers
    
    func notificationMethod() {
        
        //📍 1. 편집 버튼 눌렀을 때 수정,삭제 버튼 나타나게하기 -> 편집상태로 바꾸기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeEditStateBtn),
                                               name: NSNotification.Name(rawValue: "changeEditBtn"),
                                               object: nil)
        
        //📍 2. 완료 버튼 눌렀을 때 수정,삭제 버튼 사라지게하기 -> 완료상태로 바꾸기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hiddenEditDeleteBtn),
                                               name: NSNotification.Name(rawValue: "hiddenEditDeleteBtn"),
                                               object: nil)
        
   


    }
    
    // 📍 notificationcenter methods 1
    @objc fileprivate func changeEditStateBtn() {
        doneBtn.isHidden = true // done 버튼 숨기기
        editBtn.isHidden = false // 수정 버튼 나타내기
        deleteBtn.isHidden = false // 삭제 버튼 나타내기

    }
    
    // 📍 notificationcenter methods 2
    @objc fileprivate func hiddenEditDeleteBtn() {
        doneBtn.isHidden = false
        editBtn.isHidden = true
        deleteBtn.isHidden = true

    }
    

    
    
    func style() {
        editBtn.isHidden = true
        editBtn.lineSet()
        
        doneBtn.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
        
        deleteBtn.isHidden = true
    }
    
    
    func setCardDatas(catagoryNo: Int, planNo: Int, content: String) {
        self.catagoryNo = catagoryNo
        self.planNo = planNo
        planContentLb.text = content
    }
    
    
    //MARK: - Actions

    // 플랜 수정 버튼 tapped
    @IBAction func goToCommentButtonTapped(_ sender: Any) {
        delegate?.editPlanButtonTapped(planNo!, catagoryNo!, planContentLb.text ?? "")
    }
    
    @IBAction func DoneBtndidTapped(_ sender: Any) {
        delegate?.DoneBtndidTapped(planNo!)
        doneBtn.isHidden = false
        editBtn.isHidden = true
        deleteBtn.isHidden = true
    }
    
    // 📍 삭제버튼 tapped
    @IBAction func deleteDidTapped(_ sender: Any) {
        // 프로토콜 이용하여, 메인뷰컨에 메시지 전달
        delegate?.didTappedDeleteBtn(planNo!)
    }

}
