//
//  HttpManager.swift
//  Breaches
//
//  Created by Robert Ryan on 4/18/19.
//  Copyright © 2019 Robert Ryan. All rights reserved.
//

import Foundation

class HttpManager {
    static let shared = HttpManager()
    
    private init() { }
    
    enum HttpError: Error {
        case invalidResponse(Data?, URLResponse?)
    }
    
    public func get(_ url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HttpError.invalidResponse(data, response)))
                    return
            }
            
            completionBlock(.success(responseData))
        }
        task.resume()
    }
}
