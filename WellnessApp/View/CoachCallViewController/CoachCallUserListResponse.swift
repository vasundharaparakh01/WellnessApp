//
//  CoachCallUserListResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 10/01/23.
//
import Foundation
struct CoachCallUserListResponse : Decodable
{
    let status: String?
    let message: String?
    var results: [ResultUserList]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case results
       
    }
    
}

struct ResultUserList : Decodable
{
    
       let userCallId : String?
       let voice : String?
       let hand : String?
       let sessionId : String?
       let callId : String?
       let callJoinedBy : String?
       let callJoinedOn : String?
       let callExitedOn : String?
       let callJoinedStatus : String?
       let date : String?
       let userId : String?
       let userName : String?
       let userEmail : String?
       let profileImg : String?
       let location : String?
    
    enum CodingKeys: String, CodingKey {
        
        case userCallId
        case voice
        case hand
        case sessionId
        case callId
        case callJoinedBy
        case callJoinedOn
        case callExitedOn
        case callJoinedStatus
        case date
        case userId
        case userName
        case userEmail
        case profileImg
        case location
       
    }
}

