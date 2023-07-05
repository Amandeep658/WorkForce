//
//  ProductCrossHeader.swift
//  WorkForce
//
//  Created by apple on 05/07/23.
//

import Foundation
import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    // Button action closure
    var buttonAction: (() -> Void)?
    
    // Button for the header view
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.addTarget(CustomHeaderView.self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Initializer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // Button setup
    private func setupButton() {
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // Button action
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
