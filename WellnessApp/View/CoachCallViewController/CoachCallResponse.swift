//
//  CoachCallResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 03/01/23.
//

import Foundation

struct CoachCallResponse: Decodable
{
    let status: String?
    let message: String?
    let results: ResultDatacall?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case results
       
    }
}

struct ResultDatacall: Decodable
{
    let _id: String?
    let sessionId: String?
    let date: String?
    let callStatus: String?
    let callStartedOn: String?
    let callStartedBy: String?
    let callEndedOn: String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id
        case sessionId
        case date
        case callStatus
        case callStartedOn
        case callStartedBy
        case callEndedOn
    }
}
