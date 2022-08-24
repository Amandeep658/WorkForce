//
//  TermsConditionVC.swift
//  WorkForce
//
//  Created by apple on 24/06/22.
//

import UIKit
import WebKit

class TermsConditionVC: UIViewController,WKUIDelegate {
    
    var termsConditions = "https://u2connect.com/terms-and-conditions/"
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var termsWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
