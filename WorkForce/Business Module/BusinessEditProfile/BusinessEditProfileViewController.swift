//
//  BusinessEditProfileViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 19/05/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

var companyDataUpdate: (()->())?

class BusinessEditProfileViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate, ImagePickerDelegate,CLLocationManagerDelegate{
    
    func didSelect(image: UIImage?) {
        if image == nil{
            self.selectedImage = UIImage(named: "placeholder")
        }else{
            self.selectedImage = image
        }
    }
    
    var imagePicker : ImagePicker?
    var companyEditDataArr:CompanyListingModel?
    var company : Bool?
    var imgArray = [Data]()
    var imageData = Data()
    var latitude = ""
    var longitute = ""
    var selectedImage: UIImage? {
        didSet {
            nikeImg.image = selectedImage
        }
    }
    
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyTF: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var nikeImg: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nikeImg.layer.cornerRadius = nikeImg.frame.height/2
        setView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func editProfileBtn(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    
    //    MARK: BUSINESS EDIT FUNCTIONS
    func setView(){
        descriptionTV.delegate = self
        addressTF.delegate = self
        companyTF.delegate = self
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        companyView.layer.borderColor = UIColor.gray.cgColor
        addressView.layer.borderColor = UIColor.gray.cgColor
        companyTF.text = companyEditDataArr?.data?.company_name ?? ""
        addressTF.text = companyEditDataArr?.data?.location ?? ""
        descriptionTV.text = companyEditDataArr?.data?.description ?? ""
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        var sPhotoStr = companyEditDataArr?.data?.photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.nikeImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
    }
    
    //    MARK: TEXT FIELD DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        companyView.layer.borderColor = textField == companyTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addressView.layer.borderColor = textField == addressTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == addressTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        companyView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addressView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == descriptionTV){
            descriptionView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == descriptionTV){
            descriptionView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    func validation(){
        if (companyTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter company name." , okButton: "Ok", controller: self) {
            }
        }
        else if addressTF.text!.trimWhiteSpace.isEmpty{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter address." , okButton: "Ok", controller: self) {
            }
        }
        else if (descriptionTV.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter description." , okButton: "Ok", controller: self) {
            }
        }else{
            self.hitAddCompanyApi()
        }
    }
    
    func hitAddCompanyApi() {
        let compressedData = (nikeImg.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        let params = ["company_name":companyTF.text ?? "" ,"address":addressTF.text ?? "","description":descriptionTV.text ?? ""] as [String : Any]
        let strURL = kBASEURL + WSMethods.addCompany
        self.requestWith(endUrl: strURL , parameters: params)
    }
    
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl /* your API url */
        let AToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": AToken]
        print(headers)
        DispatchQueue.main.async {
            
            AFWrapperClass.svprogressHudShow(title: "Loading", view:self)
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
                UserDefaults.standard.set(photo, forKey: "BusinessProfileImage")
                print(status)
                if status == 1{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: respDict["message"] as? String ?? "" , okButton: "OK", controller: self) {
                        companyDataUpdate?()
                        if let tabBar = self.tabBarController as? TabBarVC {
                            print("tab bar is \(tabBar)")
                            tabBar.updateProfileImage()
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                }
            }
        }
    }
    
}
extension BusinessEditProfileViewController : GMSAutocompleteViewControllerDelegate{
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
                self.addressTF.text =  address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.addressTF.text = ArrayOfString
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

