//
//  levelTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import UIKit

class levelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet var levelName: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var levelExplain : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
