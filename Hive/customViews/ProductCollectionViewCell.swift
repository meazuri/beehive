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
    
    
}
