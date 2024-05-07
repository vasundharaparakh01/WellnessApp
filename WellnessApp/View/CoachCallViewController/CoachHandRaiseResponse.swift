//
//  CoachHandRaiseResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 12/01/23.
//

import Foundation

struct CoachHandRaiseResponse : Decodable
{
    
    let status : String?
    let message : String?
    let results : [ResultDataHandRaise]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case results
        
    }
}

struct ResultDataHandRaise : Decodable
{
    let userName : String?
    let userEmail : String?
   // let mobileNo : String?
    let profileImg : String?
    let location : String?
    let callId : String?
    let sessionId : String?
    let callJoinedStatus : String?
    let voice : String?
    let hand : String?
    let userCallId : String?
    
    enum CodingKeys: String, CodingKey {
        
        case userName
        case userEmail
      //  case mobileNo
        case profileImg
        case location
        case callId
        case sessionId
        case callJoinedStatus
        case voice
        case hand
        case userCallId
    }
    
}
