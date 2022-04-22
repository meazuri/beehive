//
//  OrderItemTableViewCell.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    @IBOutlet weak var productCodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with item: OrderDetail)  {
        if let product = item.orderproduct {
            guard  let imageURL = URL(string: (product.image)!)
                else {
                    fatalError("Invalid Image Url")

            }
            self.productImageView.kf.setImage(with: imageURL)
            let productId = String(product.id)
            self.productCodeLabel.text = "Product Code :\(String(describing: productId ))"
            self.descriptionLabel.text = "\(item.quantity) X \(String(describing: product.name ?? ""))"
            
            let price = product.amount ?? 0
            let subtotal = Double (item.quantity) * price
            self.subTotalLabel.text = String(subtotal)
        }
    }

}
