//
//  YearOfExpTableViewCell.swift
//  WorkForce
//
//  Created by Dharmani Apps on 01/06/22.
//

import UIKit

class YearOfExpTableViewCell: UITableViewCell , UITextFieldDelegate {

    let label = ["Designer","Software Developer"]
    
    @IBOutlet weak var expTableView: UITableView!
    //    @IBOutlet weak var designCancelBtn: UIButton!
//    @IBOutlet weak var developerCancelBtn: UIButton!
//    @IBOutlet weak var developerBtn: UIButton!
//    @IBOutlet weak var designerBtn: UIButton!
//
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    func setTable(){
        expTableView.delegate = self
        expTableView.dataSource = self
        self.expTableView.register(UINib(nibName: "ExpTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpTableViewCell")
    }
    
}
extension YearOfExpTableViewCell : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpTableViewCell", for: indexPath) as! ExpTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpTableViewCell.self)) as! ExpTableViewCell
       
        cell.designLbl.text = label[indexPath.row]
        return cell
        
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
    
}








//
//    @IBAction func designCancelAction(_ sender: UIButton) {
//    }
//    @IBAction func developerCancelAction(_ sender: UIButton) {
//    }
//    @IBAction func developerAction(_ sender: UIButton) {
//        let vc = YearListViewController()
//        self.window?.rootViewController!.present(vc, animated: true, completion: nil)
//        let vc = YearListViewController()
//        self.present(vc,true)
//    }
//    @IBAction func designerAction(_ sender: UIButton) {
//        let vc = YearListViewController()
//        self.window?.rootViewController!.present(vc, animated: true, completion: nil)
//    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
