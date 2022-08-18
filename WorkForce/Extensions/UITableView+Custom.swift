//
//  UITableView+Custom.swift
//  meetwise
//
//  Created by hitesh on 30/09/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit

internal extension UITableView {
    
    func registerCell(identifier: String) {
        self.register(UINib(nibName:identifier, bundle:nil), forCellReuseIdentifier: identifier)
    }
    
    func setBackgroundView(message: String) {
        let label = UILabel()
        label.text = message
        label.textColor = .black
        label.textAlignment = .center
        label.frame = self.bounds
        label.numberOfLines = 10
        label.font = UIFont.setCustom(.Poppins_Medium, 16)
        label.center = CGPoint(x: self.center.x, y: self.center.y)
        self.backgroundView = label
    }
    
    func tableHeader(with view:UIView) {
        let headerView = UIView()
        headerView.frame = view.bounds
        headerView.addSubview(view)
        self.tableHeaderView = headerView
    }
    
    func tableFooter(with view:UIView?) {
        let headerView = UIView()
        headerView.frame = view!.bounds
        headerView.addSubview(view!)
        self.tableFooterView = headerView
    }
    
    func insertRow(indexPath:IndexPath) {
        self.beginUpdates()
        self.insertRows(at: [indexPath], with: .none)
        self.endUpdates()
    }
    
    func insertRows(indexPaths:[IndexPath]) {
        self.beginUpdates()
        self.insertRows(at: indexPaths, with: .none)
        self.endUpdates()
    }
    
    func reload(row:Int, animation: UITableView.RowAnimation = .automatic) {
        self.reloadRows(at: [IndexPath(row: row, section: 0)], with: animation)
    }
    
    func reload(indexPath:IndexPath, animation: UITableView.RowAnimation = .automatic) {
        self.reloadRows(at: [indexPath], with: animation)
    }
    
    func reload(section: Int, animation: UITableView.RowAnimation = .automatic) {
        self.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    
    func sizeHeaderToFit() {
        if let headerView = tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    func addRefreshControl(refresh: @escaping(RefreshCallback)) {
        let refreshControl = RefreshControl()
        refreshControl.callback = refresh
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refresh: RefreshControl) {
        refresh.callback?(refresh)
    }
    
    var scrollToBottom: Void {
        let section = self.numberOfSections-1
        let row = self.numberOfRows(inSection: section)-1
        let indexPath = IndexPath(row: row, section: section)
        print("indexpath is ******* \(indexPath)")
        guard section != -1 , row != -1 else {return}
        self.scrollToRow(at: indexPath, at: .none, animated: false)
    }
    

}

extension UITableViewCell {
    // Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
    
    var indexPath:IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
