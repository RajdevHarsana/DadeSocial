
//

import UIKit

class MyTextField: UITextField {
    
    @IBInspectable var rightImage: String = "" {
        didSet {
            setRightImage()
        }
    }
    func setRightImage(){
        
        let DropDownEmailVw = UIImageView()
        DropDownEmailVw.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
        DropDownEmailVw.image = UIImage(named: rightImage)
        DropDownEmailVw.contentMode = .center
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(DropDownEmailVw)
        
        self.rightViewMode = UITextField.ViewMode.always
        self.rightView = DropDownEmailVw
        
    }
    
    @IBInspectable var leftImage: String = "" {
        didSet {
            setLeftImage()
        }
    }
    func setLeftImage(){
        let DropDownEmailVw = UIImageView()
        DropDownEmailVw.frame = CGRect(x: 10,y: 10,width: 30,height: 20)
        DropDownEmailVw.image = UIImage(named: leftImage)
        DropDownEmailVw.contentMode = .center
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = DropDownEmailVw
        
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leadingPadding
        return textRect
    }
    @IBInspectable var leadingPadding: CGFloat = 10
    
    @IBInspectable var leftSpace: CGFloat = 0 {
        didSet {
            setleftSpace()
        }
    }
    func setleftSpace(){
        let DropDownEmailVw = UIImageView()
        DropDownEmailVw.frame = CGRect(x: 10,y: 10,width: leftSpace,height: 20)
        DropDownEmailVw.contentMode = .center
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = DropDownEmailVw
        
    }
    
    @IBInspectable var attributePlaceHolder: String = "" {
        
        didSet {
            setAttributePlaceHolder()
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor = UIColor.white {
        didSet {
            setAttributePlaceHolder()
        }
    }
    
    func setAttributePlaceHolder(){
        self.attributedPlaceholder = NSAttributedString(string:attributePlaceHolder,attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor]);
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

    
}
