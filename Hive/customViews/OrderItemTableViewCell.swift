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

}
