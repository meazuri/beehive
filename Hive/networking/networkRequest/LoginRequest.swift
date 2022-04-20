//
//  LoginRequest.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation

struct LoginRequest :Encodable {
    var username: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case username,password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
    }
}
