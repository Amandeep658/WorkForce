//
//  customerConnectListCell.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 08/08/22.
//

import UIKit

class customerConnectListCell: UITableViewCell {
    
    @IBOutlet weak var customeImgView: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
