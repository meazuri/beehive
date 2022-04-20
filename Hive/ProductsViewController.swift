//
//  ViewController.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import UIKit
import Kingfisher

class ProductsViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UICollectionViewDataSourcePrefetching  {
    

    var products : [Product] = []
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self

        searchTextField.delegate = self
        
        fetchProducts(keyword: "")
    }


    override func viewDidAppear(_ animated: Bool) {
        configureUI()
    }
    func fetchProducts(keyword: String)  {
        var parameters: [String: String] = [:]
        
        parameters["page"] = String(0)
        parameters["size"] = String(30)
        
        if(!keyword.isEmpty){
            parameters["name"] = keyword
        }
        
        DataRepository.shared.fetchProducts(parameters: parameters, completion: {(result) in
            
            switch result {
            case .success(let productResponse):
                DispatchQueue.main.async {
                    self.products = productResponse.content
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.searchTextField) {
            textField.resignFirstResponder()
            
            let keyword = String(textField.text!)
            fetchProducts(keyword: keyword)
            
            return false;
        }
        return true;

    }
    
    
    
    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
             fatalError("The dequeued cell is not an instance of CityCollectionViewCell.")
         }
         let product = self.products[indexPath.row]
        if(!product.image.isEmpty) {
            let url = URL(string: product.image)

            cell.productImageView.kf.setImage(with:url)
            cell.productImageView.alpha = 0.8
         }
        cell.productNameLabel.text = product.name
        cell.priceLabel.text = String(product.amount)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addProduct(_:)), for: .touchUpInside)

        
        return cell
    }
    
    @objc func addProduct(_ sender:UIButton)  {
        
        print("buttonPressed ! \(sender.tag)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width
        let flowayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowayout.minimumInteritemSpacing
        let adjustedWidth = collectionViewWidth - (spaceBetweenCells + 20)

        let width: CGFloat = adjustedWidth / 2

        return CGSize(width: width, height: width)

    }
}

