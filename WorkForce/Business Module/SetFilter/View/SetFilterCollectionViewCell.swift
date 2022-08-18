//
//  SetFilterCollectionViewCell.swift
//  WorkForce
//
//  Created by apple on 09/05/22.
//

import UIKit

class SetFilterCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    func setView(){
        categoryTF.delegate = self
        categoryView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        categoryView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
}
