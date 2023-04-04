//
//  MyTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var versionLb: UILabel!
    @IBOutlet weak var detailBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        versionLb.isHidden = true 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
