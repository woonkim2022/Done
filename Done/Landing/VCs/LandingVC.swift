//
//  LandingVC.swift
//  Done
//
//  Created by 안현정 on 2022/02/15.
//

import UIKit
import SnapKit

class LandingVC: UIViewController {

    //MARK: - Outlets
    

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var pagecontrolBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomAnchor: NSLayoutConstraint!
    
    var bannerImages = ["배너이미지1","배너이미지2","배너이미지3"]
    var currentcellIndex = 0
    var timer: Timer?
    var slides : [onBoardingSlide] = []
    

    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                startBtn.setTitle("시작하기", for: .normal)
            } else {
                startBtn.setTitle("다음", for: .normal)

            }
        }
    }
    
   
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userdefault()
        layoutSetting()
//        pageControl.numberOfPages = slides.count
    //pageControl.currentPage = 0#imageLiteral(resourceName: "배너이미지1")

        slides = [
            onBoardingSlide(title: "선택하는 재미!", subtitle: "카테고리를 선택해\n다채로운 던리스트 작성") ,
            onBoardingSlide(title: "간편한 작성!", subtitle: "해시태그 기능으로,\n귀찮은 날에도 간편한 작성!"),
            onBoardingSlide(title: "귀여운 던던이 스티커까지!", subtitle: "던던이 스티커를 모아\n하루를 마무리해보세요!")]
        
        pageControl.numberOfPages = slides.count
        
        if UserDefaults.standard.bool(forKey: "autologin") == true {
            let storyBoard = UIStoryboard(name: "LoginStoryboard", bundle:  nil)
              if let vc = storyBoard.instantiateViewController(withIdentifier: "NicknameVC") as? NicknameVC {
                  self.navigationController?.pushViewController(vc, animated: true) }
            print("닉네임 화면으로 전환되었습니다")
            
            if UserDefaults.standard.bool(forKey: "changeMainVC") == true {
                let vcName = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarVC")
                    changeRootViewController(vcName)
                print("자동 로그인되었습니다")
            }
            
        }

    }
    
    
     
    //MARK: - Actions
    

    
    @IBAction func nextToButton(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            guard let vcName = UIStoryboard(name: "LandingStoryboard ", bundle: nil).instantiateViewController(identifier: "LandingLoginVC") as? LandingLoginVC else {return}
                 
                 self.navigationController?.pushViewController(vcName, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    //MARK: - Helpers
    
    func layoutSetting(){
        if UIDevice.current.isiPhoneSE2{
            collectionTopAnchor.constant = 100
            pagecontrolBottomAnchor.constant = 20
            buttonBottomAnchor.constant = 70
        }
    }
    
    
    func userdefault() {
        if let value = UserDefaults.standard.value(forKey: "emailData") as? String {
            print("userdefault email : \(value)")
        }
        if let value = UserDefaults.standard.value(forKey: "pw") as? String {
            print("userdefault pw : \(value)")
        }
    }
}



 //MARK: - CollectionView

extension LandingVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return slides.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingCollectionViewCell.identifier, for: indexPath) as! LandingCollectionViewCell
      cell.setup(slides[indexPath.row])
      cell.landingImg.image = UIImage(named: bannerImages[indexPath.row])
      return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.width, height:  collectionView.frame.height)
  }
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

//extension LandingVC: UIScrollViewDelegate {
//  func scrollViewDidScroll(_ scrollView: UIScrollView) { // 컬렉션뷰를 스크롤하면 반복적으로 호출
//      let width = scrollView.bounds.size.width // 너비 저장
//      let x = scrollView.contentOffset.x + (width / 2.0) // 현재 스크롤한 x좌표 저장
//
//      let newPage = Int(x / width)
//      if pageControl.currentPage != newPage {
//          pageControl.currentPage = newPage
//      }
//  }
//}
