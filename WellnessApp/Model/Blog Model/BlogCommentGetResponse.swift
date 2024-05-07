//
//  BlogCommentGetResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/12/21.
//

import Foundation

struct BlogCommentGetResponse: Decodable {
    let status: String?
    let comments: [BlogComment]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case comments
    }
}

struct BlogComment: Decodable {
    let add_date: String?
    let comments: String?
    let user: [BlogCommentUser]?
    
    enum CodingKeys: String, CodingKey {
        case add_date
        case comments
        case user
    }
}

struct BlogCommentUser: Decodable {
    let userName: String?
    let profileImg: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case userName
        case profileImg
        case location
    }
}
