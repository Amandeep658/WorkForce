//
//  AddProductServiceVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit

class AddProductServiceVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var lineProgressView: UIProgressView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var ShippingTF: UITextField!
    @IBOutlet weak var totalTF: UITextField!
    @IBOutlet weak var productTableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    
    var productItemModel = [AddProductItemModel()]
    
    var UserInvoiceAddressDict = InvoiceCreateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    func setTable(){
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.productTableView.register(UINib(nibName: "ProductListItemCell", bundle: nil), forCellReuseIdentifier: "ProductListItemCell")
        self.productTableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func submitBtn(_ sender: UIButton) {
        UserInvoiceAddressDict.product = productItemModel
        UserInvoiceAddressDict.product?[0].shipping = ShippingTF.text ?? ""
        UserInvoiceAddressDict.product?[0].total = totalTF.text ?? ""
        let vc = InvoiceBillViewVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
//    MARK: OUTLETS
    func invoiceListing(){
        
    }

}

extension AddProductServiceVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItemModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListItemCell", for: indexPath) as! ProductListItemCell
        cell.itemTF.text = self.productItemModel[indexPath.row].item
        cell.quantityTF.text = self.productItemModel[indexPath.row].quantity
        cell.rateTF.text = self.productItemModel[indexPath.row].rate
        cell.amountTF.text = self.productItemModel[indexPath.row].amount
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? HeaderView else {
            return nil
        }
        footerView.headerButton.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
        footerView.headerButton.tag = section
        footerView.headerLabel.text = "Add more products"
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    @objc func headerButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        if self.productItemModel.count == 10{
            self.productItemModel.remove(at: 1)
        }
        else{
            self.productItemModel.append(AddProductItemModel())
            
        }
        self.productTableView.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        DispatchQueue.main.async {
            self.productTableViewHeightConstraints.constant = self.productTableView.contentSize.height
        }
    }
}



class HeaderView: UITableViewHeaderFooterView {

    var productItemModel = [AddProductItemModel()]

    let headerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "AddItem")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hex: "#578BB8")
        
        return button
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = label.font.bold()
        label.textColor = UIColor(r: 87, g: 139, b: 184, a: 1)
        label.textColor = UIColor(hex: "#578BB8")
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(headerButton)
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: topAnchor),
            headerButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            headerButton.widthAnchor.constraint(equalToConstant: 60),
            headerButton.heightAnchor.constraint(equalToConstant: 60),
            
            headerLabel.centerYAnchor.constraint(equalTo: headerButton.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerButton.trailingAnchor, constant: 2),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIFont {

    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
