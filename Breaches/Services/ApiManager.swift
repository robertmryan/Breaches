//
//  ApiManager.swift
//  Breaches
//
//  Created by Robert Ryan on 4/18/19.
//  Copyright © 2019 Robert Ryan. All rights reserved.
//

import Foundation

class ApiManager {
    static let shared = ApiManager()
    
    private init() { }
    
    let baseUrl = URL(string: "https://haveibeenpwned.com/api/v2")!
    let breachesExtensionURL = "breaches"
    
    func fetchBreaches(completion: @escaping (Result<[Breach], Error>) -> Void) {
        let url = baseUrl.appendingPathComponent(breachesExtensionURL)
        
        HttpManager.shared.get(url) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let breaches = try decoder.decode([Breach].self, from: data)
                    DispatchQueue.main.async { completion(.success(breaches)) }
                } catch {
                    print(String(data: data, encoding: .utf8) ?? "Unable to retrieve string representation")
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
}
