//
//  ViewController.swift
//  DadeSocial
//
//  Created by MAC-27 on 01/04/21.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices

var isLoginEmail = true

class ViewController: UIViewController, ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    //MARK:- IBOutlates
    @IBOutlet weak var loginWithEmailBtn: UIButton!
    @IBOutlet weak var loginWithAppleBtn: UIButton!
    @IBOutlet weak var loginWithFacebookBtn: UIButton!
    @IBOutlet weak var ButtonStacViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var ButtonStacViewTopCons: NSLayoutConstraint!
    
    //MARK:- Variable
    var name = ""
    var lastName = ""
    var imgurll = ""
    var facebookId = ""
    var emaill = ""
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        self.loginWithEmailBtn.layer.cornerRadius = 15
        self.loginWithAppleBtn.layer.cornerRadius = 15
        self.loginWithFacebookBtn.layer.cornerRadius = 15
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhones_5_5s_5c_SE")
                self.ButtonStacViewTopCons.constant = 92
                self.ButtonStacViewBottomCons.constant = 160
            case 1334:
                print("iPhones_6_6s_7_8")
                self.ButtonStacViewTopCons.constant = 102
                self.ButtonStacViewBottomCons.constant = 150
            case 1792:
                print("iPhone_XR_11")
                self.ButtonStacViewTopCons.constant = 232
                self.ButtonStacViewBottomCons.constant = 20
            case 1920:
                print("iPhones_6Plus_6sPlus_7Plus_8Plus")
                self.ButtonStacViewTopCons.constant = 152
                self.ButtonStacViewBottomCons.constant = 100
            case 2208:
                print("iPhones_6Plus_6sPlus_7Plus_8Plus_Simulators")
                self.ButtonStacViewTopCons.constant = 152
                self.ButtonStacViewBottomCons.constant = 100
            case 2340:
                print("iPhone_12Mini")
                self.ButtonStacViewTopCons.constant = 182
                self.ButtonStacViewBottomCons.constant = 60
            case 2426:
                print("iPhone_11Pro")
                self.ButtonStacViewTopCons.constant = 182
                self.ButtonStacViewBottomCons.constant = 60
            case 2436:
                print("iPhones_X_XS_12MiniSimulator")
                self.ButtonStacViewTopCons.constant = 182
                self.ButtonStacViewBottomCons.constant = 60
            case 2532:
                print("iPhone_12_12Pro")
                self.ButtonStacViewTopCons.constant = 202
                self.ButtonStacViewBottomCons.constant = 40
            case 2688:
                print("iPhone_XSMax_ProMax")
                self.ButtonStacViewTopCons.constant = 232
                self.ButtonStacViewBottomCons.constant = 20
            case 2778:
                print("iPhone_12ProMax")
                self.ButtonStacViewTopCons.constant = 252
                self.ButtonStacViewBottomCons.constant = 0
            default:
                print("unknown")
                
            }
            
        }
        // Do any additional setup after loading the view.
    }
    //MARK:- LoginWithEmail Button Action
    @IBAction func loginWithEmailBtnAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigate = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Apple Button Action
    @IBAction func loginWithAppleBtnAction(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            
        }else{
            SCLAlertView().showSuccess(Config().AppAlertTitle, subTitle: "Please update your apple version to use login.", closeButtonTitle: "OK")
        }
    }
    //MARK:- Facebook Button Action
    @IBAction func loginWithFacebookBtnAction(_ sender: UIButton) {
        let login:LoginManager = LoginManager()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if(error != nil){
                LoginManager().logOut()
            }else if(result!.isCancelled){
                LoginManager().logOut()
            }else{
                self.fetchUserData()
            }
        }
    }
    //MARK: - Facebook login data
    private func fetchUserData() {
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, first_name, last_name, picture.type(large)"])
        graphRequest.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Error",error!.localizedDescription)
            }else{
                print(result!)
                let field = result! as? [String:Any]
                self.name = field!["first_name"] as? String ?? ""
                print(self.lastName)
                Config().AppUserDefaults.set(DataManager.getVal(self.name), forKey: "first")
                self.lastName = field!["last_name"] as? String ?? ""
                print(self.lastName)
                //var idd = ""
                Config().AppUserDefaults.set(DataManager.getVal(self.lastName), forKey: "last")
                if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    print(imageURL)
                    
                    self.imgurll = imageURL
                } else {
                    self.imgurll = ""
                }
                
                if let iddd = field!["id"] as? NSNumber {
                    self.facebookId = iddd.stringValue
                    
                }else{
                    self.facebookId = field!["id"] as! String
                    Config().AppUserDefaults.set(DataManager.getVal(self.facebookId), forKey: "facebookid")
                }
                if let email = field!["email"] {
                    self.emaill = email as! String
                    Config().AppUserDefaults.set(DataManager.getVal(self.emaill), forKey: "emailId")
                }else {
                    self.emaill = ""
                }
//                self.clearAllNotice()
                self.removeSpinner()
                
                self.facebookLogin(firstname: self.name,lastname: self.lastName, facbookID: self.facebookId, email: self.emaill, imgUrl: self.imgurll)
            }
        })
    }
    //MARK: - FaceBook Login Api Integration
    func facebookLogin(firstname:String,lastname:String,facbookID:String,email:String,imgUrl:String) {
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        
        let DeviceId = Config().AppUserDefaults.value(forKey: "deviceID") as? String ?? ""
        let DeviceToken = Config().AppUserDefaults.value(forKey: "deviceToken") as? String ?? ""
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(email), forKey: "email")
        dict.setValue(DataManager.getVal(facbookID), forKey: "facebook_id")
        dict.setValue(DataManager.getVal("2"), forKey: "device_type")
        dict.setValue(DataManager.getVal(DeviceId), forKey: "device_id")
        dict.setValue(DataManager.getVal(firstname), forKey: "first_name")
        dict.setValue(DataManager.getVal(lastname), forKey: "last_name")
        dict.setValue(DataManager.getVal(imgUrl), forKey: "profile_picture")
        dict.setValue(DataManager.getVal(DeviceToken), forKey: "device_token")
    
        let methodName = "facebooklogin"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let data = DataManager.getVal(responseData?["data"]) as! [String: Any]
                let userId = DataManager.getVal(data["user_id"]) as? String ?? ""
                Config().AppUserDefaults.set("yes", forKey: "login")
                Config().AppUserDefaults.set(userId, forKey: "User_Id")
                isLoginEmail = false
                UserDefaults.standard.setValue(isLoginEmail, forKey: "isLoginEmail")
                let navigate = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(navigate, animated: true)
                
                let leftController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
                slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
                UIApplication.shared.windows.first?.rootViewController = slideMenuController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- Apple Login Authorization Delegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        
    }
    // ASAuthorizationControllerDelegate function for successful authorization
    func AppleLogin_API(Apple_Id:String){
        let AppleUserEmail = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserEmail")) as? String ?? ""
        let DeviceId = Config().AppUserDefaults.value(forKey: "deviceID") as? String ?? ""
        let DeviceToken = Config().AppUserDefaults.value(forKey: "deviceToken") as? String ?? ""
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(AppleUserEmail), forKey: "email")
        dict.setValue(DataManager.getVal(Apple_Id), forKey: "apple_id")
        dict.setValue(DataManager.getVal("2"), forKey: "device_type")
        dict.setValue(DataManager.getVal(DeviceId), forKey: "device_id")
        dict.setValue(DataManager.getVal(DeviceToken), forKey: "device_token")
        
        let methodName = "AppleLogin"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                
                if status == "1"{
                    let data = DataManager.getVal(responseData?["data"]) as! [String: Any]
                    let userId = DataManager.getVal(data["user_id"]) as? String ?? ""
                    Config().AppUserDefaults.set("yes", forKey: "login")
                    Config().AppUserDefaults.set(userId, forKey: "User_Id")
                    isLoginEmail = false
                    UserDefaults.standard.setValue(isLoginEmail, forKey: "isLoginEmail")
                    let navigate = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(navigate, animated: true)
                    
                    let leftController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                    let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
                    slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
                    UIApplication.shared.windows.first?.rootViewController = slideMenuController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                }else{
                    self.view.makeToast(message: message)
                }
//                self.clearAllNotice()
                self.removeSpinner()
            })
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleId = appleIDCredential.user
            print(appleId)
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            print(appleUserFirstName ?? "")
            let appleUsernme = appleIDCredential.fullName?.familyName
            print(appleUsernme ?? "")
            let appleUserEmail = appleIDCredential.email
            print(appleUserEmail ?? "")
            
            if appleUserEmail == nil {
                Config().AppUserDefaults.setValue(appleUserEmail, forKey: "AppleUserEmail")
                print(appleUserEmail as Any)
            }else{
                Config().AppUserDefaults.setValue(appleUserEmail, forKey: "AppleUserEmail")
            }
            if  appleUserFirstName == nil  {
                Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "AppleUserFirstName")
                print(appleUserFirstName as Any)
            }else{
                Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "AppleUserFirstName")
            }
            if appleUsernme == nil  {
                Config().AppUserDefaults.setValue(appleUsernme, forKey: "AppleUserLastName")
                print(appleUsernme as Any)
            }else{
                Config().AppUserDefaults.setValue(appleUsernme, forKey: "AppleUserLastName")
            }
            //api calling
            self.AppleLogin_API(Apple_Id: appleId)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let appleUsername = passwordCredential.user
            print(appleUsername as Any)
            let applePassword = passwordCredential.password
            print(applePassword as Any)
            //Write your code
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
