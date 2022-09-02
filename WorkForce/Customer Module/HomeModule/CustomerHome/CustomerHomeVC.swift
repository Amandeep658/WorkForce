//
//  CustomerHomeVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 26/07/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import MapKit
import Kingfisher


class CustomerHomeVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var companiesListTableView: UITableView!
    
    var nearByComapniessDict:BusinessHomemodule?
    var nearByComapniessArr = [BusinessHomeData]()
    let locationManager = CLLocationManager()
    var nearByLocation = ""
    var currentlat = ""
    var currentlong = ""
    var locationss: CLLocationCoordinate2D?
    var iconImg = UIImage()

    
    override func viewDidLoad() {
        super.viewDidLoad()

     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        companiesListTableView.delegate = self
        companiesListTableView.dataSource = self
        companiesListTableView.register(UINib(nibName: "customerConnectListCell", bundle: nil), forCellReuseIdentifier: "customerConnectListCell")
        self.tabBarController?.tabBar.isHidden = false
        self.getLocation()
    }

    @IBAction func searchBtn(_ sender: UIButton) {
        let vc =  CustomerSearchVC()
        self.pushViewController(vc, true)
    }
    
    
    @IBAction func notificationBtn(_ sender: UIButton) {
        let vc = NotificationViewController()
        self.pushViewController(vc, true)
    }
    
    //    MARK: GET CURRENT LOCATION
    func getLocation(){
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
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationss = center
        let span = MKCoordinateSpan.init(latitudeDelta: 0.04, longitudeDelta:0.04)
        let region = MKCoordinateRegion.init(center: center, span: span)
        mapView.animate(toZoom: 0.2)
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
                self.hitCoustomerListingApi()
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
    
    
    func addMarkers(lat : Double , long : Double){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        mapView.camera = camera
        mapView.clear()
        nearByComapniessArr.forEach({ trucks in
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(trucks.latitude ?? "0.0") ?? 0.0, longitude: CLLocationDegrees(trucks.longitude ?? "0.0") ?? 0.0)
            state_marker.icon = #imageLiteral(resourceName: "pin")
            state_marker.title =  trucks.username ?? ""
            state_marker.map = mapView
        })
    }
    
    func addMarkers(lat : Double , long : Double, object: BusinessHomeData) {
        let state_marker = GMSMarker()
        state_marker.position = CLLocationCoordinate2D(latitude: Double(object.latitude ?? "0") ?? 0.0, longitude: Double(object.longitude ?? "0") ?? 0.0)
        state_marker.icon = self.iconImg
        state_marker.title =  object.username ?? ""
        let imgUrl = URL(string: object.photo ?? "")
        self.applyImage(from: imgUrl ?? URL(fileURLWithPath: ""), to: state_marker)
        state_marker.map = self.mapView
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

//    MARK: HIT COUSTOMER LISTING API
    func hitCoustomerListingApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["location": nearByLocation ,"page_no" : "1","per_page" : "40","search":""] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getNearByCompanyListing, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(BusinessHomemodule.self, from: data!)
                print(aContact)
                self.nearByComapniessDict =  aContact
                let status = aContact.status ?? 0
                let message =  aContact.message ?? ""
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                }else if status == 1 {
                    self.nearByComapniessArr = aContact.data!
                    self.companiesListTableView.setBackgroundView(message: "")
                    self.addMarkers(lat: locationss?.latitude ?? 0.0, long: locationss?.longitude ?? 0.0)
                    let fltr = self.nearByComapniessArr.filter({$0.latitude != "0"})
                    print("count is ****** \(fltr.count)")
                    fltr.forEach { data in
                        print("count is ****** \(data.latitude ?? "") ** \(data.longitude ?? "") ** \(data.username ?? "")")
                        self.addMarkers(lat: Double(data.latitude ?? "0") ?? 0.0, long: Double(data.longitude ?? "0") ?? 0.0, object: data)
                    }
                    DispatchQueue.main.async {
                        self.companiesListTableView.reloadData()
                    }
                }else if status == 0{
                    self.companiesListTableView.setBackgroundView(message: message)
                    self.companiesListTableView.reloadData()
                }else{
                    print("")
                }
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }
    
    
}
extension CustomerHomeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearByComapniessArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerConnectListCell", for: indexPath) as! customerConnectListCell
        var sPhotoStr = nearByComapniessArr[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.customeImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.locationLbl.text = "\(nearByComapniessArr[indexPath.row].location ?? "") "
        cell.companyName.text = nearByComapniessArr[indexPath.row].company_name ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CustomerDetailVC()
        vc.companyID = nearByComapniessArr[indexPath.row].user_id ?? ""
        self.pushViewController(vc, true)
    }
}
