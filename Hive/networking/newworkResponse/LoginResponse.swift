//
//  LoginResponse.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation

struct LoginResponse :Decodable {
    var token :String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
        
    }
}
