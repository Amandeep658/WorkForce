//
//  ChatTableViewCell.swift
//  WorkForce
//
//  Created by apple on 10/05/22.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var badgecount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setImage(){
            chatImg.layer.cornerRadius = chatImg.frame.height/2
    }
}
