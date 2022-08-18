//
//  NikeIncDesignerViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 23/05/22.
//

import UIKit
import SDWebImage

class NikeIncDesignerViewController: UIViewController {
    

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var companyPArr:CompanyListingModel?
//    var connectcompanyList: Worker_details?
    var connectcompanyList:NearWorkerData?

    var isNav:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        if isNav == false{
            self.uiUpdate()
        }else{
            self.isNavDetailUI()
        }
    }
    
    
    func uiUpdate(){
        companyName.text = companyPArr?.data?.company_name ?? ""
        locationLbl.text = companyPArr?.data?.location ?? ""
        descriptionLbl.text = companyPArr?.data?.description ?? ""
        var sPhotoStr = companyPArr?.data?.photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.profileImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
    }
    func isNavDetailUI(){
        companyName.text = connectcompanyList?.company_name ?? ""
        locationLbl.text = connectcompanyList?.location ?? ""
        descriptionLbl.text = connectcompanyList?.description ?? ""
        var sPhotoStr = connectcompanyList?.photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        self.profileImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))

    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }

}
