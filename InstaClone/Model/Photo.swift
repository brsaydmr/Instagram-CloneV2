//
//  Photo.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    let photoDescription: Description?
    let ownername, iconserver: String?
    let iconfarm: Int?
    let urlN: String?
    let heightN, widthN: Int?
    let urlZ: String?
    let heightZ, widthZ: Int?
    let date_taken: String?

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case photoDescription = "description"
        case ownername, iconserver, iconfarm
        case date_taken
        case urlN = "url_n"
        case heightN = "height_n"
        case widthN = "width_n"
        case urlZ = "url_z"
        case heightZ = "height_z"
        case widthZ = "width_z"
    }
}

extension Photo {
    var buddyIconURL: String? {
        if let iconServer = iconserver,
           let iconFarm = iconfarm,
           let nsid = owner,
           NSString(string: iconServer).intValue > 0 {
            return "http://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(nsid).jpg"
        } else {
            return "https://www.flickr.com/images/buddyicon.gif"
        }
    }
}

// MARK: - Description
struct Description: Codable {
    let content: String?

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

