//
//  MeditationLevelResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 19/10/21.
//

import Foundation

struct MeditationLevelResponse: Decodable {
    let chakras: [MeditationLevelChakras]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case chakras
        case status
    }
}

struct MeditationLevelChakras: Decodable {
    let audios: [MeditaionLevelAudios]?
    let chakraId: String?
    let chakraName: String?
    let description: String?
    let orders: Int?
    let videos: [MeditationLevelVideos]?
    
    enum CodingKeys: String, CodingKey {
        case audios
        case chakraId
        case chakraName
        case description
        case orders
        case videos
    }
}

struct MeditaionLevelAudios: Decodable {
    let chakraId: String?
    let description: String?
    let duration: String?
    let meditationId: String?
    let musicFile: String?
    let musicId: String?
    let musicName: String?
    let musicType: String?
    let musicLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case chakraId
        case description
        case duration
        case meditationId
        case musicFile
        case musicId
        case musicName
        case musicType
        case musicLocation
    }
}

struct MeditationLevelVideos: Decodable {
    let chakraId: String?
    let description: String?
    let duration: String?
    let meditationId: String?
    let musicFile: String?
    let musicId: String?
    let musicImg: String?
    let musicName: String?
    let musicType: String?
    let musicLocation: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case chakraId
        case description
        case duration
        case meditationId
        case musicFile
        case musicId
        case musicImg
        case musicName
        case musicType
        case musicLocation
        case location
    }
}


