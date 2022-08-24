//
//  EditProfileTableViewCell.swift
//  WorkForce
//
//  Created by apple on 12/05/22.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var developerView: UIView!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var editLbl: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTF: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        editTF.delegate = self
        editView.borderColor = .gray
        // Initialization code
    }

    @IBAction func editAction(_ sender: UIButton) {
        let vc = SkillTableViewController()
        self.window?.rootViewController!.present(vc, animated: true, completion: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editView.borderColor = .systemBlue
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        editView.borderColor = .gray
    }
}
