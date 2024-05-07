//
//  LiveCallJoinResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 28/02/23.
//

import Foundation
struct LiveCallJoinResponse: Decodable
{
    
    let status: String?
    let results: LiveCallDetails?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case results
    }
    
    
}

struct LiveCallDetails: Decodable
{
    let _id: String?
  //  let callExitedOn: String?
  //  let callId: String?
  //  let callJoinedBy: String?
  //  let callJoinedOn: String?
  //  let callJoinedStatus: String?
 //   let date: Bool?
 //   let hand: Bool?
  //  let sessionId: Bool?
 //   let voice: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        
        case _id
  //      case callExitedOn//
  //      case callId
  //      case callJoinedBy
  //      case callJoinedOn
   //     case callJoinedStatus
   //     case date
   //     case hand
   //     case sessionId
   //     case voice
    }
    
    
}
