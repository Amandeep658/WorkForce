//
//  VerifyEmailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 16/08/22.
//

import UIKit
import SDWebImage
import Alamofire

class VerifyEmailVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var descriptionMsgLbl: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    
    var viewContrl:UIViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func verifyBtn(_ sender: UIButton) {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            let vc = CompanyDetailsViewController()
            self.pushViewController(vc, true)
        }else if UserType.userTypeInstance.userLogin == .Professional{
            let vc =  FullNameViewController()
            self.pushViewController(vc, true)
        }else{
            let vc = FullNameViewController()
            self.pushViewController(vc, true)
        }
          
    }
}
