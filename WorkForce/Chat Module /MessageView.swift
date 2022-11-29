//
//  MessageView.swift
//  WalkinsAvailable
//
//  Created by MyMac on 7/29/22.
//


import UIKit

@IBDesignable
class MessageView: UIView {

    var direction: ChatDirection = .right
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if direction == .left {
            self.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 10, width: self.bounds.width, height: self.bounds.height)
        } else {
            self.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 10, width: self.bounds.width, height: self.bounds.height)
        }
    }

}

