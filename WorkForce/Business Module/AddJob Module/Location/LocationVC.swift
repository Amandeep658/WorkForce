//
//  LocationVC.swift
//  WorkForce
//
//  Created by apple on 06/07/22.
//

import UIKit
import GoogleMaps
import MapKit
import CoreMedia
import GooglePlaces
import CoreLocation

class LocationVC: UIViewController,MKLocalSearchCompleterDelegate, UISearchBarDelegate,UITextFieldDelegate, CLLocationManagerDelegate {
    
    //    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var typeAddressSearchBar: UISearchBar!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var currentLocationbtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var mapListTableView: UITableView!
    @IBOutlet weak var typeAddressTF: UITextField!
    
    //    MARK: DECLEARE TYPES
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var longitude = ""
    var latitude = ""
    var professionalUserDict = SingletonLocalModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
    }
    
    func updateUI(){
        typeAddressTF.delegate = self
        addressView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addressView.layer.borderWidth = 1.0
        currentLocationView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        currentLocationView.layer.borderWidth = 1.0
    }
   
    
    //    MARK: TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addressView.layer.borderColor = textField == typeAddressTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == typeAddressTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addressView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //   MARK: VALIDATION
    func validation(){
        if (typeAddressTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_ADDRESS".localized() , okButton: "Ok", controller: self) {
            }
        }else{
            if (UserType.userTypeInstance.userLogin == .Bussiness){
                professionalUserDict.city =  typeAddressTF.text ?? ""
                let vc = JobPhotoViewController()
                vc.professionalUserDict = professionalUserDict
                self.pushViewController(vc,true)
            }else if UserType.userTypeInstance.userLogin == .Coustomer{
                professionalUserDict.location =  typeAddressTF.text ?? ""
                let vc = JobPhotoViewController()
                vc.professionalUserDict = professionalUserDict
                self.pushViewController(vc,true)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func currentLocationbtn(_ sender: UIButton) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        validation()
    }
    
    
}
extension LocationVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let geoCoder = CLGeocoder()
        let location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        self.latitude = "\(Double(place.coordinate.latitude))"
        self.longitude = "\(Double(place.coordinate.longitude))"
        self.professionalUserDict.latitude = latitude
        self.professionalUserDict.longitude = longitude
        print("search result",location)
        self.getPlaceAddressFrom(location: location) { address,line  in
            print("here is resultttt",address)
            if address != ""{
                self.typeAddressTF.text =  address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.typeAddressTF.text = ArrayOfString
            }
        }
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("l';l;l")
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }

            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                let location = locations.last! as CLLocation
                let latStr = location.coordinate.latitude
                print("here is lat ====>>>>",latStr)
                let longStr = location.coordinate.longitude
                print("here is long =====>>>>",longStr)
                let currentlocation = CLLocationCoordinate2D(latitude: latStr, longitude: longStr)
                print("search result",currentlocation)
                self.professionalUserDict.latitude = "\(Double(latStr))"
                self.professionalUserDict.longitude = "\(Double(longStr))"
                self.getPlaceAddressFrom(location: currentlocation) { address,line  in
                    print("here is resultttt",address)
                    if address != ""{
                        self.typeAddressTF.text =  address
                    }else{
                        let ArrayOfString =  line.first ?? ""
                        self.typeAddressTF.text = ArrayOfString
                    }
                }

                } else {
                    print("Problem with the data received from geocoder")
                }
            })
            locationManager.stopUpdatingLocation()
    }
    
    func getPlaceAddressFrom(location: CLLocationCoordinate2D, completion: @escaping (_ address: String , _ line: [String]) -> Void) {
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(location) { response, error in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                } else {
                    guard let places = response?.results(),
                        let place = places.first,
                        let lines = place.lines else {
                        completion("", [""])
                            return
                    }
                    print("addressssss",place)
                    completion(place.locality ?? "", place.lines ?? [])
                }
            }
        }
}
