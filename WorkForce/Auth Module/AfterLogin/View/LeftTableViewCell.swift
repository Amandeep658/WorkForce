//
//  LeftTableViewCell.swift
//  Let Me Listen
//
//  Created by Apple on 20/12/21.
//
import UIKit
import SDWebImage

class LeftTableViewCell: UITableViewCell {
    
    //    MARK: OUTLETS
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imgViewUser: UIImageView!
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
        self.messageLabel.text = data?.message
        self.imgViewUser.sd_setImage(with: URL(string: data?.photo ?? ""), placeholderImage: UIImage(named: "placeholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        self.timeLbl.text =  data?.created ?? ""
        self.imgViewUser.layer.cornerRadius = imgViewUser.frame.height/2
        self.imgViewUser.clipsToBounds = true
        
        
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
