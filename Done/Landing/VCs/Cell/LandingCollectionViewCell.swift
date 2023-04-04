//
//  LandingCollectionViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/04/03.
//

import UIKit

class LandingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: LandingCollectionViewCell.self)
    
    @IBOutlet weak var titleTextLb: UILabel!
    @IBOutlet weak var subTitleTextLb: UILabel!
    @IBOutlet weak var landingImg: UIImageView!

    
    func setup(_ slide: onBoardingSlide) {
        titleTextLb.text = slide.title
        subTitleTextLb.text = slide.subtitle
    }
}
