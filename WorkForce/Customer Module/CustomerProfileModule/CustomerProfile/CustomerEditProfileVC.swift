//
//  CustomerEditProfileVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 09/08/22.
//

import UIKit
import Alamofire
import SDWebImage
import GoogleMaps
import GooglePlaces

var customDataUpdate: (()->())?
class CustomerEditProfileVC: UIViewController,UITextFieldDelegate, ImagePickerDelegate,CLLocationManagerDelegate {
    func videoSelect(thumbnail: UIImage?, videoData: Data?) {
        
    }
    
    func didSelect(image: UIImage?,videoData: Data?) {
        if image == nil{
            self.selectedImage = UIImage(named: "placeholder")
        }else{
            self.selectedImage = image
        }
    }
    
    //    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var dateOfBirthView: UIView!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var usercurrentLocationView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var customerUploadBtn: UIButton!
    @IBOutlet weak var editImgView: UIImageView!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var headerlbl: UILabel!
    
    let datePicker = UIDatePicker()
    var imagePicker : ImagePicker?
    var imgArray = [Data]()
    var imageData = Data()
    var latitude = ""
    var longitute = ""
    var selectedImage: UIImage? {
        didSet {
            profileImgView.image = selectedImage
        }
    }
    var customerPDate:CompanyListingModel?
    let locationManager = CLLocationManager()
    var editState = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerlbl.text = "Profile".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiConfigureUpdate()
        editHideUiUpdate()
        //        createDatePicker()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    
    func uiConfigureUpdate(){
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        dobTF.delegate = self
        locationTF.delegate = self
        dateOfBirthView.layer.borderWidth = 1.5
        dateOfBirthView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        firstNameView.layer.borderWidth = 1.5
        firstNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderWidth = 1.5
        lastNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dateOfBirthView.layer.borderWidth = 1.5
        dateOfBirthView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        locationView.layer.borderWidth = 1.5
        locationView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        usercurrentLocationView.layer.borderWidth = 1.5
        usercurrentLocationView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.width / 2
        self.profileImgView.clipsToBounds = true
        self.firstNameTF.text = customerPDate?.data?.first_name ?? ""
        self.lastNameTF.text = customerPDate?.data?.last_name ?? ""
        self.locationTF.text = customerPDate?.data?.city ?? ""
        var sPhotoStr = customerPDate?.data?.photo ?? ""
        UserDefaults.standard.set(sPhotoStr, forKey: "CoustomerProfileImage")
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.profileImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))

    }
    
    
    
    @IBAction func customerUploadBtn(_ sender: UIButton) {
        imagePicker?.present(from: sender)
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        editUnHideUiUpdate()
    }
    
    @IBAction func currentLocationBtn(_ sender: UIButton) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    //    MARK: HIT CUSTOMER EDIT PROFILE API
    func hitCustomerEditProfileAPI() {
        let compressedData = (profileImgView.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        let params = ["first_name":firstNameTF.text ?? "" ,"last_name": lastNameTF.text ?? "","city":locationTF.text ?? "","state":editState] as [String : Any]
        let strURL = kBASEURL + WSMethods.editCustomer
        self.requestWith(endUrl: strURL , parameters: params)
    }
    
//    MARK: MULTIPART FORM DATA API
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl
        let AToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": AToken]
        print(headers)
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view:self)
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
            }
            for i in 0..<self.imgArray.count{
                let imageData1 = self.imgArray[i]
                debugPrint("mime type is\(imageData1.mimeType)")
                let ranStr = String(7)
                if imageData1.mimeType == "application/pdf" ||
                    imageData1.mimeType == "application/vnd" ||
                    imageData1.mimeType == "text/plain"{
                    multipartFormData.append(imageData1, withName: "photo[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".pdf", mimeType: imageData1.mimeType)
                }else{
                    multipartFormData.append(imageData1, withName: "photo" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
                }
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: .default)
        
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
            
        })
        .responseJSON { [self] (response) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
            print("Image succesfully uploaded\(response)")
            let respDict =  response.value as? [String : AnyObject] ?? [:]
            if respDict.count != 0{
                let status = respDict["status"] as? Int ?? 0
                let data = respDict["data"] as? [String:Any] ?? [:]
                let photo = data["photo"] as? String ?? ""
                UserDefaults.standard.set(photo, forKey: "CoustomerProfileImage")
                print(status)
                if status == 1{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Profile updated successfully." , okButton: "OK", controller: self) {
                        customDataUpdate?()
                        if let tabBar = self.tabBarController as? TabBarVC {
                            print("tab bar is \(tabBar)")
                            tabBar.updateProfileImage()
                        }
                        self.editHideUiUpdate()
                        self.editBtn.isHidden = false
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                }
            }
        }
    }
    
    
    //    MARK: HIDE UIUPDATE
    func editHideUiUpdate(){
        self.editBtn.isHidden = false
        self.customerUploadBtn.isHidden = true
        self.btnSave.isHidden = true
        self.orLbl.isHidden = true
        self.editImgView.isHidden = true
        self.usercurrentLocationView.isHidden = true
        self.firstNameTF.isUserInteractionEnabled =  false
        self.lastNameTF.isUserInteractionEnabled =  false
        self.dobTF.isUserInteractionEnabled =  false
        self.locationTF.isUserInteractionEnabled =  false
    }
    
    //    MARK: UN HIDE UIUPDATE
    func editUnHideUiUpdate(){
        self.headerlbl.text = "Edit Profile".localized()
        self.customerUploadBtn.isHidden = false
        self.btnSave.isHidden = false
        self.orLbl.isHidden = false
        self.editImgView.isHidden = false
        self.editBtn.isHidden = true
        self.usercurrentLocationView.isHidden = false
        self.firstNameTF.isUserInteractionEnabled =  true
        self.lastNameTF.isUserInteractionEnabled =  true
        self.dobTF.isUserInteractionEnabled =  true
        self.locationTF.isUserInteractionEnabled =  true
    }
    
    //    MARK: VALIDATIONS
    func validation(){
        if (firstNameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_FIRST_NAME".localized() , okButton: "Ok", controller: self) {
            }
        }
        else if (lastNameTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_LAST_NAME".localized() , okButton: "Ok", controller: self) {
            }
        }
        else if locationTF.text!.trimWhiteSpace.isEmpty{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter location.".localized() , okButton: "Ok", controller: self) {
            }
        }else{
            hitCustomerEditProfileAPI()
            
        }
    }
    
    //    MARK: TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = textField == firstNameTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = textField == lastNameTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dateOfBirthView.layer.borderColor = textField == dobTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        locationView.layer.borderColor = textField == locationTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == locationTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dateOfBirthView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        locationView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension CustomerEditProfileVC : GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let geoCoder = CLGeocoder()
        let location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        self.latitude = "\(Double(place.coordinate.latitude))"
        print(latitude)
        self.longitute = "\(Double(place.coordinate.longitude))"
        print(longitute)
        print("search result",location)
        self.getPlaceAddressFrom(location: location) { address,line   in
            print("here is resultttt",address)
            print("here is address",line)
            if address != ""{
                self.locationTF.text =  address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.locationTF.text = ArrayOfString
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
                    completion("", [""])
                    return
                }
                print("addressssss",place)
                self.editState = state
                completion(place.locality ?? "", place.lines ?? [])
            }
        }
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
                self.getPlaceAddressFrom(location: currentlocation) { address,line  in
                    print("here is resultttt",address)
                    print("here is address",line)
                    if address != ""{
                        self.locationTF.text =  address
                    }else{
                        let ArrayOfString =  line.first ?? ""
                        self.locationTF.text = ArrayOfString
                        }
                    }
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        locationManager.stopUpdatingLocation()
    }
    
}
