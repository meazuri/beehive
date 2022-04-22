//
//  OrderViewController.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import UIKit

class OrderViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, OrderViewControllerViewModelDelegate,AlertDisplayer{
   
    
    @IBOutlet weak var checkOutButton: UIButton!
    
    @IBOutlet weak var contentVIew: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var stackview: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    private var viewModel: OrderViewControllerViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = OrderViewControllerViewModel(orderDelegate: self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchData();
    }
    override func viewWillAppear(_ animated: Bool) {
        stackview.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layer.borderWidth = 1
        stackview.layer.borderColor = UIColor.lightGray.cgColor
        
        self.navigationController?.isNavigationBarHidden = false

    }
    func fetchData() {
        
            let order =  viewModel.fetchOrder()
            if (order != nil){
                addressLabel.text = order?.address
                orderId.text = "OrderID - #"
                orderDate.text = "Order Date -\(DateFormatter.localizedString(from: (order?.orderdate)!, dateStyle: .none, timeStyle: .short))"
                tableView.reloadData()
                let footer = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil     )?.first as! FooterView
                let result = viewModel.calculateTotal()
                footer.taxLabel.text = String(result.tax)
                footer.totalLabel.text = String(result.grandTotal)
                footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
                tableView.tableFooterView = (footer)
                showCotentView(show : true)
            }else {
                showCotentView(show : false)

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
            noDataLabel.isHidden = false
        }
    }
   
    
    @IBAction func checkOut(_ sender: Any) {
        viewModel.checkOut()
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
                self.viewModel.updateAddress(address: inputName)
                self.addressLabel.text = inputName
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)


    }
   
    // MARK - tableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as? OrderItemTableViewCell else {
                 fatalError("The dequeued cell is not an instance of OrderItemTableViewCell.")
             }
        cell.configure(with: self.viewModel.orderItem(at: indexPath.row))
         return cell
    }

    
    // MARK: OrderViewControllerViewModelDelegate
    func onSubmitComplete(with orderNo: String) {
       
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(identifier: "OrderCompleteViewController") as OrderCompleteViewController
            nextViewController.orderNo = orderNo
            //self.navigationController?.pushViewController(nextViewController, animated: true)
            self.present(nextViewController, animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
           
        
    }
    
    func onFailed(with reason: String) {
        printError(reason: reason)

    }
   
    
    func onAuthnicationFailed(with error: HiveError){
        switch error {
        case .invalidCredentials:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = loginViewController
            
        default:
            print(error)
            printError(reason: error.localizedDescription)
           
        }
    }
    func printError(reason : String){
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])

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
