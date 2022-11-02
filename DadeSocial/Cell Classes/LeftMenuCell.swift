//
//  LeftMenuCell.swift
//  DadeSocial
//
//  Created by MAC-27 on 06/04/21.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
