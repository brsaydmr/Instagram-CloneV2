//
//  Api.swift
//  InstaClone
//
//  Created by Barış Aydemir on 7.11.2023.
//

import Foundation

struct API {
    static let flickrBaseURL = "https://www.flickr.com/services/rest/"
    static let apiKey = "7dd89640e14551c5df5f7bbae1f68223"
    
    static func getRecentPhotosURL(page: Int, perPage: Int) -> String {
        return flickrBaseURL
    }
    
    static func getRecentPhotosParameters(page: Int, perPage: Int) -> [String: Any] {
        return [
            "method": "flickr.photos.getRecent",
            "api_key": apiKey,
            "format": "json",
            "nojsoncallback": 1,
            "extras": "description,date_taken,owner_name,icon_server,url_n,url_z",
            "page": page,
            "per_page": perPage
        ]
    }
}
