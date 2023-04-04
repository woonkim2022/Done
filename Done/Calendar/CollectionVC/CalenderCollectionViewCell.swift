

//  CalenderCollectionViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/02/28.
//

import UIKit

class CalenderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stickerImage: UIImageView!
    @IBOutlet weak var todayImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        dateView.layer.cornerRadius = dateView.frame.width/2.2
        dateView.clipsToBounds = true
        dateView.backgroundColor = UIColor.white
        //backgroundColor = UIColor.black
        stickerImage.image = UIImage(named: "")

    }

    func set (_ calendarInformation: Done) {
        stickerImage.image = UIImage(named:calendarInformation.color)
        dateLabel.text = calendarInformation.doneDate
    }

    // XIB 연결해주기
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> CalenderCollectionViewCell {
        let CalenderCollectionViewCellIdentifier = "CalendarCollectionViewCellIdentifier"

        collectionView.register(UINib(nibName: "CalenderCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: CalenderCollectionViewCellIdentifier)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCellIdentifier, for: indexPath) as! CalenderCollectionViewCell
        return cell
    }


}
