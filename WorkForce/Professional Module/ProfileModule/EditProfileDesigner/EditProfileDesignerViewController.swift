//
//  EditProfileDesignerViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 23/05/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

class EditProfileDesignerViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ImagePickerDelegate,UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate  {
    
    func didSelect(image: UIImage?) {
        if image == nil{
            self.selectedImage = UIImage(named: "placeholder")
        }else{
            self.selectedImage = image
        }
    }
    
    var isslect:Bool?
    let label = ["Designer","Software Developer"]
    var imagePicker : ImagePicker?
    var professionalUserDate:ProfessionalProfileData?
    var isselect:Bool = true
    var isRateType = "Per Hour"
    var yearListArr = UIPickerView()
    var doneTool = UIToolbar()
    let yearArr = ["0 Year","1 Year","1.5 Years","2 Years","2.5 Years","3 Years","3.5 Years","4 Years","4.5 Years","5 Years","5.5 Years","6 Years","6.5 Years","7 Years","7.5 Years","8 Years","8.5 Years","9 Years","1.5 Years","10 Years","10.5 Years","11 Years","11.5 Years","12 Years","12.5 Years","13 Years","13.5 Years","14 Years","14.5 Years","15 Years","15.5 Years","16 Years","16.5 Years","17 Years","17.5 Years","18 Years","18.5 Years","19 Years","19.5 Years","20 Years"]
    let onlyYearValues = ["0","1","1.5","2","2.5","3","3.5","4","4.5","5","5.5","6","6.5","7","7.5","8","8.5","9","9.5","10","10.5","11","11.5","12","12.5","13","13.5","14","14.5","15","15.5","16","16.5","17","17.5","18","18.5","19","19.5","20"]
    var imgArray = [Data]()
    var imageData = Data()
    let datePicker = UIDatePicker()
    var jobType = ["Full Time", "Part Time", "Contract", "Freelance","Remote"]
    var jobTypePicker = UIPickerView()
    var jobDone = UIToolbar()
    var selectData : [CategoryData] = []
    var selectedSkillitems:[[String:String]] = []
    var skillUserIdKey = ""
    var professionalEditUserDict = SingletonLocalModel()
    var currentIndex = Int()
    var selectedID = String()
    var updateCatetegoryItems = [String]()
    var finalexperienceValue = ""
    var hasExperinceValue : Bool = false
    var latitude = ""
    var longitute = ""
    
    var selectedImage: UIImage? {
        didSet {
            professionalImgView.image = selectedImage
        }
    }
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var yearOfExpTableView: UITableView!
    @IBOutlet weak var JobTF: UITextField!
    @IBOutlet weak var jobView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var professionalImgView: UIImageView!
    @IBOutlet weak var rateTF: UITextField!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var professionalView: UIView!
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var hourBtn: UIButton!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var dayhrView: UIView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var category1: UILabel!
    @IBOutlet weak var category2: UILabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        uiUpdate()
        setTextField()
        createDatePicker()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func imgUploadBtn(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    
    @IBAction func categoryAction(_ sender: UIButton) {
        let vc = SkillTableViewController()
        vc.skillUserId =  skillUserIdKey
        vc.professionalUserDict.catagory_details = professionalUserDate?.catagory_details
        vc.categoryListDelegate = self
        vc.iSExperince = false
        vc.isModalInPresentation = true
        self.present(vc, true)
    }
    @IBAction func hourAction(_ sender: UIButton) {
        isselect = true
        if isselect {
            isRateType = "Per Hour"
            hourBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            dayBtn.setTitleColor(.gray, for: .normal)
        }
    }
    @IBAction func dayAction(_ sender: UIButton) {
        isselect = false
        if !isselect  {
            isRateType = "Per Day"
            dayBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            hourBtn.setTitleColor(.gray, for: .normal)
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func jobTypeBtn(_ sender: UIButton) {
        print("its dropdown")
        jobDone.removeFromSuperview()
        jobTypePicker.removeFromSuperview()
        self.jobView.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
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
        self.jobView.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
//    MARK: UI_UPDATE
    func updateDict(){
        self.professionalEditUserDict.first_name = firstNameTF.text
        self.professionalEditUserDict.last_name = lastNameTF.text
        self.professionalEditUserDict.date_of_birth = dobTF.text
        self.professionalEditUserDict.job_type  = JobTF.text
        self.professionalEditUserDict.rate_to = rateTF.text
        self.professionalEditUserDict.first_name = firstNameTF.text
        self.professionalEditUserDict.rate_type = isRateType
        self.professionalEditUserDict.catagory_details = self.professionalUserDate?.catagory_details
    }
    
    //    MARK: PICKER_VIEW_DELEGATES
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
            self.JobTF.text = self.jobType[row]
            self.professionalEditUserDict.job_type = JobTF.text
        }else {
            selectedID = onlyYearValues[row]
        }
    }
    
    //    MARK: UI_UPDATE
    func uiUpdate(){
        yearOfExpTableView.delegate = self
        yearOfExpTableView.dataSource = self
        yearOfExpTableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        editImg.layer.cornerRadius = editImg.frame.height/2
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.firstNameTF.text = professionalUserDate?.first_name ?? ""
        self.lastNameTF.text = professionalUserDate?.last_name ?? ""
        self.dobTF.text = professionalUserDate?.date_of_birth ?? ""
        self.JobTF.text = professionalUserDate?.job_type ?? ""
        self.rateTF.text = professionalUserDate?.rate_to ?? ""
        self.category1.text =  professionalUserDate?.catagory_details?.first?.category_name ?? ""
        if professionalUserDate?.catagory_details?.count ?? 0 > 1 {
            self.category2.text = professionalUserDate?.catagory_details?.last?.category_name ?? ""
        }else{
            self.category2.text = ""
        }
        if professionalUserDate?.rate_type == "Per Hour"{
            self.isselect = true
            hourBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            dayBtn.setTitleColor(.gray, for: .normal)
        }else if professionalUserDate?.rate_type == "Per Day"{
            self.isselect = false
            dayBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            hourBtn.setTitleColor(.gray, for: .normal)
        }else{
            dayBtn.setTitleColor(.gray, for: .normal)
            hourBtn.setTitleColor(.gray, for: .normal)
        }
        self.cityTF.text = professionalUserDate?.city ?? ""
        var sPhotoStr = professionalUserDate?.photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.editImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
    }
    
//    MARK: VALIDATIONS
    func validation(){
        if (firstNameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_FIRST_NAME".localized() , okButton: "Ok", controller: self) {
            }
        }else if (lastNameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_LAST_NAME".localized() , okButton: "Ok", controller: self) {
            }
        }else if (dobTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter date of birth.".localized() , okButton: "Ok", controller: self) {
            }
        }else if (category1.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select category first.".localized() , okButton: "Ok", controller: self) {
            }
        }else if finalexperienceValue == "Year" {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_EXPERIENCE".localized() , okButton: "Ok", controller: self) {
            }
        }else if (JobTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select job type.".localized() , okButton: "Ok", controller: self) {
            }
        }else if (cityTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter city.".localized() , okButton: "Ok", controller: self) {
            }
        }else{
            self.professionalEditUserDict.city =  cityTF.text
            self.updateDict()
            self.hitProfessionalApi()
        }
    }
    
    
//    MARK: DATE_PICKER
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dobTF.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        dobTF.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func donePressed() {
        if dobTF.isFirstResponder {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .none
            formatter.dateFormat = "yyyy-MM-dd"
            dobTF.text = formatter.string(from: datePicker.date)
            self.professionalEditUserDict.date_of_birth = dobTF.text
        }
        self.view.endEditing(true)
    }
    
    //    MARK: UI_UPDATES
    func setTextField(){
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        dobTF.delegate = self
        rateTF.delegate = self
        cityTF.delegate = self
        firstNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dobView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        professionalView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        rateView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        jobView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    //    MARK: TEXT_FIELD_DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = textField == firstNameTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = textField == lastNameTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dobView.layer.borderColor = textField == dobTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        rateView.layer.borderColor = textField == rateTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dayhrView.layer.borderColor = textField == rateTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        jobView.layer.borderColor = textField == JobTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityView.layer.borderColor = textField == cityTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if textField == cityTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == self.JobTF{
            if textField.text == ""{
                textField.text = self.jobType.first
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dobView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        rateView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        jobView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: PROFESSIONAL EDIT API's
    func hitProfessionalApi() {
        let compressedData = (editImg.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        
        let strURL = kBASEURL + WSMethods.editProfessional
        self.requestWith(endUrl: strURL , parameters: self.professionalEditUserDict.convertModelToDict() as! Parameters )
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
                print("My uploadedphoto \(photo)")
                UserDefaults.standard.set(photo, forKey: "ProfessionalProfileImage")
                professionalEditUserDict.photo = photo
                print(professionalEditUserDict)
                print(status)
                if status == 1{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message:"Profile update successfully.".localized(), okButton: "OK", controller: self) {
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
extension EditProfileDesignerViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professionalUserDate?.catagory_details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableViewCell", for: indexPath) as! ExperienceTableViewCell
        cell.designLbl.text = professionalUserDate?.catagory_details![indexPath.row].category_name ?? ""
        self.hasExperinceValue = true
        if professionalUserDate?.catagory_details?[indexPath.row].experience != nil{
            let exp0 = Double(professionalUserDate?.catagory_details![indexPath.row].experience ?? "0") ?? 0.0
            cell.experienceLbl.text = "\(professionalUserDate?.catagory_details![indexPath.row].experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
        }else{
            cell.experienceLbl.text = "0 Year".localized()
        }
        cell.dropDownBtn.tag = indexPath.row
        cell.dropDownBtn.addTarget(self, action: #selector(dropdwnAction), for: .touchUpInside)
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(deleteRowBtn), for: .touchUpInside)
        DispatchQueue.main.async{
            self.tableViewHeightConstant.constant = self.yearOfExpTableView.contentSize.height
        }
        return cell
    }
    
    @objc func deleteRowBtn(sender : UIButton){
        self.professionalUserDate?.catagory_details?.remove(at: sender.tag)
        self.UserDidSelectList(data: professionalUserDate?.catagory_details ?? [])
        self.yearOfExpTableView.reloadData()
        self.uiUpdate()
    }
    
    @objc func dropdwnAction(sender : UIButton) {
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
        self.doneTool.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))]
        self.view.addSubview(doneTool)
    }
    @objc func doneButtonTapped(){
        self.professionalUserDate?.catagory_details?[self.currentIndex].experience = selectedID
        doneTool.removeFromSuperview()
        yearListArr.removeFromSuperview()
        yearOfExpTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension EditProfileDesignerViewController : ListSelectionDelegate{
    func UserDidSelectList(data: [CategoryData]) {
        self.yearOfExpTableView.reloadData()
        if data.count > 0{
            self.category1.text = data.first?.category_name ?? ""
            if data.count > 1{
                self.category2.text = data.last?.category_name ?? ""
            }
        }
        self.professionalUserDate?.first_name =  firstNameTF.text ?? ""
        self.professionalUserDate?.last_name =  lastNameTF.text ?? ""
        self.professionalUserDate?.date_of_birth =  dobTF.text ?? ""
        self.professionalUserDate?.catagory_details = data
        self.professionalEditUserDict.catagory_details = data
        self.uiUpdate()
        self.yearOfExpTableView.reloadData()
    }
}
extension EditProfileDesignerViewController : GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let geoCoder = CLGeocoder()
        let location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        self.latitude = "\(Double(place.coordinate.latitude))"
        print(latitude)
        self.longitute = "\(Double(place.coordinate.longitude))"
        print(longitute)
        print("search result",location)
        self.getPlaceAddressFrom(location: location) { [self] address,line   in
            print("here is resultttt",address)
            print("here is address",line)
            if address != ""{
                self.cityTF.text =  address
                self.professionalEditUserDict.city =  cityTF.text
            }else{
                let ArrayOfString =  line.first ?? ""
                self.cityTF.text = ArrayOfString
                self.professionalEditUserDict.city =  cityTF.text
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
