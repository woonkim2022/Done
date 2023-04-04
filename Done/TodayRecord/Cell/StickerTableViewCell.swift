//
//  StickerTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/18.
//

import UIKit

class StickerTableViewCell: UITableViewCell {

     @IBOutlet weak var stickerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
