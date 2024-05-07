//
//  AgoraCreationResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 11/04/23.
//

import Foundation
struct AgoraCreationResponse : Decodable
{
    let status : String?
    let message : String?
    let result : AgoraResult?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case result
        
    }
}

struct AgoraResult : Decodable
{
    let _id : String?
    let coachId : String?
    let ctgryId : String?
    let agoraAccessToken : String?
    let agoraAppId : String?
    let channelName : String?
    let sessionName : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id
        case coachId
        case ctgryId
        case agoraAccessToken
        case agoraAppId
        case channelName
        case sessionName
        
    }
    
}
