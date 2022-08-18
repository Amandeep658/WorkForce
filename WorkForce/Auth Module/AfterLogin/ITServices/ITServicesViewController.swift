//
//  ITServicesViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 16/05/22.
//

import UIKit
import Alamofire
import SDWebImage


class ITServicesViewController: UIViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var itServicesTableView: UITableView!
    @IBOutlet weak var itServicesColllectionView: UICollectionView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var comapnynameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    let collectionArray = ["IT services & consulting","Manufacturing","Retail","Private","Corporate","B2B"]
    let image = ["facebook","air","nike","app","sp-1"]
    let label = ["Facebook","Airbnd Inc","Nike Inc","Apple Inc","Spotify"]
    let labelDesign = ["UI/UX Designer","Visual Designer","Software Developer","UI/UX Designer","Product Designer"]
    
    var itServicesDetailData:JobListDetailData?
    var itService = [JObListJob_details]()
    var itServicesCategory = [JobListCategory_details]()
    var user_iD = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTableView()
        print(user_iD)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.jobWorkerList()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    func setCollectionView(){
        itServicesColllectionView.delegate = self
        itServicesColllectionView.dataSource = self
        itServicesColllectionView.register(UINib(nibName: "ITServicesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ITServicesCollectionViewCell")
    }
    func setTableView(){
        itServicesTableView.delegate = self
        itServicesTableView.dataSource = self
        itServicesTableView.backgroundColor = .clear
        itServicesTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
//    MARK: HIT API JOBDETAIL LIST
    func jobWorkerList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["other_id": user_iD] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompanyListingbyJob, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(JobListDetailModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                if status == 1{
                    self.headerLbl.text = aContact.data?.company_name ?? ""
                    self.comapnynameLbl.text = aContact.data?.company_name ?? ""
                    self.locationLbl.text = aContact.data?.location ?? ""
                    var sPhotoStr = aContact.data?.photo ?? ""
                    sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    self.headerImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
                    self.itServicesCategory = (aContact.data?.category_details!)!
                    self.itService = (aContact.data?.job_details!)!
                    self.itServicesDetailData = aContact.data!
                    self.itServicesTableView.reloadData()
                    self.itServicesColllectionView.reloadData()
                }else{
                    self.itServicesTableView.reloadData()
                    self.itServicesColllectionView.reloadData()
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
    
}
extension ITServicesViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itServicesCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ITServicesCollectionViewCell", for: indexPath) as! ITServicesCollectionViewCell
        cell.collectionLbl.text = itServicesCategory[indexPath.row].category_name ?? ""
        DispatchQueue.main.async {
            self.heightConstraint.constant = self.itServicesColllectionView.contentSize.height
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = NSAttributedString(string: "\(itServicesCategory[indexPath.row].category_name ?? "")")
        return CGSize(width: text.size().width + 27, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
extension ITServicesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        cell.contentView.backgroundColor = nil
        var sPhotoStr = itService[indexPath.row].job_image ?? ""
        UserDefaults.standard.set(sPhotoStr, forKey: "businessProfileImageView")
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.cellImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.cellLbl.text = itService[indexPath.row].company_name ?? ""
        
        if itService[indexPath.row].catagory_details?.count ?? 0 > 1{
            cell.designerLbl.text = "\(itService[indexPath.row].catagory_details?.first?.category_name ?? "") , \(itService[indexPath.row].catagory_details?.last?.category_name ?? "") "
        }
        else{
            cell.designerLbl.text = "\(itService[indexPath.row].catagory_details?.first?.category_name ?? "") "
        }
        
        if itService[indexPath.row].rate_type == "Per Day"{
            cell.priceLbl.text = "$\(itService[indexPath.row].rate_from ?? "")/d - $\(itService[indexPath.row].rate_to ?? "")/d"
        }else if itService[indexPath.row].rate_type == "Per Hour"{
            cell.priceLbl.text = "$\(itService[indexPath.row].rate_from ?? "")/h - $\(itService[indexPath.row].rate_to ?? "")/h"
        }else{
            cell.priceLbl.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DesignerViewController()
        vc.isGetJobID = true
        vc.bygetcompanyJobId = itService[indexPath.row].job_id ?? ""
        vc.cat_ID = itService[indexPath.row].catagory_details?.first?.cat_id ?? ""
        self.pushViewController(vc, true)
    }
    
    
}
class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        // Copy each item to prevent "UICollectionViewFlowLayout has cached frame mismatch" warning
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        // Constants
        let leftPadding: CGFloat = 8
        let interItemSpacing = minimumInteritemSpacing
        
        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            
            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        
        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                
                currentRow += 1
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
