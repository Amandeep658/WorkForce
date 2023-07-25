//
//  ProfessionalFilterVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 12/07/22.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces

protocol ProfessFilterBackDelegate {
    func userDidBack(Data: [ProfessionalListJobData])
}

class ProfessionalFilterVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate {

    //    MARK: OUTLETS
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var professsetFilterLbl: UILabel!
    @IBOutlet weak var professcategoryView: UIView!
    @IBOutlet weak var professcategoryTF: UITextField!
    @IBOutlet weak var professcategoryBtn: UIButton!
    @IBOutlet weak var professlocationView: UIView!
    @IBOutlet weak var professlocationTF: UITextField!
    @IBOutlet weak var professionalRateFromView: UIView!
    @IBOutlet weak var professionalRateToView: UIView!
    @IBOutlet weak var professsalaryView: UIView!
    @IBOutlet weak var professsalaryTF: UITextField!
    @IBOutlet weak var professapplyFilterBtn: UIButton!
    @IBOutlet weak var professjobTypecollection: UICollectionView!
    @IBOutlet weak var professionalRateTF: UITextField!
    @IBOutlet weak var professionalRateToTF: UITextField!
    

    let viewModel = SetFilterVM()
    var setFilterPicker = UIPickerView()
    var doneToolBar = UIToolbar()
    var nearByWorkerFilterArr = [ProfessionalListJobData]()
    var catArrData = [CategoryData]()
    var reloadTable : ProfessFilterBackDelegate?
    var isBool:Bool?
    var catId = ""
    var jobArr = [String]()
    var jobtype = ""
    var latitude = ""
    var longitute = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
        viewModel.setJobs()
        professjobTypecollection.delegate = self
        professjobTypecollection.dataSource = self
        professjobTypecollection.allowsMultipleSelection = true
        professjobTypecollection.register(UINib(nibName: "JobTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobTypeCollectionViewCell")
        professCategoryListing()
    }

    @IBAction func professapplyFilterBtn(_ sender: UIButton) {
        self.hitFilterApi()
    }
    
    @IBAction func professCateforyBtn(_ sender: UIButton) {
        doneToolBar.removeFromSuperview()
        setFilterPicker.removeFromSuperview()
        self.professcategoryView.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        self.setFilterPicker.delegate = self
        self.setFilterPicker.dataSource = self
        self.setFilterPicker.backgroundColor = UIColor.white
        self.setFilterPicker.autoresizingMask = .flexibleWidth
        self.setFilterPicker.contentMode = .center
        self.setFilterPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(setFilterPicker)
        self.doneToolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        self.doneToolBar.barStyle = .default
        self.doneToolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(doneToolBar)
    }
    
    @objc func onDoneButtonTapped() {
        doneToolBar.removeFromSuperview()
        setFilterPicker.removeFromSuperview()
        self.professcategoryView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //    MARK: PICKER VIEW DELEGATE
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return catArrData.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            self.view.endEditing(true)
            return catArrData[row].category_name ?? ""
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.professcategoryTF.text = self.catArrData[row].category_name ?? ""
            print(professcategoryTF.text ?? "")
            self.catId = self.catArrData[row].category_id ?? ""
            print(catId)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            if textField == self.professcategoryTF{
                if textField.text == ""{
                    textField.text = self.catArrData.first?.category_name ?? ""
                }
            }
        }
    
    
    //    MARK: TEXTFIELD DELEGATES
        
        func uiConfigure(){
            professcategoryTF.delegate = self
            professlocationTF.delegate = self
            professsalaryTF.delegate = self
            professcategoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professlocationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professionalRateFromView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professionalRateToView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professcategoryView.layer.borderWidth = 1.5
            professlocationView.layer.borderWidth = 1.5
            professionalRateFromView.layer.borderWidth = 1.5
            professionalRateToView.layer.borderWidth = 1.5
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            professcategoryView.layer.borderColor = textField == professcategoryTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professlocationView.layer.borderColor = textField == professlocationTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professionalRateFromView.layer.borderColor = textField == professionalRateTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professionalRateToView.layer.borderColor = textField == professionalRateToTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            if textField == professlocationTF{
                let autocompleteController = GMSAutocompleteViewController()
                autocompleteController.delegate = self
                autocompleteController.placeFields = .coordinate
                present(autocompleteController, animated: true, completion: nil)
            }
            
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            professcategoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professlocationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professionalRateFromView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            professionalRateToView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    //    MARK: HIT FILTER API'S
        
        func hitFilterApi(){
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
            }
            let authToken  = AppDefaults.token ?? ""
            let headers: HTTPHeaders = ["Token":authToken]
            print(headers)
            AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.professionalFilter, params: hitJobListingParameters(), headers: headers) { [self] response in
                AFWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    let aContact = try jsonDecoder.decode(ProfessionalmoduleHome.self, from: data!)
                    print(aContact)
                    let status = aContact.status ?? 0
                    let message = aContact.message ?? ""
                    if status == 1{
                        self.dismiss(animated: true) {
                            self.reloadTable?.userDidBack(Data: aContact.data!)
                        }
                    }else{
                        showAlert(message: message, title: AppAlertTitle.appName.rawValue)
                    }
                }
                catch let parseError {
                    print("JSON Error \(parseError.localizedDescription)")
                }
                
            } failure: { error in
                AFWrapperClass.svprogressHudDismiss(view: self)
                alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }
        }
        func hitJobListingParameters() -> [String:Any] {
            var parameters : [String:Any] = [:]
            parameters["page_no"] = "1" as AnyObject
            parameters["per_page"] = "10" as AnyObject
            parameters["location"] = professlocationTF.text as AnyObject
            parameters["category_id"] = catId as AnyObject
            parameters["job_type"] = jobtype as AnyObject
            parameters["rate_from"] = professionalRateTF.text as AnyObject
            parameters["rate_to"] = professionalRateToTF.text as AnyObject
            parameters["deviceType"] = "1"  as AnyObject
            parameters["deviceToken"] = AppDefaults.deviceToken
            print(parameters)
            return parameters
        }
    
    
    //    MARK: HIT CATEGORY LISTNING API
    func professCategoryListing(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCategoryListing, params:hitCategoryParameters(), headers:headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print( response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ApiModel<[CategoryData]>.self, from: data!)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    self.catArrData = aContact.data!
                }
                else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            
        }
    failure: { error in
        AFWrapperClass.svprogressHudDismiss(view: self)
        alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
    }
        
    }
    func hitCategoryParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = "1" as AnyObject
        parameters["per_page"] = "100" as AnyObject
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
}
extension ProfessionalFilterVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.jobTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobTypeCollectionViewCell", for: indexPath) as! JobTypeCollectionViewCell
        cell.fullTimeLbl.backgroundColor = .aquaBlue
        cell.fullTimeLbl.borderColor = .white
        let str =  viewModel.jobTypes[indexPath.item].title ?? ""
        if self.jobArr.contains(str){
            self.jobArr = self.jobArr.filter{$0 != str}
        }else{
            self.jobArr.append(str)
        }
        let string = jobArr.joined(separator: ",")
        self.jobtype = string
        print("sperator Arr************>>>>>>>>",jobtype)
        self.professjobTypecollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobTypeCollectionViewCell", for: indexPath) as! JobTypeCollectionViewCell
      let str = viewModel.jobTypes[indexPath.item].title ?? ""
        cell.fullTimeLbl.text = str
        cell.fullTimeLbl.backgroundColor = self.jobArr.contains(str) ? #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.fullTimeLbl.textColor =  self.jobArr.contains(str) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.fullTimeLbl.borderColor = self.jobArr.contains(str) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if indexPath.row == 5 {
            cell.fullTimeLbl.borderColor = UIColor.clear
            cell.fullTimeLbl.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/2.5)
    }

}
extension ProfessionalFilterVC : GMSAutocompleteViewControllerDelegate{
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
                self.professlocationTF.text =  address
            }else{
                let ArrayOfString =  line.first ?? ""
                self.professlocationTF.text = ArrayOfString
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
                    print("place >>>>",place)
                    print("state >>>>",state)
                    completion(place.locality ?? "", place.lines ?? [])
                }
            }
        }
}

