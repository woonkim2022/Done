//
//  TextTableViewCell.swift
//  Done
//
//  Created by 안현정 on 2022/03/18.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var todayRecordContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        todayRecordContent.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
    
}
