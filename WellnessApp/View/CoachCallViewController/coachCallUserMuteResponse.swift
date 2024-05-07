//
//  coachCallUserMuteResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 11/01/23.
//

import Foundation
struct coachCallUserMuteResponse : Decodable
{
    
        let status: String?
        let message: String?
        let details: DataDetails?
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case details
       
    }
    
    
}

struct DataDetails: Decodable
{
    let _id: String?
    let sessionId: String?
    let callId: String?
    let callJoinedBy: String?
    let callJoinedOn: String?
    let callExitedOn: String?
    let callJoinedStatus: String?
    let date: String?
    let voice: String?
    let hand: String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id
        case sessionId
        case callId
        case callJoinedBy
        case callJoinedOn
        case callExitedOn
        case callJoinedStatus
        case date
        case voice
        case hand
        
    }
}
