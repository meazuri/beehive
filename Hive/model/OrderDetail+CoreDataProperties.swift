//
//  OrderDetail+CoreDataProperties.swift
//  
//
//  Created by seintsan on 21/4/22.
//
//

import Foundation
import CoreData


extension OrderDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderDetail> {
        return NSFetchRequest<OrderDetail>(entityName: "OrderDetail")
    }

    @NSManaged public var quantity: Int32
    @NSManaged public var order: Order?
    @NSManaged public var orderproduct: OrderProduct?

}
