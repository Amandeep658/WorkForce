//
//  SetFilterVC.swift
//  WorkForce
//
//  Created by apple on 21/06/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import GoogleMaps
import GooglePlaces

protocol FilterBackDelegate {
    func userDidBack(Data: [BusinessHomeData])
}

class SetFilterVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate {
    
    //    MARK: OUTLETS
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var setFilterLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var salaryView: UIView!
    @IBOutlet weak var salaryTF: UITextField!
    @IBOutlet weak var applyFilterBtn: UIButton!
    @IBOutlet weak var jobTypecollection: UICollectionView!
    
    
    let viewModel = SetFilterVM()
    var setFilterPicker = UIPickerView()
    var doneToolBar = UIToolbar()
    var nearByWorkerArr = [BusinessHomeData]()
    var categoryArr = [CategoryData]()
    var reloadTable : FilterBackDelegate?
    var isBool:Bool?
    var jobArray = [String]()
    var businessjobtype = ""
    var latitude = ""
    var longitute = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
        viewModel.setJobs()
        jobTypecollection.delegate = self
        jobTypecollection.dataSource = self
        jobTypecollection.allowsMultipleSelection = true
        jobTypecollection.register(UINib(nibName: "JobTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobTypeCollectionViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitCategoryListing()
    }
    
    @IBAction func applyFilterBtn(_ sender: UIButton) {
        hitFilterApi()
    }
    
    @IBAction func categoryBtn(_ sender: UIButton) {
        doneToolBar.removeFromSuperview()
        setFilterPicker.removeFromSuperview()
        self.categoryView.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
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
        self.categoryView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    
    //    MARK: PICKER VIEW DELEGATE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return categoryArr[row].category_name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTF.text = self.categoryArr[row].category_name ?? ""
    }
    
    
    
    //    MARK: TEXTFIELD DELEGATES
    
    func uiConfigure(){
        categoryTF.delegate = self
        locationTF.delegate = self
        salaryTF.delegate = self
        categoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        salaryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        categoryView.layer.borderWidth = 1.5
        locationView.layer.borderWidth = 1.5
        salaryView.layer.borderWidth = 1.5
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        categoryView.layer.borderColor = textField == categoryTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locationView.layer.borderColor = textField == locationTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        salaryView.layer.borderColor = textField == salaryTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if textField == locationTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.placeFields = .coordinate
            present(autocompleteController, animated: true, completion: nil)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locationView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        salaryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.filterList, params: hitJobListingParameters(), headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(BusinessHomemodule.self, from: data!)
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
        parameters["location"] = locationTF.text as AnyObject
        parameters["categoty"] = categoryTF.text as AnyObject
        parameters["job_type"] = businessjobtype as AnyObject
        parameters["rate_to"] = self.salaryTF.text as AnyObject
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    //    MARK: HIT CATEGORY LISTNING API
    func hitCategoryListing(){
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
                    self.categoryArr = aContact.data!
                    self.categoryTF.text =  self.categoryArr.first?.category_name ?? ""
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
extension SetFilterVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.jobTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobTypeCollectionViewCell", for: indexPath) as! JobTypeCollectionViewCell
        cell.fullTimeLbl.backgroundColor = .aquaBlue
        cell.fullTimeLbl.borderColor = .white
        let str =  viewModel.jobTypes[indexPath.item].title ?? ""
        if self.jobArray.contains(str){
            self.jobArray = self.jobArray.filter{$0 != str}
        }else{
            self.jobArray.append(str)
        }
        let string = jobArray.joined(separator: ",")
        self.businessjobtype = string
        self.jobTypecollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobTypeCollectionViewCell", for: indexPath) as! JobTypeCollectionViewCell
        let str = viewModel.jobTypes[indexPath.item].title ?? ""
        cell.fullTimeLbl.text = str
        cell.fullTimeLbl.backgroundColor = self.jobArray.contains(str) ? #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.fullTimeLbl.textColor =  self.jobArray.contains(str) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.fullTimeLbl.borderColor = self.jobArray.contains(str) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
extension SetFilterVC : GMSAutocompleteViewControllerDelegate{
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
