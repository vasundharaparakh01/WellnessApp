//
//  BlogListResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 19/10/21.
//

import Foundation

struct BlogListResponse: Decodable {
    let blogs: [BlogList]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case blogs
        case status
    }
}

struct BlogList: Decodable {
    let add_date: String?
    let blogId: String?
    let blog_img: String?
    let description: String?
    let title: String?
    let user: [BlogUser]?
    let likes: Int?
    let tot_likes: Int?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case add_date
        case blogId
        case blog_img
        case description
        case title
        case user
        case likes
        case tot_likes
        case location
    }
}

struct BlogUser: Decodable {
    let userName: String?
    let userId: String?
    
    enum CodingKeys: String, CodingKey {
        case userName
        case userId
    }
}
