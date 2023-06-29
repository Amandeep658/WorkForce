//
//  SelectSavedAddressCell.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit

class SelectSavedAddressCell: UITableViewCell {
    
//    MARk: OUTLETS
    
    @IBOutlet weak var selctAddressVIEW: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneNumberTF: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selctAddressVIEW?.clipsToBounds = true
        selctAddressVIEW.layer.masksToBounds = false
        selctAddressVIEW?.layer.shadowColor = UIColor.gray.cgColor
        selctAddressVIEW?.layer.shadowOffset =  CGSize.zero
        selctAddressVIEW?.layer.shadowOpacity = 0.2
        selctAddressVIEW?.layer.shadowRadius = 6    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
