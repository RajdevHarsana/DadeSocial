//
//  AppDelegate.swift
//  DadeSocial
//
//  Created by MAC-27 on 01/04/21.
//

import UIKit
import DeviceCheck
import IQKeyboardManagerSwift
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import Firebase
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var count = Int()


 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 1.0)
        IQKeyboardManager.shared.enable = true
        Config().AppUserDefaults.removeObject(forKey: "Change")
        GMSServices.provideAPIKey("AIzaSyBLUqEH6E-yMc2qgMggXOYxXAM65I7z-aw")
        GMSPlacesClient.provideAPIKey("AIzaSyBLUqEH6E-yMc2qgMggXOYxXAM65I7z-aw")
       
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        
        let currentDevice = DCDevice.current
        if currentDevice.isSupported {
        currentDevice.generateToken(completionHandler: { (data, error) in
            if let tokenData = data {
                print("Token: \(tokenData)")
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        })
        }
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
       
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = self.count
        Messaging.messaging().delegate = self
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // noting
            print(error)
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
             if let error = error {
                print("Error fetching remote instange ID: \(error)")
             } else if let result = result {
                 print("Remote instance ID token: \(result.token)")
                 Config().AppUserDefaults.set(result.token, forKey: "deviceToken")
             }
             Messaging.messaging().apnsToken = deviceToken
             Messaging.messaging().isAutoInitEnabled = true
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Config().AppUserDefaults.set(fcmToken, forKey: "deviceToken")
        print("Firebase registration token: \(fcmToken ?? "")")
    }
    
    func  application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    //MARK:- Click on notification
    
    func registerForPushNotifications() {
           UNUserNotificationCenter.current()
               .requestAuthorization(options: [.alert, .sound, .badge]) {
                   [weak self] granted, error in
                   
                   print("Permission granted: \(granted)")
                   guard granted else { return }
                   self?.getNotificationSettings()
           }
       }
       
       func getNotificationSettings() {
           UNUserNotificationCenter.current().getNotificationSettings { settings in
               print("Notification settings: \(settings)")
               guard settings.authorizationStatus == .authorized else { return }
               DispatchQueue.main.async {
                   UIApplication.shared.registerForRemoteNotifications()
               }
           }
       }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let userInfo = userInfo as! [String: Any]
        print(userInfo)
    }
//    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
//        //Handle the notification
//        completionHandler(
//            [UNNotificationPresentationOptions.alert,
//             UNNotificationPresentationOptions.sound,
//             UNNotificationPresentationOptions.badge])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
//           completionHandler( [.alert, .badge, .sound])
//    }
    //MARK:- Function will call when application in active state
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        let content = UNMutableNotificationContent() // notification content object
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notification.wav"))
        let userInfo = notification.request.content.userInfo as! [String: Any]
        print(userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")
            
        }
        
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
//        if(application.applicationState == .background)
//        {
//            print("user tapped the notification bar when the app is in background")
//            let pushContent = response.notification.request.content
//            let badgeCount = pushContent.badge as! Int
//            UIApplication.shared.applicationIconBadgeNumber = badgeCount
//            application.applicationIconBadgeNumber = badgeCount
//        }
//        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//            return
//        }
        
        print("got active scene")

        // instantiate the view controller from storyboard
        // the selected tab contains navigation controller
        // then we push the new view controller to it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigate = storyboard.instantiateViewController(withIdentifier: "NotifiactionVC") as! NotifiactionVC
        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
        slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
        UIApplication.shared.windows.first?.rootViewController = slideMenuController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        completionHandler()
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
            print("app active")
        application.applicationIconBadgeNumber = self.count
        }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return ApplicationDelegate.shared.application(app,open: (url as URL?)!,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application,open: (url as URL?)!,sourceApplication: sourceApplication,annotation: annotation)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
   

}

