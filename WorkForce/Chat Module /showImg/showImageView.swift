//
//  showImageView.swift
//  WorkForce
//
//  Created by apple on 24/01/23.
//

import UIKit
import SDWebImage


class showImageView: UIViewController {
    
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var showImgView: UIImageView!
    
    var setImage = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.showImgView.sd_setImage(with: URL(string: setImage ), placeholderImage: UIImage(named: "placeholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
    }

    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
