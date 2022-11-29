//
//  TermsConditionVC.swift
//  WorkForce
//
//  Created by apple on 24/06/22.
//

import UIKit
import WebKit

class TermsConditionVC: UIViewController,WKUIDelegate {
    
    var termsConditions = ""
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var termsWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Locale.current.languageCode == "es"{
            self.termsConditions = "http://161.97.132.85/work-forcev2/webservice/TermandConditionsSpanish.html"
        }else if Locale.current.languageCode == "pt"{
            self.termsConditions = "http://161.97.132.85/work-forcev2/webservice/TermandConditionsPortuguese.html"
        }else if Locale.current.languageCode == "en"{
            self.termsConditions = "https://u2connect.com/terms-and-conditions/"
        }
        loadAddressURL()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    func loadAddressURL(){
        let requestURL = NSURL(string: termsConditions)
        let request = NSURLRequest(url: requestURL! as URL)
        termsWebView.load(request as URLRequest)
    }
    
}
