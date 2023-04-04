//
//  RoutineTextViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//

import UIKit


class RoutineTextViewController: UIViewController {
    

    //MARK: - Properties

    lazy var dataManager: postRoutineService = postRoutineService()
    lazy var patchDataManager: PatchRoutineService = PatchRoutineService()

    @IBOutlet weak var catagoryBtn: UIButton!
    @IBOutlet weak var catagoryImage: UIImageView!
    @IBOutlet weak var catagoryIconBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var routineTextField: UITextField!
    @IBOutlet weak var routineTitleLb: UILabel!

    @IBOutlet weak var catagoryView: UIView!
    @IBOutlet weak var shadowView: UIView!


    var routineEditState = false
    var firstEditState = false
    var editTextState = false
    var catagoryImageSetState = false
    
    var catagoryNO: Int? = nil
    var editContent = ""
    var editTitleText = ""
    var routineTextState = false
    var routineData: [RoutineList] = [RoutineList]()
    var routineNo : Int = 0
    
    
    // bottom view setup
    @IBOutlet weak var dimmedBackView: UIView! // 기존 화면을 흐려지게 만들기 위한 뷰
    @IBOutlet weak var bottomSheetView: UIView!
    //var height: CGFloat = 300
    var bottomHeight: CGFloat = 140 // 바텀 시트 높이
    private var bottomSheetViewTopConstraint: NSLayoutConstraint! // bottomSheet가 view의 상단에서 떨어진 거리


    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        style()

        routineTextField.delegate = self
        routineTextField.returnKeyType = .done

        setupUI()
        setupGestureRecognizer()
        notificationMethod()
        editstate()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }

    // NotificationCenter에 Observer 등록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)),
                                               name: UITextField.textDidChangeNotification, object: nil)

    }



    

    //MARK: - Actions

    @IBAction func planInputBtn(_ sender: Any) {

        if routineTextState == true {

            editBtn.isEnabled = true
            
            if catagoryNO == 0 {
                catagoryNO = nil
            }
            
            if let txt = routineTextField.text, !txt.isEmpty {
                if editTextState == true {
                    
                    // 루틴 수정 api
                    let editInput = PatchRoutineDatamodel(content: txt, category_no: catagoryNO)
                    patchDataManager.patchData(editInput, delegate: self)
                    
                    self.hideBottomSheetAndGoBack() //입력 완료 후 바텀시트 사라지게 하기
                    
                } else if editTextState == false {
                    
                    // 루틴 등록 api
                    let input =  postRoutineDataModel(content: txt, category_no: catagoryNO)
                    dataManager.postData(input, delegate: self)
                    
                    self.hideBottomSheetAndGoBack()
                }
            }
            
            //입력 완료 후 텍스트필드 text 빈배열되도록 하기
            self.routineTextField.text = ""
       
            // 💡 카테고리 이미지 없애고 빈 카테고리 이미지 처리

            // 📌 수정상태가 true일 때,
            if routineEditState == true {

                // 테이블뷰에 입력한 routine text 실시간 갱신되도록 DispatchQueue 설정
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    // get api 호출 + tableview reloaddata()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "routineEditRelaodData"), object: nil)
                }

            // 📌 리스트를 처음 입력한 상태로 true일 때,
            } else if firstEditState == true {
                // 테이블뷰에 입력한 routine text 실시간 갱신되도록 DispatchQueue 설정
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    // get api 호출 + tableview reloaddata()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "routineFirstRelaodData"), object: nil)
                }
            }
        }
    }


    // 카테고리 버튼 눌렀을 때 카테고리 뷰 전환
    @IBAction func changeToCatagoryBtnClicked(_ sender: UIButton) {
        view.endEditing(true)
        DispatchQueue.main.async {
            if UIDevice.current.isiPhoneSE2{
                self.bottomSheetViewTopConstraint.constant = 330
            } else {
                self.bottomSheetViewTopConstraint.constant = 404
            }
            self.catagoryView.alpha = 1
            self.catagoryIconBtn.isHidden = false
            self.catagoryBtn.isHidden = true
        }


    }



    //MARK: - Helpers
    
    
    func editstate() {
        if editTextState == true {
            if catagoryNO == 0 {
                catagoryBtn.isHidden = false
                routineTextField.text = editContent
                routineTitleLb.text = editTitleText
            } else {
                catagoryBtn.isHidden = true
                routineTextField.text = editContent
                routineTitleLb.text = editTitleText
                catagoryImage.image = UIImage(named: "\(catagoryNO!)")
                print("catagoryNumber\(catagoryNO!)")
                self.catagoryImage.isUserInteractionEnabled = true //터치 가능하도록 설정
                self.catagoryImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))) //제쳐스 추가
            }
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
        self.bottomSheetViewTopConstraint.constant = 404
        self.catagoryView.alpha = 1
        }
    }
    
    
    // 디자인 속성 매소드
    func style() {

        editBtn.isHidden = true
        editBtn.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)

        addBtn.isHidden = false
        addBtn.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)

        catagoryIconBtn.isHidden = true

        routineTextField.borderStyle = .none // 텍스트필드 테두리 제거
        routineTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0); // 텍스트필드 left padding
        routineTextField.placeholder =  "루틴을 입력해보세요.(10자 이하)"
        
        catagoryView.alpha = 0
    }


    // 텍스트필드 14글자 이상 입력안되게 하기
    @objc private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case routineTextField:
                if let text = routineTextField.text {
                    if text.count > 10 {
                        // 🪓 주어진 인덱스에서 특정 거리만큼 떨어진 인덱스 반환
                        let maxIndex = text.index(text.startIndex, offsetBy: 10)
                        // 🪓 문자열 자르기
                        let newString = String(text[text.startIndex ..< maxIndex])
                        routineTextField.text = newString
                        routineTextState = true
                    } else if routineTextField.text == ""  {
                        //🪓 빈배열일 시 버튼 기능 제한
                       // self.inputBtn.backgroundColor = loginLight
                          self.editBtn.isEnabled = false
                        routineTextState = false
                    } else {
                        routineTextState = true
                        self.editBtn.isEnabled = true
                    }
                }
            default:
                return
            }
        }
        }
    
    
    //MARK: - notificationMethods
    
    func notificationMethod() {
        //카테고리 VC -> 카테고리 넘버 값
        NotificationCenter.default.addObserver(self, selector: #selector(catagoryDataReceived), name: NSNotification.Name(rawValue: "catagoryNo"), object: nil)
    }
    
        // 카테고리vc -> 카테고리 notificationcenter methods
        @objc func catagoryDataReceived(_ notification: Notification) {
            print("CatagoryViewController - datarecived")
            
            catagoryIconBtn.isHidden = true
            catagoryImageSetState = true
            
            //플랜 수정 상태에서 카테고리 버튼만 변경하고 싶을 때, 추가->수정버튼으로 변하게 하기
            if editTextState == true {
                routineTextState = true
                addBtn.isHidden = true
                editBtn.isHidden = false
            }
            
            if let catagoryNo = notification.object as? Int {
                catagoryImage.image = UIImage(named: "\(catagoryNo)")
                catagoryNO = catagoryNo
            }
            
        }
    

}


//MARK: - UITextFieldDelegate

extension RoutineTextViewController : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        editBtn.isHidden = false
        addBtn.isHidden = true
        catagoryView.alpha = 0
        
        if catagoryImageSetState == true || editTextState == true {
            catagoryIconBtn.isHidden = true

        } else {
            catagoryIconBtn.isHidden = true
            catagoryBtn.isHidden =  false
        }
    }

    
    
    // 리턴키 눌렀을 때 키보드 제어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.routineTextField.resignFirstResponder()

        return true
    }

    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)

        if routineTextField.text == "" {
            editBtn.isHidden = true
            addBtn.isHidden = false
        } else {
            editBtn.isHidden = false
            addBtn.isHidden = true
        }

    }


}

//MARK: - bottomview

extension RoutineTextViewController {

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
    }

    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = false

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
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom

        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
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

