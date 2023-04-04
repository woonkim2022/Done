//
//  getStickerPopupVC.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import UIKit

class getStickerPopupVC: UIViewController {
    
    lazy var dataManager: checkStickerService = checkStickerService()
    
    //MARK: - Properties
    
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerNameLb: UILabel!
    @IBOutlet weak var stickerExplainLb: UILabel!
    @IBOutlet weak var confirmBtn: yourButton!
    
    var stickerName: String = ""
    var stickerExplain : String = ""
    var stickerNo : Int = 0
    
    var stickerImages = ["첫 한마디","한눈에 쏙!","소확던(Done)","나만의 습관","나만의 플랜","플랜X10"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        
        stickerNameLb.text = stickerName
        stickerImageView.image = UIImage(named: "\(stickerName)")
        stickerExplainLb.text = stickerExplain
        
    }
    
    //MARK: - Actions
    
    @IBAction func dismissPopUpExplainView(_ sender: UIButton) {
        
        print("넘겨주는 스티커넘버 -----> \(stickerNo)")
        dataManager.getData(parameter: stickerNo, delegate: self)
     
        self.dismiss(animated: true, completion: nil)
     
    }
    
    //MARK: - Helpers
    
    func setElements() {
        stickerNameLb.text = stickerName
        stickerExplainLb.text = stickerExplain
        stickerImageView.image = UIImage(named: "\(stickerName)")
        
        self.view.backgroundColor =  UIColor(red: 36.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.7)
    }
}
