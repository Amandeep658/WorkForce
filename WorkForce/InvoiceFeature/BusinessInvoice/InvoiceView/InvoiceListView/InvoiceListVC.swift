//
//  InvoiceListVC.swift
//  WorkForce
//
//  Created by apple on 16/06/23.
//

import UIKit
class InvoiceListVC: UIViewController {
    
//    MARK: OUTLETS
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var invoiceListTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: SET_TABLE_LIST
    func setTable(){
        invoiceListTableView.delegate = self
        invoiceListTableView.dataSource = self
        invoiceListTableView.register(UINib(nibName: "invoicelistCells", bundle: nil), forCellReuseIdentifier: "invoicelistCells")
    }
    
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
      let vc = InvoiceSearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        let vc = NewEstimateAddressVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
extension InvoiceListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoicelistCells", for: indexPath) as! invoicelistCells
        return cell

    }
    
    
}
