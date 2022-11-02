//
//  DataCell.swift
//  DadeSocial
//
//  Created by MAC-27 on 02/04/21.
//

import UIKit

class DataCell: UITableViewCell {
    
    
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var bussnessName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var featuredIcon: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var reviewRating: FloatRatingView!
    @IBOutlet weak var reviewsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.distance.layer.cornerRadius = 10
        self.distance.layer.masksToBounds = true
        self.ImgView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
