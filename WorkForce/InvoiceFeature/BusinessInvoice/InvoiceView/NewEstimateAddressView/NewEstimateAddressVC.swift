//
//  NewEstimateAddressVC.swift
//  WorkForce
//
//  Created by apple on 20/06/23.
//

import UIKit

class NewEstimateAddressVC: UIViewController {

    
//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var businessAddressTF: UITextField!
    @IBOutlet weak var phonnumberTF: UITextField!
    @IBOutlet weak var websiteTF: UITextField!
    @IBOutlet weak var estimateNumberTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var selectImgVw: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var invoiceNameTF: UITextField!
    @IBOutlet weak var addressSelectBtn: UIButton!
    
    var iconClick = true


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }


    
    
    
//    MARK: Button Action
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        firstValidation()
    }
    
    
    @IBAction func selectBtn(_ sender: UIButton) {
        if(iconClick == true) {
            selectImgVw.image = UIImage(named: "circleTick")
            selectImgVw.contentMode = .scaleAspectFill
        } else {
            selectImgVw.image = UIImage(named: "circle")
            selectImgVw.contentMode = .scaleAspectFill
        }
        iconClick = !iconClick

    }
    
    @IBAction func addressSelectBtn(_ sender: UIButton) {
        
        
    }

    //    MARK: VALIDATIONS
    func firstValidation(){
        if (invoiceNameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "Please enter invoice name." , okButton: "Ok", controller: self) {
            }
        }else if (businessAddressTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "Please enter business address." , okButton: "Ok", controller: self) {
            }
        }else if (phonnumberTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter phone number." , okButton: "Ok", controller: self) {
            }
        }else if (websiteTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter website." , okButton: "Ok", controller: self) {
            }
        }else if (estimateNumberTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter estimate no." , okButton: "Ok", controller: self) {
            }
        }else if (dateTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT", message: "Please enter date." , okButton: "Ok", controller: self) {
            }
        }
    }
}
