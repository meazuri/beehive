//
//  ProductCollectionViewCell.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import UIKit

public class ProductCollectionViewCell :UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bookmarkLabel: UIButton!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = addButton.frame.width/2
        productImageView.contentMode = .scaleAspectFit
    }
    
    func configure(with product: Product?) {
      if let product = product {
        
        productNameLabel.alpha = 1
        priceLabel.alpha = 1
        productImageView.alpha = 1
        priceLabel.alpha = 1
        //indicatorView.stopAnimating()
        
        if(!product.image.isEmpty) {
            let url = URL(string: product.image)

            self.productImageView.kf.setImage(with:url)
            self.productImageView.alpha = 0.8
         }
        self.productNameLabel.text = product.name
        self.priceLabel.text = String(product.amount)
        
      } else {
        productNameLabel.alpha = 0
        priceLabel.alpha = 0
        productImageView.alpha = 0
        priceLabel.alpha = 0
        //indicatorView.startAnimating()
      }
    }
}
