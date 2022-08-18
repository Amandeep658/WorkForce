//
//  ChatCell.swift
//  CoWorkerUser
//
//  Created by Rakesh Kumar on 08/05/18.
//  Copyright © 2018 SevenSkyLander. All rights reserved.
//

import UIKit

enum ChatDirection {
    case left
    case right
   
}
protocol ChatCellDelegate {
    func imageAction(_ image:String?)
}

enum MESSAGE_TYPE: String {
    case text = "Text"
    case audio = "Audio"
    case photo = "Photo"
    case video = "Video"
    case doc = "Doc"
    case pdf = "Pdf"
}

enum MESSAGE_STATUS:String {
    case seen = "Seen"
    case received = "Received"
    case sent = "Sent"
}

class ChatCell: UITableViewCell {

    let leadingConstraintValue:CGFloat = 12.0
    let trailingConstraintValue:CGFloat = 90.0
    let timeConstraintRightSide:CGFloat = 22.0
    let timeConstraintRightSideWithRead:CGFloat = 30.0
    let timeConstraintLeftSide:CGFloat = 10.0
        
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chatBg: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
//    @IBOutlet weak var chatImage: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rightImageBgView: UIView!
    @IBOutlet weak var leftImageBgView: UIView!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var topMessageLabelConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingTimeLabelConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var leadingmessageConstraint: NSLayoutConstraint!
    
   
    
    
    var previousDate: String?
    var selectedModel: MessageData?
    var selectedIndexPath : IndexPath?
    var delegate: ChatCellDelegate?
    
    var viewModel:ChatVM?
    var timeArray:[String] = ["12:14","12:18","12:19","12:22","12:25"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code1
//        self.chatBg.backgroundColor = UIColor.init(hexString: "#EEEEEE", alpha: 1)
        timeLabel.textAlignment = .left
//        self.messageLabel.setLabel("message label", .black, FONT_NAMEs.Amazon_Ember, 14)
////        self.nameLabel.setLabel("name label", .red , FONT_NAME.Amazon_Ember, 12)
        self.timeLabel.text = "12:14 PM"
        self.timeLabel.textColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model : MessageData? , indexPath : IndexPath, previousDate:String? = nil, chatType: String?) {
        self.selectedModel = model
        self.selectedIndexPath = indexPath
        self.previousDate = previousDate
        self.setChatData(model: model)
//        self.nameLabel.isHidden = chatType == "Solo"
        self.setChatDirection()
    }
    
    func setChatData(model: MessageData?) {
        self.timeLabel.isHidden = false
        self.timeLabel.text = "12:14 PM"//model?.sent_date//changeFormat(.full1, to: .time)
//        let type = MESSAGE_TYPE(rawValue: model?.message_type ?? "")
//        switch type {
//        case .audio: break
//        case .photo:
//            self.messageLabel.isHidden = true
////            self.chatImage.isHidden = false
////            self.chatImage.image = UIImage(named: "image1")//setImage(image: model?.message)
////            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapImageAction))
////            self.chatImage.addGestureRecognizer(gesture)
//        case .video: break
//        case .doc: break
//        case .pdf: break
//        default:
//            self.messageLabel.isHidden = false
////            self.chatImage.isHidden = true
////            self.nameLabel.text = model?.sender?.name
//            self.messageLabel.text = model?.message
//           
//        }
    }
    
    @objc func tapImageAction() {
        self.delegate?.imageAction(selectedModel?.message)
    }

    func setChatDirection() {
        var side: ChatDirection = .left
        if selectedModel?.sender == "my" {
            side = .right
        }
      
        if side == .left {
            self.leadingConstraint = self.leadingConstraint.setRelation(relation: .equal, constant: leadingConstraintValue)
            self.trailingConstraint = self.trailingConstraint.setRelation(relation: .greaterThanOrEqual, constant: self.trailingConstraintValue)
            
//            self.chatBg.backgroundColor = UIColor.init(hexString: "#EEEEEE", alpha: 1)
            self.timeLabel.textAlignment = .right
            self.messageLabel.textColor = .black
            self.chatBg.borderWidth = 1
            self.chatBg.borderColor = UIColor.gray
            self.chatBg.cornerRadius = 10
            self.chatBg.clipsToBounds = true
            self.chatBg.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.chatBg.layer.maskedCorners = [.layerMaxXMaxYCorner,  .layerMinXMinYCorner,.layerMaxXMinYCorner]
            self.leftImage.image = UIImage(named: "Image")
            
        } else {
            self.leadingConstraint = self.leadingConstraint.setRelation(relation: .greaterThanOrEqual, constant: self.trailingConstraintValue)
            self.trailingConstraint = self.trailingConstraint.setRelation(relation: .equal, constant: self.leadingConstraintValue)
            self.chatBg.clipsToBounds = true
            self.chatBg.layer.maskedCorners = [  .layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
            self.chatBg.backgroundColor = #colorLiteral(red: 0.1532052159, green: 0.6897016168, blue: 0.8547112346, alpha: 1)
            self.timeLabel.textAlignment = .right
            self.messageLabel.textColor = .white
            self.leftImage.image = nil
        }
        
    }
    
    func setIcon(side:ChatDirection) {
        guard side == .right else {
//            self.statusButton.isHidden = true
            return
        }
        if let status = self.selectedModel?.status, let messageStatus = MESSAGE_STATUS(rawValue: status) {
            print("message status \(status)")
        } else {
            
        }
    }
   
}
