//
//  Product.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation
struct Product  :Decodable{
    
    var name: String
    var id: Int
    var image: String
    var createdDate: String
    var amount : Double
    var description: String
    
    enum CodingKeys : String,CodingKey {
        case id,name,image,createdDate,amount, description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        self.createdDate = try container.decode(String.self, forKey: .createdDate)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.description = try container.decode(String.self, forKey: .description)
        
    }
}
