//
//  RoutineViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/11.
//

import UIKit

extension RoutineViewController {
    func didRoutineService(result: Routine) {
        routines = result.routines
        routineCollectionView.reloadData()
        
        if routines.isEmpty {
            hintMessageLb.isHidden = false
            routinAddBtn.isHidden = false
        }
        
        
    }
}


class RoutineViewController: UIViewController {
    
    lazy var dataManager: routineService = routineService()
    
    //MARK: - Properties
    
    @IBOutlet weak var routineCollectionView: UICollectionView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var routinAddBtn: UIButton!
    @IBOutlet weak var hintMessageLb: UILabel!
    
    var routines: [RoutineList] = [RoutineList]()
    var routineContent : String = ""
    var catagoryNumber : Int = 0
    
    var selectState = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "emptyCatagory"), object: nil)
        
        defaultSetup()
        style()
                
        routineCollectionView.delegate = self
        routineCollectionView.dataSource = self
        
        dataManager.getData(self)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routineReloadMethod),
                                               name: NSNotification.Name(rawValue: "routineReload"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
       // routineCollectionView.reloadData()
        
    }
    

    //MARK: - Actions
    
    @objc fileprivate func routineReloadMethod() {
        dataManager.getData(self)
        
    }

    // 루틴추가 버튼 눌렀을 때 루틴페이지로 이동
    @IBAction func changeToRoutineBtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "AddRoutineVC", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "AddRoutineViewController") as? AddRoutineViewController  {
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: true)
        }
    }
    
    
    // 편집 버튼 눌렀을 때 루틴페이지로 이동
    @IBAction func didTapeedEditBtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "AddRoutineVC", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "AddRoutineViewController") as? AddRoutineViewController  {
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: true)
        }
    }

    
    
    //MARK: - Helpers

    func style() {
        editBtn.isHidden = true
        let fontSize = UIFont(name: "SpoqaHanSansNeo-Bold", size: 16)
        let attributedStr = NSMutableAttributedString(string: hintMessageLb.text!)
        attributedStr.addAttribute(.font, value: fontSize, range: (hintMessageLb.text! as NSString).range(of: "반복되는 Done List를 루틴으로 등록"))
        hintMessageLb.attributedText = attributedStr
    }
    
    //MARK: - Default Methods
    
    // 컬렉션뷰 셀 중앙정렬 레이아웃 매소드
    func defaultSetup() {
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 35)
        routineCollectionView.collectionViewLayout = layout

        let nib = UINib(nibName: "RoutineCollectionViewCell", bundle: nil)
        routineCollectionView?.register(nib, forCellWithReuseIdentifier: "RoutineCollectionViewCell")
    }

}


    //MARK: - UICollectionViewDelegate,DataSource

extension RoutineViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let identifier = "RoutineCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RoutineCollectionViewCell
        let routines = routines[indexPath.row]
        cell.routineLb.text = "#\(routines.content)"
        
        
        if self.routines.count == 0 {
            self.routinAddBtn.isHidden = false
            self.hintMessageLb.isHidden = false
            self.editBtn.isHidden = true
        } else {
            self.routinAddBtn.isHidden = true
            self.hintMessageLb.isHidden = true
             self.editBtn.isHidden = false
        }
        
        return cell
    }
    
    
    // 선택한 루틴태그 text 텍스트필드로 보내주기
    // 선택한 루틴태그 컬러 바꿔주기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RoutineCollectionViewCell {
            cell.selectTag()
            
            let tags = routines[indexPath.row]
        
            routineContent = tags.content ?? ""
            catagoryNumber = tags.category_no ?? 0
            NotificationCenter.default.post(name: NSNotification.Name("notificationName2"), object: routineContent)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeToBlue"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "routineCatagoryNo"), object: catagoryNumber)
            
            
        }
    }
    
    // 선택안한 해시태그 색상 변경
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RoutineCollectionViewCell {
            cell.unSelectTag()
    
        }
    }

    
}
