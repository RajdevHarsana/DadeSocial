//
//  MyFavoriteVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 03/04/21.
//

import UIKit

class MyFavoriteVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var FavTableView: UITableView!
    //MARK:- Variables
    var User_ID = String()
    var favDataArray = [Any]()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        self.FavTableView.delegate = self
        self.FavTableView.dataSource = self
        self.FavoriteListAPI()
        // Do any additional setup after loading the view.
    }
    //MARK:- Get Favorite List Function
    func FavoriteListAPI(){
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.User_ID), forKey: "user_id")
        
        let methodName = "getFavourite"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.FavTableView.isHidden = false
                self.favDataArray = DataManager.getVal(responseData?["like_business"]) as? [Any] ?? []
                self.FavTableView.reloadData()
            }else{
                self.FavTableView.isHidden = true
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavCell" ,for: indexPath) as! MyFavCell
        var Dict = [String:Any]()
        Dict = DataManager.getVal(self.favDataArray[indexPath.row]) as! [String:Any]
        cell.distance.layer.cornerRadius = 10
        cell.distance.layer.masksToBounds = true
        cell.distance.layer.cornerRadius = 10
        cell.distance.layer.masksToBounds = true
        cell.bussnessName.text = DataManager.getVal(Dict["business_name"]) as? String ?? ""
        cell.address.text = DataManager.getVal(Dict["address"]) as? String ?? ""
        let category_name = DataManager.getVal(Dict["category_name"]) as? String ?? ""
        cell.distance.text = "  Category : " + category_name + "  "
        Config().setimage(name: DataManager.getVal(Dict["profile_picture"]) as? String ?? "", image: cell.ImgView)
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        cell.heartBtn.setImage(UIImage(named: "heart_Fill"), for: .normal)
        let Featuredstatus = DataManager.getVal(Dict["featured_status"]) as? String ?? ""
        if Featuredstatus == "1" {
            cell.featuredIcon.isHidden = false
        }else {
            cell.featuredIcon.isHidden = true
        }
        return cell
    }
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var Dict = [String:Any]()
        Dict = DataManager.getVal(self.favDataArray[indexPath.row]) as! [String:Any]
        let Id = DataManager.getVal(Dict["business_user_id"]) as? String ?? ""
        let navigate = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        navigate.Business_User_Id = Id
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Heart Button Action
    @objc func handleTap(_ sender:UIButton) {
        let Datadict = DataManager.getVal(self.favDataArray[sender.tag]) as! NSDictionary
        let id = DataManager.getVal(Datadict["business_user_id"]) as? String ?? ""
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = self.FavTableView.cellForRow(at: index) as? MyFavCell
        sender.isSelected = !sender.isSelected
//        self.pleaseWait()
//        self.showSpinner(onView: self.view)
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
        dict.setValue(DataManager.getVal(id), forKey: "business_user_id")
        
        let methodName = "favouriteUnfavourite"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["response"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            if status == "2"{
                self.view.makeToast(message: message)
                self.FavoriteListAPI()
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
//            self.removeSpinner()
        }
    }
}
