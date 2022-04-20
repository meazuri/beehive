//
//  DataRepository.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import Foundation
class DataRepository {
    static let shared = DataRepository()
    fileprivate let basedURLString = "https://assessment-api.hivestage.com"

    let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzZWludHNhbiIsImF1dGgiOiJST0xFX1VTRVIiLCJpYXQiOjE2NTAzODAxNDAsImV4cCI6MTY1MDk4NDk0MH0.4EUE-mj_0oClLgEVOi5LXUxOmdUMLR_x6mkvaOORc4LTf7eqq2lmDVwl4N_2FeP67m0KENK6PKh5Xzmp2AmAFw"
    
    func createURLComponents(path: String ) -> URLComponents{
        var component = URLComponents()
        component.scheme="https"
        component.host="assessment-api.hivestage.com"
        //component.port = 5000
        component.path = path
    
        
    
        
        return component
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
        
        var getUrlRequest = URLRequest(url: composedURL)
        getUrlRequest.httpMethod = "GET"
//        getUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // the request is JSON
        getUrlRequest.setValue("*", forHTTPHeaderField: "accept")
        getUrlRequest.setValue(token
, forHTTPHeaderField: "Authorization")

        
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
                completion(.failure(error!))

            }
            
           
        }.resume()
    }
    func login(parameters: LoginRequest ,completion:@escaping(Result<LoginResponse,Error>  ) -> Void) {
        
        let component = createURLComponents(path:"/api/auth/login")
        print(component.url)
       
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
            let StringData = String(data: loginData,encoding: .utf8)
            print(StringData)
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
                completion(.failure(error!))

            }
            
        }.resume()

    }
}
