

import UIKit

class MyImageView: UIImageView {
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet {
            setCornerRadious()
        }
    }
    func setCornerRadious(){
        self.layer.cornerRadius = cornerRadious
        
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            setBorderColor()
        }
    }
    @IBInspectable var BorderWidth: CGFloat = 0 {
        didSet {
            setBorderColor()
        }
    }
    func setBorderColor(){
        
        self.layer.borderColor = BorderColor.cgColor
        self.layer.borderWidth = BorderWidth
        
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {

            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{

        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set {

            layer.shadowOpacity = newValue

        }
    }

}
