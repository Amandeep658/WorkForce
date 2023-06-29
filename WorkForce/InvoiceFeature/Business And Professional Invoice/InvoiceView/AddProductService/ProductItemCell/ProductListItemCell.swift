//
//  ProductListItemCell.swift
//  WorkForce
//
//  Created by apple on 26/06/23.
//

import UIKit

class ProductListItemCell: UITableViewCell {
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension ProductListItemCell:UITextFieldDelegate{
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
