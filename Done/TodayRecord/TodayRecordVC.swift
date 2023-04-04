//
//  TodayRecordVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/18.
//


// 1.todayRecordContent에 텍스트 있으면 해당 텍스트 출력

import UIKit

class TodayRecordVC: UIViewController {
    
    //MARK: - Properties
    lazy var postDataManager: todayRecordService = todayRecordService()
    lazy var patchDataManager: todayPatchService = todayPatchService()


    @IBOutlet weak var stickerBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var xmarkBtn: UIButton!
    
    @IBOutlet weak var stickerImage: UIImageView!
    @IBOutlet weak var textVIEW: UITextView!
    
    var todayRecordContent: String!
    var todayNumber: Int = 0
    var textContent: String? = nil
    var stickerNumber: Int? = nil
    var fommetDate: String? = nil

    //상태변수
    var editState: Bool?
    var newState: Bool?
    
    var stickerImages = ["첫 한마디","한눈에 쏙!","소확던(Done)","나만의 습관","나만의 플랜","플랜X10","해냄이 1일차","작심삼일 극복","30일 해냄","DONE100","꾸준함의 힘","다시 시작!","휴식도 필요해","해냄 홀릭","","","",""]
    
    
    
    //MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()

       style()
       stickerImageSet()
       notificationMethods()
       emptyTextState()
        
        print("newState--------\(newState)")
        print("editState---------\(editState)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
   
    }
    
    
    //MARK: - Actions

    @IBAction func didTapTextBtn(_ sender: Any) {
        textVIEW.isHidden = false
        textBtn.isHidden = true
  
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        textContent = textVIEW.text
        let placeholder = "텍스트를 입력하세요(최대 45자)"
        
        var stickerNilState = false
        var textNilState = false
        
        if stickerNumber == 0  {
            stickerNumber = nil
            stickerNilState = true
        }
        
        if textContent == placeholder || textContent == "" {
            textContent = nil
            textNilState = true
        }
        
        // 스티커, 텍스트 둘 중 하나라도 존재할 때,
        if newState == true {
            if stickerNilState == false || textNilState == false {
                let postInput = todayRecordDataModel(content: textContent,
                                                     date: fommetDate,
                                                     sticker_no: stickerNumber)
                print("오늘한마디 작성 input -> \(postInput)")
                postDataManager.postData(postInput, delegate: self)
                
                let patchInput = todayPatchDataModel(content: textContent,
                                                     sticker_no: stickerNumber)
                print("오늘한마디 수정 input -> \(patchInput)")
                patchDataManager.patchData(patchInput, delegate: self)
            }
        } else if editState == true {
            print("\(textContent)<---------textContent")
            let patchInput = todayPatchDataModel(content: textContent,
                                                 sticker_no: stickerNumber)
            print("오늘한마디 수정 input -> \(patchInput)")
            patchDataManager.patchData(patchInput, delegate: self)
        }
        
        
        
    }
    
    // 스티커 선택 바텀시트 창 전환
    @IBAction func changeToStickerBtn(_ sender: Any) {
        // popupBackgroundView.animatePopupBackground(true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIView.animate(withDuration: 0.4, animations: {
                self.textBtn.alpha = 0
                self.textVIEW.alpha = 0
            })
        }
        
        guard let vcName = UIStoryboard(name: "TodayRecordStoryboard", bundle: nil).instantiateViewController(identifier: "StickerViewController") as? StickerViewController else {return}
        
        vcName.modalPresentationStyle = .overCurrentContext
        self.present(vcName, animated: true)
    }
    
    
    @IBAction func deleteImage(_ sender: Any) {
        stickerNumber = 0
        self.stickerImage.isHidden = true
        self.stickerBtn.isHidden = false
        self.xmarkBtn.isHidden = true
    }
    
    
    //MARK: - Helpers
    
    func style() {
       textVIEW.delegate = self
        stickerImage.isHidden = true
        xmarkBtn.isHidden = true
        
        editNewState()
        stickerBtn.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        textBtn.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
    }
    
    func editNewState() {
        if textContent != "" || stickerNumber != 0 {
            editState = true
        } else {
            newState = true
        }
    }

    
    func emptyTextState() {
        if textContent != "" {
            textBtn.isHidden = true
            textVIEW.isHidden = false
            textVIEW.text = textContent
   
        } else {
            textBtn.isHidden = false
            textVIEW.isHidden = true
            let placeholder = "텍스트를 입력하세요(최대 45자)"
            textVIEW.text = placeholder
        }
    }
    

    
    //스티커no가 0이 아닐 때, 스티커 이미지 바꿔주기
    func stickerImageSet() {
        if stickerNumber != 0 {
            stickerImage.isHidden = false
            stickerBtn.isHidden = true
            xmarkBtn.isHidden = false
            stickerImage.image = UIImage(named: stickerImages[stickerNumber! - 1])
        }
    }
    
    func notificationMethods() {
        
        //1. 스티커 바텀 시트 닫으면, 다시 텍스트뷰 & 버튼 생기게하기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideBottomSheet),
                                               name: NSNotification.Name(rawValue: "hideBottomSheet"),
                                               object: nil)
        
        //2. 선택한 스티커 뷰에 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedSelectedSticker),
                                               name: NSNotification.Name(rawValue: "stickerImageNo"),
                                               object: nil)
        
        //3. 선택한 스티커no post api
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(postSelectedStickerNo),
                                               name: NSNotification.Name(rawValue: "stickerNo"),
                                               object: nil)
        
    }
    
    //스티커 바텀 시트 닫으면, 다시 텍스트뷰 & 버튼 생기게하기
    @objc fileprivate func hideBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.textBtn.alpha = 1
            self.textVIEW.alpha = 1
        })
    }
    
    //선택한 스티커 이미지로 바꿔주기
    @objc fileprivate func changedSelectedSticker(_ notification: Notification) {
        if let stickerImageNo = notification.object as? Int {
            stickerImage.image = UIImage(named: stickerImages[stickerImageNo])
            
            self.stickerImage.isHidden = false
            self.stickerBtn.isHidden = true
            self.xmarkBtn.isHidden = false
            print("dd\(stickerImageNo)")
        
        }
    }
    
    //선택한 스티커 넘버로 post로 보낼 stickernumber 바꿔주기
    @objc fileprivate func postSelectedStickerNo(_ notification: Notification) {
        if let stickerNo1 = notification.object as? Int {
           stickerNumber = stickerNo1
        }
        print("stickerNo------------\(stickerNumber)")
    }
    
}


extension TodayRecordVC : UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        //textVIEW.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        /// 플레이스홀더
   
        let placeholder = "텍스트를 입력하세요(최대 45자)"
        
        if textView.text.isEmpty {
            textVIEW.text = placeholder
        } else if textView.text == placeholder {
            textVIEW.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        /// 플레이스홀더
        let placeholder = "텍스트를 입력하세요(최대 45자)"
        
        if textView.text.isEmpty {
            textVIEW.text = placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textVIEW.text.count > 45 {
            textVIEW.deleteBackward()
        }
    }

}
