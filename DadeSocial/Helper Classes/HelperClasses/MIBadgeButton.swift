

import UIKit
class MIBadgeButton: UIButton {
    
    var badgeLabel = UILabel()
    @IBInspectable var badgeString: String = "" {
        didSet {
            self.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
            
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    @IBInspectable var badgeEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    @IBInspectable var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    @IBInspectable var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    
    fileprivate func setupBadgeViewWithString(badgeText: String?) {
        badgeLabel.clipsToBounds = true
        badgeLabel.text = badgeText
        badgeLabel.font = Config().AppGlobalFont(7, isBold: false)
        badgeLabel.textAlignment = .center
        badgeLabel.sizeToFit()
        let badgeSize = badgeLabel.frame.size
        
        let height = max(10, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 5.0)
        
        var vertical: Double?, horizontal: Double?
        let badgeInset = self.badgeEdgeInsets
        vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
        horizontal = Double(badgeInset.left) - Double(badgeInset.right)
        
        let x = (Double(bounds.size.width) - 10 + horizontal!)
        let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
        badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        setupBadgeStyle()
        addSubview(badgeLabel)
        
        if let text = badgeText {
            badgeLabel.isHidden = text != "" ? false : true
        } else {
            badgeLabel.isHidden = true
        }
    }
    
    fileprivate func setupBadgeStyle() {
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.textColor = badgeTextColor
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
    }
    
    
    
}
