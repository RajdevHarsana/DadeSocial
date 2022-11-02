//
//  TwitterFeedsVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 12/05/21.
//

import UIKit
import WebKit

class TwitterFeedsVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var indicationView: UIActivityIndicatorView!
    @IBOutlet weak var TwitterWebView: WKWebView!
    
    var type = String()
    var TwitterData = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterWebView.navigationDelegate = self
        indicationView.style = .large
        indicationView.color = UIColor.black
        indicationView.center = self.view.center
        termsandconditionmethod()
//        self.getActivityFeeds()
        // Do any additional setup after loading the view.
    }
    
    func getActivityFeeds(){
//        self.pleaseWait()
        self.showSpinner(onView: self.view)
        let User_ID = Config().AppUserDefaults.value(forKey: "User_Id") as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(User_ID), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.type), forKey: "type")
        
        let methodName = "getActivityFeed"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.TwitterData = DataManager.getVal(responseData?["data"]) as? [Any] ?? []
//                TweetIds = DataManager.getVal(responseData?["ids"]) as? [String] ?? []
//                print(TweetIds)
//                self.initializeView(TweetIds)
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- webview Function
    func termsandconditionmethod() {
        let urlString = "https://mobile.twitter.com/Dade_Social"
        indicationView.startAnimating()
        indicationView.isHidden = false
        TwitterWebView.scrollView.isScrollEnabled = true
        TwitterWebView.scrollView.contentOffset = CGPoint(x: 0, y: 800)
        TwitterWebView.scrollView.bounces = false
        if let aString = URL(string: urlString) {
            TwitterWebView.load(URLRequest(url: aString))
            TwitterWebView.allowsBackForwardNavigationGestures = true
        }
    }
    //MARK:- Webview Delegates
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
//        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        indicationView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        indicationView.stopAnimating()
        indicationView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

}
