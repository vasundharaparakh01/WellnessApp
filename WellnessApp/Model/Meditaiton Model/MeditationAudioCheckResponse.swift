//
//  MeditationAudioCheckResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 07/12/21.
//

import Foundation

struct MeditationAudioCheckResponse: Decodable {
    let status: String?
    let message: String?
    let userPoints: Int?
    let musics: [AudioCheckMusic]?
            
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case userPoints
        case musics
    }
}

struct AudioCheckMusic: Decodable {
    let musicId: String?
    let meditationId: String?
    let chakraId: String?
    let exerciseId: String?
    let musicName: String?
    let completed: Int?
    
    enum CodingKeys: String, CodingKey {
        case musicId
        case meditationId
        case chakraId
        case exerciseId
        case musicName
        case completed
    }
}
