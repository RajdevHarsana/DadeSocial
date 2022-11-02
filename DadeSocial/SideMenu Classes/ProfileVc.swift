//
//  ProfileVc.swift
//  DadeSocial
//
//  Created by MAC-27 on 03/04/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SDWebImage
import PhoneNumberKit

class ProfileVc: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var ProfileImgView: UIImageView!
    @IBOutlet weak var FirstNameTxtField: UITextField!
    @IBOutlet weak var LastNameTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var mobileNumTxtField: UITextField!
    @IBOutlet weak var locationTxtFeild: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var genderTxtFeild: UITextField!
    @IBOutlet weak var btnChangePasswordHeightConstraint: NSLayoutConstraint!
    //MARK:- Variables
    fileprivate let pickerView = ToolbarPickerView()
    var Gender_Array = [String]()
    var Age_Array = [String]()
    var pickerData = [String]()
    var pickerType = String()
    var singleImageArr = NSMutableArray()
    let formatter = DateFormatter()
    var firstName = String()
    var lastName  = String()
    var Lat = String()
    var Long = String()
    var place_Lat = String()
    var place_Long = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoginEmail == false {
            btnChangePasswordHeightConstraint.constant = 0
            changePasswordBtn.setTitle("", for: .normal)
        }
        else {
            btnChangePasswordHeightConstraint.constant = 50
            changePasswordBtn.setTitle("Change Password", for: .normal)
        }
        self.navigationController?.isNavigationBarHidden = true
        self.ProfileImgView.layer.cornerRadius = 20
        self.FirstNameTxtField.layer.cornerRadius = 15
        self.LastNameTxtField.layer.cornerRadius = 15
//        self.dobTxtField.layer.cornerRadius = 15
        self.emailTxtField.layer.cornerRadius = 15
        self.mobileNumTxtField.layer.cornerRadius = 15
        self.locationTxtFeild.layer.cornerRadius = 15
        self.FirstNameTxtField.setLeftPaddingPoints(15)
        self.LastNameTxtField.setLeftPaddingPoints(15)
        self.emailTxtField.setLeftPaddingPoints(15)
        self.mobileNumTxtField.setLeftPaddingPoints(15)
        self.locationTxtFeild.setLeftPaddingPoints(15)
//        self.dobTxtField.setLeftPaddingPoints(15)
        emailTxtField.isUserInteractionEnabled = true
        mobileNumTxtField.isUserInteractionEnabled = true
        self.locationTxtFeild.delegate = self
//        self.dobTxtField.datePicker(target: self,doneAction: #selector(doneAction),cancelAction: #selector(cancelAction),datePickerMode: .date)
        self.saveBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.saveBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.saveBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.saveBtn.layer.shadowOpacity = 1.0
        self.saveBtn.layer.shadowRadius = 5.0
        self.saveBtn.layer.masksToBounds = false
        self.changePasswordBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.changePasswordBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.changePasswordBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.changePasswordBtn.layer.shadowOpacity = 1.0
        self.changePasswordBtn.layer.shadowRadius = 5.0
        self.changePasswordBtn.layer.masksToBounds = false
        self.mobileNumTxtField.delegate = self
        // Do any additional setup after loading the view.
        self.getProfileAPI()
        self.Gender_Array = ["Male","Female","Prefer not to say"]
        self.Age_Array = ["13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"]
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.genderTxtFeild.layer.cornerRadius = 15
        self.genderTxtFeild.setLeftPaddingPoints(15)
        self.genderTxtFeild.delegate = self
        self.genderTxtFeild.inputView = self.pickerView
        self.genderTxtFeild.inputAccessoryView = self.pickerView.toolbar
        
        self.ageTxtField.layer.cornerRadius = 15
        self.ageTxtField.setLeftPaddingPoints(15)
        self.ageTxtField.delegate = self
        self.ageTxtField.inputView = self.pickerView
        self.ageTxtField.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
    }
    override func viewWillAppear(_ animated: Bool) {
//        let TitleName = Config().AppUserDefaults.value(forKey: "TITLE") as? String ?? ""
//        if locationTxtFeild.text == ""{
//            self.locationTxtFeild.text = Config().AppUserDefaults.value(forKey: "Address") as? String ?? ""
//            self.Lat = Config().AppUserDefaults.value(forKey: "LAT") as? String ?? ""
//            self.Long = Config().AppUserDefaults.value(forKey: "LONG") as? String ?? ""
//        }else{
//
//        }
        
    }
//    //MARK:- Date Picker Button Action
//    @objc func cancelAction() {
//        self.dobTxtField.resignFirstResponder()
//    }
//    @objc func doneAction() {
//        if let datePickerView = self.dobTxtField.inputView as? UIDatePicker {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM/dd/yyyy"
//            let dateString = dateFormatter.string(from: datePickerView.date)
//            self.dobTxtField.text = dateString
//            print(datePickerView.date)
//            print(dateString)
//            self.dobTxtField.resignFirstResponder()
//        }
//    }
    //MARK:- PickerView Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if self.pickerType == "Gender"{
            self.genderTxtFeild.text = self.pickerData[row]
        }else{
            self.ageTxtField.text = self.pickerData[row]
        }
    }
    //MARK:- ToolbarPickerView Delegates
    func didTapDone() {
        if self.pickerType == "Gender"{
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.genderTxtFeild.text = self.pickerData[row]
            self.genderTxtFeild.resignFirstResponder()
        }else{
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.ageTxtField.text = self.pickerData[row]
            self.ageTxtField.resignFirstResponder()
        }
        
    }

    func didTapCancel() {
        if self.pickerType == "Gender"{
            self.genderTxtFeild.text = nil
            self.genderTxtFeild.resignFirstResponder()
        }else{
            self.ageTxtField.text = nil
            self.ageTxtField.resignFirstResponder()
        }
    }
    //MARK:- Get Profile API Function
    func getProfileAPI(){
        self.pleaseWait()
        let UserId = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(UserId), forKey: "user_id")
        let methodName = "getUserProfile"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let Data = DataManager.getVal(responseData?["data"]) as! NSDictionary
                self.FirstNameTxtField.text = DataManager.getVal(Data["first_name"]) as? String ?? ""
                self.LastNameTxtField.text = DataManager.getVal(Data["last_name"]) as? String ?? ""
                self.ageTxtField.text = DataManager.getVal(Data["age"]) as? String ?? ""
                self.genderTxtFeild.text = DataManager.getVal(Data["gender"]) as? String ?? ""
                self.emailTxtField.text = DataManager.getVal(Data["email"]) as? String ?? ""
                let mobileNumber = DataManager.getVal(Data["contact_number"]) as? String ?? ""
//                if mobileNumber == "" {
//                    self.mobileNumTxtField.isUserInteractionEnabled = true
//                }else{
//                    self.mobileNumTxtField.isUserInteractionEnabled = false
//                }
                self.mobileNumTxtField.text = DataManager.getVal(Data["contact_number"]) as? String ?? ""
                self.locationTxtFeild.text = DataManager.getVal(Data["location"]) as? String ?? ""
                self.Lat = DataManager.getVal(Data["latitude"]) as? String ?? ""
                self.Long = DataManager.getVal(Data["longitude"]) as? String ?? ""
                Config().setimage(name: DataManager.getVal(Data["profile_picture"]) as? String ?? "", image: self.ProfileImgView)
                print(Data)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Text Feild Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumTxtField {
            guard let text = mobileNumTxtField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "XXX-XXX-XXXX", phone: newString)
            return false
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.locationTxtFeild {
            self.locationTxtFeild.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }else if textField == genderTxtFeild {
            self.view.endEditing(true)
            self.pickerType = "Gender"
            self.pickerData = self.Gender_Array
            return true
        }else if textField == ageTxtField {
            self.view.endEditing(true)
            self.pickerType = "Age"
            self.pickerData = self.Age_Array
            return true
        }else{
            return true
        }
    }
    //MARK:- Image Button Action
    @IBAction func ProfileImgBtnAction(_ sender: UIButton) {
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
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Save Button Action
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if self.FirstNameTxtField.text == ""{
            self.view.makeToast(message: "Please enter your first name.")
        }else if self.LastNameTxtField.text == ""{
            self.view.makeToast(message: "Please enter your last name.")
        }else if emailTxtField.text == ""{
            self.view.makeToast(message: "Please enter your email.")
        }else if ageTxtField.text == ""{
            self.view.makeToast(message: "Please enter your Age.")
        }else if genderTxtFeild.text == ""{
            self.view.makeToast(message: "Please enter your Gender.")
        }else{
//            self.pleaseWait()
            self.showSpinner(onView: self.view)
            let UserId = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.FirstNameTxtField.text!), forKey: "first_name")
            dict.setValue(DataManager.getVal(self.LastNameTxtField.text!), forKey: "last_name")
            dict.setValue(DataManager.getVal(self.mobileNumTxtField.text!), forKey: "contact_number")
//            dict.setValue(DataManager.getVal(self.dobTxtField.text!), forKey: "dob")
            dict.setValue(DataManager.getVal(self.ageTxtField.text!), forKey: "age")
            dict.setValue(DataManager.getVal(self.emailTxtField.text!), forKey: "email")
            dict.setValue(DataManager.getVal(self.genderTxtFeild.text!), forKey: "gender")
            dict.setValue(DataManager.getVal(UserId), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.place_Lat), forKey: "latitude")
            dict.setValue(DataManager.getVal(self.place_Long), forKey: "longitude")
            dict.setValue(DataManager.getVal(self.locationTxtFeild.text!), forKey: "location")
            //For upload image
            let dataArr = NSMutableArray()
            let dataDict = NSMutableDictionary()
            dataDict.setObject("profile_picture", forKey: "profile_picture" as NSCopying)
            dataDict.setObject(resize(self.ProfileImgView.image!).pngData()!, forKey: "imageData" as NSCopying)
            dataDict.setObject("png", forKey: "ext" as NSCopying)
            dataArr.add(dataDict)
            
            let methodName = "updateProfile"
            
            DataManager.getAPIResponseFileSingleImage(dict, methodName: methodName as NSString ,dataArray: dataArr){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    self.view.makeToast(message: message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        // your code here
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.view.makeToast(message: message)
                }
//                self.clearAllNotice()
                self.removeSpinner()
            }
        }
    }
    //MARK:- Change Password Button Action
    @IBAction func changePasswordBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(navigate, animated: true)
    }

}

extension UITextField {
    //MARK:- Date Picker Fuction
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        datePicker.maximumDate = Date()
        self.inputView = datePicker
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
extension ProfileVc: GMSAutocompleteViewControllerDelegate {
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
        self.locationTxtFeild.text = place.formattedAddress
        
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
