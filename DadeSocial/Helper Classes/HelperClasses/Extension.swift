
import UIKit
import AVFoundation
import AVKit
var currentTrack: Int = 0
var badgeCountTimer = Timer()

var isPlaying:Bool = false

var audioPlayer:AVAudioPlayer?
var timer:Timer!
var trackCount: Int = 0
var audioArray = [Any]()
var audioURL = String()


extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView {
    func leftSpace(_ amount:CGFloat) {
    self.textContainerInset = UIEdgeInsets(top: 4, left: amount, bottom: 4, right: 4)
}
}
extension UIView {
    
    func dropShadow() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = Config().AppGrayColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
    }
}
@available(iOS 13.0, *)
extension UIViewController{
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = Float(Config().screenHeight+Config().screenHeight)
        let maxWidth: Float = Float(Config().screenWidth+Config().screenWidth)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        // let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: 0.5)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
        
    }
    func presentViewController(_ PresentController: UIViewController){
        let DetailVC = PresentController
        let navctrl = UINavigationController(rootViewController: DetailVC)
        self.present(navctrl, animated: true, completion: nil)
    }
    
    func RootViewControllerWithOutNav(_ RootViewController: UIViewController){
        
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.duration = 0.3
        slideInFromLeftTransition.type = .fade
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromBottom;
        self.view.window?.layer.add(slideInFromLeftTransition, forKey: kCATransition)
        self.view.window?.rootViewController = RootViewController
    }
    
    func RootViewControllerWithNav(_ RootViewController: UIViewController){
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.duration = 0.2
        slideInFromLeftTransition.type = .fade
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromBottom;
        self.view.window?.layer.add(slideInFromLeftTransition, forKey: kCATransition)
        let navctrl = UINavigationController(rootViewController: RootViewController)
        self.view.window?.rootViewController = navctrl
    }
    func RootViewWithSideManu(_ RootViewController: UIViewController){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        
        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:RootViewController), leftMenuViewController: leftController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = initialViewController
        self.view.window?.rootViewController = slideMenuController
        
    }
    func onlyPushViewController(_ PushController: UIViewController){
        let DetailVC = PushController
        self.navigationController?.pushViewController(DetailVC, animated: true)
        
    }
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
    }
}

func convertStringToAny(StringOfAny: String) -> Any? {
    
    let dataOfString = StringOfAny.data(using: String.Encoding.utf8, allowLossyConversion: false)
    
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: dataOfString!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
        return jsonObject
    }
    catch let error as NSError {
        print(error)
        return nil
    }
    
}
extension String {
    var html2AttributedWhite: NSAttributedString? {
        do {
            
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: 10pt !important;" +
                "text-align: 10pt !important;" +
                "color: #f5f5f5 !important;" +
                "font-family: Helvetica Neue;" +
                "}</style>"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
            
        }catch {
            print("error: ", error)
            return nil
        }
        
    }
    
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                                          ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func setHtmlText(_ html: String)-> NSAttributedString {
        return html.attributedHtmlString!
    }
}
extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
extension UINavigationBar {
    func setGradientBackground(colors: [Any]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0 , 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)

        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        gradient.frame = updatedFrame
        gradient.colors = colors;
        self.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
    }

    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}
