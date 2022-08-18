//
//  BusinessSearchViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 17/05/22.
//

import UIKit

class BusinessSearchViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    let image = ["allen","img2-1","imggg"]
    let label = ["Allen khair","Marie Goodwin","Amber Faster"]
    let labelDesign = ["UI/UX Designer","Visual Designer","Software Developer"]
    
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.tabBarController?.tabBar.isHidden = true
        }


    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    func setTable(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    

}
extension BusinessSearchViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        cell.cellView.layer.backgroundColor = #colorLiteral(red: 0.9607003331, green: 0.9608381391, blue: 0.9606701732, alpha: 1)
        cell.labelView.layer.backgroundColor = #colorLiteral(red: 0.9607003331, green: 0.9608381391, blue: 0.9606701732, alpha: 1)
        cell.cellImg.image = UIImage(named: image[indexPath.item])
        cell.cellLbl.text = label[indexPath.row]
        cell.designerLbl.text = labelDesign[indexPath.row]
        return cell
    }
    
    
}
