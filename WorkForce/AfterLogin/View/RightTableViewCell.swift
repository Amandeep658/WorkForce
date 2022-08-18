//
//  RightMessageTableViewCell.swift
//  Let Me Listen
//
//  Created by Apple on 16/12/21.
//

import UIKit
import SDWebImage

class RightTableViewCell: UITableViewCell {
    
//    MARK: OUTLETS
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setMessageData(_ data: ChatAllMessages?) {
        self.messageLabel.text = data?.message
        self.timeLbl.text = data?.created ?? ""
    }
    
    func chatConvertTimeStampTodate(dateVal : String) -> String{
        let timeinterval = TimeInterval(dateVal)
        let dateFromServer = Date(timeIntervalSince1970:timeinterval ?? 0)
        print(dateFromServer)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(abbreviation: "IST")
        dateFormater.locale = NSLocale.current
        dateFormater.dateFormat = "hh:mm a"
        return dateFormater.string(from: dateFromServer)
    }
    
}
