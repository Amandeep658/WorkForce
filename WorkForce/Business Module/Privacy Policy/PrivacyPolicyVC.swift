//
//  PrivacyPolicyVC.swift
//  WorkForce
//
//  Created by apple on 24/06/22.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController,WKUIDelegate {

    var privacyUrl = ""
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var privacyView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Locale.current.languageCode == "es"{
            self.privacyUrl = "http://161.97.132.85/work-forcev2/webservice/PrivacyandPolicySpanish.html"
        }else if Locale.current.languageCode == "pt"{
            self.privacyUrl = "http://161.97.132.85/work-forcev2/webservice/privacyandPolicyPortuguese.php"
        }else if Locale.current.languageCode == "en"{
            self.privacyUrl = "https://u2connect.com/privacy-and-policy/"
        }
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
