//
//  ProfileDesignViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 19/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileDesignViewController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var professioonalImgView: UIImageView!
    @IBOutlet weak var AgeLbl: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var experienceLbl: UITextField!
    @IBOutlet weak var partTimeTF: UITextField!
    @IBOutlet weak var professionalTitleView: UILabel!
    @IBOutlet weak var jobTypeTF: UILabel!
    
    var professionalUserDate:ProfessionalProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    
    func uiUpdate(){
        self.professionalTitleView.text = professionalUserDate?.username ?? ""
        if professionalUserDate?.rate_type == "Per Day"{
            self.btnAmount.setTitle("$\(professionalUserDate?.rate_to ?? "")/d", for: .normal)
        }else if professionalUserDate?.rate_type == "Per Hour"{
            self.btnAmount.setTitle("$\(professionalUserDate?.rate_to ?? "")/h", for: .normal)
        }else{
            self.btnAmount.setTitle("Nor rate selected", for: .normal)
        }
        if professionalUserDate?.catagory_details?.count ?? 0 > 1{
            self.jobTypeTF.text = "\(professionalUserDate?.catagory_details?.first?.category_name ?? "") , \(professionalUserDate?.catagory_details?.last?.category_name ?? "") "
        }
        else{
            self.jobTypeTF.text = "\(professionalUserDate?.catagory_details?.first?.category_name ?? "") "
        }
        self.partTimeTF.text = professionalUserDate?.job_type ?? ""
        
        if professionalUserDate?.catagory_details == nil{
            self.experienceLbl.text = "0 Year"
        }else{
            let exp0 = Double(professionalUserDate?.catagory_details?.first?.experience ?? "0") ?? 0.0
            let exp1 = Double(professionalUserDate?.catagory_details?.last?.experience ?? "0") ?? 0.0
            if professionalUserDate?.catagory_details?.count ?? 0 > 1 {
                self.experienceLbl.text = "\(professionalUserDate?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years" : "Year") , \(professionalUserDate?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years" : "Year") "
            }
            else{
                self.experienceLbl.text = "\(professionalUserDate?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years" : "Year")"
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: professionalUserDate?.date_of_birth ?? "") {
            let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
            print(age)
            self.AgeLbl.text =  "\(Int(age)) Years"
        }
        var sPhotoStr = professionalUserDate?.photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.professioonalImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func btnAmount(_ sender: UIButton) {
        
    }
    

}
