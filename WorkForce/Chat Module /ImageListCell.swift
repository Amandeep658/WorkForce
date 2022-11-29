//
//  ImageListCell.swift
//  WorkForce
//
//  Created by apple on 18/10/22.
//

import UIKit

class ImageListCell: UITableViewCell {
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setMessageData(_ data: ChatAllMessages?) {
        self.imgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        self.timeLbl.text =  data?.created ?? ""
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
