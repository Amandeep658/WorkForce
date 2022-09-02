//
//  companiesTableViewCell.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 26/08/22.
//

import UIKit

class companiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
