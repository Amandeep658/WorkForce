//
//  GridCameraViewCell.swift
//  meetwise
//
//  Created by hitesh on 26/07/21.
//  Copyright © 2021 hitesh. All rights reserved.
//

import UIKit

class GridCameraViewCell: UICollectionViewCell {
    
    lazy var imgButton: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Camera"
        return lbl
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let stack = UIStackView(arrangedSubviews: [imgButton, label])
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        backgroundColor = .blue
        
    }
    
    
}
