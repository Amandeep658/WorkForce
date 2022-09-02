//
//  CustomerJobListVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 29/08/22.
//

import UIKit
import Alamofire
import SDWebImage
import GooglePlaces
import GoogleMaps
import CoreLocation

class CustomerJobListVC: UIViewController,CLLocationManagerDelegate {
//    MARK: OUTLETS
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchbar: UITextField!
    @IBOutlet weak var searhBarView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var nearByComapniessDict:BusinessHomemodule?
    var nearByComapniessArr = [BusinessHomeData]()
    var jobNearMeArr = [ProfessionalListJobData]()
    var categoryId = ""
    var myIndex = 0
    var page = 100
    var pageCount = 1
    var currentlocation = ""
    var categoryArr = [CategoryData]()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
        print("Here is current location",currentlocation)
        NotificationCenter.default.addObserver(self, selector: #selector(self.customerListHomePressed(_:)), name: Notification.Name(rawValue: "homeTabPressed"), object: nil)
    }
    
    @objc func customerListHomePressed(_ notification : Notification){
        self.categoryId = ""
        getCurntLocation()
        self.homeCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBarController?.tabBar.isHidden = false
        self.categoryId = ""
        self.hitCategoryListing()
        self.getCurntLocation()
        self.homeCollectionView.reloadData()
    }
    
    func uiConfigure(){
        self.homeTableView.backgroundColor = .clear
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        self.homeTableView.register(UINib(nibName: "customerConnectListCell", bundle: nil), forCellReuseIdentifier: "customerConnectListCell")
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.register(UINib(nibName:"HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        if let flowLayout = homeCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    //    MARK: HIT CATEGORY LISTNING API
    func hitCategoryListing(){
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCategoryListing, params:hitCategoryParameters(), headers:headers) { [self] response in
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
                    self.homeCollectionView.reloadData()
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
        let userIdentity = UserDefaults.standard.value(forKey: "uID")
        parameters["user_id"] = userIdentity
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    //    MARK: HIT COUSTOMER JOB LISTING API
        func hitCoustomerListingApi(){
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
            }
            let authToken  = AppDefaults.token ?? ""
            let headers: HTTPHeaders = ["Token":authToken]
            print(headers)
            AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.nearCustomerByJobs, params: hitCustomerJobListingParameters(), headers: headers) { [self] response in
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
                    let message =  aContact.message ?? ""
                    if status == 401 {
                        UserDefaults.standard.removeObject(forKey: "authToken")
                        appDel.navigation()
                    }else if status == 1 {
                        self.jobNearMeArr = aContact.data!
                        self.homeTableView.setBackgroundView(message: "")
                        self.homeTableView.reloadData()
                    }else{
                        self.jobNearMeArr.removeAll()
                        self.homeTableView.setBackgroundView(message: message)
                        self.homeTableView.reloadData()
                    }
                }
                catch let parseError {
                    print("JSON Error \(parseError.localizedDescription)")
                }
                
            } failure: { error in
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
        }
    
//    MARK: GET CUSTOMER JOB LIST PARAMETERS
    func hitCustomerJobListingParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = "1" as AnyObject
        parameters["per_page"] = "100" as AnyObject
        parameters["location"] = currentlocation
        if categoryId != ""{
            parameters["category_id"] = categoryId
            parameters["location"] = ""
        }else{
            parameters["category_id"] = ""
        }
        parameters["search"] = searchbar.text!
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    //    MARK: GET CURRENT LOCATION
    func getCurntLocation(){
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Address")
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            let location = locations.last! as CLLocation
            let lat = location.coordinate.latitude
            print("here is lat ====>>>>",lat)
            let long = location.coordinate.longitude
            print("here is long =====>>>>",long)
            let currentlocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
            print("search result",currentlocation)
            self.getPlaceAddressFrom(location: currentlocation) { address in
                print("here is resultttt",address)
                self.currentlocation = address ?? ""
                print(currentlocation)
                self.hitCoustomerListingApi()
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            print(containsPlacemark)
        }
    }
    
    func getPlaceAddressFrom(location: CLLocationCoordinate2D, completion: @escaping (_ address: String) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                guard let places = response?.results(),
                      let place = places.first,
                      let lines = place.lines else {
                    completion("")
                    return
                }
                print("addressssss",place)
                completion(place.locality ?? "")
            }
        }
    }
    
//    MARK: CATEGORY FILTER API
    func hitCategoryFilterApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.nearCustomerByJobs, params: hitCategoryFilterParam(), headers: headers) { [self] response in
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
                    self.jobNearMeArr =  aContact.data!
                    self.homeTableView.reloadData()
                }else{
                    self.jobNearMeArr.removeAll()
                    self.homeTableView.reloadData()
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
    func hitCategoryFilterParam() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = "1" as AnyObject
        parameters["per_page"] = "100" as AnyObject
        parameters["category_id"] = categoryId as AnyObject
        parameters["location"] = "" as AnyObject
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    @IBAction func searchBtn(_ sender: UIButton) {
        let vc = CustomerJobListSearchVC()
        self.pushViewController(vc, true)
       
    }
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = ConnectJobListNotificationVC()
        self.pushViewController(vc, true)
    }
}
extension CustomerJobListVC:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        cell!.categoryLbl.text = categoryArr[indexPath.row].category_name ?? ""
        if categoryId == ""{
            cell!.categoryView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell!.categoryView.layer.borderColor = UIColor.gray.cgColor
            cell!.categoryView.layer.borderWidth = 0.5
            cell!.categoryLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            if myIndex == indexPath.row{
                cell!.categoryView.layer.backgroundColor = #colorLiteral(red: 0.2280597985, green: 0.5824585557, blue: 0.7204178572, alpha: 1)
                cell!.categoryLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell!.categoryView.layer.borderColor = UIColor.white.cgColor
                cell!.categoryView.layer.borderWidth = 0.5
            }
            else{
                cell!.categoryView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell!.categoryView.layer.borderColor = UIColor.gray.cgColor
                cell!.categoryView.layer.borderWidth = 0.5
                cell!.categoryLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = categoryArr[indexPath.item]
        let label = UILabel()
        label.text = data.category_name ?? ""
        return CGSize(width: label.intrinsicContentSize.width + 10, height: self.homeCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myIndex = indexPath.row
        for i in 0..<categoryArr.count{
            if i != indexPath.row{
                categoryArr[i].self
            }
        }
        self.categoryId = categoryArr[indexPath.item].cat_id ?? ""
        self.page = 100
        self.jobNearMeArr.removeAll()
        self.hitCategoryFilterApi()
        self.homeCollectionView.reloadData()
    }
}

extension CustomerJobListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobNearMeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerConnectListCell", for: indexPath) as! customerConnectListCell
        var sPhotoStr = jobNearMeArr[indexPath.row].job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.customeImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        if jobNearMeArr[indexPath.row].catagory_details?.count ?? 0 > 1{
            cell.locationLbl.text = "\(jobNearMeArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(jobNearMeArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
        }
        else{
            cell.locationLbl.text = "\(jobNearMeArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
        }
        cell.companyName.text = jobNearMeArr[indexPath.row].username ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CustomerListDetailScreenVC()
        vc.specificnav = false
        vc.customerJObID = jobNearMeArr[indexPath.row].customer_job_id ?? ""
        vc.cat_id =  jobNearMeArr[indexPath.row].catagory_details?.first?.cat_id ?? ""
        self.pushViewController(vc, true)
    }
    
    
}
