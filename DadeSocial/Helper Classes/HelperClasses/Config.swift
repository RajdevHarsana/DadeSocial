

import Foundation
import UIKit
import SDWebImage
class Config: NSObject,UIAlertViewDelegate {
    
 
//    let API_URL = "https://dade-social-app.devtechnosys.info/Webservices/"//Demo
//    let API_URL = "https://3.16.75.86/Webservices/"//Live
    let API_URL = "https://dadesocial.net/Webservices/"//Live
    
   // let WEB_URL = "https://3.16.75.86/"//web content
    let WEB_URL = "https://dadesocial.net/"//web content

    let AppAlertTitle = "Dade Social"
    let AppUserDefaults = UserDefaults.standard
    
    let debug_mode = 1
    let NO_IMAGE = "No image available"
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    let imgArray = ["1","2","3","4","5","6","7","8","9","10"]
    let MagicianImgArray = ["11","12","13","14","15","11","12","13","14","15"]
    let CarImgArray = ["16","17","18","19","20","16","17","18","19","20"]
    let ServiceImgArray = ["21","22","23","24","25","21","22","23","24","25"]
    let FoodImgArray = ["26","27","28","29","30","26","27","28","29","30"]
    /********************************* App Color Codes ***************************************/
    let AppNavTextColor = UIColor(red: 141/255, green: 57/255, blue: 181/255, alpha: 1.0)
    
    let AppLineColor = UIColor.lightText
    let AppGrayColor = UIColor(white: 0xDCDCDC, alpha: 1.0)
    let AppBlackColor = UIColor.black
    let AppRedColor = UIColor(red: 233/255, green: 62/255, blue: 39/255, alpha: 1.0)
    let AppAppleColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    
    let AppWhiteColor = UIColor.white
    let AppClearColor = UIColor.clear

    func printData(_ dataValue : Any ){
        if debug_mode == 1 {
            print(dataValue)
        }
    }
    
    func AppGlobalFont(_ fontSize:CGFloat,isBold:Bool) -> UIFont {
        
        let fontName : String!
        fontName = (isBold) ? "Lato-Bold" : "Lato-Regular"
        
        return UIFont(name: fontName, size: fontSize)!
    }
    func TblViewbackgroundLbl(array: [Any],tblName: UITableView,message: String){
        tblName.reloadData()
        if array.count > 0{
            tblName.backgroundView = nil
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tblName.frame.size.width, height: tblName.frame.size.height))
            label.font = Config().AppGlobalFont(20, isBold: true)
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 2
            label.text = message
            tblName.backgroundView = label
        }
    }
    func CollectionViewbackgroundLbl(array: [Any],collectionName: UICollectionView,message: String){
        collectionName.reloadData()
        if array.count > 0{
            collectionName.backgroundView = nil
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: collectionName.frame.size.width, height: collectionName.frame.size.height))
            label.font = Config().AppGlobalFont(20, isBold: true)
            label.textColor = .black
            label.textAlignment = .center
            label.text = message
            label.numberOfLines = 2
            collectionName.backgroundView = label
        }
    }
    
    func setimage(name: String,image: UIImageView){
        if name != ""{
            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            activityIndicator.center = (image.center)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            let block: SDWebImageCompletionBlock! = { (image:UIImage?, error: Error?, cache:SDImageCacheType, url: URL?) in
                activityIndicator.stopAnimating()
            }
            let picture_url = URL(string: name)
            image.addSubview(activityIndicator)
            image.sd_setImage(with: picture_url , placeholderImage: UIImage(named: "dummy4"), options:  [], completed:block)
        }else{
            image.image = UIImage(named: "No image available")
        }
        
    }
    func VibrateOnClick(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

}




