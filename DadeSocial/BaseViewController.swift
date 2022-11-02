//
//  DashBoardVC.swift
//  Sabjiwala
//
//  Created by Ritesh Jain on 11/06/18.
//  Copyright © 2018 OWeBest.com. All rights reserved.
//

import UIKit
class BaseViewController: UIViewController,UITextFieldDelegate{
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        self.navigationItem.setHidesBackButton(false, animated:true);
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font:Config().AppGlobalFont(18, isBold: true),NSAttributedString.Key.foregroundColor: UIColor.white]
//        UIView.animate(withDuration: 0.7) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
