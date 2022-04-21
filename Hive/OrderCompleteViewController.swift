//
//  OrderCompleteViewController.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import UIKit

class OrderCompleteViewController: UIViewController {

    @IBOutlet weak var orderNoLabel: UILabel!
    var orderNo : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if orderNo != nil {
            orderNoLabel.text = "Order No : #\(String(describing: orderNo))"
        }
        
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    @IBAction func close(_ sender: Any) {
        
        //dismissViewControllers()
      
        
    }
    
    func dismissViewControllers() {

        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
