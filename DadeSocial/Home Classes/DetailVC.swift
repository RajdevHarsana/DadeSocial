//
//  DetailVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 06/04/21.
//

import UIKit
import MessageUI
import SafariServices
import MapKit

class DetailVC: UIViewController {
    
    //MARK:- IBOutlates
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    @IBOutlet weak var HeaderImagePageController: UIPageControl!
    @IBOutlet weak var TitleNameLbl: UILabel!
    @IBOutlet weak var BusinessNameLbl: UILabel!
    @IBOutlet weak var distancelbl: UILabel!
    @IBOutlet weak var ratingReviewBtn: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var LocationBtn: UIButton!
    @IBOutlet weak var reviewsLbl: UILabel!
    @IBOutlet weak var BusinessDiscription: UITextView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var businessEmailLbl: UIButton!
    @IBOutlet weak var businnesPhoneLbl: UIButton!
    @IBOutlet weak var WebSiteImg: UIImageView!
    @IBOutlet weak var WebSiteLbl: UIButton!
    @IBOutlet weak var TwitterImg: UIImageView!
    @IBOutlet weak var TwitterLbl: UIButton!
    @IBOutlet weak var FacebookImg: UIImageView!
    @IBOutlet weak var FacebookLbl: UIButton!
    @IBOutlet weak var InstaImg: UIImageView!
    @IBOutlet weak var InstagramLbl: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var webImgTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var webImgHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var WebUrlBtnTopConst: NSLayoutConstraint!
    @IBOutlet weak var WebUrlBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var twitterImgTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var twitterImgHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var twitterUrlBtnTopConst: NSLayoutConstraint!
    @IBOutlet weak var twitterUrlBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var fbImgTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var fbImgHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var fbUrlBtnTopConst: NSLayoutConstraint!
    @IBOutlet weak var fbUrlBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var InstaImgTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var InstaImgHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var InstaUrlBtnTopConst: NSLayoutConstraint!
    @IBOutlet weak var InstaUrlBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var secondaryAddressIcon: UIImageView!
    @IBOutlet weak var secondaryAddress: UIButton!
    @IBOutlet weak var secondaryAddressIconTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var secondaryAddressIconHeightCons: NSLayoutConstraint!
    @IBOutlet weak var secondaryAddressBtnTopCons: NSLayoutConstraint!
    @IBOutlet weak var secondaryAddressBtnHeightCons: NSLayoutConstraint!
    
    //MARK:- Variables
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var DetailDataDict = [String:Any]()
    var Lat = String()
    var Long = String()
    var Business_User_Id = String()
    var pictureArray = [Any]()
    var WebsiteTxt = String()
    var TwitterTxt = String()
    var FaceBookTxt = String()
    var InstaTxt = String()
    var placeLat = String()
    var placeLong = String()
    var addressn = ""
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let LayOut = UICollectionViewFlowLayout()
        LayOut.itemSize = CGSize(width: screenWidth-60, height: 350)
        LayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LayOut.minimumInteritemSpacing = 0
        LayOut.minimumLineSpacing = 0
        LayOut.scrollDirection = .horizontal
        self.ImageCollectionView.collectionViewLayout = LayOut
        self.ImageCollectionView.isPagingEnabled = true
        self.ImageCollectionView.tag = 1
        self.ImageCollectionView.layer.cornerRadius = 15
        self.ImageCollectionView.delegate = self
        self.ImageCollectionView.dataSource = self
        self.distancelbl.layer.cornerRadius = 15
        self.distancelbl.layer.masksToBounds = true
        self.categoryLbl.layer.cornerRadius = 10
        self.categoryLbl.layer.masksToBounds = true
        self.ratingView.rating = 3
        self.BusinessDiscription.layer.cornerRadius = 5
        self.BusinessDiscription.layer.borderWidth = 1
        self.BusinessDiscription.layer.borderColor = UIColor.systemGray5.cgColor
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getBusinessDetailsAPI()
    }
    //MARK:- Business List API Function
    func getBusinessDetailsAPI(){
        //        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let _lat = placeLat
        let _long = placeLong
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.Business_User_Id), forKey: "business_user_id")
        dict.setValue(DataManager.getVal(_lat), forKey: "latitude")
        dict.setValue(DataManager.getVal(_long), forKey: "longitude")
        dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
        let methodName = "getBusinessDetail"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.DetailDataDict = DataManager.getVal(responseData?["business_users"]) as! [String:Any]
                self.TitleNameLbl.text = DataManager.getVal(self.DetailDataDict["business_name"]) as? String ?? ""
                self.pictureArray = DataManager.getVal(self.DetailDataDict["images"]) as? [Any] ?? []
                self.BusinessNameLbl.text = DataManager.getVal(self.DetailDataDict["business_name"]) as? String ?? ""
                self.distancelbl.text = " " + (DataManager.getVal(self.DetailDataDict["distance"]) as? String ?? "") + " away "
                let categoryName = DataManager.getVal(self.DetailDataDict["category_name"]) as? String ?? ""
                self.categoryLbl.text = "" + categoryName + "      "
//                self.locationLbl.text = DataManager.getVal(self.DetailDataDict["address"]) as? String ?? ""
                self.Lat = DataManager.getVal(self.DetailDataDict["latitude"]) as? String ?? ""
                self.Long = DataManager.getVal(self.DetailDataDict["longitude"]) as? String ?? ""
                let rating = DataManager.getVal(self.DetailDataDict["rating"]) as? String ?? ""
                self.ratingView.rating = self.StringToFloat(str: rating)
                self.reviewsLbl.text = (DataManager.getVal(self.DetailDataDict["review"]) as? String ?? "") + " Review"
                
                self.BusinessDiscription.text = DataManager.getVal(self.DetailDataDict["description"]) as? String ?? ""
                self.addressLbl.text = DataManager.getVal(self.DetailDataDict["address"]) as? String ?? ""
                self.addressn =  DataManager.getVal(self.DetailDataDict["address"]) as? String ?? "Source"
                let secondaryAddress = DataManager.getVal(self.DetailDataDict["secondary_address"]) as? String ?? ""
                self.businessEmailLbl.setTitle(DataManager.getVal(self.DetailDataDict["email"]) as? String ?? "", for: .normal)
                self.businnesPhoneLbl.setTitle(DataManager.getVal(self.DetailDataDict["contact_number"]) as? String ?? "", for: .normal)
                if self.pictureArray.count == 0{
                    self.ImageCollectionView.isHidden = true
                    self.HeaderImagePageController.isHidden = true
                }else{
                    self.ImageCollectionView.isHidden = false
                    self.HeaderImagePageController.isHidden = false
                    self.ImageCollectionView.reloadData()
                }
                self.WebsiteTxt = DataManager.getVal(self.DetailDataDict["website_link"]) as? String ?? ""
                let twitter = DataManager.getVal(self.DetailDataDict["twiiter_link"]) as? String ?? ""
                self.TwitterTxt = twitter.replacingOccurrences(of: "http://www.", with: "")
                let faceBook = DataManager.getVal(self.DetailDataDict["facebook_link"]) as? String ?? ""
                self.FaceBookTxt = faceBook.replacingOccurrences(of: "http://www.", with: "")
                let insta = DataManager.getVal(self.DetailDataDict["instagram_link"]) as? String ?? ""
                self.InstaTxt = insta.replacingOccurrences(of: "http://www.", with: "")
                
                if secondaryAddress != "" {
                    self.secondaryAddress.setTitle(secondaryAddress, for: .normal)
                    self.secondaryAddressIconTopConstrant.constant = 8
                    self.secondaryAddressIconHeightCons.constant = 20
                    self.secondaryAddressBtnTopCons.constant = 8
                    self.secondaryAddressBtnHeightCons.constant = 20
                    self.secondaryAddressIcon.isHidden = false
                }else{
                    self.secondaryAddressIconTopConstrant.constant = 0
                    self.secondaryAddressIconHeightCons.constant = 0
                    self.secondaryAddressBtnTopCons.constant = 0
                    self.secondaryAddressBtnHeightCons.constant = 0
                    self.secondaryAddressIcon.isHidden = true
                }
                
                if self.WebsiteTxt != ""{
                    self.WebSiteLbl.setTitle( self.WebsiteTxt , for: .normal)
                    self.webImgTopConstrant.constant = 8
                    self.webImgHeightConstrant.constant = 20
                    self.WebUrlBtnTopConst.constant = 8
                    self.WebUrlBtnHeightConst.constant = 20
                    self.WebSiteImg.isHidden = false
                }else{
//                    self.WebSiteLbl.setTitle( "Web Link not available" , for: .normal)
                    self.webImgTopConstrant.constant = 0
                    self.webImgHeightConstrant.constant = 0
                    self.WebUrlBtnTopConst.constant = 0
                    self.WebUrlBtnHeightConst.constant = 0
                    self.WebSiteImg.isHidden = true
                }
                if self.TwitterTxt != "" {
                    self.TwitterLbl.setTitle("Twitter" , for: .normal)
                    self.twitterImgTopConstrant.constant = 8
                    self.twitterImgHeightConstrant.constant = 20
                    self.twitterUrlBtnTopConst.constant = 8
                    self.twitterUrlBtnHeightConst.constant = 20
                    self.TwitterImg.isHidden = false
                }else{
//                    self.TwitterLbl.setTitle("Twitter id not available" , for: .normal)
                    self.twitterImgTopConstrant.constant = 0
                    self.twitterImgHeightConstrant.constant = 0
                    self.twitterUrlBtnTopConst.constant = 0
                    self.twitterUrlBtnHeightConst.constant = 0
                    self.TwitterImg.isHidden = true
                }
                if self.FaceBookTxt != "" {
                    self.FacebookLbl.setTitle("Facebook" , for: .normal)
                    self.fbImgTopConstrant.constant = 8
                    self.fbImgHeightConstrant.constant = 20
                    self.fbUrlBtnTopConst.constant = 8
                    self.fbUrlBtnHeightConst.constant = 20
                    self.FacebookImg.isHidden = false
                }else{
//                    self.FacebookLbl.setTitle("Facebook id not not available", for: .normal)
                    self.fbImgTopConstrant.constant = 0
                    self.fbImgHeightConstrant.constant = 0
                    self.fbUrlBtnTopConst.constant = 0
                    self.fbUrlBtnHeightConst.constant = 0
                    self.FacebookImg.isHidden = true
                }
                if self.InstaTxt != "" {
                    self.InstagramLbl.setTitle("Instagram" , for: .normal)
                    self.InstaImgTopConstrant.constant = 8
                    self.InstaImgHeightConstrant.constant = 20
                    self.InstaUrlBtnTopConst.constant = 8
                    self.InstaUrlBtnHeightConst.constant = 20
                    self.InstaImg.isHidden = false
                }else{
//                    self.InstagramLbl.setTitle("Instagram id not available", for: .normal)
                    self.InstaImgTopConstrant.constant = 0
                    self.InstaImgHeightConstrant.constant = 0
                    self.InstaUrlBtnTopConst.constant = 0
                    self.InstaUrlBtnHeightConst.constant = 0
                    self.InstaImg.isHidden = true
                }
            }else{
                self.view.makeToast(message: message)
            }
            //            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- String to Float Convert Function
    func StringToFloat(str:String)->(Float){
        let string = str
        var cgFloat:Float = 0
        if let doubleValue = Double(string){
            cgFloat = Float(doubleValue)
        }
        return cgFloat
    }
    //MARK:- Location Button Action
    @IBAction func Location_Btn_Action(_ sender: UIButton) {
        self.openMapForPlace(lat: Double(self.Lat) ?? 26.785555, lng: Double(self.Long) ?? 75.525555)
//        let navigate = storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
//        navigate.str_lat = self.Lat
//        navigate.str_long = self.Long
//        self.navigationController?.pushViewController(navigate, animated: true)
    }
    
    func openMapForPlace(lat:Double,lng:Double) {
           
              let latitude:CLLocationDegrees =  lat
              let longitude:CLLocationDegrees =  lng

              let regionDistance:CLLocationDistance = 1000
              let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
              let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
              let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
              ]
              let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
              let mapItem = MKMapItem(placemark: placemark)
              mapItem.name = self.addressn
              mapItem.openInMaps(launchOptions: options)
    }
    
    //MARK:- Share Button Action
    @IBAction func ShareBtnAction(_ sender: UIButton) {
        let shareText = "https://apps.apple.com/in/app/dade-social/id1573397166"

        if let image = UIImage(named: "logo") {
            let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    //MARK:- Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    //MARK:- Rating&Review Button Action
    @IBAction func ratingReviewBtnAction(_ sender: UIButton) {
        let id = DataManager.getVal(self.DetailDataDict["id"]) as? String ?? ""
        let navigate = storyboard?.instantiateViewController(withIdentifier: "RatingVc") as! RatingVc
        navigate.Business_user_id = id
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Email Button Action
    @IBAction func Email_Btn_Action(_ sender: UIButton) {
        let email = DataManager.getVal(self.DetailDataDict["email"]) as? String ?? ""
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients([email])
            composer.setSubject("Hey there!")
            composer.setMessageBody("Hi, I'd like to know ", isHTML: false)
            present(composer, animated: true)
        }else{
            self.showErrorMsg()
        }
    }
    func showErrorMsg(){
        let AlertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: .alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertAction.Style.default, handler: nil)
        AlertMessage.addAction(action)
        self.present(AlertMessage, animated: true, completion: nil)
    }
    //MARK:- Phone Button Action
    @IBAction func Phone_Btn_Action(_ sender: UIButton) {
        let number = DataManager.getVal(self.DetailDataDict["contact_number"]) as? String ?? ""
        let newnum = number.replacingOccurrences(of: " ", with: "")
        let url:NSURL = URL(string: "TEL://\(newnum)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    //MARK:- Website Button Action
    @IBAction func WebSite_Btn_Action(_ sender: UIButton) {
        if self.WebsiteTxt != ""{
        let Url = DataManager.getVal(self.DetailDataDict["website_link"]) as? String ?? ""
        if let urlString = Url as? String {
            let url: URL?
            if urlString.hasPrefix("http://") {
                url = URL(string: urlString)
            } else {
                url = URL(string: "http://" + urlString)
            }
            if let url = url {
                let sfViewController = SFSafariViewController(url: url)
                self.present(sfViewController, animated: true, completion: nil)
                print ("Now browsing in SFSafariViewController")
            }else{
                self.view.makeToast(message: "URL is not valied")
            }
        }
        }else{
            
        }
    }
    //MARK:- Twitter Button Action
    @IBAction func twitter_Btn_Action(_ sender: UIButton) {
        if self.TwitterTxt != ""{
        let Url = DataManager.getVal(self.DetailDataDict["twiiter_link"]) as? String ?? ""
        if let urlString = Url as? String {
            let url: URL?
            if urlString.hasPrefix("http://") {
                url = URL(string: urlString)
            } else {
                url = URL(string: "http://" + urlString)
            }
            if let url = url {
                let sfViewController = SFSafariViewController(url: url)
                self.present(sfViewController, animated: true, completion: nil)
                print ("Now browsing in SFSafariViewController")
            }else{
                self.view.makeToast(message: "URL is not valied")
            }
        }
        }else{
            
        }
    }
    //MARK:- Facebook Button Action
    @IBAction func facebook_Btn_Action(_ sender: UIButton) {
        if self.FaceBookTxt != ""{
        let Url = DataManager.getVal(self.DetailDataDict["facebook_link"]) as? String ?? ""
        if let urlString = Url as? String {
            let url: URL?
            if urlString.hasPrefix("http://") {
                url = URL(string: urlString)
            } else {
                url = URL(string: "http://" + urlString)
            }
            if let url = url {
                let sfViewController = SFSafariViewController(url: url)
                self.present(sfViewController, animated: true, completion: nil)
                print ("Now browsing in SFSafariViewController")
            }else{
                self.view.makeToast(message: "URL is not valied")
            }
        }
        }else{
            
        }
    }
    //MARK:- Instagram Button Action
    @IBAction func insta_Btn_Action(_ sender: UIButton) {
        if self.InstaTxt != ""{
        let Url = DataManager.getVal(self.DetailDataDict["instagram_link"]) as? String ?? ""
        if let urlString = Url as? String {
            let url: URL?
            if urlString.hasPrefix("http://") {
                url = URL(string: urlString)
            } else {
                url = URL(string: "http://" + urlString)
            }
            if let url = url {
                let sfViewController = SFSafariViewController(url: url)
                self.present(sfViewController, animated: true, completion: nil)
                print ("Now browsing in SFSafariViewController")
            }else{
                self.view.makeToast(message: "URL is not valied")
            }
        }
        }else{
            
        }
    }
    
}
extension DetailVC: MFMailComposeViewControllerDelegate {
    //MARK:- MFMail Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result {
        case .cancelled:
            break
        case .failed:
            break
        case .saved:
            break
        case .sent:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
//MARK:- CollectionView Delegate & DataSourace
extension DetailVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HeaderImagePageController.numberOfPages = self.pictureArray.count
        HeaderImagePageController.isHidden = !(self.pictureArray.count > 1)
        return self.pictureArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.tag = indexPath.row
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        let imageName = DataManager.getVal(self.pictureArray[indexPath.item]) as? String ?? ""
        Config().setimage(name: imageName, image: cell.businessImages)
        cell.businessImages.layer.cornerRadius = 15
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.HeaderImagePageController.currentPage = indexPath.item
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            switch collectionView.tag {
            case 1:
                HeaderImagePageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            default:
                let whichCollectionViewScrolled = "unknown"
                print(whichCollectionViewScrolled)
            }
        } else{
            print("cant cast")
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            switch collectionView.tag {
            case 1:
                HeaderImagePageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            default:
                let whichCollectionViewScrolled = "unknown"
                print(whichCollectionViewScrolled)
            }
        }else{
            print("cant cast")
        }
    }
}
//MARK:- CollectionView DelegateFlowLayout
extension DetailVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-40, height: 350)
    }
}
