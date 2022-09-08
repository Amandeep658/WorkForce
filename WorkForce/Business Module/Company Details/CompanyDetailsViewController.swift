//
//  CompanyDetailsViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 17/05/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

class CompanyDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ImagePickerDelegate,CLLocationManagerDelegate{
    
    func didSelect(image: UIImage?) {
        if image == nil{
            self.selectedImage = UIImage(named: "placeholder")
        }else{
            self.selectedImage = image
        }
    }
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var compantTF: UITextField!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var nikeImg: UIImageView!
    @IBOutlet weak var imageUploadBtn: UIButton!
    
    var imagePicker : ImagePicker?
    var comapnyData:CompanyModel?
    var companyArr = [CompanyData]()
    var imgArray = [Data]()
    var imageData = Data()
    var latitude = ""
    var longitute = ""
    var selectedImage: UIImage? {
        didSet {
            nikeImg.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        setView()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func imageUploadBtn(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: VerifyNumberViewController.self)
//        self.popViewController(true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        validation()
    }
    
    //    MARK: UI UPDATE
    func setView(){
        self.descriptionTV.delegate = self
        self.addressTF.delegate = self
        self.compantTF.delegate = self
        self.companyView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.addressView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.descriptionView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        nikeImg.layer.cornerRadius = nikeImg.frame.height/2
        nikeImg.clipsToBounds = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
     }
    
    
    //    MARK: TEXTFIELD DELEGATES FUNCTIONS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        companyView.layer.borderColor = textField == compantTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
            descriptionView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    //    MARK: IMAGE FORMATE
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    //    MARK: VALIDATIONS
    func validation(){
        if (compantTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter company name.".localized() , okButton: "Ok", controller: self) {
            }
        }
        else if (addressTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_ADDRESS".localized() , okButton: "Ok", controller: self) {
            }
        }
        
        else if (descriptionTV.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter description.".localized() , okButton: "Ok", controller: self) {
            }
        }
        else{
            hitAddCompanyApi()
        }
    }
    
    //    MARK: HIT COMPANY DETAIL API
    
    func hitAddCompanyApi() {
        let compressedData = (nikeImg.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        let params = ["company_name":compantTF.text ?? "" ,"latitude":latitude,"longitude":longitute,"address":addressTF.text ?? "","description":descriptionTV.text ?? ""] as [String : Any]
        let strURL = kBASEURL + WSMethods.addCompany
        self.requestWith(endUrl: strURL , parameters: params)
        print(params)
    }
    
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl /* your API url */
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
            print("Image succesfully uploaded  ****  \(response)")
            print(response)
            let respDict =  response.value as? [String : AnyObject] ?? [:]
            print(respDict)
            if respDict.count != 0 {
                let status = respDict["status"] as? Int ?? 0
                print(status)
                let data = respDict["data"] as? [String:Any] ?? [:]
                let jobIDD = data["location"] as? String ?? ""
                let photo = respDict["photo"] as? String ?? ""
                UserDefaults.standard.set(photo, forKey: "BusinessProfileImage")
                if let data = self.imgArray.first, let image = UIImage(data: data) {
                    print("set image at url \(photo)")
                    SDImageCache.shared().store(image, forKey: photo)
                }
                
                UserDefaults.standard.set(jobIDD, forKey: "getCityName")
                if status == 1{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: respDict["message"] as? String ?? "" , okButton: "OK", controller: self) {
                        AppDefaults.checkLogin
                        if let tabBar = self.tabBarController as? TabBarVC {
                            print("tab bar is \(tabBar)")
                            tabBar.updateProfileImage()
                        }
                        if UserType.userTypeInstance.userLogin == .Bussiness{
                            let vc = TabBarVC()
                            self.pushViewController(vc, true)
                        }
                    }
                }else if status == 401{
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                }else{
                }
            }
        }
    }
}

extension CompanyDetailsViewController : GMSAutocompleteViewControllerDelegate{
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

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
