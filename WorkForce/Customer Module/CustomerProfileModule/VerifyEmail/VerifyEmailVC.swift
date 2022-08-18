//
//  VerifyEmailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 16/08/22.
//

import UIKit
import SDWebImage
import Alamofire

protocol BackToViewDelegate {
    func userDidPressCancel()
}

class VerifyEmailVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var descriptionMsgLbl: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    
    var crossDelegate : BackToViewDelegate?

    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.crossDelegate?.userDidPressCancel()
        }
    }
    
    @IBAction func verifyBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
