//
//  InvoiceBillViewCell.swift
//  WorkForce
//
//  Created by apple on 26/06/23.
//

import UIKit

class InvoiceBillViewCell: UITableViewCell {
    
//    MARK: OUTLETS
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var ratelbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
