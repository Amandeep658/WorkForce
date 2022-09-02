//
//  CustomerSkillVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 17/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class CustomerSkillVC: UIViewController {    

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var categoryLbl1: UILabel!
    @IBOutlet weak var categoryLbl2: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var categorySelectBtn: UIButton!
    @IBOutlet weak var catView: UIView!
    
    var categoryArr = [CategoryData]()
    var selectedCategoryitems:[[String:String]] = []
    var setectedCategoryId = String()
    var selectedCategoryid:[String] = []
    var userIdentity:Int?
    var professionalUserDict = SingletonLocalModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.catView.layer.borderWidth = 1
        self.catView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func categorySelectBtn(_ sender: UIButton) {
        self.catView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        let vc = SkillTableViewController()
        vc.selecteditems = selectedCategoryitems
        vc.professionalUserDict = self.professionalUserDict
        vc.professionalUserDict.catagory_details = self.professionalUserDict.catagory_details
        vc.categoryListDelegate = self
        vc.iSExperince == true
        vc.isModalInPresentation = true
        self.present(vc, true)
    }
    
    //   MARK: VALIDATION
    func validation(){
        if (categoryLbl1.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select categories." , okButton: "Ok", controller: self) {
            }
        }else{
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }
        }
}
extension CustomerSkillVC : ListSelectionDelegate{
    func UserDidSelectList(data: [CategoryData]) {
        self.categoryLbl1.text = data.first?.category_name ?? ""
        if data.count > 1{
            self.categoryLbl2.text = data.last?.category_name ?? ""
        }
        else{
            self.categoryLbl2.text = ""
        }
        self.professionalUserDict.catagory_details = data
    }
}
