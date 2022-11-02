//
//  InstaCell.swift
//  DadeSocial
//
//  Created by MAC-27 on 18/05/21.
//

import UIKit
import AVFoundation

class InstaCell: UITableViewCell, ASAutoPlayVideoLayerContainer {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userCityLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var captionLbl: ExpandableLabel!
    @IBOutlet weak var uploadDateTimeLbl: UILabel!
    
//    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var    videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImgView.layer.cornerRadius = self.userImgView.bounds.width / 2
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        contentImgView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }

    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
        self.contentImgView.imageURL = imageUrl
        self.videoURL = videoUrl
    }

    override func prepareForReuse() {
        contentImgView.imageURL = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let horizontalMargin: CGFloat = 20
        let width: CGFloat = self.contentImgView.frame.width
        let height: CGFloat = self.contentImgView.frame.height
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(contentImgView.frame, from: contentImgView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}
