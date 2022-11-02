//
//  SelecteLocationVc.swift
//  DadeSocial
//
//  Created by MAC-27 on 06/04/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class SelecteLocationVc: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,UISearchBarDelegate {
    
    //    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    //MARK:- IBOutlates
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var crossBtn: UIButton!
    //MARK:- Variables
    var locationManager = CLLocationManager()
    var Current_Lat = String()
    var Current_Long = String()
    var user_Id = String()
    var isPresent = Bool()
    var isComeFromProfile = Bool()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.cityTxtField.layer.cornerRadius = 15
//        self.locationBtn.layer.cornerRadius = 15
        self.mainView.layer.cornerRadius = 8
        self.cityTxtField.setLeftPaddingPoints(35)
        self.cityTxtField.delegate = self
        if self.isPresent == true {
            self.crossBtn.isHidden = false
        }else if self.isComeFromProfile == true{
            self.crossBtn.isHidden = false
        }else{
            self.crossBtn.isHidden = true
        }
    }
    //MARK:- LOcation Manager Delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_Lat = ((String(locValue.latitude) ))
        Current_Long = ((String(locValue.longitude) ))
        Config().AppUserDefaults.set(Current_Lat, forKey: "LAT")
        Config().AppUserDefaults.set(Current_Long, forKey: "LONG")
        locationManager.stopUpdatingLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.location!)
                print(placemark.name!)
                print(placemark.locality!)
                print(placemark.subAdministrativeArea)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                let placeName = "\(placemark.locality!),\(placemark.administrativeArea!), \(placemark.country!)"
                print(placeName)
                Config().AppUserDefaults.set(placeName, forKey: "TITLE")
                if self.isComeFromProfile == true{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    Config().AppUserDefaults.set("Yes", forKey: "SetLocation")
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigate = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    navigate.User_ID = self.user_Id
                    let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                    let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
                    slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
                    UIApplication.shared.windows.first?.rootViewController = slideMenuController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    //MARK:- Text Feild Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.cityTxtField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    //MARK:- Cross Button Action
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Current Button Action
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
    }
}

extension SelecteLocationVc: GMSAutocompleteViewControllerDelegate {
    //MARK:- Google Place Delegate
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        let CurrentLat = String(lat)
        let CurrentLong = String(lon)
        Config().AppUserDefaults.set(CurrentLat, forKey: "LAT")
        Config().AppUserDefaults.set(CurrentLong, forKey: "LONG")
        print("lat lon",lat,lon)
        self.cityTxtField.text = place.name
        let titleName = place.formattedAddress ?? ""
        var Street = String()
        var Route = String()
        var city = String()
        var state = String()
        var country = String()
//        let address = place.addressComponents
        print(place.addressComponents ?? "")
        if place.addressComponents != nil {
            for addressComponent in (place.addressComponents)! {
               for type in (addressComponent.types){

                switch(type){
                
                    case "street_number":
                        Street = addressComponent.shortName ?? ""
                    case "route":
                        Route = addressComponent.shortName ?? ""
                    case "locality":
                        city = addressComponent.name
                    case "administrative_area_level_1":
                        state = addressComponent.shortName ?? ""
                    case "country":
                        country = addressComponent.shortName ?? ""
                   default:
                       break
                   }
               }
           }
        }
        var address = String()
        address = city + ", " + state
//        if Street == ""{
//            address = Route+", "+city+", "+state+", "+country
//        }else if Route == ""{
//            address = Street+", "+city+", "+state+", "+country
//        }else if Street == "" || Route == "" {
//            address = city + ", " + state + ", " + country
//        }else{
//            address = Street+", "+Route+", "+city+", "+state+", "+country
//        }
        Config().AppUserDefaults.set(address, forKey: "TITLE")
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
        if self.isComeFromProfile == true{
            self.dismiss(animated: true, completion: nil)
            self.removeSpinner()
        }else{
            Config().AppUserDefaults.set("Yes", forKey: "SetLocation")
            let navigate = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            navigate.User_ID = user_Id
            let leftController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
            let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:navigate), leftMenuViewController: leftController)
            slideMenuController.delegate = leftController as? SlideMenuControllerDelegate
            UIApplication.shared.windows.first?.rootViewController = slideMenuController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            self.removeSpinner()
        }
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
