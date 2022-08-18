//
//  ProfileTableViewCell.swift
//  WorkForce
//
//  Created by apple on 11/05/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
