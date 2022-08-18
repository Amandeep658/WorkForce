//
//  CountryViewCell.swift
//  WorkForce
//
//  Created by Dharmani Apps mini on 07/06/22.
//

import UIKit

class CountryViewCell: UITableViewCell {
    
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
