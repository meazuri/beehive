//
//  ViewController.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        configureUI()
    }
    
    func configureUI()  {
        let searchImage = UIImage(named: "search")

        let imageIcon = UIImageView(frame: CGRect(x: 5, y: 0, width: searchImage!.size.width, height: searchImage!.size.height))
        imageIcon.image = searchImage
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: searchImage!.size.width, height: searchImage!.size.height)
        contentView.addSubview(imageIcon)
        searchTextField.leftView = contentView
        searchTextField.leftViewMode = .always
    }
}

