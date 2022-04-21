//
//  OrderProduct+CoreDataProperties.swift
//  
//
//  Created by seintsan on 21/4/22.
//
//

import Foundation
import CoreData


extension OrderProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderProduct> {
        return NSFetchRequest<OrderProduct>(entityName: "OrderProduct")
    }

    @NSManaged public var amount: Double
    @NSManaged public var desp: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var orderdetail: NSSet?

}

// MARK: Generated accessors for orderdetail
extension OrderProduct {

    @objc(addOrderdetailObject:)
    @NSManaged public func addToOrderdetail(_ value: OrderDetail)

    @objc(removeOrderdetailObject:)
    @NSManaged public func removeFromOrderdetail(_ value: OrderDetail)

    @objc(addOrderdetail:)
    @NSManaged public func addToOrderdetail(_ values: NSSet)

    @objc(removeOrderdetail:)
    @NSManaged public func removeFromOrderdetail(_ values: NSSet)

}
