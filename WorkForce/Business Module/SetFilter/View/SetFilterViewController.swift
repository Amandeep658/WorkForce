//
//  SetFilterViewController.swift
//  WorkForce
//
//  Created by apple on 09/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class SetFilterViewController: UIViewController,UITextFieldDelegate {

    var listArr:[String] = ["Category","Sub Category","Location","Salary"]
    
    @IBOutlet weak var setFilterCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    
    let viewModel = SetFilterVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        let tapGesture1 = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture1)
        tapGesture1.cancelsTouchesInView = false
        setView()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)    }
    
    func setView(){
        viewModel.setJobs()
        setFilterCollectionView.delegate = self
        setFilterCollectionView.dataSource = self
        setFilterCollectionView.register(UINib(nibName: "JobTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobTypeCollectionViewCell")
        setFilterCollectionView.register(UINib(nibName: "SetFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SetFilterCollectionViewCell")
        setFilterCollectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        setFilterCollectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
    }
   
}
extension SetFilterViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return viewModel.jobTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetFilterCollectionViewCell", for: indexPath) as! SetFilterCollectionViewCell
            if indexPath.item == 2 {
                cell.categoryImg.isHidden = false
                
            }else if indexPath.item == 3{
                cell.categoryImg.isHidden = false

            }else{
                cell.categoryImg.isHidden = true
            }
            cell.categoryLbl.text = listArr[indexPath.item]
            cell.setView()
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobTypeCollectionViewCell", for: indexPath) as! JobTypeCollectionViewCell
            cell.fullTimeLbl.text = viewModel.jobTypes[indexPath.item].title
            
            if indexPath.item == 1{
                cell.fullTimeLbl.backgroundColor = UIColor(rgb: 0x3A94B7)
                cell.fullTimeLbl.borderColor = UIColor(rgb: 0x3A94B7)
            }else if indexPath.item == 3{
                cell.fullTimeLbl.backgroundColor = UIColor(rgb: 0x3A94B7)
                cell.fullTimeLbl.borderColor = UIColor(rgb: 0x3A94B7)
            }else{
                cell.fullTimeLbl.backgroundColor = .white

            }
            if indexPath.item == 5 {
                cell.fullTimeLbl.borderColor = UIColor.clear

            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
//        let cell = collectionView.cellForItem(at: indexPath) as! JobTypeCollectionViewCell
//           

        }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            
            header.jobLbl.text = "Job Type".localized()
        return header
        }else{
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView", for: indexPath) as! FooterCollectionReusableView
        footer.applyBtn.setTitle("APPLY FILTER", for: .normal)
            return footer
        }
    
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: 0, height: 0)
        }else{
        return CGSize(width: view.frame.size.width, height: 40)
    }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: 0, height: 0)
        }else{
        return CGSize(width: 246, height: 80)
    }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            if (indexPath.item < 2){
           return CGSize(width: collectionView.frame.width, height: 123)
            }else{
                return CGSize(width: collectionView.frame.width/2, height: 123)
            }
            
        default:
            return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height/12)
        }
    }
    
}
