//
//  SearchViewController.swift
//  WorkForce
//
//  Created by apple on 09/05/22.
//

import UIKit

class SearchViewController: UIViewController {
     
    let image = ["facebook","air","nike","app","sp-1"]
    let label = ["Facebook","Airbnd Inc","Nike Inc","Apple Inc","Spotify"]
    let labelDesign = ["UI/UX Designer","Visual Designer","Software Developer","UI/UX Designer","Product Designer"]
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.tabBarController?.tabBar.isHidden = true
        }


    
    func setTable(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    

}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        cell.cellImg.image = UIImage(named: image[indexPath.item])
        cell.cellLbl.text = label[indexPath.row]
        cell.designerLbl.text = labelDesign[indexPath.row]
        return cell
    }
    
    
}
