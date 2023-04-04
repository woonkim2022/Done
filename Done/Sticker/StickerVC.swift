//
//  StickerVC.swift
//  Done
//
//  Created by 안현정 on 2022/03/30.
//

import UIKit

extension StickerVC {
    
     // 내 스티커 조회
    func didStickerService(_ response: myStickerDataModel) {
        stickerList =  response.item?.stickers ?? []

        for i in stickerList {
            stickername.append(i.name ?? "")
        }

        if stickername.isEmpty {
            print("빈배열입니다")
        } else {
            print("빈배열이 아닙니다")
        }

        print(stickername)
    }

    // 전체 스티커 조회
    func didAllStickerService(_ response: allStickerDataModel) {
        allStickerList = response.item?.stickers ?? []
        print(allStickerList)
    }
    
    

}

class StickerVC: UIViewController {
    
   // lazy var getDataManager: myStickerService2 = myStickerService2()
    lazy var allGetDataManager: allStickerService = allStickerService()


    //MARK: - Properties
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var stickerCollcetionView: UICollectionView!
    @IBOutlet weak var sticker2CollcetionView: UICollectionView!
    @IBOutlet weak var sticker3CollcetionView: UICollectionView!
    
    //데이터 변수
    var stickerNo : Int = 0
    var stickerImageNo : Int = 0
    var stickerList : [MyStickerlist] = []
    var allStickerList : [allStickerList] = []
    var stickername = [String]()
    
    var stickerImages = ["첫 한마디","한눈에 쏙!","소확던(Done)","나만의 습관","나만의 플랜","플랜X10"]
    var stickerImages2 = [ "해냄이 1일차","작심삼일 극복","30일 해냄","DONE100","꾸준함의 힘"]
    var stickerImages3 = ["다시 시작!", "휴식도 필요해","해냄 홀릭"]
    
    var nonStickerImages = ["N첫 한마디","N한눈에 쏙!","N소확던(Done)","N나만의 습관","N나만의 플랜","N플랜X10"]
    var nonStickerImages2 = ["N해냄이 1일차","N작심삼일 극복","N30일 해냄","NDONE100","N꾸준함의 힘"]
    var nonStickerImages3 = ["N다시 시작!","N휴식도 필요해","N해냄 홀릭"]
    
    
    //MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()

       //getDataManager.getData(self)
        allGetDataManager.getData(self)
        
        print(stickername)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       }
    
    //MARK: - Helpers

   
}

//MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension StickerVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == stickerCollcetionView {
            return stickerImages.count
        } else if collectionView == sticker2CollcetionView {
            return stickerImages2.count
        } else {
            return stickerImages3.count
        }
      
    }
    
    // 셀 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        if collectionView == stickerCollcetionView {
            if let vc = storyboard!.instantiateViewController(withIdentifier: "stickerExplainPopupVC") as? stickerExplainPopupVC {
                vc.stickerName = allStickerList[indexPath.row].name ?? ""
                vc.stickerExplain = allStickerList[indexPath.row].explanation ?? ""
         
                print(vc.stickerName)
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == stickerCollcetionView {

           if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Sticker1CollectionViewCell", for: indexPath) as? Sticker1CollectionViewCell {

            
            print("stickername -----\(stickername)")
            
                var get = false
                var non = false

               if stickername.isEmpty {
                   non = true
               }
             
               
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
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    }
                    
                case 1:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    }
                    
                case 2:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    }
                    
                case 3:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                        
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    }
                    
                case 4:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    }
                    
                case 5:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages[indexPath.row])
                        cell.stickerLb.text = stickerImages[indexPath.row]
                    }
                    
                default:
                    cell.stickerImageView.image = UIImage()
                    
                }
            
                return cell
            }
            return UICollectionViewCell()
            
        } else if collectionView == sticker2CollcetionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Sticker2CollectionViewCell", for: indexPath) as? Sticker2CollectionViewCell {
                
                var get = false
                var non = false

                if stickername.isEmpty {
                    non = true
                }

                for i in stickername {
                    if i == stickerImages2[indexPath.row] {
                        get = true
                    } else {
                        non = true
                    }
                }

                switch indexPath.row {
                    
                case 0:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    }
                    
                case 1:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    }
                    
                case 2:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    }
                    
                case 3:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                        
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    }
                    
                case 4:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    }
                    
                case 5:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages2[indexPath.row])
                        cell.stickerLb.text = stickerImages2[indexPath.row]
                    }
                    
                default:
                    cell.stickerImageView.image = UIImage()
                
            }
                return cell
            }
            return UICollectionViewCell()
            
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Sticker3CollectionViewCell", for: indexPath) as? Sticker3CollectionViewCell {
                
                var get = false
                var non = false

                if stickername.isEmpty {
                    non = true
                }

                for i in stickername {
                    if i == stickerImages3[indexPath.row] {
                        get = true
                    } else {
                        non = true
                    }
                }

                switch indexPath.row {
                    
                case 0:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages3[indexPath.row])
                        cell.stickerLb.text = stickerImages3[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages3[indexPath.row])
                        cell.stickerLb.text = stickerImages3[indexPath.row]
                    }
                    
                case 1:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages3[indexPath.row])
                        cell.stickerLb.text = stickerImages3[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages3[indexPath.row])
                        cell.stickerLb.text = stickerImages3[indexPath.row]
                    }
                    
                case 2:
                    if get == true {
                        cell.stickerImageView.image = UIImage(named: stickerImages3[indexPath.row])
                        cell.stickerLb.text = stickerImages3[indexPath.row]
                    } else if non == true {
                        cell.stickerImageView.image = UIImage(named: nonStickerImages3[indexPath.row])
                        cell.stickerLb.text = stickerImages3[indexPath.row]
                    }
                default:
                    cell.stickerImageView.image = UIImage()
                
            }
                return cell
            }
            return UICollectionViewCell()
        }
        
    }
    
    
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    
    
}

