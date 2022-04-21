//
//  Order+CoreDataProperties.swift
//  
//
//  Created by seintsan on 21/4/22.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var address: String?
    @NSManaged public var orderdate: Date?
    @NSManaged public var orderId: Int64
    @NSManaged public var orderdetail: NSSet?

}

// MARK: Generated accessors for orderdetail
extension Order {

    @objc(addOrderdetailObject:)
    @NSManaged public func addToOrderdetail(_ value: OrderDetail)

    @objc(removeOrderdetailObject:)
    @NSManaged public func removeFromOrderdetail(_ value: OrderDetail)

    @objc(addOrderdetail:)
    @NSManaged public func addToOrderdetail(_ values: NSSet)

    @objc(removeOrderdetail:)
    @NSManaged public func removeFromOrderdetail(_ values: NSSet)

}
