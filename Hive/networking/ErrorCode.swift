//
//  ErrorCode.swift
//  Hive
//
//  Created by seintsan on 20/4/22.
//

import Foundation
enum HiveError: Error {
    case unknownError
    case invalidCredentials
    case invalidRequest(errorNo : Int)
    case notFound
   
    
    static func checkErrorCode(_ errorCode: Int) -> HiveError {
            switch errorCode {
            case 403:
                return .invalidCredentials
            case 502:
                return .invalidRequest(errorNo:502)
            case 404:
                return .notFound
            //bla bla bla
            default:
                return .unknownError
            }
        }

 }
