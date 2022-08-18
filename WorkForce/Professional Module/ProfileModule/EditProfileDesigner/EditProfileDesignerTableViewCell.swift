//
//  EditProfileDesignerTableViewCell.swift
//  WorkForce
//
//  Created by Dharmani Apps on 10/06/22.
//

import UIKit

class EditProfileDesignerTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var designLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func dropDownAction(_ sender: UIButton) {
        let vc = YearListViewController()
        self.window?.rootViewController!.present(vc, animated: true, completion: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
