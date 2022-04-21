//
//  ProductDetailViewController.swift
//  Hive
//
//  Created by seintsan on 20/4/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var customerReviewView: UIView!
    @IBOutlet weak var switchViewSegmentcontrol: UISegmentedControl!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: NSLayoutConstraint!
    
    @IBOutlet weak var productDetailLabel: UILabel!
    
    @IBOutlet weak var Category: UILabel!
    
    var selectedProduct : Product?
    var quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)

        segmentControl.removeBorder()
        segmentControl.addUnderlineForSelectedSegment()
        
        bottomStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bottomStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func bindData()  {
        
        if let productDetail = selectedProduct {
            if(!productDetail.image.isEmpty) {
                
                let url = URL(string: productDetail.image)
                imageView.kf.setImage(with:url)
            }
            
            nameLabel.text = productDetail.name
            amountLabel.text = "\(productDetail.amount) MMK "
            productDetailLabel.numberOfLines = 0
            productDetailLabel.text = productDetail.description
            Category.text = productDetail.createdDate
            quantityLabel.text = String(quantity)
        }
      
        
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func minus(_ sender: Any) {
        if (quantity > 1) {
            quantity = quantity - 1
            quantityLabel.text = String(quantity)
        }
    }
    @IBAction func plus(_ sender: Any) {
        quantity = quantity + 1
        quantityLabel.text = String(quantity)
    }
    @IBAction func addToCart(_ sender: Any) {
        
        CoreDataHelper.shared.insertProduct(productToAdd: selectedProduct!, quantity: Int32(quantity))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(identifier: "OrderViewController") as OrderViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
   
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        segmentControl.changeUnderlinePosition()
        if (sender.selectedSegmentIndex == 0) {
            
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: [.transitionFlipFromLeft],
                animations: {
                    self.customerReviewView.isHidden = true
                    //self.customerReviewView.alpha = 0.0
                    self.detailView.isHidden = false

            })
        }else {
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: [.transitionFlipFromRight],
                animations: {
                    self.detailView.isHidden = true
                    self.customerReviewView.isHidden = false

            })
            
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
