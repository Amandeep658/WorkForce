//
//  BusinessHmVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 29/08/22.
//

import UIKit

class BusinessHmVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var homeSegmentController: UISegmentedControl!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var jobView: UIView!
    var  currentIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeSegmentController.selectedSegmentIndex = self.currentIndex
        homeSegmentController.addTarget(self, action: #selector(BusinessHmVC.indexChanged(_:)), for: .valueChanged)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        self.currentIndex = sender.selectedSegmentIndex
        if homeSegmentController.selectedSegmentIndex == 0 {
            self.parentView.isHidden = false
            let board = BusinessHomeViewController()
            self.addCustom(asChildViewController: board, containerView: parentView)
            self.jobView.isHidden = true
        } else if homeSegmentController.selectedSegmentIndex == 1 {
            self.jobView.isHidden = false
            let storyboard = CustomerJobListVC()
            self.addCustom(asChildViewController: storyboard, containerView: jobView)
            self.parentView.isHidden = true
        }else{

        }
    }

//    MARK: UPDATES
    func uiConfigure(){
        // selected option color
        self.homeSegmentController.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        // color of other options
        self.homeSegmentController.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        let board = BusinessHomeViewController()
        self.addCustom(asChildViewController: board, containerView: parentView)
        self.jobView.isHidden = true
        self.parentView.isHidden = false
        self.homeSegmentController.backgroundColor = .white
    }
}
extension UIViewController{
    //MARK:- Handle Child View controllers
     func addCustom(asChildViewController viewController: UIViewController, containerView: UIView) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.backgroundColor = .clear
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func customRemoveAllChildViewControllers(){
        children.forEach({
          $0.willMove(toParent: nil)
          $0.view.removeFromSuperview()
          $0.removeFromParent()
        })
    }
    
     func removeCustom(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}
