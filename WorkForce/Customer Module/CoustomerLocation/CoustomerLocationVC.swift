//
//  CoustomerLocationVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 06/08/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import GooglePlaces
import GoogleMaps

class CoustomerLocationVC: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {
    
    
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var continueBtn: ActualGradientButton!
    
//    MARK: VARIABLES
    var professionalUserDict =  SingletonLocalModel()
    var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigureUpdate()
    }

    @IBAction func currentLocationBtn(_ sender: UIButton) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func continueBtn(_ sender: UIButton) {
        hitValidation()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    func uiConfigureUpdate(){
        addressTF.delegate = self
        addressView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addressView.layer.borderWidth = 1.0
        currentLocationView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        currentLocationView.layer.borderWidth = 1.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addressView.layer.borderColor = textField == addressTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == addressTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == addressTF){
            addressView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }else{
            currentLocationView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    
    func hitValidation(){
        if (addressTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_ADDRESS".localized() , okButton: "Ok", controller: self) {
            }
        }else{
            if (UserType.userTypeInstance.userLogin == .Coustomer){
                professionalUserDict.city =  addressTF.text ?? ""
                hitCoustomerSignUpApi()
            }else{
                print("Its JobPhotoController")
            }
        }
    }
    func hitCoustomerSignUpApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers,"headers")
        print(self.professionalUserDict.convertModelToDict(),"Parameter")
        AFWrapperClass.requestPOSTURL(kBASEURL +  WSMethods.addProfessional, params: self.professionalUserDict.convertModelToDict() as! Parameters , headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ProfessionalModel.self, from: data!)
                let status = aContact.status ??  0
                let message = aContact.message ?? ""
                if status == 1{
                    let userID = aContact.data?.user_id ?? ""
                    print("here is user id ======>>>>>>>",userID)
                    UserDefaults.standard.set(userID, forKey: "getUserId")
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: message, okButton: "OK", controller: self) {
                        if UserType.userTypeInstance.userLogin == .Coustomer{
                            let vc = TabBarVC()
                            self.pushViewController(vc, true)
                        }else{
                            print("Its coustomer Module LocationVC")
                        }
                    }
                }else if status == 401{
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.checkLogin()
                }else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }

        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: "", view: self)
        }
    }
    
//    MARK: HIT COUSTOMER SIGNUP API
}
extension CoustomerLocationVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let geoCoder = CLGeocoder()
        let location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        self.lat = "\(Double(place.coordinate.latitude))"
        self.long = "\(Double(place.coordinate.longitude))"
        self.professionalUserDict.latitude = self.lat
        self.professionalUserDict.longitude = self.long
        print("search result",location)
        self.getPlaceAddressFrom(location: location) { address,line  in
            print("here is resultttt",address)
            print("here is address",line)
            if address != ""{
                self.addressTF.text =  address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.addressTF.text = ArrayOfString
            }
        }
        dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Your current location city ====>>>>")
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
                        self.addressTF.text =  address
                    }else{
                        let ArrayOfString =  line.first ?? ""
                        self.addressTF.text = ArrayOfString
                    }
                }

                } else {
                    print("Problem with the data received from geocoder")
                }
            })
            locationManager.stopUpdatingLocation()

    }
    
//    MARK: GET FULL ADDRESS WITH LAT&LONG
    func getPlaceAddressFrom(location: CLLocationCoordinate2D, completion: @escaping (_ address: String , _ line: [String]) -> Void) {
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(location) { response, error in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                } else {
                    guard let places = response?.results(),
                        let place = places.first,
                        let state = place.administrativeArea,
                        let lines = place.lines else {
                            completion("",[""])
                            return
                    }
                    print("addressssss",place)
                    self.professionalUserDict.state = state
                    completion(place.locality ?? "", place.lines ?? [])
                }
            }
        }
}
