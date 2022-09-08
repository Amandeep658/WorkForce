//
//  SkillTableViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 19/05/22.
//

import UIKit
import Alamofire

protocol ListSelectionDelegate {
    func UserDidSelectList(data : [CategoryData])
}

var updateData: (()->())?

class SkillTableViewController: UIViewController {
    
    @IBOutlet weak var skillTableView: UITableView!
    @IBOutlet weak var skillListTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissbtn: UIButton!
    @IBOutlet weak var DoneBtn: UIButton!
    
    let label = ["Designer","Software Developer","Testing","Android Developer","IOS Developer","HR"]
    var categoryArr = [CategoryData]()
    var selecteditems:[[String:String]] = []
    var selectedItems = [CategoryData]()
    var skillUserId = ""
    var iSExperince:Bool?
    var professionalUserDict = SingletonLocalModel()
    var categoryListDelegate: ListSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here is my table use user id \(skillUserId)")
        setTable()
        if self.professionalUserDict.catagory_details != nil{
            if self.professionalUserDict.catagory_details!.count > 0{
                for i in 0..<(self.professionalUserDict.catagory_details?.count ?? 0){
                    self.professionalUserDict.catagory_details?[i].isSelected = true
                    self.selectedItems.append(self.professionalUserDict.catagory_details?[i] ?? CategoryData())
                }
                DispatchQueue.main.async {
                    self.skillTableView.reloadData()
                }
            }
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "dataTransferToSignUpScreen"), object: nil)
    }
    
    @IBAction func dismissbtn(_ sender: UIButton) {
       
    }
    
    @IBAction func DoneBtn(_ sender: UIButton) {
        dismiss(animated: true) { [self] in
            self.categoryListDelegate?.UserDidSelectList(data: selectedItems)
        }
    }
    
    //    MARK: FUNCTIONS
    func setTable(){
        skillTableView.delegate = self
        skillTableView.dataSource = self
        skillTableView.register(UINib(nibName: "SkillTableTableViewCell", bundle: nil), forCellReuseIdentifier: "SkillTableTableViewCell")
        hitCategoryListing()
        skillTableView.allowsMultipleSelection = false
    }
    
    //    MARK: hIT GET CATEGORY LISTING API's
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
                    for i in 0..<self.categoryArr.count{
                        if self.selectedItems.contains(where: {self.categoryArr[i].cat_id == $0.cat_id}) == true{
                            self.categoryArr[i].isSelected = true
                        }
                    }
                    self.skillTableView.reloadData()
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
        if iSExperince == true{
            parameters["user_id"] = professionalUserDict.userId as AnyObject
        }else if iSExperince == false {
            parameters["user_id"] = skillUserId
        }
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    
}
extension SkillTableViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoryArr.count
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath) as! SkillTableTableViewCell
        if self.categoryArr[indexPath.row].isSelected == true{
            if self.selectedItems.count > 0{
                cell.tickBtn.setImage(UIImage(named: "ck1"), for: .normal)
                self.categoryArr[indexPath.row].isSelected = false
                let selectedItemIndex = self.selectedItems.firstIndex{$0.cat_id == self.categoryArr[indexPath.row].cat_id} ?? 0
                self.selectedItems.remove(at: selectedItemIndex)
            }
        }
        else{
            if self.selectedItems.count < 2 {
                self.selectedItems.append(categoryArr[indexPath.row])
                cell.tickBtn.setImage(UIImage(named: "ck"), for: .normal)
                self.categoryArr[indexPath.row].isSelected = true
            }else{
                showAlert(message: "You can select only two category.".localized(), title: AppAlertTitle.appName.rawValue)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableTableViewCell", for: indexPath) as! SkillTableTableViewCell
        cell.tableLbl.text = categoryArr[indexPath.row].category_name ?? ""
        cell.tickBtn.setImage(UIImage(named: self.categoryArr[indexPath.row].isSelected == true ? "ck" : "ck1"), for: .normal)
        return cell
    }
    
}


