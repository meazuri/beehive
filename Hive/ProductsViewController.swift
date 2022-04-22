//
//  ViewController.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import UIKit
import Kingfisher

class ProductsViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UICollectionViewDataSourcePrefetching,AlertDisplayer, ProductsViewControllerViewModelDelegate  {
    
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    private var viewModel: ProductsViewControllerViewModel!
    private var shouldShowLoadingCell = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProductsViewControllerViewModel(productsDelegate: self)
        
        loadingIndicator.color = ColorPalette.Purple
        loadingIndicator.startAnimating()
        
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self

        searchTextField.delegate = self
        
        viewModel.fetchProducts(keyword: "")
        addBadge()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        addBadge()

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.searchTextField) {
            textField.resignFirstResponder()
            
            let keyword = String(textField.text!)
            viewModel.searchKeyword = keyword
            viewModel.reFetchData()
            
            return false;
        }
        return true;

    }
    
    
    
    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(viewModel.currentCount  )
        print( viewModel.totalCount)
        if( indexPaths.contains(where: isLoadingCell)){
            
            print("API calling ")
            let keyword = String(self.searchTextField.text!)

            viewModel.fetchProducts(keyword: keyword)
            print("End API calling ")

        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //return self.products.count
        return viewModel.totalCount

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
             fatalError("The dequeued cell is not an instance of CityCollectionViewCell.")
         }
        
        if isLoadingCell(for: indexPath) {
           cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.product(at: indexPath.row))
            cell.addButton.tag = indexPath.row
            cell.addButton.addTarget(self, action: #selector(addProduct(_:)), for: .touchUpInside)

        }
        
        
        return cell
    }
    
    @objc func addProduct(_ sender:UIButton)  {
        
        print("buttonPressed ! \(sender.tag)")
        viewModel.addToCart(index: sender.tag)
        addBadge()

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width
        let flowayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowayout.minimumInteritemSpacing
        let adjustedWidth = collectionViewWidth - (spaceBetweenCells + 20)

        let width: CGFloat = adjustedWidth / 2

        return CGSize(width: width, height: width)

    }
    
    // MARK: - Delegate
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
          guard let newIndexPathsToReload = newIndexPathsToReload else {
            loadingIndicator.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
            return
          }
          // 2
          let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
         collectionView.reloadItems(at: indexPathsToReload)
    }
    func onFetchFailed(with reason: String) {
        printError(reason: reason)
    }
    
    func onAuthnicationFailed(with error: HiveError)  {
        loadingIndicator.stopAnimating()

        print(error)
            
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
    @IBAction func showCart(_ sender: Any) {
        performSegue(withIdentifier: "cart", sender: nil)
    }
    func addBadge()  {
        print(viewModel.orderInCard)
        if(viewModel.orderInCard > 0) {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height:  40))
        customView.backgroundColor = .clear
        let shoppingCartImg = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        shoppingCartImg.setImage(UIImage(named: "purplecart"), for: .normal)
        shoppingCartImg.addTarget(self, action: #selector(self.showCart), for: .touchUpInside)

        
        customView.addSubview(shoppingCartImg)
        // we can also add this way
//        let itemInCart = UIButton(frame: CGRect(x: 20, y: 12, width: 14, height: 14))
//        itemInCart.layer.cornerRadius = 7
//        itemInCart.backgroundColor = .red
//        customView.addSubview(itemInCart)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: customView)
        }else {
            let button = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(self.showCart))
            button.tintColor = ColorPalette.Purple

            self.navigationItem.rightBarButtonItem = button

        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
                  
        switch (segue.identifier ?? "") {
            case "productDetail":
                guard let selectedProductCollectionCell = sender as? ProductCollectionViewCell  else {
                    fatalError("Unexpected sender: \(String(describing: sender))")}
                guard let indexPath = collectionView.indexPath(for: selectedProductCollectionCell) else {
                    fatalError("The selected cell is not being displayed by the table")}
                                           
                guard let productDetailController = segue.destination as? ProductDetailViewController else{
                                     fatalError("Unexpected destination: \(segue.destination)")
                          }
                let selectedProduct = viewModel.product(at: indexPath.row)
                productDetailController.selectedProduct = selectedProduct
        case "cart":
            guard let destinationController = segue.destination as? OrderViewController else{
                                 fatalError("Unexpected destination: \(segue.destination)")
                      }
                
                  default:
                      fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

                  }
    }
}
private extension ProductsViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
