//
//  NetworkLayer.swift
//  CanadaFacts
//
//  Created by Kiran Chowdary on 8/5/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//

import Foundation


enum APIError: Swift.Error {
    case networkError
    case jsonDecodingError
}
//Making Network request
struct NetworkAPI {
    
    private let urlString = URL_PATH

    
    public func fetchData(completionHandler: ( @escaping (ResponseResult<FactInfo, APIError>) -> Void)) {
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return completionHandler(.failure(.networkError))
            }
            
            guard
                let data: Data = String(data: data!, encoding: .isoLatin1)?.data(using: .utf8),
                let factObj = try? JSONDecoder().decode(FactInfo.self, from: data)
            
                else {
                    return completionHandler(.failure(.jsonDecodingError))
            }
            
            return completionHandler(.success(factObj))
            
            
            }.resume()
    }
}
