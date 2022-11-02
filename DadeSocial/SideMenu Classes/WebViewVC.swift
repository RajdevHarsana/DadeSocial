//
//  WebViewVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 07/04/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    
    //MARK:- IBoutlates
    @IBOutlet weak var indicationView: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    //MARK:- Variables
    var webtype = String()
    var isComingFrom = Bool()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //        webviewvc.delegate = self
        if isComingFrom == true{
            let image = UIImage(named: "whiteBack")
            self.menuBtn.setImage(image, for: .normal)
        }else{
            let image = UIImage(named: "Menu_icon")
            self.menuBtn.setImage(image, for: .normal)
        }
        webView.navigationDelegate = self
        indicationView.style = .large
        indicationView.color = UIColor.black
        indicationView.center = self.view.center
        termsandconditionmethod()
        // Do any additional setup after loading the view.
    }
    //MARK: - webview Function
    func termsandconditionmethod() {
        var urlString = ""
        if webtype == "about" {
            self.titleLbl.text = "About Us"
            urlString = Config().WEB_URL + "about_us_app_view"
        }else if webtype == "faq" {
            self.titleLbl.text = "FAQs"
            urlString = Config().WEB_URL + "faq_app_view"
        }else if webtype == "term" {
            self.titleLbl.text = "Terms & Conditions"
            urlString = Config().WEB_URL + "terms_and_condition_app_view"
        }else if webtype == "privacy" {
            self.titleLbl.text = "Privacy Policy"
            urlString = Config().WEB_URL + "privacy_policy_app_view"
        }
        
        indicationView.startAnimating()
        indicationView.isHidden = false
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.contentOffset = CGPoint(x: 0, y: 800)
        webView.scrollView.bounces = false
        if let aString = URL(string: urlString) {
            webView.load(URLRequest(url: aString))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    //MARK: - Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        if isComingFrom == true{
            navigationController?.popViewController(animated: true)
        }else{
            self.slideMenuController()?.toggleLeft()
        }
    }
    //MARK: - Webview Delegates
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
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
