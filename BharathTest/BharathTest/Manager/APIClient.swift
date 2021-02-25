//
//  APIClient.swift
//  BharathTest
//
//  Created by RAKSYS on 25/02/21.
//

import Foundation

class APIClient {
    
    func makeGenericAPICall<T: Decodable>(url: URL, resultType: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if error == nil && data != nil {
                
                do {
                    
                    let futureWeatherModel =  try JSONDecoder().decode(T.self, from: data!)
                    handler(Result.success(futureWeatherModel))
                    
                } catch {
                    
                    handler(Result.failure(.parsingError))
                }
                
            } else {
                
                handler(Result.failure(.serverError))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    
    case parsingError
    case serverError
}
