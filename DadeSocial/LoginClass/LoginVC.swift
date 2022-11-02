//
//  LoginVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 02/04/21.
//

import UIKit
import SafariServices

class LoginVC: UIViewController, SFSafariViewControllerDelegate {

    //MARK:- IBOutlates
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var rememberMeBtn: ResponsiveButton!
    
    //MARK:- Veriables
    var remember: Bool = false
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.emailTextField.setLeftPaddingPoints(15)
        self.passwordTextField.setLeftPaddingPoints(15)
        self.emailTextField.layer.cornerRadius = 15
        self.passwordTextField.layer.cornerRadius = 15
        self.loginBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.loginBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.loginBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.loginBtn.layer.shadowOpacity = 1.0
        self.loginBtn.layer.shadowRadius = 5.0
        self.loginBtn.layer.masksToBounds = false
        
        let is_remember = DataManager.getVal(Config().AppUserDefaults.object(forKey: "isRemember")) as? String ?? ""
        
        if is_remember == "yes"{
            let user_email = DataManager.getVal(Config().AppUserDefaults.object(forKey: "user_email")) as? String ?? ""
            let user_password = DataManager.getVal(Config().AppUserDefaults.object(forKey: "user_password")) as? String ?? ""
            self.emailTextField.text = user_email
            self.passwordTextField.text = user_password
            self.rememberMeBtn.setImage(UIImage(named: "Check_icon"), for: UIControl.State.normal)
            self.remember = true
        }else{
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.rememberMeBtn.setImage(UIImage(named: "Uncheck_icon"), for: UIControl.State.normal)
            self.remember = false
        }
        // Do any additional setup after loading the view.
    }
    //MARK:- Business Link Button Action
    @IBAction func businessLinkAction(_ sender: UIButton) {
        let urlString = "https://dadesocial.net/sign_up"
        let url = URL(string: urlString)
        if let url = url {
            let sfViewController = SFSafariViewController(url: url)
            self.present(sfViewController, animated: true, completion: nil)
            print ("Now browsing in SFSafariViewController")
        }else{
            self.view.makeToast(message: "URL is not valied")
        }
    }
    
    //MARK:- Login Button Action
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if self.emailTextField.text == ""{
            self.view.makeToast(message: "Please enter your email.")
        }else if self.passwordTextField.text == ""{
            self.view.makeToast(message: "Please enter your password.")
        }else{
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let DeviceId = Config().AppUserDefaults.value(forKey: "deviceID") as? String ?? ""
        let DeviceToken = Config().AppUserDefaults.value(forKey: "deviceToken") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.emailTextField.text!), forKey: "email")
        dict.setValue(DataManager.getVal(self.passwordTextField.text!), forKey: "password")
        dict.setValue(DataManager.getVal("2"), forKey: "device_type")
        dict.setValue(DataManager.getVal(DeviceId), forKey: "device_id")
        dict.setValue(DataManager.getVal(DeviceToken), forKey: "device_token")
        let methodName = "login"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let user = DataManager.getVal(responseData?["data"]) as! NSDictionary
                let userId = DataManager.getVal(user["user_id"]) as? String ?? ""
                let verified_status = DataManager.getVal(user["verified_status"]) as? String ?? ""
                if verified_status == "1"{
                    Config().AppUserDefaults.set(userId, forKey: "User_Id")
                    if self.remember == true{
                        Config().AppUserDefaults.set("yes", forKey: "isRemember")
                        Config().AppUserDefaults.set(DataManager.getVal(self.emailTextField.text!), forKey: "user_email")
                        Config().AppUserDefaults.set(DataManager.getVal(self.passwordTextField.text!), forKey: "user_password")
                    }else{
                        Config().AppUserDefaults.set("no", forKey: "isRemember")
                    }
                    Config().AppUserDefaults.set("yes", forKey: "login")
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let navigate = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                    let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
//                    let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
//                    slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
////                    UIApplication.shared.windows.first?.rootViewController = slideMenuController
////                    UIApplication.shared.windows.first?.makeKeyAndVisible()
//                    navigate.User_ID = userId
//                    self.navigationController?.pushViewController(navigate, animated: true)
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigate = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                    let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
                    slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
                    UIApplication.shared.windows.first?.rootViewController = slideMenuController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                }else{
                    if self.remember == true{
                        Config().AppUserDefaults.set("yes", forKey: "isRemember")
                        Config().AppUserDefaults.set(DataManager.getVal(self.emailTextField.text!), forKey: "user_email")
                        Config().AppUserDefaults.set(DataManager.getVal(self.passwordTextField.text!), forKey: "user_password")
                    }else{
                        Config().AppUserDefaults.set("no", forKey: "isRemember")
                    }
                    let navigate = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    navigate.fromLogin = true
                    navigate.user_Id = userId
                    self.navigationController?.pushViewController(navigate, animated: true)
                }
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
         }
        }
    }
    
    //MARK:- Remember Button Action
    @IBAction func RememberMeBtnAction(_ sender: ResponsiveButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.remember = true
            self.rememberMeBtn.setImage(UIImage(named: "Check_icon"), for: UIControl.State.selected)
        }else{
            self.remember = false
            self.rememberMeBtn.setImage(UIImage(named: "Uncheck_icon"), for: UIControl.State.normal)
        }
    }
    //MARK:- Forgot Button Action
    @IBAction func forgotBtnAction(_ sender: UIButton) {
        let nav1 = UINavigationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigate = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        nav1.viewControllers = [navigate]
        UIApplication.shared.windows.first?.rootViewController = nav1
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        let navigate = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
//        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Register Button Action
    @IBAction func registerBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(navigate, animated: true)
    }
}
