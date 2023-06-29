//
//  AlertView.swift
//  SessionControl
//
//  Created by apple on 20/03/23.
//  Copyright © 2023 dharmesh. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {

    @IBOutlet weak var addItemBtn: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView: UIView = loadViewFromNib()
        subView.frame = self.bounds
        addSubview(subView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() -> UIView {
        let view: UIView = UINib(nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func addItemBtn(_ sender: UIButton) {
        
    }
    

}
