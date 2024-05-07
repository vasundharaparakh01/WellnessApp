//
//  MeditationAudioResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 23/10/21.
//

import Foundation

//struct MeditationAudioResponse: Decodable {
//    let message: String?
//    let musics: [MeditationMusics]?
//    let status: String?
//    let userPoints: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case message
//        case musics
//        case status
//        case userPoints
//    }
//}
struct MeditationAudioResponse: Decodable {
    let message: String?
    let musics: [MeditationMusics]?
    let videos: [SoothingVideosList]?
    let status: String?
    let userPoints: Int?
    
    enum CodingKeys: String, CodingKey {
        case message
        case musics
        case videos
        case status
        case userPoints
    }
}

struct MeditationMusics: Decodable {
    let add_date: String?
    let chakraId: String?
    let completed: [CompletedMeditationAudio]?
    let description: String?
    let duration: String?
    let exerciseId:String?
    let favorites: [FavouritesMeditationAudio]?
    let meditationId: String?
    let musicFile: String?
    let musicId: String?
    let musicImg: String?
    let musicName: String?
    let musicType: String?
    let pointDuration: Int?
    let seen: [SeenMeditationAudio]?
    let step1: String?
    let step2: String?
    let step3: String?
    let step4: String?
    let unlock_points: Int?
    let open: Int?
    let musicLocation: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case add_date
        case chakraId
        case completed
        case description
        case duration
        case exerciseId
        case favorites
        case meditationId
        case musicFile
        case musicId
        case musicImg
        case musicName
        case musicType
        case pointDuration
        case seen
        case step1
        case step2
        case step3
        case step4
        case unlock_points
        case open
        case musicLocation
        case location
    }
}

struct FavouritesMeditationAudio: Decodable {
    let userId: Int?
    let musicId: String?
    let musicType: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case musicType
    }
}

struct CompletedMeditationAudio: Decodable {
    let userId: Int?
    let musicId: String?
    let listenMin: Int?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case listenMin
        case add_date
    }
}

struct SeenMeditationAudio: Decodable {
    let userId: Int?
    let musicId: String?
    let listenMin: Int?
    let listen_date: String?
    let listen_time: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case musicId
        case listenMin
        case listen_date
        case listen_time
    }
}
