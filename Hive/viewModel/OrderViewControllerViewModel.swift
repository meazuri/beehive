//
//  OrderViewControllerViewModel.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import Foundation
protocol OrderViewControllerViewModelDelegate: AnyObject {
    func onSubmitComplete(with orderNo:String)
    
    func onFailed(with reason:String)
    
    func onAuthnicationFailed(with error: HiveError)

}
final class OrderViewControllerViewModel {
    private weak var delegate: OrderViewControllerViewModelDelegate?
    
    private var orderItems : [OrderDetail] = []
    private var order : Order?
    private var orderNumber: String?
    
    var itemCount : Int {
        return orderItems.count
    }
    func orderItem(at index:Int) -> OrderDetail {
        return orderItems[index]
    }
    
    init(orderDelegate: OrderViewControllerViewModelDelegate) {
        self.delegate = orderDelegate
    }
    
    func fetchOrder() -> Order?{
        
        do {
            let order =  try CoreDataHelper.shared.fetchOrder()
            if( order != nil){
                let orderDetailarr  = order?.orderdetail?.allObjects as! [OrderDetail]
                orderItems = orderDetailarr
            }
            return order

        } catch (let error) {
            print(error)
            return nil
        }
    }
    func updateAddress(address: String) {
        do
        {
         try CoreDataHelper.shared.updateAddress(address: address)
        }
        catch (let error) {
            print(error)
        }
    }
    func checkOut()  {
        var orderEntites : [OrderEntity] = []
        var total = 0.0
        for item in orderItems {
            guard let product = item.orderproduct else {
                return
            }
            let price = product.amount
            let lineTotal = Double (item.quantity) * price
            total += lineTotal
            
           
            let entity = OrderEntity(productId: Int(product.id), productName: product.name!, amount: product.amount, quantity: Int(item.quantity), lineTotal: lineTotal)
            orderEntites.append(entity)
        }
        let tax = total * 0.05
        let grandTotal = total + tax
        
        let orderRequest = OrderRequest(subTotal: total, tax: tax, total: grandTotal, orderEntries: orderEntites)
        DataRepository.shared.insertOrder(param: orderRequest, completion:  { (result ) in
            
            switch result {
            case .success(let orderResponse) :
                
                print(orderResponse)
                do {
                    try CoreDataHelper.shared.deleteOrder()

                    DispatchQueue.main.async {
                        self.delegate?.onSubmitComplete(with: orderResponse.orderNumber)
                    }

                }catch(let error ){
                    print(error)
                    self.onFailed(error: error.localizedDescription)

                }
            
            case .failure(let error):
                if let hivError = error as? HiveError {
                    switch hivError {
                    case .invalidCredentials:
                        KeychainHelper.standard.delete(service: "access-token", account: "hive")
                        DispatchQueue.main.async {
                            self.delegate?.onAuthnicationFailed(with:  hivError)
                        }

                    default:
                        self.onFailed(error: hivError.localizedDescription)

                    }

                }else{
                    self.onFailed(error: error.localizedDescription)

                }
                
            }
            
        
        })
    }
    private func onFailed(error: String){
        print(error)

        DispatchQueue.main.async {
            self.delegate?.onFailed(with: error)

        }
    }
    
    func calculateTotal() -> (subTotal: Double,tax: Double,grandTotal :Double) {
        
        var total = 0.0
        for  item in orderItems {
            let price = item.orderproduct?.amount ?? 0
            let subtotal = Double (item.quantity) * price
            total += subtotal
        }
        let subTotal = total
        let tax = total * 0.05
        let grandTotal = subTotal + tax
    
        return (subTotal,tax,grandTotal)
    }
}
