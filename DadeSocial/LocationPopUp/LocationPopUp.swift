//
//  LocationPopUp.swift
//  DadeSocial
//
//  Created by MAC-27 on 04/05/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class LocationPopUp: UIView,CLLocationManagerDelegate,UITextFieldDelegate,UISearchBarDelegate {

    @IBOutlet weak var searchLocationTxt: UITextField!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var buttonLocationHandler : (() -> Void)?
    var buttonCancelHandler : (() -> Void)?
    var locationManager = CLLocationManager()
    var current_Lat = String()
    var Current_Long = String()
    
    class func intitiateFromNib() -> LocationPopUp {
        let View1 = UINib.init(nibName: "LocationPopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! LocationPopUp
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func currentLocationBtnAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            if (CLLocationManager.locationServicesEnabled()) {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            } else {
                print("Location services are not enabled");
            }
        }
        buttonLocationHandler?()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        buttonCancelHandler?()
    }
    
}
