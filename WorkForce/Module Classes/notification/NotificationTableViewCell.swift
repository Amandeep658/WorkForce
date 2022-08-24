//
//  NotificationTableViewCell.swift
//  WorkForce
//
//  Created by apple on 07/05/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationImg: UIImageView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func setImage(){
//        notificationView.layer.cornerRadius = notificationImg.frame.height/2
//        notificationView.layer.borderWidth = 0.5
//       notificationView.layer.borderColor = UIColor.systemBlue.cgColor
//    }
}
