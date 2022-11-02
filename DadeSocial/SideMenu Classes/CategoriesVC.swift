//
//  CategoriesVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 10/05/21.
//

import UIKit

protocol MyDataSendingDelegate {
    func sendDataToFirstViewController(category_id: String, Name: String)
}

class CategoriesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBoutlates
    @IBOutlet weak var crossbtn: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    //MARK:- Variables
    var CategoriesArray = [Any]()
    var delegate: MyDataSendingDelegate? = nil
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        self.getCategoryListAPI()
        self.crossbtn.layer.cornerRadius = self.crossbtn.frame.width/2
        // Do any additional setup after loading the view.
    }
    //MARK:- Get Category List API Function
    func getCategoryListAPI(){
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let dict = NSMutableDictionary()
        let methodName = "getCategory"
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.CategoriesArray = DataManager.getVal(responseData?["categories"]) as! [Any]
                self.categoryTableView.reloadData()
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- Cross Button Action
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Table View Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CategoriesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell" ,for: indexPath) as! CategoriesCell
        let dict = DataManager.getVal(self.CategoriesArray[indexPath.row]) as! NSMutableDictionary
        cell.categoryName.text = DataManager.getVal(dict["name"]) as? String ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.CategoriesArray[indexPath.row]) as! [String: Any]
        let id = DataManager.getVal(dict["id"]) as? String ?? ""
        let name = DataManager.getVal(dict["name"]) as? String ?? ""
        if self.delegate != nil{
            let data_id = id
            let data_name = name
            self.delegate?.sendDataToFirstViewController(category_id: data_id, Name: data_name)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
