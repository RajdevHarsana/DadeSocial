//
//  FeedImageCollectionViewCell.swift
//  KDInstagram
//
//  Created by Sam Ding on 7/12/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit
import AVFoundation

class FeedImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 5
        imgView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        imgView.clipsToBounds = true
        imgView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        imgView.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        imgView.layer.addSublayer(videoLayer)
    }
    
    func configure(image: UIImage){
        self.imgView.image = image
    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
        self.imgView.imageURL = imageUrl
        self.videoURL = videoUrl
    }

    override func prepareForReuse() {
        imgView.imageURL = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(imgView.frame, from: imgView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
}



