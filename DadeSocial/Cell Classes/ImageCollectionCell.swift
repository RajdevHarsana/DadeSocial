//
//  ImageCollectionCell.swift
//  DadeSocial
//
//  Created by MAC-27 on 27/05/21.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var businessImages: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.businessImages.layer.cornerRadius = 15
    }
}
