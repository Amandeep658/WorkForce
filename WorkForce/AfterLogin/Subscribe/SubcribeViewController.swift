//
//  SubcribeViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 13/05/22.
//

import UIKit

class SubcribeViewController: UIViewController {
    
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    
    var jobLDataArr = [AddJobData]()
    var subcriptionType = "2"
    var workerJObId = ""
    var VC:UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("*************\(subcriptionType)********************")// Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backgroundAction(_ sender: UIButton) {
        let vc = SubscribePlanViewController()
        vc.navType = subcriptionType
        vc.jobLtData = jobLDataArr
        vc.workerID =  workerJObId
        self.dismiss(animated: true, completion: nil)
        self.VC?.pushViewController(vc, true)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}
    
    

