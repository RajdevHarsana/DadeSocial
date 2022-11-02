//
//  NotifiactionVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 05/04/21.
//

import UIKit

class NotifiactionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBoutlates
    @IBOutlet weak var NotificationTableView: UITableView!
    //MARK:- Veriables
    var user_id = String()
    var NotiDataArray = [Any]()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.NotificationTableView.delegate = self
        self.NotificationTableView.dataSource = self
        self.user_id = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        self.getNotificationAPI()
        // Do any additional setup after loading the view.
    }
    //MARK:- Get Notification API Function
    func getNotificationAPI(){
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "getNotifications"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.NotificationTableView.isHidden = false
                self.NotiDataArray = DataManager.getVal(responseData?["notifications"]) as! [Any]
                self.NotificationTableView.reloadData()
            }else{
                self.NotificationTableView.isHidden = true
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
        return self.NotiDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell" ,for: indexPath) as! NotificationCell
        let dict = DataManager.getVal(self.NotiDataArray[indexPath.row]) as! [String:Any]
        cell.notiNameLbl.text = DataManager.getVal(dict["title"]) as? String ?? ""
        cell.notiDetailLbl.text = DataManager.getVal(dict["message"]) as? String ?? ""
        let date = DataManager.getVal(dict["date"]) as? String ?? ""
        cell.notiDateLbl.text = date
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let Datadict = DataManager.getVal(self.NotiDataArray[indexPath.row]) as! [String:Any]
            let id = DataManager.getVal(Datadict["id"]) as? String ?? ""
            self.NotiDataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            self.showSpinner(onView: self.view)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(id), forKey: "notification_id")
            
            let methodName = "deleteNotification"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
//                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
//                self.removeSpinner()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
