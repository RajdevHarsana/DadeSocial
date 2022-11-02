//
//  LeftMenuViewController.swift
//  DadeSocial
//
//  Created by MAC-27 on 06/04/21.
//

import UIKit

class LeftMenuViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var ProfileImgView: UIImageView!
    @IBOutlet weak var UserNameLbl: UILabel!
    //MARK:- Variables
    var Menu_Item_Array = [String]()
    var Menu_Item_Image_Array = [String]()
    var email = String()
    var phoneNum = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuView.layer.cornerRadius = 20
        self.menuView.clipsToBounds = true
        self.ProfileImgView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfileAPI()
//        self.Menu_Item_Image_Array = ["home","profile_icon","favrate_icon","register_icon","notif_icon","activityFeed_icon","privacy_icon","privacy_icon","FAQ's_icon","privacy_icon","ContactUs_icon","logout_icon"]
        self.Menu_Item_Image_Array = ["home","profile_icon","favrate_icon","notif_icon","activityFeed_icon","privacy_icon","privacy_icon","FAQ's_icon","privacy_icon","ContactUs_icon","logout_icon"]
        
//        self.Menu_Item_Array = ["Home","My Profile","My Favorites","Register My Business","Notifications","Activity Feed","Privacy Policy","Terms & Conditions","FAQs","About Us","Contact Us","Logout"]
        self.Menu_Item_Array = ["Home","My Profile","My Favorites","Notifications","Activity Feed","Privacy Policy","Terms & Conditions","FAQs","About Us","Contact Us","Logout"]
        
    }
    //MARK:- Get Profile API Function
    func getProfileAPI(){
//        self.pleaseWait()
//        self.showSpinner(onView: self.view)
        let UserId = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(UserId), forKey: "user_id")
        let methodName = "getUserProfile"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let Data = DataManager.getVal(responseData?["data"]) as! NSDictionary
                let firstName = DataManager.getVal(Data["first_name"]) as? String ?? ""
                let lastName = DataManager.getVal(Data["last_name"]) as? String ?? ""
                self.email = DataManager.getVal(Data["email"]) as? String ?? ""
                self.phoneNum = DataManager.getVal(Data["contact_number"]) as? String ?? ""
                self.UserNameLbl.text = firstName + " " + lastName
                Config().setimage(name: DataManager.getVal(Data["profile_picture"]) as? String ?? "", image: self.ProfileImgView)
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
//            self.removeSpinner()
        }
    }
    //MARK:- TableView Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Menu_Item_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell" ,for: indexPath) as! LeftMenuCell
        cell.itemImg.image = UIImage(named: self.Menu_Item_Image_Array[indexPath.row])
        cell.itemName.text = self.Menu_Item_Array[indexPath.row]
        return cell
    }
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 1{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "ProfileVc") as! ProfileVc
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 2{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "MyFavoriteVC") as! MyFavoriteVC
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }
//        else if indexPath.row == 3{
//            let navigate = storyboard?.instantiateViewController(withIdentifier: "RegisterBusinessVC") as! RegisterBusinessVC
//            navigate.user_Email = self.email
//            navigate.user_PhoneNo = self.phoneNum
//            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
//        }
        else if indexPath.row == 3{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "NotifiactionVC") as! NotifiactionVC
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 4{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "ActivityFeedsVC") as! ActivityFeedsVC
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 5{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            navigate.webtype = "privacy"
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 6{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            navigate.webtype = "term"
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 7{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            navigate.webtype = "faq"
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 8{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            navigate.webtype = "about"
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 9{
            let navigate = storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: navigate), close: true)
        }else if indexPath.row == 10{
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("YES", backgroundColor: UIColor(red: 246/255, green: 113/255, blue: 46/255, alpha: 1.0)){
                Config().AppUserDefaults.removeObject(forKey: "login")
                Config().AppUserDefaults.removeObject(forKey: "isLoginEmail")
                isLoginEmail = true
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = UINavigationController(rootViewController: newViewController)
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            alert.addButton("NO", backgroundColor: UIColor(red: 246/255, green: 113/255, blue: 46/255, alpha: 1.0)){
                print("NO")
            }
            alert.showEdit("LOGOUT", subTitle: "Are you sure you want to logout?")
            
        }
    }
}
