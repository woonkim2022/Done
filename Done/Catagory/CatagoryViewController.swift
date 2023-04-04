//
//  CatagoryViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/11.
//

import UIKit

extension CatagoryViewController {
    func didCatagoryService(result: Category) {
        catagories = result.categories
        catagoryCollectionView.reloadData()
    }
}


class CatagoryViewController: UIViewController {
    lazy var dataManager: CatagoryService = CatagoryService()

    //MARK: - Properties
    
    @IBOutlet weak var catagoryCollectionView: UICollectionView!
    
    var catagories: [Categorylist] = [Categorylist]()
    var catagoryNo : Int = 0

    //MARK: - Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()
        
        catagoryCollectionView.delegate = self
        catagoryCollectionView.dataSource = self
        
        dataManager.getData(self)

    }
    
    //MARK: - Actions
    
    //MARK: - Helpers


}

 //MARK: - UICollectionViewDelegate,DataSource

extension CatagoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catagories.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "CatagoryCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CatagoryCollectionViewCell
        let catagory = catagories[indexPath.row]
        cell.catagoryImage.image = UIImage(named: "\(catagory.category_no)")
 
        return cell
    }
    
    // 선택한 카테고리No 보내주기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            let catagory = catagories[indexPath.row]
            catagoryNo = catagory.category_no
            print("선택한 카테고리 넘버 ----> \(catagoryNo)")
            NotificationCenter.default.post(name: NSNotification.Name("catagoryNo"), object: catagoryNo)
        }
    }
    
    
