//
//  InvoiceGetDetailView.swift
//  WorkForce
//
//  Created by Apple on 07/07/23.
//

import UIKit
import Alamofire
import PDFKit

class InvoiceGetDetailView: UIViewController, UIDocumentInteractionControllerDelegate {

    //    MARK: OUTLETS
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var businessAddressLbl: UILabel!
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
    @IBOutlet weak var pdfScrollView: UIScrollView!
    
    @IBOutlet weak var savePDFBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var totalinvoiceLbl: UILabel!

    var invoiceDetail = [InvoiceAddressData]()
    var invoiceId = ""
    var pdfimageview = UIImageView()
    var setImage = UIImage()
    var totalValue = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInvoiceDetail()
        self.savePDFBtn.isHidden = false
    }
    
    
//    MARK: BUTTON ACTIONS
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func savePdfBtn(_ sender: UIButton) {
        self.savePDFBtn.isHidden = true
        UIGraphicsBeginImageContextWithOptions(pdfView.bounds.size, true, 1.0)
        pdfView.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: pdfView.bounds.size), afterScreenUpdates: true)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            pdfimageview.image = image
            self.setImage = image
        }
        let pdfView = PDFView(frame: view.bounds)
        let pdfDocument = PDFDocument()
        let pdfPage = PDFPage(image: self.setImage)
        pdfDocument.insert(pdfPage!, at: 0)
        pdfView.document = pdfDocument
        pdfView.isHidden = false
        self.savePDFBtn.isHidden = true
        guard let pdfData = pdfDocument.dataRepresentation() else {
            return
        }
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let pdfURL = temporaryDirectory.appendingPathComponent("screenshot.pdf")
        do {
            try pdfData.write(to: pdfURL)
        } catch {
            print("Failed to write PDF file: \(error)")
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            print("completion==.>>>>>>>>>>>>>>>>>>",activityType as Any,"======",completed,"=====",returnedItems as Any)
            if activityType == .init(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles"){
                self.showAlert(message: "PDF file saved successfully.", title: AppAlertTitle.appName.rawValue) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.pdfView.isHidden = false
                self.savePDFBtn.isHidden = false
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
//    MARK: FUNCTIONS
    func setTable(){
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(UINib(nibName: "InvoiceBillViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceBillViewCell")
    }
    
    //MARK: Get Invoice Detail
    func getInvoiceDetail(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["id":"\(invoiceId)"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getinvoice, params: param, headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(InvoicePDFBillModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message
                if status == 1{
                    self.invoiceDetail = aContact.data!
                    self.nameLbl.text =  aContact.data?.first?.invoice_number ?? ""
                    self.businessAddressLbl.text = aContact.data?.first?.business_address ?? ""
                    self.addressLbl.text = "\(aContact.data?.first?.dial_code ?? "") \(aContact.data?.first?.business_phone_number ?? "")"
                    self.websiteLbl.text = aContact.data?.first?.website ?? ""
                    self.billingAddressLbl.text = "\(aContact.data?.first?.customer_address ?? ""),\(aContact.data?.first?.customer_city ?? ""),\(aContact.data?.first?.customer_state ?? ""),\(aContact.data?.first?.customer_country ?? "")"
                    self.shippingAddressLbl.text = "\(aContact.data?.first?.shipping_address ?? ""),\(aContact.data?.first?.shipping_city ?? ""),\(aContact.data?.first?.shipping_state ?? ""),\(aContact.data?.first?.shipping_country ?? "")"
                    self.estimateLbl.text = "Estimate \(aContact.data?.first?.estimate_no ?? "")"
                    self.dateLbl.text = "DATE \(aContact.data?.first?.date ?? "")"
                    self.itemTableView.setBackgroundView(message: "")
                    self.itemTableView.reloadData()
                }
                else {
                    self.itemTableView.setBackgroundView(message: message!)
                    self.itemTableView.reloadData()
                }
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
   
    
}
extension InvoiceGetDetailView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceDetail.first?.product_drtails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceBillViewCell", for: indexPath) as! InvoiceBillViewCell
        cell.itemLbl.text =  invoiceDetail.first?.product_drtails?[indexPath.row].item ?? ""
        cell.quantityLbl.text = invoiceDetail.first?.product_drtails?[indexPath.row].quantity ?? ""
        cell.ratelbl.text = invoiceDetail.first?.product_drtails?[indexPath.row].rate ?? ""
        cell.amountLbl.text = invoiceDetail.first?.product_drtails?[indexPath.row].amount ?? ""

        let amountLabel = invoiceDetail.first?.product_drtails?[indexPath.row].amount ?? ""
        totalValue += Int(amountLabel) ?? 0
        print("totalValue is here >>>",totalValue)
        self.subtotalLbl.text = "SUBTOTAL:  $\(totalValue)"
        self.shippingTaxLbl.text = "SHIPPING/TAX:  $\(invoiceDetail.first?.product_drtails?[0].shipping ?? "")"
        let sumShippingVal = totalValue + (Int(invoiceDetail.first?.product_drtails?[0].shipping ?? "") ?? 0)
        self.totalinvoiceLbl.text = "$\(sumShippingVal)"
       
        DispatchQueue.main.async{
            self.itemHeightConstraint.constant = self.itemTableView.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UIView {
    func screenshot() -> UIImage {

            if(self is UIScrollView) {
                let scrollView = self as! UIScrollView

                let savedContentOffset = scrollView.contentOffset
                let savedFrame = scrollView.frame

                UIGraphicsBeginImageContext(scrollView.contentSize)
                scrollView.contentOffset = .zero
                self.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
                self.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();

                scrollView.contentOffset = savedContentOffset
                scrollView.frame = savedFrame

                return image!
            }

            UIGraphicsBeginImageContext(self.bounds.size)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!

        }
}
