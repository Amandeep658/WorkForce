//
//  BusinessHomeViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 17/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import GooglePlaces
import GoogleMaps
import CoreLocation
import MapKit
import Kingfisher
import FirebaseCrashlytics

class BusinessHomeViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,FilterBackDelegate {
    func userDidBack(Data: [BusinessHomeData]) {
        DispatchQueue.main.async { [self] in
            nearByWorkerArr.removeAll()
            businessFilter = "Nav from home filter"
            nearByWorkerArr = Data
            self.businessHomeTableView.reloadData()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var businessHomeTableView: UITableView!
    @IBOutlet weak var googleMap: GMSMapView!
    
    var tapGesture = UITapGestureRecognizer()
    var nearByWorkerDict:BusinessHomemodule?
    var nearByWorkerArr = [BusinessHomeData]()
    let locationManager = CLLocationManager()
    var nearByLocation = ""
    var currentlat = ""
    var currentlong = ""
    var businessFilter = ""
    var page = 100
    var pageCount = 1
    var pin = UIView()
    var locationss: CLLocationCoordinate2D?
    
    var iconImg = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        searchView.addGestureRecognizer(tapGesture)
        searchView.isUserInteractionEnabled = true
        setTable()
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeTabPressed(_:)), name: Notification.Name(rawValue: "homeTabPressed"), object: nil)
    }
    
    @objc func homeTabPressed(_ notification : Notification){
        getLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        getLocation()
    }
    
    func setTable(){
        businessHomeTableView.delegate = self
        businessHomeTableView.dataSource = self
        businessHomeTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //    MARK: GET CURRENT LOCATION
    func getLocation(){
        googleMap.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.map = googleMap
    }
    
    
    //    MARK: GOOGLE MAP
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationss = center
        let span = MKCoordinateSpan.init(latitudeDelta: 0.04, longitudeDelta:0.04)
        let region = MKCoordinateRegion.init(center: center, span: span)
        mapView.setRegion(region, animated: true)
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            let location = locations.last! as CLLocation
            let lat = location.coordinate.latitude
            self.currentlat = "\(Double(lat))"
            let long = location.coordinate.longitude
            self.currentlong = "\(Double(long))"
            let currentlocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.getPlaceAddressFrom(location: currentlocation) { [self] address in
                print("here is resultttt", address)
                self.nearByLocation = address
                print("Get current Location address ======>>>>",nearByLocation)
                self.addMarkers(lat: lat, long: long)
                self.nearByWorkerList()
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        locationManager.stopUpdatingLocation()
    }
    
    
    func addMarkers(lat : Double , long : Double, object: BusinessHomeData) {
        let state_marker = GMSMarker()
        state_marker.position = CLLocationCoordinate2D(latitude: Double(object.latitude ?? "0") ?? 0.0, longitude: Double(object.longitude ?? "0") ?? 0.0)
        state_marker.icon = self.iconImg
        state_marker.title =  object.username ?? ""
        let imgUrl = URL(string: object.photo ?? "")
        self.applyImage(from: imgUrl ?? URL(fileURLWithPath: ""), to: state_marker)
        state_marker.map = self.googleMap
    }
    
    func addMarkers(lat : Double , long : Double){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        googleMap.camera = camera
        googleMap.clear()
        nearByWorkerArr.forEach({ trucks in
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(trucks.latitude ?? "0.0") ?? 0.0, longitude: CLLocationDegrees(trucks.longitude ?? "0.0") ?? 0.0)
            state_marker.icon = #imageLiteral(resourceName: "pin")
            state_marker.title =  trucks.username ?? ""
            state_marker.map = googleMap
        })
    }
    
    func applyImage(from url: URL, to marker: GMSMarker) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                marker.icon = MappinImage.drawImageWithProfilePic(pp: image, image: UIImage(named: "pin")!)
            }
        }
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
    
    
    //    MARK: TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let controller = SearchListVC()
        pushViewController(controller, true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = SetFilterVC()
        vc.reloadTable = self
        self.present(vc, true)
    }
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = NotificationViewController()
        self.pushViewController(vc, true)
    }
    
    @IBAction func searchBtn(_ sender: UIButton) {
        let vc =  SearchListVC()
        vc.currentLocation = nearByLocation
        self.pushViewController(vc, true)
    }
    
    //    MARK: HIT NEAR BY WORKER
    func nearByWorkerList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["location": nearByLocation ,"page_no" : "1","per_page" : "40","search":""] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.nearByWorker, params: param, headers: headers) { [self] response in
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
                let message =  aContact.message ?? ""
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                }else if status == 1 {
                    self.businessFilter = ""
                    self.nearByWorkerArr = aContact.data!
                    self.addMarkers(lat: locationss?.latitude ?? 0.0, long: locationss?.longitude ?? 0.0)
                    let fltr = self.nearByWorkerArr.filter({$0.latitude != "0"})
                    print("count is ****** \(fltr.count)")
                    fltr.forEach { data in
                        print("count is ****** \(data.latitude ?? "") ** \(data.longitude ?? "") ** \(data.username ?? "")")
                        self.addMarkers(lat: Double(data.latitude ?? "0") ?? 0.0, long: Double(data.longitude ?? "0") ?? 0.0, object: data)
                    }
                    self.businessHomeTableView.setBackgroundView(message: "")
                    self.businessHomeTableView.reloadData()
                }else{
                    self.businessHomeTableView.setBackgroundView(message: message)
                    self.nearByWorkerArr.removeAll()
                    self.businessHomeTableView.reloadData()
                }
                
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            //            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
}

extension BusinessHomeViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearByWorkerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        var sPhotoStr = nearByWorkerArr[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.cellImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        if businessFilter != "Nav from home filter" {
            if nearByWorkerArr[indexPath.row].catagory_details?.count ?? 0 > 1{
                cell.designerLbl.text = "\(nearByWorkerArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(nearByWorkerArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
            }
            else{
                cell.designerLbl.text = "\(nearByWorkerArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
            }
        }else{
            cell.designerLbl.text = nearByWorkerArr[indexPath.row].category_name ?? ""
        }
        cell.cellLbl.text = nearByWorkerArr[indexPath.row].username ?? ""
        if nearByWorkerArr[indexPath.row].rate_type == "Per Day"{
            if nearByWorkerArr[indexPath.row].rate_to == ""{
                cell.priceLbl.text = ""
            }else{
                cell.priceLbl.text = "$\(nearByWorkerArr[indexPath.row].rate_to ?? "")/d"
            }
        }else if nearByWorkerArr[indexPath.row].rate_type == "Per Hour"{
            if nearByWorkerArr[indexPath.row].rate_to == ""{
                cell.priceLbl.text = ""
            }else{
                cell.priceLbl.text = "$\(nearByWorkerArr[indexPath.row].rate_to ?? "")/h"
            }
        }else if nearByWorkerArr[indexPath.row].rate_type == ""{
            cell.priceLbl.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BusinessDesignerViewController()
        vc.userID = nearByWorkerArr[indexPath.row].user_id ?? ""
        self.pushViewController(vc, true)
    }
    
}

extension BusinessHomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
}


extension UIImage {
    func cropped() -> UIImage {
        let targetSize: CGSize = .init(width: 44, height: 44)
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = max(widthRatio, heightRatio)
        
        print("widthRatio",widthRatio)
        print("heightRatio",heightRatio)
        print("scaleFactor",scaleFactor)
        
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        print("scaledImageSize",scaledImageSize)
        
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
