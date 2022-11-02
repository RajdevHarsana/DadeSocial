

import UIKit

class MyLabel: UILabel {
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet {
            setCornerRadious()
        }
    }
    func setCornerRadious(){
        self.layer.cornerRadius = cornerRadious
        self.layer.borderWidth = BorderWidth
        self.layer.borderColor = BorderColor.cgColor
        
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0 {
        didSet {
            setCornerRadious()
        }
    }
    @IBInspectable var BorderColor: UIColor = UIColor.white{
        didSet {
            setCornerRadious()
        }
    }
    
}
