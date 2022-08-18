//
//  ConnectTableViewCell.swift
//  WorkForce
//
//  Created by apple on 06/05/22.
//

import UIKit

class ConnectTableViewCell: UITableViewCell {

    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var designerLbl: UILabel!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var contentListView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
