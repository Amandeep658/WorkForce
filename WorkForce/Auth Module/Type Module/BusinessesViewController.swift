//
//  BusinessesViewController.swift
//  WorkForce
//
//  Created by apple on 04/05/22.
//

import UIKit
import Firebase
import FirebaseAuth

class BusinessesViewController: UIViewController {

    @IBOutlet weak var businessesBtn: UIButton!
    @IBOutlet weak var professionalsBtn: UIButton!
    @IBOutlet weak var coustomerAction: UIButton!
    
    var selectedLanguage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //    MARK : UI CONFIGURATION
    func setButton(){
        businessesBtn.layer.cornerRadius = 5
        professionalsBtn.layer.cornerRadius = 5
        coustomerAction.layer.cornerRadius = 5
    }

    @IBAction func businessesAction(_ sender: UIButton) {
        UserType.userTypeInstance.userLogin = .Bussiness
        UserDefaults.standard.set("Business", forKey: "CheckRow")
        let vc = LogInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func professionalsAction(_ sender: UIButton) {
        UserType.userTypeInstance.userLogin = .Professional
        UserDefaults.standard.set("Professional", forKey: "CheckRow")
        let vc = LogInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func coustomerAction(_ sender: UIButton) {
        UserType.userTypeInstance.userLogin = .Coustomer
        UserDefaults.standard.set("Customer", forKey: "CheckRow")
        let vc = LogInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension String{
    func localizable(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

