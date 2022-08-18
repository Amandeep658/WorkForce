//
//  RateTableViewCell.swift
//  WorkForce
//
//  Created by Dharmani Apps on 09/06/22.
//

import UIKit

class RateTableViewCell: UITableViewCell , UITextFieldDelegate {

    var isselect:Bool?
    
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var rateTF: UITextField!
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet weak var dayHrView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        // Initialization code
    }

    @IBOutlet weak var rateAction: UIView!
    @IBAction func dayAction(_ sender: UIButton) {
        if(isselect == false){
            dayBtn.setTitleColor(.systemBlue, for: .normal)
            hrBtn.setTitleColor(.gray, for: .normal)
        }else{
            dayBtn.setTitleColor(.gray, for: .normal)
            hrBtn.setTitleColor(.systemBlue, for: .normal)
        }
    }
    @IBAction func hrAction(_ sender: UIButton) {
        if (isselect == true){
            hrBtn.setTitleColor(.systemBlue, for: .normal)
            dayBtn.setTitleColor(.gray, for: .normal)

        }else{
            hrBtn.setTitleColor(.gray, for: .normal)
            dayBtn.setTitleColor(.systemBlue, for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setView(){
        rateTF.delegate = self
        rateView.layer.borderColor = UIColor.gray.cgColor
        dayHrView.layer.borderColor = UIColor.gray.cgColor
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
            rateView.layer.borderColor = UIColor.systemBlue.cgColor
            dayHrView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        rateView.layer.borderColor = UIColor.gray.cgColor
        dayHrView.layer.borderColor = UIColor.gray.cgColor
    }
}
