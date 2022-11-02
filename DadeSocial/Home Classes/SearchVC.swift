//
//  SearchVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 06/04/21.
//

import UIKit

class SearchVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, MyFilterDataSendingDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var SearchTableView: UITableView!
    @IBOutlet weak var searchBuisnessTxt: UISearchBar!
    @IBOutlet weak var loactionBtn: UIButton!
    @IBOutlet weak var searchTitleLbl: UILabel!
    //MARK:- Variables
    var searchTitleName = String()
    var User_Id = String()
    var Current_lat = String()
    var Current_long = String()
    var DistanceFrom = String()
    var DistanceTo = String()
    var category = String()
    var category_Id = String()
    var DataArray = [Any]()
    var searchplace = String()
    var categoryArray = [Any]()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.SearchTableView.delegate = self
        self.SearchTableView.dataSource = self
        self.searchBuisnessTxt.delegate = self
        self.searchBuisnessTxt.layer.cornerRadius = 15
        self.searchBuisnessTxt.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.searchTitleName = Config().AppUserDefaults.value(forKey: "TITLE") as? String ?? ""
//        self.searchTitleLbl.text = self.searchTitleName
        self.User_Id = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        self.Current_lat = Config().AppUserDefaults.value(forKey: "LAT") as? String ?? ""
        self.Current_long = Config().AppUserDefaults.value(forKey: "LONG") as? String ?? ""
        self.searchListAPI(distanceFrom: self.DistanceFrom, distanceTo: self.DistanceTo, category_id: self.category_Id, searchKey: self.searchBuisnessTxt.text!)
    }
    //MARK:- Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let utf8str = self.searchBuisnessTxt.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.searchListAPI(distanceFrom: self.DistanceFrom, distanceTo: self.DistanceTo, category_id: self.category_Id, searchKey: base64Encoded)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
        if searchplace == ""{
            self.searchListAPI(distanceFrom: self.DistanceFrom, distanceTo: self.DistanceTo, category_id: self.category_Id, searchKey: self.searchBuisnessTxt.text!)
        }
    }
    //MARK:- Protocol Delegate Function
    func sendDataToSearchViewController(DistanceFrom: String, DistanceTo: String, Category_Id: String, Category: String) {
        self.DistanceFrom = DistanceFrom
        self.DistanceTo = DistanceTo
        self.category_Id = Category_Id
        self.category = Category
        let utf8str = self.searchBuisnessTxt.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.searchListAPI(distanceFrom: self.DistanceFrom, distanceTo: self.DistanceTo, category_id: self.category_Id, searchKey: base64Encoded)
    }
    //MARK:- Search List API Function
    func searchListAPI(distanceFrom: String, distanceTo: String, category_id: String, searchKey:String){
        self.showSpinner(onView: self.view)
        let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let _lat = Config().AppUserDefaults.value(forKey: "LAT") as? String ?? ""
        let _long = Config().AppUserDefaults.value(forKey: "LONG") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
        dict.setValue(DataManager.getVal(_lat), forKey: "latitude")
        dict.setValue(DataManager.getVal(_long), forKey: "longitude")
        dict.setValue(DataManager.getVal(distanceFrom), forKey: "from_distance")
        dict.setValue(DataManager.getVal(distanceTo), forKey: "to_distance")
        dict.setValue(DataManager.getVal(category_Id), forKey: "category_id")
        dict.setValue(DataManager.getVal(searchKey), forKey: "business_name")
        let methodName = "searchingAndFilter"
        print(dict)
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.DataArray = DataManager.getVal(responseData?["business_users"]) as? [Any] ?? []
                if self.DataArray.count != 0{
                    self.SearchTableView.isHidden = false
                }else{
                    self.SearchTableView.isHidden = true
                }
                self.categoryArray = DataManager.getVal(responseData?["categories"]) as? [Any] ?? []
                self.SearchTableView.reloadData()
                self.view.endEditing(true)
            }else{
                self.DataArray.removeAll()
                self.SearchTableView.isHidden = true
                self.view.makeToast(message: message)
            }
            self.removeSpinner()
        }
    }
    //MARK:- TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell" ,for: indexPath) as! SearchCell
        var Dict = [String:Any]()
        Dict = DataManager.getVal(self.DataArray[indexPath.row]) as! [String:Any]
        cell.distance.layer.cornerRadius = 10
        cell.distance.layer.masksToBounds = true
        cell.bussnessName.text = DataManager.getVal(Dict["business_name"]) as? String ?? ""
        let rating = DataManager.getVal(Dict["rating"]) as? String ?? ""
        cell.reviewRating.rating = self.StringToFloat(str: rating)
        let reviews = DataManager.getVal(Dict["review"]) as? String ?? ""
        cell.reviewsLbl.text = reviews + " Review"
        cell.address.text = DataManager.getVal(Dict["address"]) as? String ?? ""
        let distance = DataManager.getVal(Dict["distance"]) as? String ?? ""
        cell.distance.text = "" + distance + " away      "
        let categoryName = DataManager.getVal(Dict["category_name"]) as? String ?? ""
        cell.category.layer.cornerRadius = 10
        cell.category.layer.masksToBounds = true
        cell.category.text = "" + categoryName + "      "
        Config().setimage(name: DataManager.getVal(Dict["profile_picture"]) as? String ?? "", image: cell.ImgView)
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        let LikeStatus = DataManager.getVal(Dict["like"]) as? String ?? ""
        if LikeStatus == "1" {
            cell.heartBtn.setImage(UIImage(named: "heart_Fill"), for: .normal)
        }else {
            cell.heartBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
        let Featuredstatus = DataManager.getVal(Dict["featured_status"]) as? String ?? ""
        if Featuredstatus == "1" {
            cell.featuredIcon.isHidden = false
        }else {
            cell.featuredIcon.isHidden = true
        }
        return cell
    }
    //MARK:- String to Float Convert Function
    func StringToFloat(str:String)->(Float){
        let string = str
        var cgFloat:Float = 0
        if let doubleValue = Double(string){
            cgFloat = Float(doubleValue)
        }
        return cgFloat
    }
    //MARK:- TableVIew Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var Dict = [String:Any]()
        Dict = DataManager.getVal(self.DataArray[indexPath.row]) as! [String:Any]
        let Id = DataManager.getVal(Dict["id"]) as? String ?? ""
        let navigate = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        navigate.Business_User_Id = Id
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Heart Button Action
    @objc func handleTap(_ sender:UIButton) {
        let dict = DataManager.getVal(self.DataArray[sender.tag]) as! NSDictionary
        let id = DataManager.getVal(dict["id"]) as? String ?? ""
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = self.SearchTableView.cellForRow(at: index) as? SearchCell
        sender.isSelected = !sender.isSelected
        if cell?.heartBtn.currentImage == UIImage(named: "heart_Fill"){
            let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
            dict.setValue(DataManager.getVal(id), forKey: "business_user_id")
            
            let methodName = "favouriteUnfavourite"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["response"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                if status == "2"{
                    cell?.heartBtn.setImage(UIImage(named: "heart"), for: .normal)
                    self.searchListAPI(distanceFrom: self.DistanceFrom, distanceTo: self.DistanceTo, category_id: self.category_Id, searchKey: self.searchBuisnessTxt.text!)
                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
            }
        }else{
            let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
            dict.setValue(DataManager.getVal(id), forKey: "business_user_id")
            
            let methodName = "favouriteUnfavourite"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["response"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                if status == "1"{
                    cell?.heartBtn.setImage(UIImage(named: "heart_Fill"), for: .normal)
                    self.searchListAPI(distanceFrom: self.DistanceFrom, distanceTo: self.DistanceTo, category_id: self.category_Id, searchKey: self.searchBuisnessTxt.text!)
                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
            }
        }
    }
    //MARK:- Cross Button Action
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Location Button Action
    @IBAction func locationBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "SelecteLocationVc") as! SelecteLocationVc
        navigate.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navigate, animated: true, completion: nil)
    }
    //MARK:- Filter Button Action
    @IBAction func filterBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        navigate.categories = self.categoryArray
        navigate.delegate = self
        navigate.Category = self.category
        self.navigationController?.present(navigate, animated: true, completion: nil)
    }
    //MARK:- Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        Config().AppUserDefaults.removeObject(forKey: "Change")
    }
    
}

