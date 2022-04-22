//
//  CoreDataHelper.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import Foundation
import CoreData
import UIKit
class CoreDataHelper {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = CoreDataHelper()

    
    func initializeCart()-> Order? {
       
        do {
            // fetch existing Order
            var order = try fetchOrder()
            if( order == nil) {
                // if no existing order , create new one
               let Neworder = Order(context: context)
                Neworder.address = "";
                Neworder.orderId = 1
                Neworder.orderdate = Date()
                try context.save()
                order = try fetchOrder()
            }
            
            return order
        }
        catch {
            // Handle Error
            return nil
        }
    }
    func fetchOrder()throws -> Order?  {
        let fetchRequest = NSFetchRequest<Order>(entityName: "Order")

        let orderArray = try context.fetch(fetchRequest)
        if ( orderArray.count > 0){
            return orderArray.first
        }
        return nil
    }
    func getEntityCount() -> Int {
        let fetchRequest = NSFetchRequest<Order>(entityName: "OrderDetail")
        do {
            let orderCount =  try context.count(for: fetchRequest)
            return orderCount
        }catch (let error){
            return 0
        }

    }
    func insertProduct(productToAdd:Product,quantity: Int32 )  {
        let productEntitiy = OrderProduct(context: context)
        productEntitiy.name = productToAdd.name
        productEntitiy.id = Int64(productToAdd.id)
        productEntitiy.amount = productToAdd.amount
        productEntitiy.image = productToAdd.image
        productEntitiy.desp = productToAdd.description
        
        let orderdetail = OrderDetail(context: context)
        orderdetail.orderproduct = productEntitiy
        orderdetail.quantity = quantity
                
        do {
            
            //Check if there is existing order
            var order =   try fetchOrder()
            
            if( order == nil) {
                //if not, create order
                order = initializeCart()
            }
            
            if((order) != nil && order?.orderdetail != nil){
                //find existing order and update
                guard let orderDetailarr = order?.orderdetail else { return  }
                var existingProduct : OrderDetail?
                for p in orderDetailarr{
                    var  product = p as! OrderDetail
                    if(Int( product.orderproduct!.id ) == productToAdd.id){
                        product.quantity = product.quantity + quantity
                        existingProduct = product
                        break
                    }
                }
                //no existing order, add new one 
                if ( existingProduct == nil ){
                    order?.addToOrderdetail(orderdetail)
                }
                
                
            }
           try context.save()
        }
        catch {
            // Handle Error
        }
    }
    func deleteOrder()  throws{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Order")
        let deleteOrderRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        let fetchDetailRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OrderDetail")
        let deleteOrderDetailRequest = NSBatchDeleteRequest(fetchRequest: fetchDetailRequest)

        
        let fetchOrderProductRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OrderProduct")
        let deleteOrderProductRequest = NSBatchDeleteRequest(fetchRequest: fetchOrderProductRequest)
        try context.execute(deleteOrderRequest)
        try context.execute(deleteOrderDetailRequest)
        try context.execute(deleteOrderProductRequest)
        
    }
    func updateAddress(address: String) throws {
        let fetchRequest = NSFetchRequest<Order>(entityName: "Order")
        let orders = try context.fetch(fetchRequest)
        if(orders.count > 0){
            let order = orders[0]
            order.address = address
        }
        try context.save()
        
    }
}
