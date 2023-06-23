//
//  InvoiceSearchVC.swift
//  WorkForce
//
//  Created by apple on 16/06/23.
//

import UIKit

class InvoiceSearchVC: UIViewController {

//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    //    MARK: SET_TABLE_LIST
    func setTable(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "invoicelistCells", bundle: nil), forCellReuseIdentifier: "invoicelistCells")
    }


    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension InvoiceSearchVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoicelistCells", for: indexPath) as! invoicelistCells
        return cell

    }
    
    
}
