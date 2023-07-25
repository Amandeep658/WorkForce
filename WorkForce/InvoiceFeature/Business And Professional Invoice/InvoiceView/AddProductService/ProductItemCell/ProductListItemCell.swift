//
//  ProductListItemCell.swift
//  WorkForce
//
//  Created by apple on 26/06/23.
//

import UIKit

class ProductListItemCell: UITableViewCell,UITextFieldDelegate {
    
    var productItem = AddProductItemModel()
    var getProductitemDelegate:getProductItemDetail?
    var updateCount: (() -> Void)? 
    
    @IBOutlet weak var itemTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var rateTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var crossView: UIView!
    @IBOutlet weak var crossViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossBtn: UIButton!
    
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


    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.itemTF:
            self.productItem.item = textField.text
            self.getProductitemDelegate?.detail(parentDict: self.productItem,   index: textField.tag)
            return
        case self.quantityTF:
            self.productItem.quantity = textField.text
            self.getProductitemDelegate?.detail(parentDict: self.productItem, index: textField.tag)
            return
        case self.rateTF:
            self.productItem.rate = textField.text
            self.getProductitemDelegate?.detail(parentDict: self.productItem, index: textField.tag)
            return
        case self.amountTF:
            self.productItem.amount = textField.text
            self.getProductitemDelegate?.detail(parentDict: self.productItem, index: textField.tag)
            return
        default:
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.quantityTF, self.rateTF:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                if quantityTF.text?.count ?? 0 > 0 && rateTF.text?.count ?? 0 > 0 {
                    print("Int(quantityTF.text)+Int(rateTF.text)", (Int(quantityTF.text ?? "") ?? 0) + (Int(rateTF.text ?? "") ?? 0))
                    let count = (Int(quantityTF.text ?? "") ?? 0) * (Int(rateTF.text ?? "") ?? 0)
                    print("total count is **", count)
                    self.amountTF.text = "\(count)"
                    self.productItem.amount = "\(count)"
                    self.getProductitemDelegate?.detail(parentDict: self.productItem, index: textField.tag)
                    updateTotal?()
                }
            }
        default:break
        }
        return true
    }
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        updateCount?()
    }
}
