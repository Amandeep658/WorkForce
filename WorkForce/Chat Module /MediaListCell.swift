//
//  MediaListCell.swift
//  WorkForce
//
//  Created by apple on 14/10/22.
//

import UIKit
import AVFoundation
import AVKit
import CoreAudio
import SwiftUI

class MediaListCell: UITableViewCell {

    @IBOutlet weak var bgView: MessageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upperStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet var sharedChatMedia: [UIImageView]!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    
    let leadingConstraintValue:CGFloat = 12.0
    let trailingConstraintValue:CGFloat = 90.0
    let timeConstraintRightSide:CGFloat = 22.0
    let timeConstraintRightSideWithRead:CGFloat = 30.0
    let timeConstraintLeftSide:CGFloat = 10.0
    var media: [String]?
    var urlStr: String?
    var previousDate: String?
    var timeStamp: String?
    var role: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.widthConstraint.constant = (SCREEN_SIZE.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(media: [String]?, role: String?, previousDate: String?, timeStamp: String?) {
        self.media = media
        self.role = role
        self.previousDate = previousDate
        self.timeStamp = timeStamp
        setImages()
    }
    
    func setImages() {
        self.sharedChatMedia.forEach { imgView in
            upperStackView.isHidden = true
            bottomStackView.isHidden = true
            imgView.isHidden = true
            imgView.contentMode = .scaleAspectFill
            imgView.layer.cornerRadius = 10
            imgView.layer.masksToBounds = true
        }
        
        let topVC = UIApplication.getTopViewController()
        if self.media?.count ?? 0 > 0 {
            self.media?.enumerated().forEach({ (index, data) in
                if data.isVideoType() {
                    print("******* yess *******")
                    if index == 0 {
                        hideView()
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].thumbnailForVideoAt(urlString: data)
                        self.urlStr = data
                    } else if index == 1 {
                        hideView()
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].thumbnailForVideoAt(urlString: data)
                        self.urlStr = data
                    } else if index == 2 {
                        showBottomView()
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].thumbnailForVideoAt(urlString: data)
                        self.urlStr = data
                    } else if index == 3 {
                        self.upperStackView.isHidden = false
                        self.bottomStackView.isHidden = false
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].thumbnailForVideoAt(urlString: data)
                        self.urlStr = data
                    }
                    self.playButton.isHidden = false
                    self.playButton.isUserInteractionEnabled = true
                    return
                } else {
                    if index == 0 {
                        hideView()
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].setImageView(urls: self.media ?? [], placeholder: UIImage(named: "placeholder"), item: index, controller: topVC)
                    } else if index == 1 {
                        hideView()
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].setImageView(urls: self.media ?? [], placeholder: UIImage(named: "placeholder"), item: index, controller: topVC)
                    } else if index == 2 {
                        showBottomView()
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].setImageView(urls: self.media ?? [], placeholder: UIImage(named: "placeholder"), item: index, controller: topVC)
                    } else if index == 3 {
                        self.upperStackView.isHidden = false
                        self.bottomStackView.isHidden = false
                        self.sharedChatMedia[index].isHidden = false
                        self.sharedChatMedia[index].setImageView(urls: self.media ?? [], placeholder: UIImage(named: "placeholder"), item: index, controller: topVC)
                    }
                }
            })
        }
        checkDaysDiff()
        setChatDirection()
    }
    
    func addPlayButton(view: UIView, urlStr: String) -> UIView {
        let foregroundImage = UIImage(named: "play")
        let foregroundButton = UIButton()// UIImageView(image: foregroundImage)
        foregroundButton.setImage(foregroundImage, for: .normal)
        foregroundButton.center = view.center
        foregroundButton.bounds.size = CGSize(width: 20.0, height: 20.0)
//        foregroundButton.addTarget(self, action: #selector(playButtonAction(url: urlStr)), for: .touchUpInside)
        return foregroundButton
    }
    
    @objc func playButtonAction(url: String) {
        let urlStr: String?
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.contentView.bounds
        self.contentView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func hideView() {
        self.playButton.isHidden = true
        self.playButton.isUserInteractionEnabled = false
        self.upperStackView.isHidden = false
    }
    
    func showBottomView() {
        self.upperStackView.isHidden = false
        self.bottomStackView.isHidden = false
        self.playButton.isHidden = true
        self.playButton.isUserInteractionEnabled = false
    }
    
    func setChatDirection() {
        var side: ChatDirection = .left
//        if self.role == UserDefaultsCustom.getLoginRole(key: UserDefaultsCustom.getUserId() ?? "").role {
//            side = .right
//        }
        bgView.direction = side
        if side == .left {
            self.viewLeadingConstraint = self.viewLeadingConstraint.setRelation(relation: .equal, constant: leadingConstraintValue)
            self.viewTrailingConstraint = self.viewTrailingConstraint.setRelation(relation: .greaterThanOrEqual, constant: self.trailingConstraintValue)
            
            self.timeLabel.textAlignment = .left
//            self.leftImage.setImage(url: self.selectedModel?.image, placeHolder: UIImage(named: "placeHolder"))
            self.bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            self.viewLeadingConstraint = self.viewLeadingConstraint.setRelation(relation: .greaterThanOrEqual, constant: self.trailingConstraintValue)
            self.viewTrailingConstraint = self.viewTrailingConstraint.setRelation(relation: .equal, constant: self.leadingConstraintValue)
            self.timeLabel.textAlignment = .right
            
//            self.leftImage.image = nil
            self.bgView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.7294117647, blue: 0.7411764706, alpha: 1)
        }
        
    }
    
    func checkDaysDiff() {
        let date = String().convertTimeStampToString(timeStamp: timeStamp ?? "", format: "dd MMM YYYY")
        let currentMessageDate = Date(timeIntervalSince1970: TimeInterval(timeStamp ?? "0") ?? 0.0)
        let previousMessageDate = Date(timeIntervalSince1970: TimeInterval(previousDate ?? "0") ?? 0.0)
        
        let dayDiff = Calendar.current.dateComponents([.day], from: previousMessageDate, to: currentMessageDate).day
        
        print("days differance is ****", dayDiff)
        
        
        let dayDiff2 = Calendar.current.dateComponents([.day], from: currentMessageDate, to: Date()).day
        
        if Calendar.current.isDateInToday(currentMessageDate) == true {
        } else if  Calendar.current.isDateInYesterday(currentMessageDate) == true  {
        } else {
        }
    }
    
    
    @IBAction func playButtonAction(_ sender: Any) {
        let topVc = UIApplication.getTopViewController()
        let videoURL = URL(string: self.urlStr ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        topVc?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    

}

