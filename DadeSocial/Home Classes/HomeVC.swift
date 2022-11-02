//
//  HomeVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 02/04/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class HomeVC: UIViewController,SlideMenuControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, ToolbarPickerViewDelegate {
    //MARK:- IBOutlates
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var txtChooseCategory: UITextField!
    @IBOutlet weak var txtChooseCity: UITextField!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var btnClearCategory: UIButton!
    @IBOutlet weak var btnClearCity: UIButton!
    @IBOutlet weak var btnClearBusiness: UIButton!
    @IBOutlet weak var viewTableLoader: UIView!
    //MARK:- Variables
    var locationManager = CLLocationManager()
    var current_lat = String()
    var current_long = String()
    var User_ID = String()
    var DataArray = [Any]()
    var titleName = String()
    var UserData = [String:Any]()
    var refreshControl: UIRefreshControl!
    var categories = [Any]()
    var categoryId = String()
    var categoryName = String()
    var distanceFrom = String()
    var distanceTo = String()
    var Placelat = String()
    var Placelong = String()
    var isSpinnerShowing = true
    
    fileprivate let pickerView = ToolbarPickerView()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:-TextFieldCode
        viewTableLoader.isHidden = true
        txtChooseCity.delegate = self
        txtBusinessName.delegate = self
        txtChooseCategory.delegate = self
        txtChooseCategory.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtChooseCity.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtBusinessName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        btnClearCategory.addTarget(self, action: #selector(ClearButtonPressed(_:)), for: .touchUpInside)
        btnClearCity.addTarget(self, action: #selector(ClearButtonPressed(_:)), for: .touchUpInside)
        btnClearBusiness.addTarget(self, action: #selector(ClearButtonPressed(_:)), for: .touchUpInside)
        btnClearCategory.isHidden = true
        btnClearCity.isHidden = true
        btnClearBusiness.isHidden = true
        GetCategories()
        //        self.titleName = Config().AppUserDefaults.value(forKey: "TITLE") as? String ?? ""
        //        self.titleLbl.text = self.titleName
        self.navigationController?.isNavigationBarHidden = true
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
        self.dataTableView.rowHeight = UITableView.automaticDimension
        self.dataTableView.estimatedRowHeight = 600
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor(red: 246/255, green: 113/255, blue: 46/255, alpha: 1.0)
        self.refreshControl.addTarget(self,action: #selector(self.refreshVenueList),for: .valueChanged)
        self.dataTableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
        self.txtChooseCategory.inputView = self.pickerView
        self.txtChooseCategory.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        //        self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
        
        pickerView.reloadAllComponents()
    }
    override func viewWillAppear(_ animated: Bool) {
        //        self.titleName = Config().AppUserDefaults.value(forKey: "TITLE") as? String ?? ""
        //        self.titleLbl.text = self.titleName
        if self.User_ID == "" {
            self.User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        }else{
            
        }
        self.current_lat = Config().AppUserDefaults.value(forKey: "LAT") as? String ?? ""
        self.current_long = Config().AppUserDefaults.value(forKey: "LONG") as? String ?? ""
        self.removeSpinner()
        let utf8str = self.txtBusinessName.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.HomeListAPI(Lat: Placelat, Long: Placelong, distanceFrom: distanceFrom, distanceTo: distanceTo, category_id: categoryId, searchKey: base64Encoded)
    }
    @objc func refreshVenueList(sender: UIRefreshControl) {
        let utf8str = self.txtBusinessName.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.HomeListAPI(Lat: Placelat, Long: Placelong, distanceFrom: distanceFrom, distanceTo: distanceTo, category_id: categoryId, searchKey: base64Encoded)
        self.refreshControl.endRefreshing()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtChooseCategory {
            if txtChooseCategory.text != "" {
                btnClearCategory.isHidden = false
            }else {
                btnClearCategory.isHidden = true
            }
        }
        else if textField == txtChooseCity {
            if txtChooseCity.text != "" {
                btnClearCity.isHidden = false
            }else {
                btnClearCity.isHidden = true
            }
        }
        else if textField == txtBusinessName {
            if txtBusinessName.text != "" {
                btnClearBusiness.isHidden = false
                isSpinnerShowing = false
                let utf8str = self.txtBusinessName.text!.data(using: .utf8)
                let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
                self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
                
                
            }else {
                isSpinnerShowing = false
                let utf8str = self.txtBusinessName.text!.data(using: .utf8)
                let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
                self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
                
                
                btnClearBusiness.isHidden = true
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtChooseCity{
            self.txtChooseCity.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            btnClearCity.isHidden = false
        }
    }
    @objc func ClearButtonPressed(_ Button : UIButton){
        if Button == btnClearCategory{
            txtChooseCategory.text = ""
            categoryId = ""
            btnClearCategory.isHidden = true
            let utf8str = self.txtBusinessName.text!.data(using: .utf8)
            let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
            self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
        } else if Button == btnClearCity {
            txtChooseCity.text = ""
            btnClearCity.isHidden = true
            self.Placelat = ""
            self.Placelong = ""
            let utf8str = self.txtBusinessName.text!.data(using: .utf8)
            let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
            self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)        }
        else if Button == btnClearBusiness {
            txtBusinessName.text = ""
            btnClearBusiness.isHidden = true
            let utf8str = self.txtBusinessName.text!.data(using: .utf8)
            let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
            self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)        }
        
    }
    //MARK:- PickerView Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var dict = [String:Any]()
        dict = DataManager.getVal(self.categories[row]) as! [String:Any]
        let categoryName = DataManager.getVal(dict["name"]) as? String ?? ""
        return categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dict = [String:Any]()
        dict = DataManager.getVal(self.categories[row]) as! [String:Any]
        let categoryName = DataManager.getVal(dict["name"]) as? String ?? ""
        self.txtChooseCategory.text = categoryName
        //        self.pickerView.isHidden = true
    }
    //MARK:- ToolbarPickerView Delegates
    func didTapDone() {
        if self.categories.count != 0 {
            btnClearCategory.isHidden = false
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            var dict = [String:Any]()
            dict = DataManager.getVal(self.categories[row]) as! [String:Any]
            let categoryName = DataManager.getVal(dict["name"]) as? String ?? ""
            self.txtChooseCategory.text = categoryName
            self.categoryName = categoryName
            self.categoryId = DataManager.getVal(dict["id"]) as? String ?? ""
            self.txtChooseCategory.resignFirstResponder()
            let utf8str = self.txtBusinessName.text!.data(using: .utf8)
            let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
            self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
        }else{
            self.txtChooseCategory.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        categoryId = ""
        self.txtChooseCategory.text = nil
        self.txtChooseCategory.resignFirstResponder()
        let utf8str = self.txtBusinessName.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
    }
    //MARK:- Get Categories
    func GetCategories(){
        let methodName = "getCategory"
        DataManager.getAPIResponse([:], methodName: methodName, methodType: "GET") { responce, error in
            let status = DataManager.getVal(responce?["status"]) as? String ?? ""
            if status == "1"{
                self.categories = DataManager.getVal(responce?["categories"]) as? Array ?? []
            }
        }
    }
    //MARK:- Get Profile API
    func HomeListAPI(Lat:String,Long:String,distanceFrom: String, distanceTo: String, category_id: String, searchKey:String){
        if isSpinnerShowing == true {
            self.showSpinner(onView: self.view)
        } else {
            
            viewTableLoader.isHidden = false
            self.showTableSpinner(onView: viewTableLoader)
        }
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.User_ID), forKey: "user_id")
        dict.setValue(DataManager.getVal(Lat), forKey: "latitude")
        dict.setValue(DataManager.getVal(Long), forKey: "longitude")
//        dict.setValue(DataManager.getVal(distanceFrom), forKey: "from_distance")
//        dict.setValue(DataManager.getVal(distanceTo), forKey: "to_distance")
        dict.setValue(DataManager.getVal(category_id), forKey: "category_id")
        dict.setValue(DataManager.getVal(searchKey), forKey: "business_name")
        print(dict)
        let methodName = "searchingAndFilter"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.UserData = DataManager.getVal(responseData?["userData"]) as? [String:Any] ?? [:]
                let role_Id = DataManager.getVal(self.UserData["role_id"]) as? String ?? ""
                if role_Id == "2" {
                    Config().AppUserDefaults.removeObject(forKey: "login")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let navigationController = UINavigationController(rootViewController: newViewController)
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }else{
                    self.dataTableView.isHidden = false
                    self.DataArray = DataManager.getVal(responseData?["business_users"]) as? [Any] ?? []
                    if self.DataArray.count != 0{
                        self.dataTableView.isHidden = false
                    }else{
                        self.dataTableView.isHidden = true
                    }
                    self.categories = DataManager.getVal(responseData?["categories"]) as? [Any] ?? []
                    self.dataTableView.reloadData()
                }
            }else{
                self.DataArray.removeAll()
                self.dataTableView.isHidden = true
                //                self.view.makeToast(message: message)
            }
            self.removeSpinner()
            self.view.willRemoveSubview(vSpinner ?? self.view)
            self.isSpinnerShowing = true
        }
    }
    //MARK:- TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell" ,for: indexPath) as! DataCell
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
        self.viewTableLoader.isHidden = true
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
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var Dict = [String:Any]()
        Dict = DataManager.getVal(self.DataArray[indexPath.row]) as! [String:Any]
        let Id = DataManager.getVal(Dict["id"]) as? String ?? ""
        let navigate = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        navigate.Business_User_Id = Id
        navigate.placeLat = Placelat
        navigate.placeLong = Placelong
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Location Button Action
    @IBAction func locationBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "SelecteLocationVc") as! SelecteLocationVc
        navigate.modalPresentationStyle = .fullScreen
        navigate.isPresent = true
        self.navigationController?.present(navigate, animated: true, completion: nil)
    }
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Scearch Button Action
    @IBAction func searchBtnAction(_ sender: UIButton) {
        let navigate = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(navigate, animated: true)
    }
    //MARK:- Heart Button Action
    @objc func handleTap(_ sender:UIButton) {
        let dict = DataManager.getVal(self.DataArray[sender.tag]) as! NSDictionary
        let id = DataManager.getVal(dict["id"]) as? String ?? ""
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = self.dataTableView.cellForRow(at: index) as? DataCell
        sender.isSelected = !sender.isSelected
        if cell?.heartBtn.currentImage == UIImage(named: "heart_Fill"){
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
            dict.setValue(DataManager.getVal(id), forKey: "business_user_id")
            
            let methodName = "favouriteUnfavourite"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["response"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                if status == "2"{
                    cell?.heartBtn.setImage(UIImage(named: "heart"), for: .normal)
                    let utf8str = self.txtBusinessName.text!.data(using: .utf8)
                    let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
                    self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
            }
        }else{
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
            dict.setValue(DataManager.getVal(id), forKey: "business_user_id")
            
            let methodName = "favouriteUnfavourite"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["response"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                if status == "1"{
                    cell?.heartBtn.setImage(UIImage(named: "heart_Fill"), for: .normal)
                    let utf8str = self.txtBusinessName.text!.data(using: .utf8)
                    let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
                    self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
            }
        }
    }
    
}
extension HomeVC: GMSAutocompleteViewControllerDelegate {
    //MARK:- Google Place Delegate
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        Placelat = String(place.coordinate.latitude)
        Placelong = String(place.coordinate.longitude)
        let utf8str = self.txtBusinessName.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
        
        let CurrentLat = String(lat)
        let CurrentLong = String(lon)
        Config().AppUserDefaults.set(CurrentLat, forKey: "LAT")
        Config().AppUserDefaults.set(CurrentLong, forKey: "LONG")
        print("lat lon",lat,lon)
        self.txtChooseCity.text = place.name
        let titleName = place.formattedAddress ?? ""
        var Street = String()
        var Route = String()
        var city = String()
        var state = String()
        var country = String()
        //        let address = place.addressComponents
        print(place.addressComponents ?? "")
        if place.addressComponents != nil {
            for addressComponent in (place.addressComponents)! {
                for type in (addressComponent.types){
                    
                    switch(type){
                    
                    case "street_number":
                        Street = addressComponent.shortName ?? ""
                    case "route":
                        Route = addressComponent.shortName ?? ""
                    case "locality":
                        city = addressComponent.name
                    case "administrative_area_level_1":
                        state = addressComponent.shortName ?? ""
                    case "country":
                        country = addressComponent.shortName ?? ""
                    default:
                        break
                    }
                }
            }
        }
        var address = String()
        address = city + ", " + state
        //        if Street == ""{
        //            address = Route+", "+city+", "+state+", "+country
        //        }else if Route == ""{
        //            address = Street+", "+city+", "+state+", "+country
        //        }else if Street == "" || Route == "" {
        //            address = city + ", " + state + ", " + country
        //        }else{
        //            address = Street+", "+Route+", "+city+", "+state+", "+country
        //        }
        //        Config().AppUserDefaults.set(address, forKey: "TITLE")
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
        //        if self.isComeFromProfile == true{
        //            self.dismiss(animated: true, completion: nil)
        //            self.removeSpinner()
        //        }else{
        //            Config().AppUserDefaults.set("Yes", forKey: "SetLocation")
        //            let navigate = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //            navigate.User_ID = user_Id
        //            let leftController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        //            let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
        //            slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
        //            UIApplication.shared.windows.first?.rootViewController = slideMenuController
        //            UIApplication.shared.windows.first?.makeKeyAndVisible()
        //            self.removeSpinner()
        //        }
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
        if txtChooseCity.text != "" {
            btnClearCity.isHidden = false
        } else{
            btnClearCity.isHidden = true
        }
        let utf8str = self.txtBusinessName.text!.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
        self.HomeListAPI(Lat: self.Placelat, Long: self.Placelong, distanceFrom: self.distanceFrom, distanceTo: self.distanceTo, category_id: self.categoryId, searchKey: base64Encoded)
    }
}
