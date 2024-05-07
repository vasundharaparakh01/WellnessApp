//
//  SoothingVideosListResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 27/10/21.
//

import Foundation

struct SoothingVideosListResponse: Decodable {
    let status: String?
    let musics: [SoothingVideosList]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case musics
    }
}
            
struct SoothingVideosList: Decodable {
    let musicId: String?
    let musicType: String?
    let musicName: String?
    let musicFile: String?
    let musicImg: String?
    let description: String?
    let duration: String?
    let add_date: String?
    let favorites: [SoothingFavourite]?
    let musicLocation: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case musicId
        case musicType
        case musicName
        case musicFile
        case musicImg
        case description
        case duration
        case add_date
        case favorites
        case musicLocation
        case location
    }
}

struct SoothingFavourite: Decodable {
    let userId: Int?
    let musicId: String?
    let musicType: String?
    
    enum CodingKeys: String, CodingKey {
       case userId
       case musicId
       case musicType
   }
}
