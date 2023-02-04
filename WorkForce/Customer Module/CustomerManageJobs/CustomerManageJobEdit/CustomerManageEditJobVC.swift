//
//  CustomerManageEditJobVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 22/08/22.
//

import UIKit
import Alamofire
import SDWebImage
import MapKit
import CoreMedia
import GooglePlaces
import GoogleMaps

class CustomerManageEditJobVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, ImagePickerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    func videoSelect(thumbnail: UIImage?,videoData: Data?) {
        
    }
    
    func didSelect(image: UIImage?,videoData: Data?) {
        self.selectedImage = image
    }

//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var jobeditImgView: UIImageView!
    @IBOutlet weak var editJobBtn: UIButton!
    @IBOutlet weak var categorylbl1: UILabel!
    @IBOutlet weak var categoryLbl2: UILabel!
    @IBOutlet weak var jobTypeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var localityTF: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var jobTypeView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var localityView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    
    var imagePicker : ImagePicker?
    var isRateType = ""
    var yearListArr = UIPickerView()
    var doneTool = UIToolbar()
    var imgArray = [Data]()
    var imageData = Data()
    var isselect:Bool = Bool()
    var jobTypePicker = UIPickerView()
    var jobDone = UIToolbar()
    var jobType = ["Full Time".localized(), "Part Time".localized(), "Contract".localized(), "Freelance".localized(),"Remote".localized()]
    let yearArr = ["0 Year","1 Year","1.5 Years","2 Years","2.5 Years","3 Years","3.5 Years"]
    let onlyYearValues = ["0","1","1.5","2","2.5","3","3.5"]
    var currentIndex = Int()
    var selectedID = String()
    var hasExperinceValue : Bool = false
    var jobID = ""
    var jobDetailByJobdict:JobDetailByJobIdModel?
    var professionalEditUserDict = SingletonLocalModel()
    
    var selectedImage: UIImage? {
        didSet {
            jobeditImgView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateEditManageUI()
        self.uiUpdate()
  }

    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }

    @IBAction func editJobBtnProfile(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @IBAction func addCategoryBtn(_ sender: UIButton) {
        let vc = SkillTableViewController()
        vc.skillUserId =  jobDetailByJobdict?.data?.user_id ?? ""
        vc.professionalUserDict.catagory_details = jobDetailByJobdict?.data?.catagory_details as? [CategoryData]
        vc.categoryListDelegate = self
        vc.iSExperince = false
        vc.isModalInPresentation = true
        self.present(vc, true)
    
    }
    
    @IBAction func jobTypeBtn(_ sender: UIButton) {
        jobDone.removeFromSuperview()
        jobTypePicker.removeFromSuperview()
        self.jobTypeView.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        self.jobTypePicker.delegate = self
        self.jobTypePicker.dataSource = self
        self.jobTypePicker.backgroundColor = UIColor.white
        self.jobTypePicker.autoresizingMask = .flexibleWidth
        self.jobTypePicker.contentMode = .center
        self.jobTypePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(jobTypePicker)
        self.jobDone = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        self.jobDone.barStyle = .default
        self.jobDone.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(jobDone)
    }
    
    @objc func onDoneButtonTapped() {
        jobDone.removeFromSuperview()
        jobTypePicker.removeFromSuperview()
        self.jobTypeView.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        validation()
    }
    
    //    MARK: PICKER VIEW DELEGATE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == jobTypePicker{
            return jobType.count
        }else{
            return yearArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == jobTypePicker{
            self.view.endEditing(true)
            return jobType[row]
        }else{
            self.view.endEditing(true)
            return yearArr[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == jobTypePicker{
            self.jobTypeTF.text = self.jobType[row]
        }else {
            selectedID = onlyYearValues[row]
        }
    }
    
    
    //    MARK: UI UPDATES
    func uiUpdate(){
        jobTypeTF.delegate = self
        cityTF.delegate = self
        localityTF.delegate = self
        descriptionTxtView.delegate = self
        jobTypeView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        localityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        descriptionView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        categoryView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        jobeditImgView.layer.cornerRadius = jobeditImgView.frame.height/2
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func updateEditManageUI(){
        self.jobTypeTF.text = jobDetailByJobdict?.data?.job_type ?? ""
        self.cityTF.text = jobDetailByJobdict?.data?.location ?? ""
        self.descriptionTxtView.text = jobDetailByJobdict?.data?.description ?? ""
        self.categorylbl1.text =  jobDetailByJobdict?.data?.catagory_details?.first?.category_name ?? ""
        if jobDetailByJobdict?.data?.catagory_details?.count ?? 0 > 1 {
            self.categoryLbl2.text = jobDetailByJobdict?.data?.catagory_details?.last?.category_name ?? ""
        }else{
            self.categoryLbl2.text = ""
        }
     
        var sPhotoStr = jobDetailByJobdict?.data?.job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.jobeditImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
    }
    
    
//    MARK: UPDATE DATA IN DICT
    func updateDict(){
        self.professionalEditUserDict.customer_job_id =  jobID
        self.professionalEditUserDict.userId =  UserDefaults.standard.string(forKey: "uID")
        self.professionalEditUserDict.rate_type =  isRateType
        self.professionalEditUserDict.job_type = jobTypeTF.text
        self.professionalEditUserDict.location = cityTF.text
        self.professionalEditUserDict.state = localityTF.text
        self.professionalEditUserDict.description  = descriptionTxtView.text
        self.professionalEditUserDict.catagory_details = self.jobDetailByJobdict?.data?.catagory_details
    }
    
//    MARK: VALIDATIONS
    func validation(){
        if (categorylbl1.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select category first.".localized() , okButton: "Ok", controller: self) {
            }
        }else if (jobTypeTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select job type.".localized() , okButton: "Ok", controller: self) {
            }
        }else if (cityTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select city first.".localized() , okButton: "Ok", controller: self) {
            }
        }else if (descriptionTxtView.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter description.".localized() , okButton: "Ok", controller: self) {
            }
        }
        else{
            self.updateDict()
            self.hitProfessionalApi()
        }
    }

    
    //    MARK: TEXT FIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        jobTypeView.layer.borderColor = textField == jobTypeTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityView.layer.borderColor = textField == cityTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        localityView.layer.borderColor = textField == localityTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == cityTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == self.jobTypeTF{
            if textField.text == ""{
                textField.text = self.jobType.first
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        jobTypeView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        localityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        descriptionView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        categoryView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: PROFESSIONAL EDIT API's
    func hitProfessionalApi() {
        let compressedData = (jobeditImgView.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        
        let strURL = kBASEURL + WSMethods.editCustomerJob
        self.requestWith(endUrl: strURL , parameters: self.professionalEditUserDict.convertModelToDict() as! Parameters )
        print(strURL)
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
                if key as! String == "catagory_details"{
                    let catagoryArray = value as! [[String:Any]]
                    for i in 0..<catagoryArray.count{
                        multipartFormData.append("\(catagoryArray[i]["experience"] ?? "")".data(using: String.Encoding.utf8)!, withName: "catagory_details[\(i)][experience]" )
                        multipartFormData.append("\(catagoryArray[i]["cat_id"] ?? "")".data(using: String.Encoding.utf8)!, withName: "catagory_details[\(i)][cat_id]" )
                    }
                }
                else{
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                }
            }
            for i in 0..<self.imgArray.count{
                let imageData1 = self.imgArray[i]
                debugPrint("mime type is\(imageData1.mimeType)")
                let ranStr = String(7)
                if imageData1.mimeType == "application/pdf" ||
                    imageData1.mimeType == "application/vnd" ||
                    imageData1.mimeType == "text/plain"{
                    multipartFormData.append(imageData1, withName: "job_image[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".pdf", mimeType: imageData1.mimeType)
                }else{
                    multipartFormData.append(imageData1, withName: "job_image" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
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
                print(status)
                if status == 1{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: respDict["message"] as? String ?? "" , okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                }
            }
        }
    }
    
    
}
extension CustomerManageEditJobVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobDetailByJobdict?.data?.catagory_details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableViewCell", for: indexPath) as! ExperienceTableViewCell
        cell.designLbl.text = jobDetailByJobdict?.data?.catagory_details![indexPath.row].category_name ?? ""
        self.hasExperinceValue = true
        if jobDetailByJobdict?.data?.catagory_details?[indexPath.row].experience != nil{
            let exp0 = Double(jobDetailByJobdict?.data?.catagory_details![indexPath.row].experience ?? "0") ?? 0.0
            cell.experienceLbl.text = "\(jobDetailByJobdict?.data?.catagory_details![indexPath.row].experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
        }else{
            cell.experienceLbl.text = "0 Year".localized()
        }
        cell.dropDownBtn.tag = indexPath.row
        cell.dropDownBtn.addTarget(self, action: #selector(drpdwnAction), for: .touchUpInside)
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(dltRowBtn), for: .touchUpInside)
        return cell
    }
    
    @objc func dltRowBtn(sender : UIButton){
        self.jobDetailByJobdict?.data?.catagory_details?.remove(at: sender.tag)
        self.UserDidSelectList(data: jobDetailByJobdict?.data?.catagory_details ?? [])
        self.updateEditManageUI()
    }
    
    @objc func drpdwnAction(sender : UIButton) {
        self.currentIndex = sender.tag
        self.doneTool.removeFromSuperview()
        self.yearListArr.removeFromSuperview()
        self.yearListArr.delegate = self
        self.yearListArr.dataSource = self
        self.yearListArr.backgroundColor = UIColor.white
        self.yearListArr.autoresizingMask = .flexibleWidth
        self.yearListArr.contentMode = .center
        self.yearListArr.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(yearListArr)
        self.doneTool = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        self.doneTool.barStyle = .default
        self.doneTool.items = [UIBarButtonItem.init(title: "Done".localized(), style: .done, target: self, action: #selector(doneButtonTapped))]
        self.view.addSubview(doneTool)
    }
    @objc func doneButtonTapped(){
        self.jobDetailByJobdict?.data?.catagory_details?[self.currentIndex].experience = selectedID
        doneTool.removeFromSuperview()
        yearListArr.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension CustomerManageEditJobVC : ListSelectionDelegate{
    func UserDidSelectList(data: [CategoryData]) {
        if data.count > 0{
            self.categorylbl1.text = data.first?.category_name ?? ""
            if data.count > 1{
                self.categoryLbl2.text = data.last?.category_name ?? ""
            }
        }
        self.jobDetailByJobdict?.data?.catagory_details = data
//        self.professionalEditUserDict.catagory_details = data
        self.uiUpdate()
    }
}
extension CustomerManageEditJobVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let geoCoder = CLGeocoder()
        let location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        print("search result",location)
        self.getPlaceAddressFrom(location: location) { [self] address ,line  in
            print("here is resultttt",address)
            if address != ""{
                self.cityTF.text = address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.cityTF.text = ArrayOfString
            }
            self.professionalEditUserDict.city = cityTF.text ?? ""
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
                    completion("",[""])
                    return
                }
                print("addressssss",place)
                completion(place.locality ?? "", place.lines ?? [])
            }
        }
    }
}

