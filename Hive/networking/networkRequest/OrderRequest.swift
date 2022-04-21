//
//  OrderRequest.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import Foundation
struct OrderRequest : Encodable, Decodable{
    var orderNumber: String = ""
    var subTotal : Double
    var tax: Double
    var total: Double
    var orderEntries: [OrderEntity]
    enum CodingKeys: String, CodingKey {
        case orderNumber,subTotal,tax,total,orderEntries
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(subTotal, forKey: .subTotal)
        try container.encode(tax, forKey: .tax)
        try container.encode(total, forKey: .total)
        try container.encode(orderEntries, forKey: .orderEntries)
    

    }
    init(subTotal: Double,tax: Double,total: Double,orderEntries: [OrderEntity]) {
        self.subTotal = subTotal
        self.tax = tax
        self.total = total
        self.orderEntries = orderEntries
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderNumber = try container.decode(String.self, forKey: .orderNumber)
        self.subTotal = try container.decode(Double.self, forKey: .subTotal)
        self.tax = try container.decode(Double.self, forKey: .tax)
        self.total = try container.decode(Double.self, forKey: .total)
        self.orderEntries = try container.decode([OrderEntity].self, forKey: .orderEntries)
        
    }
}
