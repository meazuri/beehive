//
//  ProductResponse.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation

struct ProductResponse: Decodable {
    var page : Int
    var size : Int
    var totalElements : Int
    var last : Bool
    var content : [Product]
    
    enum CodingKeys: String,CodingKey {
        case page,size,totalElements,last,content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.size = try container.decode(Int.self, forKey: .size)
        self.totalElements = try container.decode(Int.self, forKey: .totalElements)
        self.last = try container.decode(Bool.self, forKey: .last)
        self.content = try container.decode([Product].self, forKey: .content)


    }
}
