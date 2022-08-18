//
//  SkillsViewController.swift
//  WorkForce
//
//  Created by apple on 05/05/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

var passData = [[String:Any]]()

class SkillsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var categoryTF: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var categoryTF2: UILabel!
    @IBOutlet weak var headerTextLabel: UILabel!
    
    var categoryArr = [CategoryData]()
    var selectedCategoryitems:[[String:String]] = []
    var setectedCategoryId = String()
    var selectedCategoryid:[String] = []
    var userIdentity:Int?
    var professionalUserDict = SingletonLocalModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        setView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    func setView(){
        if UserType.userTypeInstance.userLogin == .Bussiness{
            self.headerTextLabel.text = "What professional Skills are you looking for?"
        }else{
            self.headerTextLabel.text = "What professional Skills can you offer?"
        }
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    //   MARK: VALIDATION
    func validation(){
        if (categoryTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please select categories." , okButton: "Ok", controller: self) {
            }
        }else{
            if (UserType.userTypeInstance.userLogin == .Bussiness){
                let vc = YearOfExpViewController()
                vc.professionalUserDict = self.professionalUserDict
                vc.categoryListDelegate = self
                self.pushViewController(vc, true)
            }else if UserType.userTypeInstance.userLogin == .Professional{
                let vc = YearOfExpViewController()
                vc.professionalUserDict = self.professionalUserDict
                vc.categoryListDelegate = self
                self.pushViewController(vc, true)
            }else{
                
            }
        }
    }

    
    @IBAction func continueAction(_ sender: UIButton) {
        validation()
    }
    
    
    @IBAction func dropDownAction(_ sender: UIButton) {
        categoryView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        if (UserType.userTypeInstance.userLogin == .Bussiness){
            let vc = SkillTableViewController()
            vc.selecteditems = selectedCategoryitems
            vc.professionalUserDict = self.professionalUserDict
            vc.professionalUserDict.catagory_details = self.professionalUserDict.catagory_details
            vc.categoryListDelegate = self
            vc.iSExperince == true
            vc.isModalInPresentation = true
            self.present(vc, true)
        }else{
            let vc = SkillTableViewController()
            vc.selecteditems = selectedCategoryitems
            vc.professionalUserDict = self.professionalUserDict
            vc.professionalUserDict.catagory_details = self.professionalUserDict.catagory_details
            vc.categoryListDelegate = self
            vc.iSExperince == true
            vc.isModalInPresentation = true
            self.present(vc, true)
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            self.popViewController(true)
        }else{
            self.popViewController(true)
        }
    }
    
}
    


extension SkillsViewController : ListSelectionDelegate{
    func UserDidSelectList(data: [CategoryData]) {
        self.categoryTF.text = data.first?.category_name ?? ""
        if data.count > 1{
            self.categoryTF2.text = data.last?.category_name ?? ""
        }
        else{
            self.categoryTF2.text = ""
        }
        self.professionalUserDict.catagory_details = data
    }
}
