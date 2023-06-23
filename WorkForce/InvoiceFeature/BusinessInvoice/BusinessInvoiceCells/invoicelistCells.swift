//
//  invoicelistCells.swift
//  WorkForce
//
//  Created by apple on 21/06/23.
//

import UIKit

class invoicelistCells: UITableViewCell {

//    MARK: OUTLETS
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var viewSet: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
