//
//  ChangePasswordVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 03/04/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK:- IBOutlates
    @IBOutlet weak var currentPasswordTxtField: UITextField!
    @IBOutlet weak var newPasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    //MARK:- Variables
    var user_Id = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.currentPasswordTxtField.layer.cornerRadius = 15
        self.newPasswordTxtField.layer.cornerRadius = 15
        self.confirmPasswordTxtField.layer.cornerRadius = 15
        self.currentPasswordTxtField.setLeftPaddingPoints(15)
        self.newPasswordTxtField.setLeftPaddingPoints(15)
        self.confirmPasswordTxtField.setLeftPaddingPoints(15)
        self.confirmPasswordTxtField.setLeftPaddingPoints(15)
        self.submitBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.submitBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.submitBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.submitBtn.layer.shadowOpacity = 1.0
        self.submitBtn.layer.shadowRadius = 5.0
        self.submitBtn.layer.masksToBounds = false
        self.user_Id = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        // Do any additional setup after loading the view.
    }
    //MARK:- Submit Button Action
    @IBAction func submitBtnAction(_ sender: UIButton) {
        if self.currentPasswordTxtField.text == ""{
            self.view.makeToast(message: "Please enter your old password.")
        }else if self.newPasswordTxtField.text == ""{
            self.view.makeToast(message: "Please enter your new password.")
        }else if self.newPasswordTxtField.text!.count < 7 || self.newPasswordTxtField.text!.count > 16 {
            self.view.makeToast(message: "New Password should be 7-16 character")
            self.view.endEditing(true)
        }else if confirmPasswordTxtField.text == ""{
            self.view.makeToast(message: "Please enter your confirm password.")
        }else if self.confirmPasswordTxtField.text!.count < 7 || self.confirmPasswordTxtField.text!.count > 16 {
            self.view.makeToast(message: "Confirm Password should be 7-16 character")
            self.view.endEditing(true)
        }else if confirmPasswordTxtField.text != self.newPasswordTxtField.text{
            self.view.makeToast(message: "Your confirm password not match with new password.")
        }else if confirmPasswordTxtField.text == self.currentPasswordTxtField.text{
            self.view.makeToast(message: "Your confirm password similar old password.")
        }else{
//            self.pleaseWait()
            self.showSpinner(onView: self.view)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.currentPasswordTxtField.text!), forKey: "current_password")
            dict.setValue(DataManager.getVal(self.confirmPasswordTxtField.text!), forKey: "password")
            dict.setValue(DataManager.getVal(self.user_Id), forKey: "user_id")
            
            let methodName = "changePassword"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
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
    //MARK:- Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
