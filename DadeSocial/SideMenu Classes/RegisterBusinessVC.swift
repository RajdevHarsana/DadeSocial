//
//  RegisterBusinessVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 05/04/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import PhoneNumberKit

class RegisterBusinessVC: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,MyDataSendingDelegate{
    
    //MARK:- IBoutlates
    @IBOutlet weak var ProfileImgView: UIImageView!
    @IBOutlet weak var nameTxtFeild: UITextField!
    @IBOutlet weak var phoneTxtFeild: UITextField!
    @IBOutlet weak var emailTxtFeild: UITextField!
    @IBOutlet weak var categaryTxtFeild: UITextField!
    @IBOutlet weak var addressTxtFeild: UITextField!
    @IBOutlet weak var secondaryAddressTxtFeild: UITextField!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var discriptionTxtView: UITextView!
    @IBOutlet weak var webSiteTxtFeild: UITextField!
    @IBOutlet weak var twitterProfileTxtFeild: UITextField!
    @IBOutlet weak var fbProfileTxtFeild: UITextField!
    @IBOutlet weak var instaProfileTxtFeild: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    //MARK:- Variables
    var categoryID = String()
    var locationManager = CLLocationManager()
    var current_lat = String()
    var current_long = String()
    var place_Lat = String()
    var place_Long = String()
    var isOnFlag = Bool()
    var user_Email = String()
    var user_PhoneNo = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        self.ProfileImgView.layer.cornerRadius = 20
        self.nameTxtFeild.layer.cornerRadius = 15
        self.phoneTxtFeild.layer.cornerRadius = 15
        self.emailTxtFeild.layer.cornerRadius = 15
        self.categaryTxtFeild.layer.cornerRadius = 15
        self.addressTxtFeild.layer.cornerRadius = 15
        self.webSiteTxtFeild.layer.cornerRadius = 15
        self.twitterProfileTxtFeild.layer.cornerRadius = 15
        self.fbProfileTxtFeild.layer.cornerRadius = 15
        self.instaProfileTxtFeild.layer.cornerRadius = 15
        self.discriptionTxtView.layer.cornerRadius = 15
        self.secondaryAddressTxtFeild.layer.cornerRadius = 15
        self.nameTxtFeild.setLeftPaddingPoints(15)
        self.phoneTxtFeild.setLeftPaddingPoints(15)
        self.emailTxtFeild.setLeftPaddingPoints(15)
        self.categaryTxtFeild.setLeftPaddingPoints(15)
        self.addressTxtFeild.setLeftPaddingPoints(15)
        self.webSiteTxtFeild.setLeftPaddingPoints(15)
        self.twitterProfileTxtFeild.setLeftPaddingPoints(15)
        self.fbProfileTxtFeild.setLeftPaddingPoints(15)
        self.instaProfileTxtFeild.setLeftPaddingPoints(15)
        self.secondaryAddressTxtFeild.setLeftPaddingPoints(15)
        self.discriptionTxtView.leftSpace(10)
        self.categaryTxtFeild.delegate = self
        self.nameTxtFeild.delegate = self
        self.addressTxtFeild.delegate = self
        self.webSiteTxtFeild.delegate = self
        self.twitterProfileTxtFeild.delegate = self
        self.fbProfileTxtFeild.delegate = self
        self.instaProfileTxtFeild.delegate = self
//        self.phoneTxtFeild.delegate = self
        self.submitBtn.layer.cornerRadius = 15
        // Shadow color and radius
        submitBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        submitBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        submitBtn.layer.shadowOpacity = 1.0
        submitBtn.layer.shadowRadius = 5.0
        submitBtn.layer.masksToBounds = false
        discriptionTxtView.delegate = self
        discriptionTxtView.text = "Description"
        discriptionTxtView.textColor = UIColor.lightGray
        discriptionTxtView.selectedTextRange = discriptionTxtView.textRange(from: discriptionTxtView.beginningOfDocument, to: discriptionTxtView.beginningOfDocument)
        if #available(iOS 11.0, *) {
            PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "MX", "AU", "GB", "DE"]
        }
        self.emailTxtFeild.text = self.user_Email
        self.phoneTxtFeild.text = self.user_PhoneNo
        // Do any additional setup after loading the view.
        self.categaryTxtFeild.setRightPaddingPoints(self.categaryTxtFeild.frame.size.width/4 - 40)
    }
    //MARK:- Text Feild RightView Button
    @objc func refresh(sender:UIButton){
        
    }
    //MARK:- Text Feild RightView Drop Button Action
    @IBAction func dropBtnAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- Text Feild Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.categaryTxtFeild{
            self.view.endEditing(true)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return false
        }else if textField == self.addressTxtFeild {
            self.addressTxtFeild.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTxtFeild {
            guard let text = phoneTxtFeild.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "XXX-XXX-XXXX", phone: newString)
            return false
        }else if textField == nameTxtFeild{
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == webSiteTxtFeild{
            textField.text = "http://www."
        }else if textField == twitterProfileTxtFeild{
            textField.text = "http://www.twitter.com/"
        }else if textField == fbProfileTxtFeild{
            textField.text = "http://www.facebook.com/"
        }else if textField == instaProfileTxtFeild{
            textField.text = "http://www.instagram.com/"
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == webSiteTxtFeild{
//            textField.text = ""
//        }else if textField == twitterProfileTxtFeild{
//            textField.text = ""
//        }else if textField == fbProfileTxtFeild{
//            textField.text = ""
//        }else if textField == instaProfileTxtFeild{
//            textField.text = ""
//        }
    }
    //MARK:- Protocol Delegate Function
    func sendDataToFirstViewController(category_id: String, Name: String) {
        self.categoryID = category_id
        print(categoryID)
        self.categaryTxtFeild.text = Name
    }
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Current Button Action
    @IBAction func locationBtnAction(_ sender: UIButton) {
        
    }
    //MARK:- Text View Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            discriptionTxtView.text = ""
            discriptionTxtView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            discriptionTxtView.text = "Description"
            discriptionTxtView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    //MARK:- Image Button Action
    @IBAction func imageSelectBtnAction(_ sender: UIButton) {
        let Picker = UIImagePickerController()
        Picker.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: "Choose your source", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            Picker.sourceType = .camera
            self.present(Picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            
            Picker.sourceType = .photoLibrary
            self.present(Picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    //MARK:- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                self.ProfileImgView.image = image
            }else{
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    self.ProfileImgView.image = image
                }
            }
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK:- Apply Button Action
    @IBAction func applyNowBtnAction(_ sender: UIButton) {
        if ValidationClass().ValidateUserRegisterBusiness(self){
            if self.discriptionTxtView.text == "Description"{
                self.view.makeToast(message: "Please Enter your business Description.")
            }else{
                self.showSpinner(onView: self.view)
                let UserId = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
                let dict = NSMutableDictionary()
                dict.setValue(DataManager.getVal(self.nameTxtFeild.text!), forKey: "business_name")
                dict.setValue(DataManager.getVal(self.phoneTxtFeild.text!), forKey: "contact_number")
                dict.setValue(DataManager.getVal(self.emailTxtFeild.text!), forKey: "email")
                dict.setValue(DataManager.getVal(self.categoryID), forKey: "category_id")
                dict.setValue(DataManager.getVal(self.addressTxtFeild.text!), forKey: "address")
                dict.setValue(DataManager.getVal(self.secondaryAddressTxtFeild.text!), forKey: "secondary_address")
                dict.setValue(DataManager.getVal(self.webSiteTxtFeild.text!), forKey: "website_link")
                dict.setValue(DataManager.getVal(self.twitterProfileTxtFeild.text!), forKey: "twiiter_link")
                dict.setValue(DataManager.getVal(self.fbProfileTxtFeild.text!), forKey: "facebook_link")
                dict.setValue(DataManager.getVal(self.instaProfileTxtFeild.text!), forKey: "instagram_link")
                dict.setValue(DataManager.getVal(self.discriptionTxtView.text!), forKey: "description")
                dict.setValue(DataManager.getVal(UserId), forKey: "user_id")
                dict.setValue(DataManager.getVal(self.place_Lat), forKey: "latitude")
                dict.setValue(DataManager.getVal(self.place_Long), forKey: "longitude")
                print(dict)
                //For upload image
//                let dataArr = NSMutableArray()
//                let dataDict = NSMutableDictionary()
//                dataDict.setObject("profile_picture", forKey: "profile_picture" as NSCopying)
//                dataDict.setObject(resize(self.ProfileImgView.image!).pngData()!, forKey: "imageData" as NSCopying)
//                dataDict.setObject("png", forKey: "ext" as NSCopying)
//                dataArr.add(dataDict)
//                print(dataArr)
                let methodName = "addBusinessRequest"
                
                DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                    
                    let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                    let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                    
                    if status == "1"{
                        self.view.makeToast(message: message)
                        self.nameTxtFeild.text = ""
                        self.emailTxtFeild.text = ""
                        self.phoneTxtFeild.text = ""
                        self.categaryTxtFeild.text = ""
                        self.addressTxtFeild.text = ""
                        self.secondaryAddressTxtFeild .text = ""
                        self.webSiteTxtFeild.text = ""
                        self.twitterProfileTxtFeild.text = ""
                        self.fbProfileTxtFeild.text = ""
                        self.instaProfileTxtFeild.text = ""
                        self.discriptionTxtView.text = ""
                        self.discriptionTxtView.delegate = self
//                        Config().setimage(name: "dummy4", image: self.ProfileImgView)
                    }else{
                        self.view.makeToast(message: message)
                    }
//                    self.clearAllNotice()
                    self.removeSpinner()
                }
            }
        }
    }
    
}
extension RegisterBusinessVC: GMSAutocompleteViewControllerDelegate {
    //MARK:- Google Place Delegates
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        let PlaceLat = String(lat)
        let PlaceLong = String(lon)
        self.place_Lat = PlaceLat
        self.place_Long = PlaceLong
        print("lat lon",lat,lon)
        //    self.addressTxtFeild.text = place.name
        self.addressTxtFeild.text = place.formattedAddress
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
