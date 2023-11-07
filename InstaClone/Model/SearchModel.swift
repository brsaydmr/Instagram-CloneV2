//
//  SearchModel.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import Foundation

class SearchModel {
    var userName:String?
    var userPP:String?
    var post:String?
    var postLike:Int?
    var userComment:String?
    
    init(userName: String, userPP: String, post: String, postLike: Int, userComment: String) {
        self.userName = userName
        self.userPP = userPP
        self.post = post
        self.postLike = postLike
        self.userComment = userComment
    }
    
    init() {
        
    }
}
