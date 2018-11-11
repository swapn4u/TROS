//
//  MapViewController.swift
//  TROS
//
//  Created by Swapnil Katkar on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class MapViewController: UIViewController {
    //variables and Constance
    var selectedLocation : CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var isFromMenuSelection = false

    //Outlet Connections
    @IBOutlet weak var mapViewPresenter: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewPresenter.delegate = self
        setUpMyLocation()
        setRootVC("MapViewController")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Choose Your Location", isBackBtnVisible: false, accessToOpenSlider: isFromMenuSelection ? true :false, leftBarOptionToShow: .search)
        
    }
    func setUpMyLocation()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapViewPresenter.isMyLocationEnabled = true
        mapViewPresenter.settings.myLocationButton = true
        mapViewPresenter.mapType = .normal
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locationManager.location
        }
        //Your map initiation code
        self.mapViewPresenter.isMyLocationEnabled = true
        self.mapViewPresenter.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }

    @IBAction func UseloactionAndProceedPressed(_ sender: UIButton)
    {
       let verifyUserVC =  self.loadViewController(identifier: "UserVerificationVC") as! UserVerificationVC
        locationManager.stopUpdatingLocation()
        let cordinates = locationManager.location?.coordinate
        saveRecord(value: "\(cordinates?.latitude ?? 0.0)", forKey:"lat" )
        saveRecord(value:"\(cordinates?.longitude ?? 0.0)" , forKey: "long")
       self.navigationController?.pushViewController(verifyUserVC, animated: true)
    }
}
//Fetch Current Location
extension MapViewController : CLLocationManagerDelegate,GMSMapViewDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        drawLocationOnMap(cordinates: (self.locationManager.location?.coordinate)!)
            self.locationManager.stopUpdatingLocation()
    }
    func drawLocationOnMap(cordinates:CLLocationCoordinate2D)
    {
        DispatchQueue.main.async {
            self.mapViewPresenter.clear()
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withTarget:(cordinates), zoom: 14)
            self.mapViewPresenter.camera = camera
            self.locationManager.delegate = self
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(self.locationManager.location!) { (placemark, error) in
                if let placeInfo = placemark?.last
                {
                    print(placeInfo)
                    if let place = placeInfo as? CLPlacemark
                    {
                        let places = "\(place)".split(separator: "@").first
                        print(places!)
                         let address = "\(placeInfo.locality ?? "")*\(placeInfo.subLocality ?? ""),*\(""),*\(placeInfo.postalCode ?? ""),*\(placeInfo.administrativeArea ?? "")"
                        self.saveRecord(value: address, forKey: "currentLocation")
                        self.showMarker(position: camera.target, address: String(places!))
                    }
                }
            }
        }
    }
    //OPEN details of selected pub on map
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        let VerifylVC = self.loadViewController(identifier: "VerifyViewController") as! VerifyViewController
        locationManager.stopUpdatingLocation()
        self.navigationController?.pushViewController(VerifylVC, animated: true)
    }
}
//Other Functions
extension MapViewController
{
    func showMarker(position: CLLocationCoordinate2D,address:String)
{
    let marker = GMSMarker()
    marker.position = position
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageView.contentMode = .scaleAspectFit
    imageView.image = #imageLiteral(resourceName: "redPin")
    marker.iconView = imageView
    marker.snippet = address
    saveRecord(value: address, forKey: "address")
    marker.map = mapViewPresenter
}
    @objc func searchButtonPressed()
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}
//Google Autocompletion handler
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        DispatchQueue.main.async {
            self.mapViewPresenter.clear()
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withTarget:(place.coordinate), zoom: 18)
            self.mapViewPresenter.camera = camera
            self.locationManager.delegate = self
           self.showMarker(position: camera.target, address:place.formattedAddress! )
        }
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
