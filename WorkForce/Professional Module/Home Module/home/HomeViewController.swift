//
//  HomeViewController.swift
//  WorkForce
//
//  Created by apple on 06/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import GooglePlaces
import GoogleMaps
import CoreLocation

class HomeViewController: UIViewController,CLLocationManagerDelegate,ProfessFilterBackDelegate,UITextFieldDelegate {
    func userDidBack(Data: [ProfessionalListJobData]) {
        DispatchQueue.main.async { [self] in
            jobNearMeArr.removeAll()
            self.filterData = "nav from professional filter"
            jobNearMeArr = Data
            self.homeTableView.reloadData()
        }
    }
    
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchbar: UITextField!
    @IBOutlet weak var searhBarView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    var jobNearMeArr = [ProfessionalListJobData]()
    var categoryArr = [CategoryData]()
    var selectedItems = [CategoryData]()
    var categoryId = ""
    var myIndex = 0
    var page = 100
    var pageCount = 1
    var currentlocation = ""
    var filterData = ""
    let locationManager = CLLocationManager()
    private var jobListArr : Pagination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        searchView.addGestureRecognizer(tapGesture)
        searchView.isUserInteractionEnabled = true
        setCell()
        getCurntLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.professionalhomeTabPressed(_:)), name: Notification.Name(rawValue: "professionalhomeTabPressed"), object: nil)
    }
    @objc func professionalhomeTabPressed(_ notification : Notification){
        self.categoryId = ""
        self.jobListArr = Pagination()
        self.getCurntLocation()
        self.hitCategoryListing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = false
        self.jobListArr = Pagination()
        self.categoryId = ""
        getCurntLocation()
        hitCategoryListing()
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let vc = SearchViewController()
        self.pushViewController(vc, true)
    }
    
    
    func setCell(){
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeTableView.backgroundColor = .clear
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        self.homeTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.homeCollectionView.register(UINib(nibName:"HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        if let flowLayout = homeCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        self.searchbar.delegate = self
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
        print("l';l;l")
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
                self.homeJobListing()
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
    
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = ProfessionalFilterVC()
        vc.reloadTable = self
        self.present(vc, true)
    }
    @IBAction func searchBtn(_ sender: UIButton) {
        let vc = SearchVC()
        vc.currentLocation = currentlocation
        self.pushViewController(vc, true)
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = NotificationViewController()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
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
        let userIdentity = UserDefaults.standard.value(forKey: "getUserId")
        parameters["user_id"] = userIdentity ?? ""
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    func hitCategoryFilterApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.professionalFilter, params: hitCategoryFilterParam(), headers: headers) { [self] response in
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
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    //    MARK: HIT JOB LISTNING API
    func homeJobListing(){
        guard (!(self.jobListArr?.isLoading ?? false) && self.jobListArr?.canLoadMore ?? true) else {return}
        self.jobListArr?.isLoading = true
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.jobListing, params: hitJobListingParameters(), headers: headers) { [self] response in
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
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                }
                else if status == 1{
                    self.filterData = ""
                    if self.jobListArr?.pageNum == 1{
                        self.jobNearMeArr = aContact.data!
                    }else{
                        self.jobNearMeArr.append(contentsOf: aContact.data!)
                    }
                    if aContact.data!.count > 0{
                        let canLoadMore = aContact.data!.count > 0
                        self.jobListArr?.canLoadMore = canLoadMore
                        self.jobListArr?.pageNum += 1
                        self.jobListArr?.isLoading = false
                    }
                    self.homeTableView.reloadData()
                }else{
                    if self.jobNearMeArr.count == 0{
                        self.homeTableView.setBackgroundView(message: message)
                    }
                }
            }
            catch let parseError {
                self.jobListArr?.isLoading = false
                print("JSON Error \(parseError.localizedDescription)")
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    func hitJobListingParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = self.jobListArr?.pageNum ?? 1 as AnyObject
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
    
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
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
                cell!.categoryView.layer.backgroundColor = #colorLiteral(red: 0.1169760153, green: 0.4974487424, blue: 0.6748260856, alpha: 1)
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
        self.categoryId = categoryArr[indexPath.item].category_id ?? ""
        self.page = 100
        self.hitCategoryFilterApi()
        self.homeCollectionView.reloadData()
    }
    
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobNearMeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        cell.contentView.backgroundColor = .clear
        cell.cellImg.isUserInteractionEnabled = true
        cell.viewLeading.constant = 15
        cell.viewTop.constant = 15
        cell.viewTrailing.constant = 15
        cell.viewBottom.constant = 2
        cell.layer.cornerRadius = 15
        var sPhotoStr = jobNearMeArr[indexPath.row].job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.cellImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.cellLbl.text = jobNearMeArr[indexPath.row].company_name ?? ""
        if categoryId != "" || filterData == "nav from professional filter"{
            cell.designerLbl.text =  jobNearMeArr[indexPath.row].category_name ?? ""
        } else {
            if jobNearMeArr[indexPath.row].catagory_details?.count ?? 0 > 1{
                cell.designerLbl.text = "\(jobNearMeArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(jobNearMeArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
            }
            else{
                cell.designerLbl.text = "\(jobNearMeArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
            }
        }
        if jobNearMeArr[indexPath.row].rate_type == "Per Day"{
            if jobNearMeArr[indexPath.row].rate_from == "" || jobNearMeArr[indexPath.row].rate_to == "" {
                cell.priceLbl.text = ""
            }else{
                cell.priceLbl.text = "$\(jobNearMeArr[indexPath.row].rate_from ?? "")/d - $\(jobNearMeArr[indexPath.row].rate_to ?? "")/d "
            }
        }else if jobNearMeArr[indexPath.row].rate_type == "Per Hour"{
            if jobNearMeArr[indexPath.row].rate_from == "" || jobNearMeArr[indexPath.row].rate_to == "" {
                cell.priceLbl.text = ""
            }else{
            cell.priceLbl.text = "$\(jobNearMeArr[indexPath.row].rate_from ?? "")/h - $\(jobNearMeArr[indexPath.row].rate_to ?? "")/h"
            }
        }else{
            cell.priceLbl.text = ""
        }
        cell.imageBtn.tag = indexPath.row
        cell.imageBtn.addTarget(self, action: #selector(taptoNextScreen), for: .touchUpInside)
        return cell
    }
    
    @objc func taptoNextScreen(sender : UIButton) {
        let vc = ITServicesViewController()
        vc.user_iD = jobNearMeArr[sender.tag].user_id ?? ""
        self.pushViewController(vc, true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DesignerViewController()
        vc.workerlike = true
        vc.isGetJobID = false
        vc.job_id = jobNearMeArr[indexPath.row].job_id ?? ""
        vc.cat_ID = jobNearMeArr[indexPath.row].catagory_details?.first?.cat_id ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
}

