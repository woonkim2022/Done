//
//  DoneTextVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/02.
//

import UIKit
import FSCalendar

protocol TextChangeDelegate {
    func onChange()
}

let notificationName2 = "btnClick"

class DoneTextVC: UIViewController {
    
    var changeDelegate: TextChangeDelegate?
    
    //MARK: - Properties

    lazy var dataManager: doneCreateService = doneCreateService()
    lazy var editDataManager: donePatchService = donePatchService()

    static let identifier: String = "DoneTextVC"
   // var completion : ((String) -> Void)?
    
    // DONETEXT outlet
    @IBOutlet weak var catagoryBtn: UIButton!
    @IBOutlet weak var catagoryIconBtn: UIButton!
    @IBOutlet weak var catagoryImage: UIImageView!
    @IBOutlet weak var inputBtn: UIButton!
    @IBOutlet weak var hashtagBtn: UIButton!
    @IBOutlet weak var doneTextField: UITextField!
    
    @IBOutlet weak var doneTitleLb: UILabel!
    
    // 컨테이너뷰
    @IBOutlet weak var catagoryView: UIView!
    @IBOutlet weak var hashtagView: UIView!
    
    // bottom view setup
    @IBOutlet weak var dimmedBackView: UIView! // 기존 화면을 흐려지게 만들기 위한 뷰
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    //var height: CGFloat = 300
    var bottomHeight: CGFloat = 140 // 바텀 시트 높이
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    // 날짜 변수
    var date: String!
    var fommetDate: String? = nil
    
    // 데이터 변수
    let userDefaults = UserDefaults()
    var tags: [Taglist] = [Taglist]()

    //var dones: [Done] = []
    
    //상태변수
    var doneTextState = false
    var editTextState = false
    var catagoryImageSetState = false
    var catagoryNO: Int? = nil
    var tagNo : Int? = nil
    var routineNo : Int? = nil

    var doneListCount = "" //N번째 던리스트 숫자 N

    //수정상태변수
    var editContent = "" //수정할 때 수정 done content
    var cellRow = 0
    var editDoneListCount = "" //N번째 던리스트 숫자 N
    var doneNo: Int = 0

    
    
    var routineEidtState = false
   
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        
        doneTextField.delegate = self
        doneTextField.returnKeyType = .done
        
        setupUI()
        setupGestureRecognizer()
        notificationMethod()
        editstate() // 수정버튼 눌렀을 때 수정상태 변환 매소드
   
        catagoryView.alpha = 0
        hashtagView.alpha = 0
        
       
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        style()
        showBottomSheet()

    }
    
    // NotificationCenter에 Observer 등록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
        if routineEidtState == true {
            showBottomSheet()
            
        } else {
            
        }
    }
    


    //MARK: - Actions
    @objc func upBottomSheet2() {
        routineEidtState = true
        self.bottomSheetViewTopConstraint.constant = 900
        
        }

    // 여백부분 눌렀을 때 바텀시트 내림
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .init("categoryClose"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //입력과 동시에 테이블뷰 reloaddata()
    @IBAction func doneInputBtn(_ sender: Any) {
        
        //        if doneTextState == true {
        inputBtn.isEnabled = true
        
        if catagoryNO == 0 {
            catagoryNO = nil
        }
        
        if let txt = doneTextField.text, !txt.isEmpty {
            if editTextState == true {
                
                // 수정 api
                let patchInput = donePatchDataModel(content: txt,
                                                    category_no: catagoryNO,
                                                    tag_no: tagNo,
                                                    routine_no: routineNo)
                
                editDataManager.patchData(patchInput, delegate: self)
                print("작성한 데이터 -> \(patchInput)")
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil)
                }
                
                
            }
            else if editTextState == false {
                
                let string = fommetDate
                userDefaults.set(fommetDate, forKey: "date")
                
                // 조회 api
                let input = doneCreateDataModel(content: txt,
                                                date: fommetDate,
                                                category_no: catagoryNO,
                                                tag_no: nil,
                                                routine_no: nil)
                
                dataManager.postData(input, delegate: self)
                print("작성한 데이터 -> \(input)")
                
                inputBtn.isHidden = true
                hashtagBtn.isHidden = false
                
                // 입력 완료 후, 다음 N번째 숫자 불러오는 매소드
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(titleLbReload),
                                                       name: NSNotification.Name(rawValue: "reloadTitleLb"),
                                                       object: nil)
                
                // 테이블뷰에 입력한 done text 실시간 갱신되도록 DispatchQueue 설정
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    // get api 호출 + tableview reloaddata()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil)
                }
                
            }
        }
        

        
        //입력버튼 누르면 텍스트필드 text,카테고리 이미지 원상복귀 시키기
        self.doneTextField.text = ""
        self.catagoryBtn.isHidden = false
        self.catagoryImage.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeToBlue"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "routinTagBlue"), object: nil)

    }
    
    
    // 해시태그 버튼 눌렀을 때 바텀뷰 올라오도록 하기
    @IBAction func didTappedHashtagBtn(_ sender: Any) {
        doneTextField.placeholder = "오늘 한 일을 선택해 보세요!"

        if UIDevice.current.isiPhoneSE2{
            bottomSheetViewTopConstraint.constant = 330
        } else {
            bottomSheetViewTopConstraint.constant = 404
        }
        
        view.endEditing(true)

        if catagoryImageSetState == true  || editTextState == true {
            catagoryIconBtn.isHidden = true
            catagoryBtn.isHidden =  true
        } else {
            catagoryIconBtn.isHidden = true
            catagoryBtn.isHidden =  false
        }
        
    }
    
    // 카테고리 버튼 눌렀을 때 바텀뷰 올라오도록 하기
    @IBAction func didTappedCatagoryBtn(_ sender: Any) {

        view.endEditing(true)
        DispatchQueue.main.async {
            if UIDevice.current.isiPhoneSE2{
                self.bottomSheetViewTopConstraint.constant = 330
            } else {
                self.bottomSheetViewTopConstraint.constant = 404
            }
            self.catagoryIconBtn.isHidden = false
            self.catagoryBtn.isHidden = true
        }
        
    }
    

    
    @IBAction func TappedBtnClicked(_ sender: UIButton) {
        
        //버튼마다 tag값 주기
        catagoryBtn.tag = 1
        hashtagBtn.tag = 2
        
        if sender.tag == 1 {
            catagoryView.alpha = 1
            hashtagView.alpha = 0
        }
        else if sender.tag == 2 {
            catagoryView.alpha = 0
            hashtagView.alpha = 1
        }
    }
    
    
    
    //MARK: - Helpers
    
    
    // UITapGestureRecognizer -> 해시태그 선택 후, 내장된 카테고리 아이콘 이미지 클릭 때 catagoryview로 바꿔줄 매소드
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
        self.bottomSheetViewTopConstraint.constant = 404
        self.catagoryView.alpha = 1
        self.hashtagView.alpha = 0
        }
    }
    
    

    
    
    func editstate() {
        if editTextState == true {
            if catagoryNO == 0 {
                catagoryBtn.isHidden = false
                doneTitleLb.text = "오늘의 \(editDoneListCount)번째 Done"
                doneTextField.text = editContent
            } else {
                doneTextField.text = editContent
                catagoryImage.image = UIImage(named: "\(catagoryNO!)")
                print("catagoryNumber\(catagoryNO!)")
                catagoryBtn.isHidden = true
                self.catagoryImage.isUserInteractionEnabled = true //터치 가능하도록 설정
                self.catagoryImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))) //제쳐스 추가
                doneTitleLb.text = "오늘의 \(editDoneListCount)번째 Done"
            }
        } else if editTextState == false {
            doneTitleLb.text = "오늘의 \(doneListCount)번째 Done"
        }
    }
    
    // 디자인 속성 매소드
    func style() {
        
        inputBtn.isHidden = true
        inputBtn.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
        
        hashtagBtn.isHidden = false
        hashtagBtn.blueLineSet()
        hashtagBtn.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
        hashtagBtn.circleSet()
        
        catagoryIconBtn.isHidden = true
        //  catagoryImage.isHidden = true
        
        doneTextField.borderStyle = .none // 텍스트필드 테두리 제거
        doneTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0); // 텍스트필드 left padding
        doneTextField.placeholder = "작은일도 써보세요!(14자 이하)"

       
        
    }
    
    
    // 텍스트필드 14글자 이상 입력안되게 하기
    @objc private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case doneTextField:
                if let text = doneTextField.text {
                    if text.count > 15 {
                        // 🪓 주어진 인덱스에서 특정 거리만큼 떨어진 인덱스 반환
                        let maxIndex = text.index(text.startIndex, offsetBy: 15)
                        // 🪓 문자열 자르기
                        let newString = String(text[text.startIndex ..< maxIndex])
                        doneTextField.text = newString
                    } else if doneTextField.text == ""  {
                        //🪓 빈배열일 시 버튼 기능 제한
                        // self.inputBtn.backgroundColor = loginLight
                        // self.inputBtn.isEnabled = false
                        doneTextState = false
                    } else {
                        doneTextState = true
                        self.inputBtn.isEnabled = true
                    }
                }
            default:
                return
            }
        }
    }
    
    
    //MARK: - Notification Methods
    
    func notificationMethod() {
        
        //해시태그 값
        NotificationCenter.default.addObserver(self, selector: #selector(tagDataReceived),
                                               name: NSNotification.Name(rawValue: "notificationName2"),
                                               object: nil)
        
        //카테고리 VC -> 카테고리 넘버 값
        NotificationCenter.default.addObserver(self, selector: #selector(catagoryDataReceived),
                                               name: NSNotification.Name(rawValue: "catagoryNo"),
                                               object: nil)
        
        //해시태그 VC -> 카테고리 넘버 값
        NotificationCenter.default.addObserver(self, selector: #selector(HashtagCatagoryDataReceived),
                                               name: NSNotification.Name(rawValue: "HashtagCatagoryNo"),
                                               object: nil)
        
        //루틴 VC -> 카테고리 넘버 값
        NotificationCenter.default.addObserver(self, selector: #selector(routineCatagoryDataReceived),
                                               name: NSNotification.Name(rawValue: "routineCatagoryNo"),
                                               object: nil)
        
        
        
        //던리스트 8개 되면 바텀시트 창 내리기
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(donelist8),
                                               name: NSNotification.Name(rawValue: "donelist8"),
                                               object: nil)

        
        
    }
    
    
    
    // 해시태그 notificationcenter methods
    @objc func tagDataReceived(_ notification: Notification) {
        print("HashtagViewController - datarecived")
        
        if let tagcontent = notification.object as? String {
            doneTextField.text = tagcontent
        }
        
        catagoryImage.isHidden = false
        hashtagBtn.isHidden = true
        inputBtn.isHidden = false
    }
    
    // 카테고리vc -> 카테고리 notificationcenter methods
    @objc func catagoryDataReceived(_ notification: Notification) {
        print("CatagoryViewController - datarecived")
        
        catagoryBtn.isHidden = true
        catagoryIconBtn.isHidden = true
        catagoryImageSetState = true
        
        if let catagoryNo = notification.object as? Int {
            catagoryImage.image = UIImage(named: "\(catagoryNo)")
            catagoryNO = catagoryNo
        }
        
    }
    
    
    // 해시태그vc -> 카테고리 notificationcenter methods
    @objc func HashtagCatagoryDataReceived(_ notification: Notification) {
        print("HashtagViewController - 카테고리 datarecived")
    
        if let catagoryNo = notification.object as? Int {
            catagoryImage.image = UIImage(named: "\(catagoryNo)")
            catagoryNO = catagoryNo
        }
        
        catagoryBtn.isHidden = true
        catagoryIconBtn.isHidden = true
        catagoryImageSetState = true
        
        //카테고리 아이콘 이미지 눌렀을 때 catagoryview로 전환
        self.catagoryImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))) //제쳐스 추가
        self.catagoryImage.isUserInteractionEnabled = true //터치 가능하도록 설정
        
        
      
        
    }
    
    
    // 루틴vc -> 카테고리 notificationcenter methods
    @objc func routineCatagoryDataReceived(_ notification: Notification) {
        print("HashtagViewController - 카테고리 datarecived")
        
        catagoryBtn.isHidden = true
        catagoryIconBtn.isHidden = true
        catagoryImageSetState = true
        
        //카테고리 아이콘 이미지 눌렀을 때 catagoryview로 전환
        self.catagoryImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))) //제쳐스 추가
        self.catagoryImage.isUserInteractionEnabled = true //터치 가능하도록 설정
        
        
        if let catagoryNo = notification.object as? Int {
            catagoryImage.image = UIImage(named: "\(catagoryNo)")
            catagoryNO = catagoryNo
            
            if catagoryNo == 0 {
                catagoryBtn.isHidden = false
            }
        }
        
    }
    
    
    // DoneVC -> 입력 후, 다음 N번째 donelist 숫자 불러오는 notificationcenter methods
    @objc fileprivate func titleLbReload(_ notification: Notification)  {
        if let tagcontent = notification.object as? String {
            doneTitleLb.text = "오늘의 \(tagcontent)번째 Done"
        }
    }
    
    // 던리스트 8개 되면 바텀시트 내리기
    @objc fileprivate func donelist8() {
     self.hideBottomSheetAndGoBack()
    }
    
    
    @IBAction func dddd(_ sender: Any) {
        self.hideBottomSheetAndGoBack()

    }
    
  
}


    //MARK: - UITextFieldDelegate

extension DoneTextVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputBtn.isHidden = false
        hashtagBtn.isHidden = true
        catagoryView.alpha = 0
        hashtagView.alpha = 0
        
        if catagoryImageSetState == true || editTextState == true {
            catagoryIconBtn.isHidden = true
        } else {
            catagoryIconBtn.isHidden = true
            catagoryBtn.isHidden =  false
        }
        
    }
    
    // 리턴키 눌렀을 때 키보드 제어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.doneTextField.resignFirstResponder()

        return true
    }
    
    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
//        inputBtn.isHidden = true
//        hashtagBtn.isHidden = false
//        bottomSheetViewTopConstraint.constant = 622
    }
    

}



   //MARK: - bottomview

extension DoneTextVC {
    
    // MARK: - 바텀시트 UI 세팅
    private func setupUI() {
        
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 20
        shadowView.layer.shadowOpacity = 0.3
        
        dimmedBackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        bottomSheetView.backgroundColor = .white
        bottomSheetView.layer.cornerRadius = 27
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.clipsToBounds = true
        
        
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
 
        dimmedBackView.alpha = 0.0
        setupLayout()
        setupGestureRecognizer()
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
//    // 카테고리 버튼 -> view height 키우기
//    private func catagoryGestureRecognizer() {
//        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(catagoryTapped(_:)))
//        catagoryBtn.addGestureRecognizer(dimmedTap)
//        catagoryBtn.isUserInteractionEnabled = true
//
//    }


    // 레이아웃 세팅
    private func setupLayout() {
        dimmedBackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedBackView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSheetView.layer.shadowColor = UIColor.black.cgColor
        bottomSheetView.layer.shadowOffset = CGSize(width: 0, height: 50)
        bottomSheetView.layer.shadowRadius = 4
        bottomSheetView.layer.shadowOpacity = 1
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint
        ])
        
  
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        NotificationCenter.default.addObserver(self, selector: #selector(upBottomSheet2), name: NSNotification.Name(rawValue: "upBottomSheet2"), object: nil)
        
        if  routineEidtState == true {
                if UIDevice.current.isiPhoneSE2 {
                    self.bottomSheetViewTopConstraint.constant = 330
                    inputBtn.isHidden = false
                    hashtagBtn.isHidden = true
                } else {
                    self.bottomSheetViewTopConstraint.constant = 404
                    inputBtn.isHidden = false
                    hashtagBtn.isHidden = true
                }
        } else {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
    
            
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    }
    
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func catagoryTapped(_ tapRecognizer: UITapGestureRecognizer) {
        bottomSheetViewTopConstraint.constant = 404
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
}
