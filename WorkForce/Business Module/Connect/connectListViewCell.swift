//
//  connectListViewCell.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 13/07/22.
//

import UIKit

class connectListViewCell: UITableViewCell {
    
    
//    MARK: DELEGATES
    @IBOutlet weak var workerImgView: UIImageView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
