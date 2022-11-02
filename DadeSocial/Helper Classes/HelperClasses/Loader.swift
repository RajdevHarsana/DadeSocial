//
//  Loader.swift
//  CallKitTest
//
//  Created by mac-14 on 30/11/20.
//  Copyright © 2020 mac-16. All rights reserved.
//
import Foundation
import UIKit
import NVActivityIndicatorView

var vSpinner : UIView?
 
extension UIViewController {

    func showSpinner(onView : UIView) {
        
        let myColor : UIColor = UIColor.white
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.06, green: 0.30, blue: 0.46, alpha: 0.4)
        let ai = NVActivityIndicatorView(frame: CGRect(x: screenWidth/2-25, y: screenHeight/2-25, width: 50, height: 50), type: .pacman, color: myColor, padding: 10)
        
        ai.isHidden = false
        
        let VwText = UITextView(frame: CGRect(x: screenWidth/2-50, y: screenHeight/2+10, width: 100, height: 30))
        VwText.text = "Loading..."
        VwText.textColor = myColor
        VwText.textAlignment = .center
        VwText.backgroundColor = .clear
        
        ai.startAnimating()
       
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            spinnerView.addSubview(VwText)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
func showTableSpinner(onView : UIView) {
    
    let myColor : UIColor = UIColor.white
    
    let screenWidth = onView.bounds.width
    let screenHeight = onView.bounds.height
    
    
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor(red: 0.06, green: 0.30, blue: 0.46, alpha: 0.4)
    let ai = NVActivityIndicatorView(frame: CGRect(x: screenWidth/2-25, y: screenHeight/2-25, width: 50, height: 50), type: .pacman, color: myColor, padding: 10)
    
    ai.isHidden = false
    
    let VwText = UITextView(frame: CGRect(x: screenWidth/2-50, y: screenHeight/2+10, width: 100, height: 30))
    VwText.text = "Loading..."
    VwText.textColor = myColor
    VwText.textAlignment = .center
    VwText.backgroundColor = .clear
    
    ai.startAnimating()
   
    DispatchQueue.main.async {
        spinnerView.addSubview(ai)
        spinnerView.addSubview(VwText)
        onView.addSubview(spinnerView)
    }
    vSpinner = spinnerView
}
}
