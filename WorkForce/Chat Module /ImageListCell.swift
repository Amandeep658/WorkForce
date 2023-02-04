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
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setMessageData(_ data: ChatAllMessages?) {
        if data!.chat_image!.contains(".jpg"){
            self.imgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        }else if data!.chat_image!.contains(".png") {
            self.imgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        }else if data!.chat_video!.contains(".mp4"){
            self.imgCell.sd_setImage(with: URL(string: data?.chat_image ?? ""), placeholderImage: UIImage(named: "jobSeekerPlaceholder"), options: .allowInvalidSSLCertificates, progress: nil, completed: nil)
        }else{
            self.imgCell.image = UIImage(named: "ic_ph_document")
        }
        if data!.message_type == "video"{
            self.playImgView.isHidden = false
            self.playView.isHidden = false
        }else{
            self.playImgView.isHidden = true
            self.playView.isHidden = true
        }
            
        
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
