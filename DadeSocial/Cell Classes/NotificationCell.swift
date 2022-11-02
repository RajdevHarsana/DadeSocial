//
//  NotificationCell.swift
//  DadeSocial
//
//  Created by MAC-27 on 05/04/21.
//

import UIKit

class NotificationCell: UITableViewCell {

    
    
    @IBOutlet weak var notiImg: UIImageView!
    @IBOutlet weak var notiNameLbl: UILabel!
    @IBOutlet weak var notiDetailLbl: UILabel!
    @IBOutlet weak var notiDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
