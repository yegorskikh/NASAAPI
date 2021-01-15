//
//  ModelAPOTD.swift
//  NASAAPI
//
//  Created by Егор Горских on 16.12.2020.
//

import Foundation

struct APOTDModel: Codable {
    
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    var date: String
    
    private var mediaType: String
    
    enum Keys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
        case date
    }
    
    var isImage: Bool {
        return mediaType == "image"
    }
    
    var isVideo: Bool {
        return mediaType == "video"
    }
    
    init(from decoder: Decoder) throws {
        
        let valueContainer = try decoder.container(keyedBy: Keys.self)
        
        self.title = try valueContainer.decode(String.self, forKey: Keys.title)
        self.description = try valueContainer.decode(String.self, forKey: Keys.description)
        self.url = try valueContainer.decode(URL.self, forKey: Keys.url)
        self.copyright = try? valueContainer.decode(String.self, forKey: Keys.copyright)
        self.mediaType = try valueContainer.decode(String.self, forKey: Keys.mediaType)
        self.date = try valueContainer.decode(String.self, forKey: Keys.date)
    }

}
