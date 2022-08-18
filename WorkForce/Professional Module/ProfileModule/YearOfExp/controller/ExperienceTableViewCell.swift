//
//  ExperienceTableViewCell.swift
//  WorkForce
//
//  Created by Dharmani Apps on 10/06/22.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {

    var yearListArr = UIPickerView()
    var doneTool = UIToolbar()

    
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var designLbl: UILabel!
    @IBOutlet weak var experienceLbl: UILabel!
    @IBOutlet weak var yearlistView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        skillupdateData = {
            self.yearlistView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    @IBAction func dropDownAction(_ sender: UIButton) {
//        let vc = YearListViewController()
//        self.window?.rootViewController!.present(vc, animated: true, completion: nil)
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
