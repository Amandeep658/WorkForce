//
//  CustomDatePicker.swift
//  gsa
//
//  Created by apple on 29/03/19.
//  Copyright © 2019 stackgeeks. All rights reserved.
//

import UIKit

protocol CustomDatePickerDelegate {
    func pickedDate(date: String, _ tag:Int, _ datePickerDate:Date?)
    func cancelPicker(_ tag:Int)
}

class CustomDatePicker: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBGView: UIView!
    
    var delegate:CustomDatePickerDelegate?
    var selectedDate:Date?
    var tag:Int = 0
    var pickerMode:UIDatePicker.Mode = .date
    var datePickerMaximumDate:Date?
    var datePickerMinimumDate:Date?
    var format:String = "dd/MM/yyyy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = selectedDate {
            print("\n\nselected date\(date)")
            datePicker.setDate(date, animated: false)
        }
        if let minimumDate = self.datePickerMinimumDate {
            print("selected minimum date\(minimumDate)")
            datePicker.minimumDate = minimumDate
        }
        if let maximumDate = self.datePickerMaximumDate {
            print("selected max date\(maximumDate)")
            datePicker.maximumDate = maximumDate
        }
        datePicker.datePickerMode = pickerMode
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(gesture)
        datePickerBGView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
    }
    
    func set(_ selectedDate:Date?, _ delegate:CustomDatePickerDelegate?, _ tag:Int, _ pickerMode:UIDatePicker.Mode, _ format:String, _ maximumDate:Date?, _ minimumDate:Date?) {
        self.selectedDate = selectedDate
        self.delegate = delegate
        self.tag = tag
        self.pickerMode = pickerMode
        self.format = format
        self.datePickerMinimumDate = minimumDate
        self.datePickerMaximumDate = maximumDate
        print("max:\(maximumDate) min:\(minimumDate) sele:\(selectedDate)")
        self.modalPresentationStyle = .overFullScreen
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.datePickerBGView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.datePickerBGView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: false) {
            self.delegate?.cancelPicker(self.tag)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.string(from: datePicker.date)
        self.delegate?.pickedDate(date: date, tag, datePicker.date)
        print("date picker date \(datePicker.date)")
        self.dismissView()
    }
    
    @objc func dismissView() {
        dismiss(animated:false, completion:nil)
    }
    
}
