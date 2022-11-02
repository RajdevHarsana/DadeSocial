//
//  EmbedsViewController.swift
//  Demo Tweet View
//
//  Created by MAC-27 on 13/05/21.
//

import UIKit
import WebKit
import SafariServices

let DefaultCellHeight: CGFloat = 1000
let TweetPadding: CGFloat = 20

let HtmlTemplate = "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body><div id='container'></div></body></html>"

var TweetIds = [String]()


let HeightCallback = "heightCallback"
let ClickCallback = "clickCallback"

class EmbedsViewController: UITableViewController {
    //MARK:- Variables
    let Tweets = TweetsManager.shared
    let WidgetsJs = WidgetsJsManager.shared
    var IdsArray = [String]()
    var type = String()
    var TwitterData = [Any]()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(IdsArray)
        title = "Embeds"
        self.getActivityFeeds()
        // Set up tableview
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WebCell")
    }

        override func viewDidAppear(_ animated: Bool) {
            self.initializeView(TweetIds)
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
                TweetIds = DataManager.getVal(responseData?["ids"]) as? [String] ?? []
                print(TweetIds)
                self.initializeView(TweetIds)
            }else{
                self.view.makeToast(message: message)
            }
//            self.clearAllNotice()
            self.removeSpinner()
        }
    }
    //MARK:- Intialize View Function
    func initializeView(_ tweetIds: [String]) {
        Tweets.initializeWithTweetIds(tweetIds)
        // Load widgets.js globally
        WidgetsJs.load()
        // Preload WebViews before they are rendered
        preloadWebviews()

        tableView.reloadData()
    }
    //MARK:- WebView Management
    // WebView Management
    var arr = [WKWebView]()
    func preloadWebviews() {
        Tweets.all().forEach { tweet in
            tweet.setWebView(createWebView(idx: tweet.idx))
        }
    }
    //MARK:- Create WebView Function
    func createWebView(idx: Int) -> WKWebView {
        let webView = WKWebView()
        // Set delegates
        webView.navigationDelegate = self
        webView.uiDelegate = self
        // Register callbacks
        webView.configuration.userContentController.add(self, name: ClickCallback)
        webView.configuration.userContentController.add(self, name: HeightCallback)
        // Set index as tag
        webView.tag = idx
        // Set initial frame
        webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: CGFloat(DefaultCellHeight))
        // Prevent scrolling
        webView.scrollView.isScrollEnabled = false
        // Load HTML template and set your domain
        webView.loadHTMLString(HtmlTemplate, baseURL: URL(string: "https://your-apps-website.com")!)

        return webView
    }
    //MARK:- TableView Dalegate & Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tweets.count()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath)
        if let tweet = Tweets.getByIdx(indexPath.row), let webView = tweet.webView {
            cell.contentView.addSubview(webView)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tweet = Tweets.getByIdx(indexPath.row) {
            return tweet.height
        }
        return DefaultCellHeight
    }
    // Helpers
    //MARK:- Update Height Function
    func updateHeight(idx: Int, height: String) {
        if let tweet = Tweets.getByIdx(idx) {
            if (tweet.height == DefaultCellHeight) {
                // Store the height to display the UITableViewCell at the correct height
                tweet.setHeight(stringToCGFloat(height) + TweetPadding)

                // Prevent UITableViewCells from jumping around and changing
                //   the scroll position as they resize
                tableView.reloadRowWithoutAnimation(IndexPath(row: idx, section: 0))
            }
        }
    }
    //MARK:- Open Tweet Function
    func openTweet(_ id: String) {
        if let url = URL(string: "https://twitter.com/i/status/\(id)") {
            openInSafarViewController(url)
        }
    }
    //MARK:- Open Tweet In Safari Function
    func openInSafarViewController(_ url: URL) {
        let vc = SFSafariViewController(url: url)
        self.showDetailViewController(vc, sender: self)
    }
    //MARK:- Convert String to CGFloat Function
    func stringToCGFloat (_ s: String) -> CGFloat {
        if let intHeight = Int(s) {
            return CGFloat(integerLiteral: intHeight)
        }
        return DefaultCellHeight
    }

}
//MARK:- WKNavigation Delegates
extension EmbedsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
            openInSafarViewController(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    self.containerHeight.constant = height as! CGFloat
                })
            }

            })
        loadTweetInWebView(webView)
    }
    // Tweet Loader
    func loadTweetInWebView(_ webView: WKWebView) {
        if let widgetsJsScript = WidgetsJs.getScriptContent(), let tweet = Tweets.getByIdx(webView.tag) {
            webView.evaluateJavaScript(widgetsJsScript)
            webView.evaluateJavaScript("twttr.widgets.load();")

            // Documentation:
            // https://developer.twitter.com/en/docs/twitter-for-websites/embedded-tweets/guides/embedded-tweet-javascript-factory-function
            webView.evaluateJavaScript("""
                twttr.widgets.createTweet(
                    '\(tweet.id)',
                    document.getElementById('container'),
                    { align: 'center' }
                ).then(el => {
                    window.webkit.messageHandlers.heightCallback.postMessage(el.offsetHeight.toString())
                });
            """)
//
//            WebView WebSiteView = new WebView();
//            WebSiteView.Source = WebUrl;
//            WebSiteView.EvaluateJavaScriptAsync("document.getElementById('test').style.display = 'none';");
                
        }
    }
}
//MARK:- WKUI Delegate
extension EmbedsViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        // Allow links with target="_blank" to open in SafariViewController
        //   (includes clicks on the background of Embedded Tweets
        if let url = navigationAction.request.url, navigationAction.targetFrame == nil {
            openInSafarViewController(url)
        }
        return nil
    }
}
//MARK:- WKScript Messager Handler Class
extension EmbedsViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case HeightCallback:
            updateHeight(idx: message.webView!.tag, height: message.body as! String)
        default:
            print("Unhandled callback")
        }
    }
}
//MARK:- Cell reload Function
extension UITableView {
    func reloadRowWithoutAnimation(_ indexPath: IndexPath) {
        let lastScrollOffset = contentOffset
        UIView.performWithoutAnimation {
            reloadRows(at: [indexPath], with: .none)
        }
        setContentOffset(lastScrollOffset, animated: false)
    }
}
//MARK:- Tweets Manager Class Fuction
class TweetsManager {
    static let shared = TweetsManager()

    var tweets: [Tweet] = []

    func initializeWithTweetIds(_ tweetIds: [String]) {
        tweets = buildIndexedTweets(tweetIds)
    }

    func count() -> Int {
        return tweets.count
    }

    func all() -> [Tweet] {
        return tweets
    }

    func getByIdx(_ idx: Int) -> Tweet? {
        return tweets.first { $0.idx == idx }
    }

    private func buildIndexedTweets(_ tweetIds: [String]) -> [Tweet] {
        return tweetIds.enumerated().map { (idx, id) in
            return Tweet(id: id, idx: idx)
        }
    }
}
//MARK:- Tweet Class Functions
class Tweet {
    // The Tweet ID
    var id: String

    // An index value we'll use to map Tweets to the WKWebView tag property and the UITableView row
    var idx: Int

    // The height of the WKWebView
    var height: CGFloat

    // The WKWebView we'll use to display the Tweet
    var webView: WKWebView?

    init(id: String, idx: Int) {
        self.id = id
        self.idx = idx
        self.height = DefaultCellHeight
    }

    func setHeight(_ value: CGFloat) {
        height = value
    }

    func setWebView(_ value: WKWebView) {
        webView = value
    }
}
//MARK:- Widgets JsManager
class WidgetsJsManager {
    static let shared = WidgetsJsManager()

    // The contents of https://platform.twitter.com/widgets.js
    var content: String?

    func load() {
        do {
            content = try String(contentsOf: URL(string: "https://platform.twitter.com/widgets.js")!)
        } catch {
            print("Could not load widgets.js script")
        }
    }

    func getScriptContent() -> String? {
        return content
    }
}
