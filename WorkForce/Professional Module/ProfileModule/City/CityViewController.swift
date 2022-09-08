//
//  CityViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 18/05/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import CoreLocation


class CityViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: ActualGradientButton!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var currentLocationBtn: UIButton!

    var professionalUserDict = SingletonLocalModel()
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        setView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    @IBAction func continueAction(_ sender: ActualGradientButton) {
        validation()
    }
    
    @IBAction func currentLocationBtn(_ sender: UIButton) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    func setView(){
        cityTF.delegate = self
        stateTF.delegate = self
        cityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        stateView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cityView.layer.borderColor = textField == cityTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == cityTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == cityTF){
            cityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }else{
            stateView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
//    MARK: HIT PROFESSIONAL SIGN UP
    func hitProfessionalSignUpApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": authToken]
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
                        if UserType.userTypeInstance.userLogin == .Professional{
                            let vc = TabBarVC()
                            self.pushViewController(vc, true)
                        }else{
                            print("Its city")
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
    
    func signUpParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["first_name"] = self.professionalUserDict.first_name
        parameters["last_name"] =  self.professionalUserDict.last_name
        parameters["catagory_details"] = self.professionalUserDict.catagory_details
        parameters["rate_from"] = self.professionalUserDict.rate_from
        parameters["rate_to"] =  self.professionalUserDict.rate_to
        parameters["rate_type"] = self.professionalUserDict.rate_type
        parameters["job_type"] = self.professionalUserDict.job_type
        parameters["latitude"] = self.professionalUserDict.latitude
        parameters["longitude"] = self.professionalUserDict.longitude
        parameters["city"] = cityTF.text
        parameters["state"] = stateTF.text
        parameters["deviceType"] = "1"
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    //   MARK: VALIDATION
    func validation(){
        if (cityTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select city first.".localized() , okButton: "Ok", controller: self) {
            }
        } else if (stateTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter state." , okButton: "Ok", controller: self) {
            }
        }else{
            if (UserType.userTypeInstance.userLogin == .Bussiness){
                let vc = JobPhotoViewController()
                self.pushViewController(vc,true)
            }else if UserType.userTypeInstance.userLogin == .Professional{
                self.professionalUserDict.city = self.cityTF.text
                self.professionalUserDict.state = self.stateTF.text
                hitProfessionalSignUpApi()
            }else if UserType.userTypeInstance.userLogin == .Coustomer{
                let vc = JobPhotoViewController()
                self.pushViewController(vc,true)
            }
        }
    }
}

extension CityViewController: GMSAutocompleteViewControllerDelegate {
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
                self.cityTF.text =  address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.cityTF.text = ArrayOfString
            }
        }
        dismiss(animated: true, completion: nil)
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
                    print("here is address",line)
                    if address != ""{
                        self.cityTF.text =  address
                    }else{
                        let ArrayOfString =  line.first ?? ""
                        self.cityTF.text = ArrayOfString
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
                            completion("",[""])
                            return
                    }
                    print("addressssss",place)
                    completion(place.locality ?? "", place.lines ?? [])
                }
            }
        }
}
