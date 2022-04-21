//
//  OrderViewController.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import UIKit

class OrderViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
 
    
    @IBOutlet weak var checkOutButton: UIButton!
    
    @IBOutlet weak var contentVIew: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var stackview: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderId: UILabel!
    var orderItems : [OrderDetail] = []
    var order : Order?
    var orderNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        stackview.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layer.borderWidth = 1
        stackview.layer.borderColor = UIColor.lightGray.cgColor
        
        self.navigationController?.isNavigationBarHidden = false

    }
    func fetchData() {
        
        do {
            let order =  try CoreDataHelper.shared.fetchOrder()
            if (order != nil){
                addressLabel.text = order?.address
                orderId.text = "OrderID - #"
                orderDate.text = "Order Date -\(DateFormatter.localizedString(from: (order?.orderdate)!, dateStyle: .none, timeStyle: .short))"
                let orderDetailarr  = order?.orderdetail?.allObjects as! [OrderDetail]
                orderItems = orderDetailarr
                tableView.reloadData()
                let footer = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil     )?.first as! FooterView
                let result = calculateTotal(orderDetails: orderItems)
                footer.taxLabel.text = String(result.tax)
                footer.totalLabel.text = String(result.grandTotal)
                footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
                tableView.tableFooterView = (footer)
                showCotentView(show : true)
            }else {
                showCotentView(show : false)

            }

        } catch (let error) {
            print(error)
        }
    }
    func showCotentView(show: Bool)  {
        if show {
            contentVIew.isHidden = false
            checkOutButton.isHidden = false
            noDataLabel.isHidden = true
        }else {
            contentVIew.isHidden = true
            checkOutButton.isHidden = true
            noDataLabel.isHidden = true
        }
    }
    @IBAction func checkOut(_ sender: Any) {
        var orderEntites : [OrderEntity] = []
        var total = 0.0
        for item in orderItems {
            guard let product = item.orderproduct else {
                return
            }
            let price = product.amount
            let lineTotal = Double (item.quantity) * price
            total += lineTotal
            
           
            let entity = OrderEntity(productId: Int(product.id), productName: product.name!, amount: product.amount, quantity: Int(item.quantity), lineTotal: lineTotal)
            orderEntites.append(entity)
        }
        let tax = total * 0.05
        let grandTotal = total + tax
        
        let orderRequest = OrderRequest(subTotal: total, tax: tax, total: grandTotal, orderEntries: orderEntites)
        DataRepository.shared.insertOrder(param: orderRequest, completion:  { (result ) in
            
            switch result {
            case .success(let orderResponse) :
                
                print(orderResponse)
                do {
                    try CoreDataHelper.shared.deleteOrder()

                }catch(let error ){
                    print(error)
                }
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextViewController = storyboard.instantiateViewController(identifier: "OrderCompleteViewController") as OrderCompleteViewController
                    nextViewController.orderNo = String(orderResponse.orderNumber)
                    //self.navigationController?.pushViewController(nextViewController, animated: true)
                    self.present(nextViewController, animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                   
                }
            
            case .failure(let error):
                print(error)
            }
            
        
        })
    }
    @IBAction func editAddress(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Hive", message: "Address to Deliver", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Address"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Update", style: .default) { _ in

            // this code runs when the user hits the "save" button

            if let inputName = alertController.textFields![0].text {
               
                do
                {
                 try CoreDataHelper.shared.updateAddress(address: inputName)
                    self.addressLabel.text = inputName
                }
                catch (let error) {
                    print(error)
                }
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)


    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as? OrderItemTableViewCell else {
                 fatalError("The dequeued cell is not an instance of OrderItemTableViewCell.")
             }
        
        let item = self.orderItems[indexPath.row]
        if(item.orderproduct != nil) {
            
            let product = item.orderproduct
            guard  let imageURL = URL(string: (product?.image)!)
                else {
                    fatalError("Invalid Image Url")

            }
            cell.productImageView.kf.setImage(with: imageURL)
            let productId = String(product!.id)
            cell.productCodeLabel.text = "Product Code :\(String(describing: productId ))"
            cell.descriptionLabel.text = "\(item.quantity) X \(String(describing: product?.name ?? ""))"
            
            let price = product?.amount ?? 0
            let subtotal = Double (item.quantity) * price
            cell.subTotalLabel.text = String(subtotal)
            

         }
         return cell
    }

    func calculateTotal(orderDetails : [OrderDetail]) -> (subTotal: Double,tax: Double,grandTotal :Double) {
        
        var total = 0.0
        for  item in orderDetails {
            let price = item.orderproduct?.amount ?? 0
            let subtotal = Double (item.quantity) * price
            total += subtotal
        }
        let subTotal = total
        let tax = total * 0.05
        let grandTotal = subTotal + tax
    
        return (subTotal,tax,grandTotal)
    }
//    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        
//        switch segue.identifier {
//        case "success":
//            guard let destinationController = segue.destination as? OrderCompleteViewController else{
//                                 fatalError("Unexpected destination: \(segue.destination)")
//                      }
//            destinationController.orderNo =
//        default:
//            
//        }
//    }
    

}
