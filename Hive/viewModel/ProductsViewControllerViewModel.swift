//
//  ProductsViewControllerViewModel.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import Foundation
protocol ProductsViewControllerViewModelDelegate : AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String, error: HiveError)

}
final class ProductsViewControllerViewModel {
    private weak var delegate : ProductsViewControllerViewModelDelegate?

    
    private var products : [Product] = []
    private var keyword : String?

    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    private var totalPage = 1;
    
    var page : Int {
        set { self.currentPage = newValue}
        get { return self.currentPage}
    }
    var searchKeyword : String? {
        set { self.keyword = newValue}
        get { return self.keyword}
    }
    var totalCount : Int {
        return total
    }
    
    var currentCount : Int {
        return products.count
    }
    
    func product(at index:Int) -> Product {
        return products[index]
    }
    func addToCart(index : Int) {
        let addToCartProduct = products[index]
        CoreDataHelper.shared.insertProduct(productToAdd: addToCartProduct, quantity: 1)
        
    }
    init(  productsDelegate: ProductsViewControllerViewModelDelegate) {
        self.delegate = productsDelegate
        
        
    }
    func reFetchData()  {
        currentPage = 0
        products = []
        total = 0
        totalPage = 0
        fetchProducts(keyword: self.keyword ?? "")
    }
    func fetchProducts(keyword: String)  {
        var parameters: [String: String] = [:]
        
        parameters["page"] = String(self.currentPage)
        parameters["size"] = String(6)
        
        if(!keyword.isEmpty){
            parameters["name"] = keyword
        }
        
        DataRepository.shared.fetchProducts(parameters: parameters, completion: {(result) in
            
            switch result {
            case .success(let productResponse):
                DispatchQueue.main.async {
                  // 1
                    self.currentPage += 1
                    self.isFetchInProgress = false
                  // 2
                    self.total = productResponse.totalElements
                    self.products.append(contentsOf: productResponse.content)
                    self.totalPage = productResponse.totalPages
                    
                  
                  // 3
                    if productResponse.page > 0 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: productResponse.content)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                    self.delegate?.onFetchCompleted(with: .none)
                  }
                }
                
            case .failure(let error ):
                print(error)
                
                if let hivError = error as? HiveError {
                    switch hivError {
                    case .invalidCredentials:
                        KeychainHelper.standard.delete(service: "access-token", account: "hive")
                        
                        DispatchQueue.main.async {
                          self.isFetchInProgress = false
                            self.delegate?.onFetchFailed(with: error.localizedDescription,error: hivError)
                        }
                        
                    default:
                        print(error)

                    }

                }else{
                    print(error)

                }
            }
        })
        
    }
    
    private func calculateIndexPathsToReload(from newProducts: [Product]) -> [IndexPath] {
      let startIndex = products.count - newProducts.count
      let endIndex = startIndex + newProducts.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
