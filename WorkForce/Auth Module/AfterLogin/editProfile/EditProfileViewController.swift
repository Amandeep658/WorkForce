//
//  EditProfileViewController.swift
//  WorkForce
//
//  Created by apple on 12/05/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    let label = ["First Name","Last Name","Date of Birth","Category","Year of Experience","Job Type","Rate"]
    
    @IBOutlet weak var editProfileTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
       
        setTable()
        setHeaderView()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden =  true
    }
    
    
    func setTable(){
        editProfileTableView.delegate = self
        editProfileTableView.dataSource = self
        editProfileTableView.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileTableViewCell")
        editProfileTableView.register(UINib(nibName: "YearOfExpTableViewCell", bundle: nil), forCellReuseIdentifier: "YearOfExpTableViewCell")
        editProfileTableView.register(UINib(nibName: "RateTableViewCell", bundle: nil), forCellReuseIdentifier: "RateTableViewCell")
    }
    func setHeaderView(){
        DispatchQueue.main.async{
            let header = UINib(nibName: "EditProfileHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as? EditProfileHeaderView
            header?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 192)
            self.editProfileTableView.tableHeaderView = header
        }
    }
    

}
extension EditProfileViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "YearOfExpTableViewCell", for: indexPath) as! YearOfExpTableViewCell
            cell.setTable()
            return cell
           
        }else if (indexPath.row == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateTableViewCell", for: indexPath) as! RateTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as! EditProfileTableViewCell
            cell.designView.isHidden = indexPath.row != 3
            cell.developerView.isHidden = indexPath.row != 3
            cell.editBtn.isHidden = indexPath.row != 3
            cell.editBtn.isHidden = indexPath.row != 5
            cell.editLbl.text = label[indexPath.row]
        return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UINib(nibName: "EditProfileFooterView", bundle: nil).instantiate (withOwner: self, options: nil).first as? EditProfileFooterView
        return footer
    
}
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
        return 140
        }else {
            return 100
        }
}

}
