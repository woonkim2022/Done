//
//  DoneTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/02.
//

import UIKit
import DropDown


class DoneTableViewCell: UITableViewCell {

    @IBOutlet weak var catagoryImage: UIImageView!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var doneNo: Int?
    var catagoryNo: Int? = nil
    var row: Int?
    
    weak var delegate: donelsitTableViewButtonSelectedDelegate?
    
    let editDropDown = DropDown()

    //MARK: - lifecycle

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDropdown()

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    
    //MARK: - Actions

    @IBAction func editDeleteTapped(_ sender: Any) {
        delegate?.editDropdownState()
        dropdownMethod()
    }
    
    
    //MARK: - Helpers
    
    func setCardDatas(doneNo: Int, catagoryNo: Int, content: String) {
        self.doneNo = doneNo
        self.catagoryNo = catagoryNo
        doneLabel.text = content
    }
    
    func dropdownMethod() {
        editDropDown.dataSource = ["수정", "삭제"]
        editDropDown.show()
        editDropDown.anchorView = deleteBtn
        editDropDown.width = 108
        editDropDown.backgroundColor = UIColor.white
        editDropDown.cellHeight = 54
        editDropDown.cornerRadius = 15
        editDropDown.bottomOffset = CGPoint(x: -80, y: ((editDropDown.anchorView?.plainView.bounds.height)!)-16)
        editDropDown.dismissMode = .onTap
    }
    
    func setupDropdown() {
        // 다이얼로그에서 선택했을 때 label 폰트 바꿔주기
        editDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.editDropDown.clearSelection()
            
            if index == 0 {
                print("선택한 아이템 : \(item)")
                //수정 api
                delegate?.didTappedEditBtn(doneNo!, catagoryNo!,doneLabel.text ?? "", row!)
                
            } else if index == 1 {
                print("선택한 아이템 : \(item)")
                //삭제 api
                delegate?.didTappedDeleteBtn(doneNo!)
                
            }
        }
    }
    

    }
    

    
    

