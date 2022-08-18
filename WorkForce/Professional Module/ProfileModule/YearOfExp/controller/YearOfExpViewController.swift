//
//  YearOfExpViewController.swift
//  WorkForce
//
//  Created by apple on 05/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class YearOfExpViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var yearOfExpTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    let yearArr = ["0 Year","1 Year","1.5 Years","2 Years","2.5 Years","3 Years","3.5 Years","4 Years","4.5 Years","5 Years","5.5 Years","6 Years","6.5 Years","7 Years","7.5 Years","8 Years","8.5 Years","9 Years","1.5 Years","10 Years","10.5 Years","11 Years","11.5 Years","12 Years","12.5 Years","13 Years","13.5 Years","14 Years","14.5 Years","15 Years","15.5 Years","16 Years","16.5 Years","17 Years","17.5 Years","18 Years","18.5 Years","19 Years","19.5 Years","20 Years"]
    let onlyYearValues = ["0","1","1.5","2","2.5","3","3.5","4","4.5","5","5.5","6","6.5","7","7.5","8","8.5","9","9.5","10","10.5","11","11.5","12","12.5","13","13.5","14","14.5","15","15.5","16","16.5","17","17.5","18","18.5","19","19.5","20"]
    let label = ["Designer","Software Developer"]
    var yearListArr = UIPickerView()
    var doneTool = UIToolbar()
    var str : [String] = [""]
    var currentIndex = Int()
    var selectedID = String()
    var currentINdex = 0
    var isSelect = "0"
    var professionalUserDict = SingletonLocalModel()
    var categoryListDelegate: ListSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentationController?.presentedView?.gestureRecognizers?.first!.isEnabled = false

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        if (UserType.userTypeInstance.userLogin == .Bussiness){
            if professionalUserDict.catagory_details!.count > 0 {
                let vc = ProfessionalRateViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                showAlert(message: "Please select category first.", title: AppAlertTitle.appName.rawValue) {
                }
                print("===>>>> please add experience","\(professionalUserDict.catagory_details?.count)")
            }
        }else if UserType.userTypeInstance.userLogin == .Professional{
            if professionalUserDict.catagory_details!.count > 0 {
                let vc = ProfessionalsViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                showAlert(message: "Please select category first.", title: AppAlertTitle.appName.rawValue) {
                }
                print("===>>>> please add experience","\(professionalUserDict.catagory_details?.count)")
            }
        }else{
            if professionalUserDict.catagory_details!.count > 0 {
                let vc = ProfessionalsViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                showAlert(message: "Please select category first.", title: AppAlertTitle.appName.rawValue) {
                }
                print("===>>>> please add experience","\(professionalUserDict.catagory_details?.count)")
            }
        }
    }
    
    func setTable(){
        self.yearOfExpTableView.delegate = self
        self.yearOfExpTableView.dataSource = self
        self.yearOfExpTableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        yearOfExpTableView.allowsMultipleSelection = true
        if professionalUserDict.catagory_details!.count > 0{
            self.yearOfExpTableView.backgroundView = nil
        }else{
            self.yearOfExpTableView.setBackgroundView(message: "Please select category first")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return yearArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedID = onlyYearValues[row]
    }
}

extension YearOfExpViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.professionalUserDict.catagory_details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableViewCell", for: indexPath) as! ExperienceTableViewCell
        cell.yearlistView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        skillupdateData = {
            cell.yearlistView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        let dict = self.professionalUserDict.catagory_details?[indexPath.row]
        cell.designLbl.text = dict?.category_name ?? ""
        cell.dropDownBtn.tag = indexPath.row
        cell.dropDownBtn.addTarget(self, action: #selector(dropdwnAction), for: .touchUpInside)
        let val = dict?.experience ?? ""
        if val == "" {
            cell.experienceLbl.text = "0 Year"
        }else{
            if val == "0"{
                cell.experienceLbl.text = "0 Year"
            }else if val == "1"{
                cell.experienceLbl.text = "1 Year"
            }else{
                cell.experienceLbl.text = "\(val) Years"
            }
//            cell.experienceLbl.text = "\(val == ("0" || "1") ? "Years" : "Year")"
        }
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtn), for: .touchUpInside)
        return cell
    }

    @objc func cancelBtn(sender : UIButton) {
        self.professionalUserDict.catagory_details?.remove(at: sender.tag)
        self.categoryListDelegate?.UserDidSelectList(data:  self.professionalUserDict.catagory_details ?? [])
        self.yearOfExpTableView.reloadData()
        if professionalUserDict.catagory_details!.count > 0{
            self.yearOfExpTableView.backgroundView = nil
        }else{
            self.yearOfExpTableView.setBackgroundView(message: "Please select atleast one category.")
        }
    }
    
    @objc func dropdwnAction(sender : UIButton) {
        self.currentIndex = sender.tag
        self.doneTool.removeFromSuperview()
        self.yearListArr.removeFromSuperview()
        self.yearListArr.delegate = self
        self.yearListArr.dataSource = self
        self.yearListArr.backgroundColor = UIColor.white
        self.yearListArr.autoresizingMask = .flexibleWidth
        self.yearListArr.contentMode = .center
        self.yearListArr.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(yearListArr)
        self.doneTool = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        self.doneTool.barStyle = .default
        self.doneTool.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(doneTool)
    }
    @objc func onDoneButtonTapped(){
        if UserType.userTypeInstance.userLogin == .Bussiness{
            self.professionalUserDict.catagory_details?[self.currentIndex].experience = selectedID
            doneTool.removeFromSuperview()
            yearListArr.removeFromSuperview()
            yearOfExpTableView.reloadData()
        }else if UserType.userTypeInstance.userLogin == .Professional{
            self.professionalUserDict.catagory_details?[self.currentIndex].experience = selectedID
            doneTool.removeFromSuperview()
            yearListArr.removeFromSuperview()
            yearOfExpTableView.reloadData()
        }else{
            self.professionalUserDict.catagory_details?[self.currentIndex].experience = selectedID
            doneTool.removeFromSuperview()
            yearListArr.removeFromSuperview()
            yearOfExpTableView.reloadData()
        }
    }
}
