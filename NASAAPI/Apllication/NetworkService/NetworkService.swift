//
//  NetworkingService.swift
//  NASAAPI
//
//  Created by Егор Горских on 11.01.2021.
//

import Foundation

// MARK: Networking for the entire application (not used)

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    public func getData(url: URL, completion: @escaping (Any) -> () ) {
     
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
