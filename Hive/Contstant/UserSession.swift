//
//  UserSession.swift
//  Hive
//
//  Created by seintsan on 20/4/22.
//

import Foundation

class UserSession {
    
    static let shared = UserSession()

    private var sharedToken = ""
    
    var token :String {
        get {
            if sharedToken.isEmpty {
                sharedToken = KeychainHelper.standard.getBearToken()
            }
            return sharedToken
            
        }
        set{
            sharedToken = newValue
            let data = Data(sharedToken.utf8)
            KeychainHelper.standard.save(data, service: "access-token", account: "hive")
            
        }
    }
    
}
