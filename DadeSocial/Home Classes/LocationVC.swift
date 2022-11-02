//
//  LocationVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 14/05/21.
//

import UIKit
import MapKit
import GoogleMaps

class LocationVC: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLbl: UILabel!
    private let locationManager = CLLocationManager()
    //MARK:- Variables
    var loc : CLLocationCoordinate2D?
    var driverMarker: GMSMarker?
    var str_lat:String!
    var str_long:String!
    var lat = Double()
    var long = Double()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var city:String!
    var state:String!
    var country:String!
    var zipcode:String!
    var myMarker : GMSMarker?
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let Latitude = Double(self.str_lat)
        let Longitude = Double(self.str_long)
        self.myMarker = GMSMarker()
        self.myMarker?.position = CLLocationCoordinate2DMake(Latitude!, Longitude!)
        
        self.myMarker?.icon = UIImage(named: "test2")
        self.myMarker?.map = self.mapView
        self.myMarker?.title = "Tutor"
        self.myMarker?.snippet = "Location"
        self.myMarker?.isDraggable = true
        self.mapView.settings.consumesGesturesInView = false
        let BigMapupdatedCamera = GMSCameraUpdate.setTarget((self.myMarker?.position)!, zoom: 14.0)
        self.mapView.animate(with: BigMapupdatedCamera)
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            mapView.delegate = self
        }
    }
}
//    //MARK:- Location Manager Delegates
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        loc = locValue
//        let Latitude = Double(self.str_lat)
//        let Longitude = Double(self.str_long)
//        self.myMarker = GMSMarker()
//        self.myMarker?.position = CLLocationCoordinate2DMake(Latitude!, Longitude!)
//
//        self.myMarker?.icon = UIImage(named: "test2")
//        self.myMarker?.map = self.mapView
//        self.myMarker?.title = "Tutor"
//        self.myMarker?.snippet = "Location"
//        self.myMarker?.isDraggable = true
//        self.mapView.settings.consumesGesturesInView = false
//        let BigMapupdatedCamera = GMSCameraUpdate.setTarget((self.myMarker?.position)!, zoom: 14.0)
//        self.mapView.animate(with: BigMapupdatedCamera)
//
//        locationManager.stopUpdatingLocation()
//        locationManager.delegate = nil
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
//        print("Error \(error)")
//    }
//    //MARK:- Back Button Action
//    @IBAction func backBtnAction(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//extension LocationVC : GMSMapViewDelegate{
//    //MARK:- Google Map Delegates
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        //        self.myMarker?.position = position.target
//        //        if self.myMarker?.position == nil{
//        //            self.lat = Config().AppUserDefaults.value(forKey: "latti") as! Double
//        //            self.long = Config().AppUserDefaults.value(forKey: "latti") as! Double
//        //        }else{
//        //            self.lat = (self.myMarker?.position.latitude)!
//        //            self.long = (self.myMarker?.position.longitude)!
//        //            Config().AppUserDefaults.setValue(self.lat, forKey: "latti")
//        //            Config().AppUserDefaults.setValue(self.long, forKey: "longi")
//        //        }
//        let Latitude = Double(self.str_lat)
//        let Longitude = Double(self.str_long)
//        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
//        aGMSGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(Latitude!, Longitude!), completionHandler: { gmsReverseGeocodeResponse,error in
//            let gmsAddress = gmsReverseGeocodeResponse?.firstResult()
//            let lines = gmsAddress?.lines
//            let city = gmsAddress?.locality ?? ""
//            let state = gmsAddress?.administrativeArea ?? ""
//            let country = gmsAddress?.country ?? ""
//            let zipeCode = gmsAddress?.postalCode ?? ""
//            print("Response is = \(String(describing: gmsAddress))")
//            print("Response is = \(String(describing: lines))")
//            print("Response is = \(city)")
//            print("Response is = \(state)")
//            print("Response is = \(country)")
//            print("Response is = \(zipeCode)")
//
//            self.addressLbl.text = lines?.joined(separator: "\n")
//            self.city = city
//            self.state = state
//            self.country = country
//            self.zipcode = zipeCode
//
//        })
//
//        self.myMarker?.title = self.addressLbl.text
//        self.myMarker?.map = self.mapView
//    }
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        self.mapView.isMyLocationEnabled = true
//
//        if (gesture) {
//            self.mapView.selectedMarker = nil
//        }
//
//    }
//}
