//
//  SelectCityAddressCell.swift
//  WorkForce
//
//  Created by apple on 29/06/23.
//

import UIKit

class SelectCityAddressCell: UITableViewCell {
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressLbl2: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var contantVw: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        contantVw?.clipsToBounds = true
        contantVw.layer.masksToBounds = false
        contantVw?.layer.shadowColor = UIColor.gray.cgColor
        contantVw?.layer.shadowOffset =  CGSize.zero
        contantVw?.layer.shadowOpacity = 0.2
//        selctAddressVIEW?.layer.shadowRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
