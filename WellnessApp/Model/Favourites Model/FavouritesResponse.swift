//
//  FavouritesResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 27/10/21.
//

import Foundation

struct FavouritesResponse: Decodable {
    let status: String?
    let message: String?
    let detail: FavouriteDetail?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
    }
}

struct FavouriteDetail: Decodable {
    let userId: Int?
    let musicId: String?
    let musicType: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case musicType
    }
}
