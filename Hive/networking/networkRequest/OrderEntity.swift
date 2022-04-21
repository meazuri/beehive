//
//  OrderEntity.swift
//  Hive
//
//  Created by seintsan on 21/4/22.
//

import Foundation
struct OrderEntity :  Encodable ,Decodable{
    var   productId : Int
    var   productName :String
    var   amount  :Double
    var   quantity: Int
    var   lineTotal :Double
    
    enum CodingKeys: String, CodingKey {
        case productId,productName,amount,quantity,lineTotal
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productId, forKey: .productId)
        try container.encode(productName, forKey: .productName)
        try container.encode(amount, forKey: .amount)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(lineTotal, forKey: .lineTotal)

    }
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.lineTotal = try container.decode(Double.self, forKey: .lineTotal)
        
    }
    init(productId:Int ,productName: String,amount: Double,quantity: Int,lineTotal :Double) {
        self.productId = productId
        self.productName = productName
        self.amount = amount
        self.quantity = quantity
        self.lineTotal = lineTotal
    }
}
