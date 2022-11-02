//
//  RatingVc.swift
//  DadeSocial
//
//  Created by MAC-27 on 07/04/21.
//

import UIKit

class RatingVc: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBoutlates
    @IBOutlet weak var TotalRatingLbl: UILabel!
    @IBOutlet weak var TotalReviewsLbl: UILabel!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var excellentRatingBar: UIProgressView!
    @IBOutlet weak var goodRatingBar: UIProgressView!
    @IBOutlet weak var averageRatingBar: UIProgressView!
    @IBOutlet weak var beloAverageRatingBar: UIProgressView!
    @IBOutlet weak var poorRatingBar: UIProgressView!
    @IBOutlet weak var businessRatingView: FloatRatingView!
    @IBOutlet weak var commentBtn: UIButton!
    
    //MARK:- Variables
    var Business_user_id = String()
    var RatingData = [Any]()
    var User_Id = String()
    var type = String()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.ratingTableView.delegate = self
        self.ratingTableView.dataSource = self
        self.commentBtn.layer.cornerRadius = 15
        self.getRatingCommentApi()
        // Do any additional setup after loading the view.
    }
    //MARK:- Get Comment and Rating API Function
    func getRatingCommentApi(){
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.Business_user_id), forKey: "business_user_id")
        let methodName = "getRateReview"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.ratingTableView.isHidden = false
                self.RatingData = DataManager.getVal(responseData?["ratings"]) as? [Any] ?? []
                self.User_Id = DataManager.getVal(responseData?["user_id"]) as? String ?? ""
                let excellent = DataManager.getVal(responseData?["excellent"]) as? String ?? ""
                let good = DataManager.getVal(responseData?["good"]) as? String ?? ""
                let average = DataManager.getVal(responseData?["average"]) as? String ?? ""
                let belowAverage = DataManager.getVal(responseData?["below_average"]) as? String ?? ""
                let poor = DataManager.getVal(responseData?["poor"]) as? String ?? ""
                self.excellentRatingBar.progress = self.StringToFloat(str: excellent)
                self.goodRatingBar.progress = self.StringToFloat(str: good)
                self.averageRatingBar.progress = self.StringToFloat(str: average)
                self.beloAverageRatingBar.progress = self.StringToFloat(str: belowAverage)
                self.poorRatingBar.progress = self.StringToFloat(str: poor)
                let totalRating = DataManager.getVal(responseData?["total_rating"]) as? String ?? ""
                let totalReview = DataManager.getVal(responseData?["total_review"]) as? String ?? "0"
                self.TotalReviewsLbl.text = "based on " + totalReview + " reviews"
                self.businessRatingView.rating = self.StringToFloat(str: totalRating)
                if totalRating.contains(".0"){
                    self.TotalRatingLbl.text = totalRating
                }else{
                    self.TotalRatingLbl.text = totalRating
                }
                self.ratingTableView.reloadData()
            }else{
                self.RatingData.removeAll()
                self.ratingTableView.isHidden = true
                self.TotalReviewsLbl.text = "based on " + "0" + " reviews"
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- TableView Datasource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RatingData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell" ,for: indexPath) as! RatingCell
        let Dict = DataManager.getVal(self.RatingData[indexPath.row]) as! [String:Any]
        let firstName = DataManager.getVal(Dict["first_name"]) as? String ?? ""
        let lastName = DataManager.getVal(Dict["last_name"]) as? String ?? ""
        cell.reviewName.text = firstName + " " + lastName
        cell.reviewDateLbl.text = DataManager.getVal(Dict["time"]) as? String ?? ""
        let rating = DataManager.getVal(Dict["rating"]) as? String ?? ""
        cell.reviewRating.rating = StringToFloat(str: rating)
        cell.commentLbl.text = DataManager.getVal(Dict["comment"]) as? String ?? ""
        if rating.contains(".0"){
            cell.reviewPointsLbl.text = rating
        }else if rating == ""{
            cell.reviewPointsLbl.text = "0"
        }else{
            cell.reviewPointsLbl.text = rating + ".0"
        }
        
        Config().setimage(name: DataManager.getVal(Dict["profile_picture"]) as? String ?? "", image: cell.reviewImg)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Dict = DataManager.getVal(self.RatingData[indexPath.row]) as! [String:Any]
        let rating = DataManager.getVal(Dict["rating"]) as? String ?? ""
        let comment = DataManager.getVal(Dict["comment"]) as? String ?? ""
        let id = DataManager.getVal(Dict["id"]) as? String ?? ""
        let review_user_Id = DataManager.getVal(Dict["user_id"]) as? String ?? ""
        if self.User_Id != review_user_Id{
            
        }else{
            let nextview = CommentReview.intitiateFromNib()
            nextview.RatingView.rating = StringToFloat(str: rating)
            nextview.commentTxtFeild.text = comment
            nextview.updatedLbl.text = rating
            let model = BackModel()
            nextview.layer.cornerRadius = 8
            nextview.buttonDoneHandler = {
    //            self.pleaseWait()
    //            self.showSpinner(onView: self.view)
                let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
                var Rating = Config().AppUserDefaults.value(forKey: "Rating") as? String ?? ""
                if Rating == "" {
                    Rating = "0"
                }
                let Comment = Config().AppUserDefaults.value(forKey: "Comment") as? String ?? ""
                let dict = NSMutableDictionary()
                dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
                dict.setValue(DataManager.getVal(self.Business_user_id), forKey: "business_user_id")
                dict.setValue(DataManager.getVal(Rating), forKey: "rating")
                dict.setValue(DataManager.getVal(Comment), forKey: "comment")
                dict.setValue(DataManager.getVal("edit"), forKey: "type")
                dict.setValue(DataManager.getVal(id), forKey: "rating_business_id")
                
                let methodName = "postRateReview"
                
                DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                    
                    let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                    let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                    
                    if status == "1"{
                        self.getRatingCommentApi()
                        model.closewithAnimation()
                    }else{
                        self.view.makeToast(message: message)
                        model.closewithAnimation()
                    }
    //                self.clearAllNotice()
    //                self.removeSpinner()
                }
            }
            nextview.buttonCancelHandler = {
                model.closewithAnimation()
            }
            model.show(view: nextview)
        }
        
    }
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    //MARK:- Comment Button Action
    @IBAction func commentBtnAction(_ sender: UIButton) {
        let nextview = CommentReview.intitiateFromNib()
        let model = BackModel()
        nextview.layer.cornerRadius = 8
        nextview.buttonDoneHandler = {
//            self.pleaseWait()
//            self.showSpinner(onView: self.view)
            let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
            var Rating = Config().AppUserDefaults.value(forKey: "Rating") as? String ?? ""
            if Rating == "" {
                Rating = "0"
            }
            let Comment = Config().AppUserDefaults.value(forKey: "Comment") as? String ?? ""
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.Business_user_id), forKey: "business_user_id")
            dict.setValue(DataManager.getVal(Rating), forKey: "rating")
            dict.setValue(DataManager.getVal(Comment), forKey: "comment")
            dict.setValue(DataManager.getVal("add"), forKey: "type")
            
            let methodName = "postRateReview"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    self.getRatingCommentApi()
                    model.closewithAnimation()
                }else{
                    self.view.makeToast(message: message)
                    model.closewithAnimation()
                }
//                self.clearAllNotice()
//                self.removeSpinner()
            }
        }
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        model.show(view: nextview)
    }
    
}
