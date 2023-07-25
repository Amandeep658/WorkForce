//
//  InvoiceBillViewVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit
import Alamofire
import PDFKit

class InvoiceBillViewVC: UIViewController {

//    MARK: OUTLETS
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var businessAddressLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
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
    
    @IBOutlet weak var savePDFBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var totalinvoiceLbl: UILabel!
    @IBOutlet weak var billScrollView: UIScrollView!
    
    var UserInvoiceAddressDict = InvoiceCreateModel()
    var invoiceDetail = [InvoiceAddAddressData]()
    var invoiceProductDetail = [Addproduct_drtails]()
    let showPDFView = PDFView()
    var totalValue = 0
    var pdfimageview = UIImageView()
    var setImage = UIImage()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        self.backBtn.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        updateData()
        getInvoiceDetail()
        self.backBtn.isHidden = false
    }
    
    func updateData(){
        self.nameLbl.text = "\(UserInvoiceAddressDict.business_name ?? "")"
        self.businessAddressLbl.text = "\(UserInvoiceAddressDict.business_address ?? "")"
        self.addressLbl.text = "\(UserInvoiceAddressDict.dial_code ?? "") \(UserInvoiceAddressDict.business_phone_number ?? "")"
        self.websiteLbl.text = UserInvoiceAddressDict.website
        self.billingAddressLbl.text = "\(UserInvoiceAddressDict.customer_address ?? ""),\(UserInvoiceAddressDict.customer_city ?? ""),\(UserInvoiceAddressDict.customer_state ?? ""),\(UserInvoiceAddressDict.customer_country ?? "")"
        self.shippingAddressLbl.text = "\(UserInvoiceAddressDict.shipping_address ?? ""),\(UserInvoiceAddressDict.shipping_city ?? ""),\(UserInvoiceAddressDict.shipping_state ?? ""),\(UserInvoiceAddressDict.shipping_country ?? "")"
        self.estimateLbl.text =  "Estimate \(UserInvoiceAddressDict.estimate_no ?? "")"
        self.dateLbl.text = "DATE \(UserInvoiceAddressDict.date ?? "")"
    }
    
    func setTable(){
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(UINib(nibName: "InvoiceBillViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceBillViewCell")
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 4
    }

    @IBAction func savePDFBtn(_ sender: UIButton) {
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
            print("completion==.>>>>>>>>>>>>>>>>>>",activityType,"======",completed,"=====",returnedItems)
            if activityType == .init(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles"){
                self.showAlert(message: "PDF file saved successfully.", title: AppAlertTitle.appName.rawValue) {
                    self.tabBarController?.selectedIndex = 4
                }
            }else{
                self.pdfView.isHidden = false
                self.savePDFBtn.isHidden = false
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    //    MARK: Get Invoice Detail
    func getInvoiceDetail(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["page_no" : "1","per_page" : "40"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getinvoice, params: [:], headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(InvoiceAddAddressModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message
                if status == 1{
                    self.invoiceDetail = aContact.data!
                    self.nameLbl.text = "\(aContact.data?.first?.business_name ?? "")"
                    self.businessAddressLbl.text = "\(aContact.data?.first?.business_address ?? "")"
                    self.addressLbl.text = "\(aContact.data?.first?.dial_code ?? "") \(aContact.data?.first?.business_phone_number ?? "")"
                    self.websiteLbl.text = aContact.data?.first?.website
                    self.billingAddressLbl.text = "\(aContact.data?.first?.customer_address ?? ""),\(aContact.data?.first?.customer_city ?? ""),\(aContact.data?.first?.customer_state ?? ""),\(aContact.data?.first?.customer_country ?? "")"
                    self.shippingAddressLbl.text = "\(aContact.data?.first?.shipping_address ?? ""),\(aContact.data?.first?.shipping_city ?? ""),\(aContact.data?.first?.shipping_state ?? ""),\(aContact.data?.first?.shipping_country ?? "")"
                    self.estimateLbl.text =  "Estimate \(aContact.data?.first?.estimate_no ?? "")"
                    self.dateLbl.text = "DATE \(aContact.data?.first?.date ?? "")"
                    self.invoiceProductDetail = aContact.data?.first?.product_drtails ?? []
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
    
    
    
//    MARK: UIVIEW to PDF
    func createPDF(from view: UIView, completion: @escaping () -> Void) {
           let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
           let outputFileURL = documentDirectory.appendingPathComponent("MyPDF.pdf")
           print("URL:", outputFileURL) // When running on simulator, use the given path to retrieve the PDF file

           let pdfRenderer = UIGraphicsPDFRenderer(bounds: view.bounds)

           do {
               try pdfRenderer.writePDF(to: outputFileURL, withActions: { context in
                   context.beginPage()
                   view.layer.render(in: context.cgContext)
               })
           } catch {
               print("Could not create PDF file: \(error)")
           }
        completion()
       }
    
}
extension InvoiceBillViewVC : UITableViewDelegate, UITableViewDataSource{
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
        self.subtotalLbl.text = "SUBTOTAL: $\(totalValue)"
        self.shippingTaxLbl.text = "SHIPPING/TAX: $\(invoiceDetail.first?.product_drtails?[0].shipping ?? "")"
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
