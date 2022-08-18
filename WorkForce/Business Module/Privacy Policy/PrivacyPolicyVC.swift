//
//  PrivacyPolicyVC.swift
//  WorkForce
//
//  Created by apple on 24/06/22.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController,WKUIDelegate {

    var privacyUrl = "http://161.97.132.85/work-force/webservice/Privacy-policy.html"
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var privacyView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddressURL()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    func loadAddressURL(){
        let requestURL = NSURL(string: privacyUrl)
        let request = NSURLRequest(url: requestURL! as URL)
        privacyView.load(request as URLRequest)
    }
    
    
}
