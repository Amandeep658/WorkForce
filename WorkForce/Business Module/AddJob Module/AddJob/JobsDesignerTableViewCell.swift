//
//  JobsDesignerTableViewCell.swift
//  WorkForce
//
//  Created by Dharmani Apps on 18/05/22.
//

import UIKit

class JobsDesignerTableViewCell: UITableViewCell {

    @IBOutlet weak var jobsDesignLbl: UILabel!
    @IBOutlet weak var jobsImg: UIImageView!
    @IBOutlet weak var jobsPriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
