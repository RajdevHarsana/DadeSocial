//
//  RatingCell.swift
//  DadeSocial
//
//  Created by MAC-27 on 19/04/21.
//

import UIKit

class RatingCell: UITableViewCell {

    @IBOutlet weak var reviewImg: UIImageView!
    @IBOutlet weak var reviewName: UILabel!
    @IBOutlet weak var reviewRating: FloatRatingView!
    @IBOutlet weak var reviewPointsLbl: UILabel!
    @IBOutlet weak var reviewDateLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var reviewDiscriptionTxt: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.reviewImg.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
