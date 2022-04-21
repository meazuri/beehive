//
//  DataRepository.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation
class DataRepository {
    static let shared = DataRepository()
    func createURLComponents(path: String ) -> URLComponents{
        var component = URLComponents()
        component.scheme="https"
        component.host="assessment-api.hivestage.com"
        component.path = path

        return component
    }
    func insertOrder(param: OrderRequest , completion:@escaping(Result<OrderRequest,Error>)-> Void) {
        let component = createURLComponents(path: "/api/orders")
        guard let composedURL = component.url else {
            print("URL creation failed...")
            return
        }
        var postUrlRequest = URLRequest(url: composedURL)
        let token = UserSession.shared.token

        postUrlRequest.httpMethod = "POST"
        postUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // the request is JSON
        postUrlRequest.setValue("*", forHTTPHeaderField: "accept")
        postUrlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let orderData = try JSONEncoder().encode(param)
            postUrlRequest.httpBody = orderData
            
        }catch {
            print("Encoding Failed")
        }
        URLSession.shared.dataTask(with: postUrlRequest){ (data,response ,error) in
           
            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")

            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(error!))
                return
            }
            if( httpResponse.statusCode == 200 ){
               
                guard let validData = data ,error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                do {
                    print(validData)
                    let orderResponse = try JSONDecoder().decode(OrderRequest.self, from: validData)
                    completion(.success(orderResponse))

                }catch let serializationError {
                    completion(.failure(serializationError))
                }
            }else{
                let hivError = HiveError.checkErrorCode(httpResponse.statusCode)
                completion(.failure(hivError))

            }
            
           
        }.resume()
        
    }
    func fetchProducts( parameters: Dictionary<String,String>,completion:@escaping(Result<ProductResponse,Error>) -> Void) {
        
        var component = createURLComponents(path: "/api/products")
        var queryItems: [URLQueryItem] = []
        
        for (key,value) in parameters {
            queryItems.append(URLQueryItem (name: key, value: value))

        }
        component.queryItems = queryItems

        guard let composedURL = component.url else {
            print("URL creation failed...")
            return
        }
        let token = UserSession.shared.token
        var getUrlRequest = URLRequest(url: composedURL)
        getUrlRequest.httpMethod = "GET"
        getUrlRequest.setValue("*", forHTTPHeaderField: "accept")
        getUrlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: getUrlRequest){ (data,response ,error) in
           
            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")

            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(error!))
                return
            }
            if( httpResponse.statusCode == 200 ){
               
                guard let validData = data ,error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                do {
                    let productResponse = try JSONDecoder().decode(ProductResponse.self, from: validData)
                    completion(.success(productResponse))

                }catch let serializationError {
                    completion(.failure(serializationError))
                }
            }else{
                let hivError = HiveError.checkErrorCode(httpResponse.statusCode)
                completion(.failure(hivError))

            }
            
           
        }.resume()
    }
    func login(parameters: LoginRequest ,completion:@escaping(Result<LoginResponse,Error>  ) -> Void) {
        
        let component = createURLComponents(path:"/api/auth/login")
       
        guard let composedURL = component.url else {
            print("URL creation failed...")
            return
        }
        var postUrlRequest = URLRequest(url: composedURL)
        postUrlRequest.httpMethod = "POST"
        postUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // the request is JSON
        postUrlRequest.setValue("*", forHTTPHeaderField: "accept")
        

        do {
            let loginData = try JSONEncoder().encode(parameters)
            //_ = String(data: loginData,encoding: .utf8)
            postUrlRequest.httpBody = loginData
            
        }catch {
            print("Encoding Failed")
        }
        
    
        URLSession.shared.dataTask(with: postUrlRequest){ (data,response ,error) in
            
            guard let httpREsponse = response as? HTTPURLResponse else {
                completion(.failure(error!))
                return
            }
            if( httpREsponse.statusCode == 200 ){
                guard let validData = data ,error == nil else {
                    completion(.failure(error!))
                    return
                }

                do {
                    let token = try JSONDecoder().decode(LoginResponse.self, from: validData)
                    completion(.success(token))

                }catch let serializationError {
                    completion(.failure(serializationError))
                }
            }else{
                let hivError = HiveError.checkErrorCode(httpREsponse.statusCode)
                completion(.failure(hivError))

            }
            
        }.resume()

    }
}
