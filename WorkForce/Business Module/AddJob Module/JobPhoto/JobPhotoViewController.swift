//
//  JobPhotoViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 18/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import Alamofire


class JobPhotoViewController: UIViewController,UITextViewDelegate,ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image == nil{
            self.selectedImage = UIImage(named: "plcordr")
        }else{
            self.selectedImage = image
        }
    }
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: ActualGradientButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var jobImg: UIImageView!
    @IBOutlet weak var jobImgView: UIView!
    
    var professionalUserDict = SingletonLocalModel()
    var button_isActive: Bool = false
    var imagePicker : ImagePicker?
    var imgArray = [Data]()
    var selectedImage: UIImage? {
        didSet {
            jobImg.image = selectedImage
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        self.setView()
        print(professionalUserDict)
    }
    
    func setView(){
        self.descriptionTV.delegate = self
        self.descriptionView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.descriptionView.layer.borderWidth = 1.5
        self.jobImgView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.jobImgView.layer.borderWidth = 1.5
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.jobImg.layer.cornerRadius = 4
        self.jobImg.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func continueAction(_ sender: ActualGradientButton) {
        validation()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func photoAction(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    //    MARK: TEXTVIEW DELEGATES
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        jobImgView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        descriptionView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //   MARK: VALIDATION
        func validation(){
            if (descriptionTV.text?.trimWhiteSpace.isEmpty)! {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter description." , okButton: "Ok", controller: self) {
                }
            }
            else if selectedImage == nil {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select image." , okButton: "Ok", controller: self) {
                }
            }
            else{
                professionalUserDict.description = descriptionTV.text ?? ""
                if UserType.userTypeInstance.userLogin == .Bussiness{
                    self.hitAddCompanyApi()
                }else if UserType.userTypeInstance.userLogin == .Coustomer{
                    self.hitCompanyAddJobApi()
                }

            }
        }
    

    //    MARK: CompanyAddJobApi
    func hitAddCompanyApi() {
        let compressedData = (jobImg.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        
        let strURL = kBASEURL + WSMethods.addJob
        self.requestWith(endUrl: strURL , parameters: self.professionalUserDict.convertModelToDict() as! Parameters )
        print("URL************>>>>>>>",strURL)
    }
    
    //    MARK: CustomerAddJobApi
    func hitCompanyAddJobApi() {
        let compressedData = (jobImg.image?.jpegData(compressionQuality: 0.3))!
        if compressedData.isEmpty == false{
            imgArray.append(compressedData)
        }
        
        let strURL = kBASEURL + WSMethods.customerAddJob
        self.requestWith(endUrl: strURL , parameters: self.professionalUserDict.convertModelToDict() as! Parameters )
        print("URL************>>>>>>>",strURL)
    }
    
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl /* your API url */
        let AToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": AToken]
        print(headers)
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Laoding..", view:self)
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
            let respDict =  response.value as? [String : Any] ?? [:]
            if respDict.count != 0{
                let status = respDict["status"] as? Int ?? 0
                print(status)
                let data = respDict["data"] as? [String:Any] ?? [:]
                let jobIDD = data["job_id"] as? String ?? ""
                print(data)
                if status == 1{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: respDict["message"] as? String ?? "" , okButton: "OK", controller: self) {
                        let vc = JobsDesignerViewController()
                        vc.jobId = jobIDD
                        vc.isJobPhoto = true
                        self.navigationController?.popToViewController(ofClass: JobsDesignerViewController.self, animated: true )
                        func viewWillAppear(animated: Bool) {
                            self.viewWillAppear(animated)
                            self.tabBarController?.tabBar.isHidden = false
                        }
                    }
                }else{
                }
            }
        }
    }
    
    
}





