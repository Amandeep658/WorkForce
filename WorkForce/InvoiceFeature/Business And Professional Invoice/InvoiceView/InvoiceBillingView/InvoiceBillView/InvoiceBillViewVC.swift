//
//  InvoiceBillViewVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit

class InvoiceBillViewVC: UIViewController {

//    MARK: OUTLETS
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var billingAddressLbl: UILabel!
    @IBOutlet weak var shippingAddressLbl: UILabel!
    @IBOutlet weak var logoImgVw: UIImageView!
    @IBOutlet weak var estimateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var itemHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstItemLbl: UILabel!
    @IBOutlet weak var seconditemLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var shippingTaxLbl: UILabel!
    
    @IBOutlet weak var savePDFBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    var UserInvoiceAddressDict = InvoiceCreateModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        updateData()
    }
    
    func updateData(){
        self.nameLbl.text = UserInvoiceAddressDict.business_name
        self.addressLbl.text = UserInvoiceAddressDict.business_phone_number
        self.websiteLbl.text = UserInvoiceAddressDict.website
        self.billingAddressLbl.text = UserInvoiceAddressDict.business_address
        self.shippingAddressLbl.text = UserInvoiceAddressDict.shipping_address
        self.estimateLbl.text =  "Estimate \(UserInvoiceAddressDict.estimate_no ?? "")"
        self.dateLbl.text = "DATE \(UserInvoiceAddressDict.date ?? "")"
        
    }
    
    func setTable(){
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(UINib(nibName: "InvoiceBillViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceBillViewCell")
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func savePDFBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension InvoiceBillViewVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceBillViewCell", for: indexPath) as! InvoiceBillViewCell
        DispatchQueue.main.async{
            self.itemHeightConstraint.constant = self.itemTableView.contentSize.height
        }
        return cell

    }
    
    
    
}



//@objc func removeCell(_ notification: Notification) {

//}

