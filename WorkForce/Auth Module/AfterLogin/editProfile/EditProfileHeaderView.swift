//
//  EditProfileHeaderView.swift
//  WorkForce
//
//  Created by Dharmani Apps on 12/05/22.
//

import UIKit

class EditProfileHeaderView: UIView {

    @IBOutlet weak var profileImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage()
    }
    func setImage(){
        self.profileImg.layer.cornerRadius = profileImg.frame.height/2
        self.profileImg.clipsToBounds = true
    }
}
