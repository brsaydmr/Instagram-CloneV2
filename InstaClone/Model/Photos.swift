//
//  Photos.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import Foundation

struct Photos: Codable {
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    var photo: [Photo]?
}
