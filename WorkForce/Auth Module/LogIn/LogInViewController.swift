//
//  LogInViewController.swift
//  WorkForce
//
//  Created by apple on 04/05/22.
//

import UIKit
import Firebase
import FirebaseAuth


class LogInViewController: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var loginBtnView: UIView!
    @IBOutlet weak var backAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    func setButton(){
        logInBtn.layer.cornerRadius = 5
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func logInAction(_ sender: Any) {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            let vc = VerifyNumberViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if UserType.userTypeInstance.userLogin == .Professional{
            let vc = VerifyNumberViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            let vc = VerifyNumberViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    

}