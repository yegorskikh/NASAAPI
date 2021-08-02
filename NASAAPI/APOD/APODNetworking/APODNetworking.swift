//
//  NetworkingAPOTD.swift
//  NASAAPI
//
//  Created by Егор Горских on 16.12.2020.
//

import Foundation

struct APODNetworking {
    
    func fetchAstronomyPicture(completion: @escaping (APODModel?) -> Void) {
        
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            let jsonDecoder = JSONDecoder()
            if
                let data = data,
                let photoInfo = try? jsonDecoder.decode(APODModel.self, from: data)
            {
                completion(photoInfo)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchUrlData(with url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
}
