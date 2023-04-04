//
//  HashtagViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/11.
//

import UIKit

extension HashtagViewController {
    func didhashtagService(result: Tag) {
        tags = result.tags
        tagCollectionView.reloadData()
    }
}

class HashtagViewController: UIViewController {
 
    lazy var dataManager: hashtagService = hashtagService()
    //MARK: - Properties
    
    @IBOutlet weak var tagCollectionView: UICollectionView!

    var tags: [Taglist] = [Taglist]()

    var tagContent : String = ""
    var catagoryNumber : Int = 0
    
    var mainVC : DoneTextVC?
    
    var randomState = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSetup()
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        dataManager.getData(self)
        
        print("해시태그 viewdidload---------")
 
    }
    
    //MARK: - Actions
    
    @IBAction func tappedRandomBtn(_ sender: Any) {
        dataManager.getData(self)
        randomState = true //랜덤버튼 눌렀을 때, 회색버튼이 파란색 버튼 되도록하기
    
    }
    
    
    //MARK: - Default Methods

 

    // 컬렉션뷰 셀 중앙정렬 레이아웃 매소드
    func defaultSetup() {
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 35)
        tagCollectionView.collectionViewLayout = layout

        let nib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
        tagCollectionView?.register(nib, forCellWithReuseIdentifier: "TagCollectionViewCell")
    }
    
    @objc func didTapTag(sender : UIButton){
        print("화면전환 구현해주기")

   }
    

}


//MARK: - UICollectionViewDelegate,DataSource

extension HashtagViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "TagCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        let tags = tags[indexPath.row]
        cell.tagBtn.text = "#\(tags.name!)"
        
        if randomState == true {
            cell.unSelectTag()
        }
   
        return cell
    }
    

    // 선택한 해시태그 text 텍스트필드로 보내주기
    // 선택한 해시태그 컬러 바꿔주기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
            cell.selectTag()
            let tags = tags[indexPath.row]
            tagContent = tags.name ?? ""
            catagoryNumber = tags.category_no ?? 0
            NotificationCenter.default.post(name: NSNotification.Name("notificationName2"), object: tagContent)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HashtagCatagoryNo"), object: catagoryNumber)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "routinTagBlue"), object: nil)

        }
    }
    
    // 선택안한 해시태그 색상 변경
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
            cell.unSelectTag()
        }
    }


    
}
