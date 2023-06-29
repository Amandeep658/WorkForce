//
//  ProductListItemCell.swift
//  WorkForce
//
//  Created by apple on 26/06/23.
//

import UIKit

class ProductListItemCell: UITableViewCell,UITextFieldDelegate {
    
    var productItem = AddProductItemModel()

    
    @IBOutlet weak var itemTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var rateTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemTF.delegate = self
        quantityTF.delegate = self
        rateTF.delegate = self
        amountTF.delegate = self
//        amountTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        let quantity = quantityTF.text ?? ""
//        let rate = rateTF.text ?? ""
//        let calculatedValue = (Int(quantity) ?? 0) * (Int(rate) ?? 0)
//        self.amountTF.text = "\(calculatedValue)"
//    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.itemTF:
            self.productItem.item = textField.text
            return
        case self.quantityTF:
            self.productItem.quantity = textField.text
            return
        case self.rateTF:
            self.productItem.rate = textField.text
            return
        case self.amountTF:
            self.productItem.amount = textField.text
            return
        default:
            return
        }
    }
}
