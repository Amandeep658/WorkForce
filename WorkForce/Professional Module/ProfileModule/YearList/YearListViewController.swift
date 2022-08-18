//
//  YearListViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 19/05/22.
//

import UIKit

var skillupdateData: (()->())?

class YearListViewController: UIViewController {

    let label = ["1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year"]
    
    @IBOutlet weak var yearListTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var yearListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    func setTable(){
        yearListTableView.delegate = self
        yearListTableView.dataSource = self
        yearListTableView.register(UINib(nibName: "YearListTableViewCell", bundle: nil), forCellReuseIdentifier: "YearListTableViewCell")
    }

    
}
extension YearListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearListTableViewCell", for: indexPath) as! YearListTableViewCell
        cell.yearLbl.text = label[indexPath.row]
        
        DispatchQueue.main.async {
            self.yearListTableHeightConstraint.constant = self.yearListTableView.contentSize.height
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        skillupdateData?()
        self.dismiss(animated: true, completion: nil)
    }
    
}
