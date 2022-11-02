//
//  InstagramFeedsVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 18/05/21.
//

import UIKit

class InstagramFeedsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableLabelDelegate {
    
    //MARK:- IBoutlates
    @IBOutlet weak var InstaFeedTable: UITableView!
    @IBOutlet weak var FeedsTableView: UITableView!
    //MARK:- Variables
    var type = String()
    var InstaData = [Any]()
    var postTime = Date()
    var Videos = [String]()
    var VideoImages = [String]()
    var VideoIndex = [String]()
    var caption = String()
    var playerController: ASVideoPlayerController?
    var Index = Int()
    var APICall = Bool()
    var NextData = String()
    var isNewDataLoading = Bool()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.FeedsTableView.isHidden = true
        self.InstaFeedTable.delegate = self
        self.InstaFeedTable.dataSource = self
        self.getInstaFeedApi(next: "")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: NSNotification.Name.init(UIApplication.willEnterForegroundNotification.rawValue), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in InstaFeedTable.visibleCells {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: cell as! ASAutoPlayVideoLayerContainer)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.FeedsTableView.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.pausePlayeVideos()
    }
    //MARK:- Get Instagram Feed API Function
    func getInstaFeedApi(next:String){
        self.showSpinner(onView: self.view)
        let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.type), forKey: "type")
        dict.setValue(DataManager.getVal(next), forKey: "next")
        let methodName = "getActivityFeed"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                var arr_data = [Any]()
                arr_data = DataManager.getVal(responseData?["data"]) as? [Any] ?? []
                if arr_data.count != 0 {
                self.InstaData.append(contentsOf: arr_data)
                arr_data.removeAll()
              }
                let dict = DataManager.getVal(responseData?["paging"]) as? [String:Any] ?? [:]
                self.NextData = DataManager.getVal(dict["next"]) as? String ?? ""
                for i in 0..<self.InstaData.count{
                    let dict = DataManager.getVal(self.InstaData[i]) as? [String:Any] ?? [:]
                    let videoInd = DataManager.getVal(dict["media_type"]) as? String ?? ""
                    let videoUrl = DataManager.getVal(dict["media_url"]) as? String ?? ""
                    let thumbnailUrl = DataManager.getVal(dict["thumbnail_url"]) as? String ?? ""
                    self.Videos.append(videoUrl)
                    self.VideoImages.append(thumbnailUrl)
                    self.VideoIndex.append(videoInd)
                }
                self.InstaFeedTable.reloadData()
            }else{
                self.view.makeToast(message: message)
            }
            self.removeSpinner()
        }
    }
    //MARK:- TableView Delegate & Datasource
    func numberOfSections(in tableView: UITableView) -> Int{
        var numOfSections: Int = 0
        if self.InstaData.count>0{
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Feeds Found"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.InstaData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.isNewDataLoading = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstaCell" ,for: indexPath) as! InstaCell
        let Dict = DataManager.getVal(self.InstaData[indexPath.row]) as? [String:Any] ?? [:]
        cell.userNameLbl.text = DataManager.getVal(Dict["username"]) as? String ?? ""
        self.caption = DataManager.getVal(Dict["caption"]) as? String ?? ""
        let timestamp = DataManager.getVal(Dict["timestamp"]) as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:timestamp)!
        self.postTime = date
        cell.uploadDateTimeLbl.text = self.postTime.timeAgoDisplay()
        let media_Type = DataManager.getVal(Dict["media_type"]) as? String ?? ""
        if media_Type == "VIDEO" {
            cell.configureCell(imageUrl: DataManager.getVal(Dict["thumbnail_url"]) as? String ?? "", description: "", videoUrl: DataManager.getVal(Dict["media_url"]) as? String ?? "")
        }else{
            cell.configureCell(imageUrl: DataManager.getVal(Dict["media_url"]) as? String ?? "", description: "", videoUrl: nil)
        }
        cell.captionLbl.delegate = self
        cell.captionLbl.setLessLinkWith(lessLink: "Close", attributes: [.foregroundColor:UIColor.red], position: .left)
        cell.layoutIfNeeded()
        cell.captionLbl.shouldCollapse = true
        cell.captionLbl.textReplacementType = ExpandableLabel.TextReplacementType.word
        cell.captionLbl.numberOfLines = 3
        cell.captionLbl.text = caption
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    //MARK:- ScrollView Delegate & Datasource
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
        if scrollView == InstaFeedTable{
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if !self.isNewDataLoading{
                self.isNewDataLoading = true
                self.getInstaFeedApi(next: self.NextData)
                }
            }
        }
    }
    //MARK:- Video Play Pause Functions
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: InstaFeedTable)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: InstaFeedTable, appEnteredFromBackground: true)
    }
    
    //MARK:- ExpandableLabel Delegate
    func willExpandLabel(_ label: ExpandableLabel) {
        InstaFeedTable.beginUpdates()
    }
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: InstaFeedTable)
        if let indexPath = InstaFeedTable.indexPathForRow(at: point) as IndexPath? {
            //            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.InstaFeedTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        InstaFeedTable.endUpdates()
    }
    func willCollapseLabel(_ label: ExpandableLabel) {
        InstaFeedTable.beginUpdates()
    }
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: InstaFeedTable)
        if let indexPath = InstaFeedTable.indexPathForRow(at: point) as IndexPath? {
            //            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.InstaFeedTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        InstaFeedTable.endUpdates()
    }
}
