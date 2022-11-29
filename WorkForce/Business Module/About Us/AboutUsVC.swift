//
//  AboutUsVC.swift
//  WorkForce
//
//  Created by apple on 24/06/22.
//

import UIKit
import WebKit

class AboutUsVC: UIViewController,WKUIDelegate {

    var aboutUrl = "https://u2connect.com/about/"
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var aboutView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddressURL()
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    func loadAddressURL(){
        let requestURL = NSURL(string: aboutUrl)
        let request = NSURLRequest(url: requestURL! as URL)
        aboutView.load(request as URLRequest)
    }

}
