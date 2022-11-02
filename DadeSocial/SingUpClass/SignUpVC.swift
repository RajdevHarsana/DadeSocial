//
//  SignUpVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 02/04/21.
//

import UIKit
//import PhoneNumberKit

class SignUpVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var genderTxtFeild: UITextField!
    @IBOutlet weak var mobileNumTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var acceptBtn: ResponsiveButton!
    //MARK:- Veriables
    var accepte: Bool = false
    var phoneNumber = String()
    fileprivate let pickerView = ToolbarPickerView()
    var Gender_Array = [String]()
    var Age_Array = [String]()
    var pickerData = [String]()
    var pickerType = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.firstNameTxtField.layer.cornerRadius = 15
        self.lastNameTxtField.layer.cornerRadius = 15
        self.emailTxtField.layer.cornerRadius = 15
        self.mobileNumTxtField.layer.cornerRadius = 15
        self.passwordTxtField.layer.cornerRadius = 15
        self.confirmPasswordTxtField.layer.cornerRadius = 15
        self.submitBtn.layer.cornerRadius = 15
        self.firstNameTxtField.setLeftPaddingPoints(15)
        self.lastNameTxtField.setLeftPaddingPoints(15)
        self.emailTxtField.setLeftPaddingPoints(15)
        self.mobileNumTxtField.setLeftPaddingPoints(15)
        self.passwordTxtField.setLeftPaddingPoints(15)
        self.confirmPasswordTxtField.setLeftPaddingPoints(15)
        self.firstNameTxtField.delegate = self
        self.lastNameTxtField.delegate = self
        self.mobileNumTxtField.delegate = self
        // Shadow color and radius
        self.submitBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.submitBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.submitBtn.layer.shadowOpacity = 1.0
        self.submitBtn.layer.shadowRadius = 5.0
        self.submitBtn.layer.masksToBounds = false
//        self.mobileNumTxtField.withPrefix = false
//        self.mobileNumTxtField.withFlag = true
//        self.mobileNumTxtField.withExamplePlaceholder = true
//        self.mobileNumTxtField.withDefaultPickerUI = true
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
        // Do any additional setup after loading the view.
    }
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
    //MARK:- Text Feild Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == genderTxtFeild {
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTxtField {
        let maxLength = 30
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }else if textField == lastNameTxtField {
            let maxLength = 30
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if textField == mobileNumTxtField {
            guard let text = mobileNumTxtField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "XXX-XXX-XXXX", phone: newString)
            return false
        }else{
            return true
        }
    }
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
    //MARK:- Accept Button Action
    @IBAction func acceptBtnAction(_ sender: ResponsiveButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.accepte = true
            self.acceptBtn.setImage(UIImage(named: "Check_icon"), for: UIControl.State.selected)
        }else{
            self.accepte = false
            self.acceptBtn.setImage(UIImage(named: "Uncheck_icon"), for: UIControl.State.selected)
        }
    }
    //MARK:- Term Services Button Action
    @IBAction func termBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        navigate.webtype = "term"
        navigate.isComingFrom = true
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Privacy Policy Button Action
    @IBAction func privacyPolicyBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        navigate.webtype = "privacy"
        navigate.isComingFrom = true
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Login Button Action
    @IBAction func loginBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Submit Button Action
    @IBAction func submitBtnAction(_ sender: UIButton) {
        if ValidationClass().ValidateUserSignUpForm(self){
            self.showSpinner(onView: self.view)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.firstNameTxtField.text!), forKey: "first_name")
            dict.setValue(DataManager.getVal(self.lastNameTxtField.text!), forKey: "last_name")
            dict.setValue(DataManager.getVal(self.emailTxtField.text!), forKey: "email")
            dict.setValue(DataManager.getVal(self.ageTxtField.text!), forKey: "age")
            dict.setValue(DataManager.getVal(self.genderTxtFeild.text!), forKey: "gender")
            dict.setValue(DataManager.getVal(self.mobileNumTxtField.text!), forKey: "contact_number")
            dict.setValue(DataManager.getVal(self.passwordTxtField.text!), forKey: "password")
            
            let methodName = "signup"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let user = DataManager.getVal(responseData?["data"]) as! NSDictionary
                    let userId = DataManager.getVal(user["user_id"]) as? String ?? ""
                    Config().AppUserDefaults.set(userId, forKey: "User_Id")
                    let navigate = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    navigate.isComingFrom = true
                    navigate.user_Id = userId
                    self.navigationController?.pushViewController(navigate, animated: true)
                }else{
                    self.view.makeToast(message: message)
                }
                self.removeSpinner()
            }
        }
    }
    //MARK:- Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
