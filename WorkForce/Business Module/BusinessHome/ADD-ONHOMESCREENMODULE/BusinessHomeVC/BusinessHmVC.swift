//
//  BusinessHmVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 29/08/22.
//

import UIKit
import Alamofire

class BusinessHmVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var homeSegmentController: UISegmentedControl!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var jobView: UIView!
    
    var JObController : UIViewController?
    var workerController : UIViewController?
    var currentIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()

        self.workerController = BusinessHomeViewController()
        
        self.addCustom(asChildViewController: workerController!, containerView: parentView)
        if let controller = self.workerController as? BusinessHomeViewController{
            controller.getLocation()
        }
        self.parentView.isHidden = false
        self.homeSegmentController.selectedSegmentIndex = self.currentIndex
        homeSegmentController.addTarget(self, action: #selector(BusinessHmVC.indexChanged(_:)), for: .valueChanged)
       JObController = CustomerJobListVC()
        if let vc = JObController as? CustomerJobListVC{
            vc.getCurntLocation()
            vc.navigateFrom = "navigateFromCoustomerList"
        }
        self.addCustom(asChildViewController: JObController!, containerView: jobView)
        self.jobView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
       
        self.currentIndex = sender.selectedSegmentIndex
        if homeSegmentController.selectedSegmentIndex == 0 {
            self.updateUI(index: 0)
            if let vc = workerController as? BusinessHomeViewController{
                vc.workerPagination?.pageNum = 1
                vc.getLocation()
            }
           // self.showView1()
            //let board = BusinessHomeViewController()
            //board.getLocation()
            //self.addCustom(asChildViewController: board, containerView: parentView)
        } else if homeSegmentController.selectedSegmentIndex == 1 {
            self.updateUI(index: 1)
            if let vc = JObController as? CustomerJobListVC{
                vc.customerJobListArr?.pageNum = 1
                vc.getCurntLocation()
            }
           // self.showView2()
            //let storyboard = CustomerJobListVC()
            //storyboard.navigateFrom = "navigateFromCoustomerList"
            //self.addCustom(asChildViewController: storyboard, containerView: jobView)
        }else{
            self.customRemoveAllChildViewControllers()
        }
    }
    
    
//    MARK : SHOW / HIDE
        //MARK: Update UI
    func updateUI(index : Int){
        self.parentView.isHidden = index == 0 ? false : true
        self.jobView.isHidden = index == 0 ? true : false

    }
    func showView1() {
        self.jobView.isHidden = true
        self.parentView.isHidden = false
    }

    func showView2() {
        self.parentView.isHidden = true
        self.jobView.isHidden = false
    }

//    MARK: UPDATES
    func uiConfigure(){
        self.homeSegmentController.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.homeSegmentController.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
       
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
