//
//  leftImageListCell.swift
//  WorkForce
//
//  Created by apple on 18/10/22.
//

import UIKit

class leftImageListCell: UITableViewCell {

    @IBOutlet weak var leftImgCell: UIImageView!
    @IBOutlet weak var leftUserimgCell: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setMessageData(_ data: ChatAllMessages?) {
        if data!.chat_image!.contains(".jpg"){
            self.leftImgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        }else if data!.chat_image!.contains(".png") {
            self.leftImgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        }else if data!.chat_video!.contains(".mp4"){
            self.leftImgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        }else{
            self.leftImgCell.image = UIImage(named: "ic_ph_document")
        }
        self.leftUserimgCell.sd_setImage(with: URL(string: data?.photo ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        self.timeLbl.text =  data?.created
        self.leftUserimgCell.layer.cornerRadius = leftUserimgCell.frame.height/2
        self.leftUserimgCell.clipsToBounds = true
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
