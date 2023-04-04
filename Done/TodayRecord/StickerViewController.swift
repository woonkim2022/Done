//
//  StickerViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/27.
//

import UIKit

extension StickerViewController {
    func didMyStickerService(_ response: myStickerDataModel) {
        stickerList =  response.item?.stickers ?? []
                
        for i in stickerList {
            stickername.append(i.name ?? "")
        }
        print("stickername7 ------_> \(stickername)")

        if stickername.isEmpty {
            noStickerMessage.isHidden = false
            pageControl.isHidden = true
        } else {
            noStickerMessage.isHidden = true
            pageControl.isHidden = false
        }

    }
}

class StickerViewController: UIViewController {
    
    lazy var getDataManager: myStickerService = myStickerService()
    //MARK: - Properties

    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var noStickerMessage: UILabel!
    
    // bottom view setup
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dimmedBackView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    var bottomHeight: CGFloat = 314
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    //데이터 변수
    var stickerNo : Int = 0
    var stickerImageNo : Int = 0
    var stickerList : [MyStickerlist] = []
    var stickername = [String]()
    var stickerImages = ["첫 한마디","한눈에 쏙!","소확던(Done)","나만의 습관","나만의 플랜","플랜X10",
                         "해냄이 1일차","작심삼일 극복","30일 해냄","DONE100","꾸준함의 힘","다시 시작!",
                         "휴식도 필요해","해냄 홀릭","","","",""]
    var nonStickerImages = ["N첫 한마디","N한눈에 쏙!","N소확던(Done)","N나만의 습관","N나만의 플랜","N플랜X10",
                         "N해냄이 1일차","N작심삼일 극복","N30일 해냄","NDONE100","N꾸준함의 힘","N다시 시작!",
                         "N휴식도 필요해","N해냄 홀릭","","","",""]
    
    var stickerImages2 = ["첫 한마디","한눈에 쏙!"]
    
    //상태변수
    var getStickerState = false
    var defaultStickerState = false

    var timer : Timer?
    var currentCelIndex = 0

    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        getDataManager.getData(self)
        
        setElements()
        setupUI()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    //MARK: - Actions
    
    // page control
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        stickerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    
    //MARK: - Helpers
    
    func setElements() {
        let fontSize = UIFont(name: "SpoqaHanSansNeo-Bold", size: 16)
        let attributedStr = NSMutableAttributedString(string: noStickerMessage.text!)
        attributedStr.addAttribute(.font, value: fontSize, range: (noStickerMessage.text! as NSString).range(of: "아직 스티커가 없어요😔"))
        noStickerMessage.attributedText = attributedStr

        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        pageControl.pageIndicatorTintColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor =   UIColor(red: 255/255, green: 145/255, blue: 0/255, alpha: 1.0)
    }
 
    // 1. 스티커 버튼 숨기기
    // 2. 선택한 스티커 이미지 선택 셀로 이동
    // 3. 뒤로가기 버튼 누를 때, 선택한 스티커 no 보내기 -> indexpathrow number

}

   //MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension StickerViewController : UICollectionViewDelegate,UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerImages.count
    }
    
    // 셀 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var get = false
        var non = false
        
        for i in stickername {
            if i == stickerImages[indexPath.row] {
                get = true
            } else {
                non = true
            }
        }
        
        if get == true {
            if indexPath.row == 0 {
                stickerNo = indexPath.row + 1
                stickerImageNo = indexPath.row
                NotificationCenter.default.post(name: NSNotification.Name("stickerNo"), object: stickerNo) // 선택한 스티커 인덱스 no
                NotificationCenter.default.post(name: NSNotification.Name("stickerImageNo"), object: stickerImageNo) // 선택한 스티커 배열 no
            }
            else if indexPath.row == 1 {
                stickerNo = indexPath.row + 1
                stickerImageNo = indexPath.row

                NotificationCenter.default.post(name: NSNotification.Name("stickerNo"), object: stickerNo)
                NotificationCenter.default.post(name: NSNotification.Name("stickerImageNo"), object: stickerImageNo)
            }
            else if indexPath.row == 2 {
                stickerNo = indexPath.row + 1
                stickerImageNo = indexPath.row

                NotificationCenter.default.post(name: NSNotification.Name("stickerNo"), object: stickerNo)
                NotificationCenter.default.post(name: NSNotification.Name("stickerImageNo"), object: stickerImageNo)
            }
            else if indexPath.row == 3 {
                stickerNo = indexPath.row + 1
                stickerImageNo = indexPath.row

                NotificationCenter.default.post(name: NSNotification.Name("stickerNo"), object: stickerNo)
                NotificationCenter.default.post(name: NSNotification.Name("stickerImageNo"), object: stickerImageNo)
            }
            else if indexPath.row == 4 {
                stickerNo = indexPath.row + 1
                stickerImageNo = indexPath.row
                NotificationCenter.default.post(name: NSNotification.Name("stickerNo"), object: stickerNo)
                NotificationCenter.default.post(name: NSNotification.Name("stickerImageNo"), object: stickerImageNo)
            }
            else if indexPath.row == 5 {
                stickerNo = indexPath.row + 1
                stickerImageNo = indexPath.row
                NotificationCenter.default.post(name: NSNotification.Name("stickerNo"), object: stickerNo)
                NotificationCenter.default.post(name: NSNotification.Name("stickerImageNo"), object: stickerImageNo)
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("stickername ------_> \(stickername)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StickerCollectionViewCell
        
       

        var get = false
        var non = false
        
        for i in stickername {
            if i == stickerImages[indexPath.row] {
                get = true
            } else {
                non = true
            }
        }

        switch indexPath.row {

        case 0:

            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
   
        case 1:
         
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
            
        case 2:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
        case 3:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
            
        case 4:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
        case 5:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
            
        case 6:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
        case 7:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
            
        case 8:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        case 9:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        case 10:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        case 11:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        case 12:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        case 13:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        case 14:
            if get == true {
                cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
            } else if non == true {
                cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
            }
        default:
            cell.stickerImageView.image = UIImage()
        }
        return cell
        }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 90
        
            let numberofColumn = 3
            let width = (self.stickerCollectionView.frame.size.width - CGFloat((numberofColumn - 1 ) * 10)) / CGFloat(numberofColumn)
        
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: width, height: collectionViewSize/3)
        
    }

}


extension StickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        // 좌표보정을 위해 절반의 너비를 더해줌
        let x = scrollView.contentOffset.x + (width/2)
        
        let newPage = Int(x / width)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}

     //MARK: - bottom sheet

extension StickerViewController {
    
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideBottomSheet"), object: nil)
            default:
                break
            }
        }
    }
}

