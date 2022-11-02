//
//  VerificationVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 02/04/21.
//

import UIKit
import SVPinView

class VerificationVC: UIViewController {
    
    //MARK:- IBOutlates
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    //MARK:- Veriables
    var isComingFrom = Bool()
    var fromLogin = Bool()
    var user_Id = String()
    var GetEmailotpString = String()
    var PhoneNumber = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.makeToast(message: "Please enter the 4-digit code sent to your registered email.")
        self.verifyBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.verifyBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.verifyBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.verifyBtn.layer.shadowOpacity = 1.0
        self.verifyBtn.layer.shadowRadius = 5.0
        self.verifyBtn.layer.masksToBounds = false
        configurePinView()
        // Do any additional setup after loading the view.
    }
    //MARK:- PinView Functions
    func configurePinView() {
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 15
        pinView.textColor = UIColor.black
        pinView.borderLineColor = UIColor.darkGray
        pinView.activeBorderLineColor = UIColor.lightGray
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        pinView.activeFieldBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        pinView.fieldCornerRadius = 15
        pinView.activeFieldCornerRadius = 15
        pinView.placeholder = "****"
        
        
        pinView.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        pinView.keyboardAppearance = .default
        pinView.tintColor = .black
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        pinView.font = UIFont.boldSystemFont(ofSize: 20)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    func didFinishEnteringPin(pin:String) {
        GetEmailotpString = pin
        print("OTPString: \(pin)")
    }
    //MARK:- Verify Button Action
    @IBAction func verifyBtnAction(_ sender: UIButton) {
        if !GetEmailotpString.isEmpty {
            //            self.pleaseWait()
            self.showSpinner(onView: self.view)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_Id), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.GetEmailotpString), forKey: "otp")
            var methodName = String()
            if isComingFrom == true{
                methodName = "verifyAccount"
            }else if self.fromLogin == true{
                methodName = "verifyAccount"
            }else{
                methodName = "verifyOtp"
            }
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    if self.isComingFrom == true{
                        Config().AppUserDefaults.set("yes", forKey: "login")
                        let navigate = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        navigate.User_ID = self.user_Id
                        let leftController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
                        slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
                        UIApplication.shared.windows.first?.rootViewController = slideMenuController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }else if self.fromLogin == true{
                        Config().AppUserDefaults.set("yes", forKey: "login")
                        let navigate = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        navigate.User_ID = self.user_Id
                        let leftController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
                        slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
                        UIApplication.shared.windows.first?.rootViewController = slideMenuController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }else{
                        let navigate = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                        navigate.user_Id = self.user_Id
                        self.navigationController?.pushViewController(navigate, animated: true)
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                //                self.clearAllNotice()
                self.removeSpinner()
            }
        }else if GetEmailotpString.isEmpty {
            self.view.makeToast(message: "Please enter email OTP.")
        }
    }
    //MARK:- Resend Button Action
    @IBAction func resendBtnAction(_ sender: UIButton) {
        self.view.endEditing(false)
        pinView.resignFirstResponder()
        //        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_Id), forKey: "user_id")
        var methodName = String()
        if isComingFrom == true{
            methodName = "resendOtp"
        }else{
            methodName = "resendForgotOtp"
        }
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.view.endEditing(false)
                self.pinView.refreshView()
                self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            //            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        if isComingFrom == true {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigate = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(navigate, animated: true)
        }else if self.fromLogin == true{
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
}
