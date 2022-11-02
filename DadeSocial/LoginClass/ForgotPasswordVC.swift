//
//  ForgotPasswordVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 02/04/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK:- IBOutlates
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.emailTxtField.layer.cornerRadius = 15
        self.emailTxtField.setLeftPaddingPoints(15)
        self.submitBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.submitBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.submitBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.submitBtn.layer.shadowOpacity = 1.0
        self.submitBtn.layer.shadowRadius = 5.0
        self.submitBtn.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    }
    //MARK:- Submit Button Action
    @IBAction func submitBtnAction(_ sender: UIButton) {
        if emailTxtField.text == ""{
            self.view.makeToast(message: "Please enter your email address.")
        }else{
            self.showSpinner(onView: self.view)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.emailTxtField.text!), forKey: "email")
            
            let methodName = "forgotpassword"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let user = DataManager.getVal(responseData?["data"]) as! NSDictionary
                    let userId = DataManager.getVal(user["user_id"]) as? String ?? ""
                    let navigate = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
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
        let navigate = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(navigate, animated: true)
    }
}
