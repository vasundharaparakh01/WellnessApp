//
//  CoachResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 22/11/22.
//

import Foundation

struct CoachResponse: Decodable
{
    let status: String?
    let data: Datas?
    let details: [Deatails]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case data
        case details
        
       
    }
}

struct Datas: Decodable
{
    let coachname: String?
    let coachemail: String?
    let coachId: String?
    let coachMobileno: String?
    let quote: Ouote?
    let quotesArray: [quoteNew]?
   
    
    enum CodingKeys: String, CodingKey{
        
        case coachname
        case coachemail
        case coachId
        case coachMobileno
        case quote
        case quotesArray
    }
}
struct Ouote: Decodable
{
    
    let quote: String?
    let authorName: String?
    
    enum CodingKeys: String, CodingKey{
        
        case quote
        case authorName
    }
}

struct Deatails: Decodable
{
    let _id: String?
    let sessionName: String?
    let sessionStarttime: String?
    let sessionEndtime: String?
    let assignOn: String?
    let ctgryId: String?
    let agoraAccessToken: String?
    let agoraAppId: String?
    let chennelName: String?
    
    enum CodingKeys: String, CodingKey
    {
        case _id
        case sessionName
        case sessionStarttime
        case sessionEndtime
        case assignOn
        case ctgryId
        case agoraAccessToken
        case agoraAppId
        case chennelName
    }
    
}

struct quoteNew: Decodable
{
    let quote: String?
    let authorName: String?
//    let sessionStarttime: String?
//    let sessionEndtime: String?
//    let assignOn: String?
//    let ctgryId: String?
//    let agoraAccessToken: String?
//    let agoraAppId: String?
//    let chennelName: String?
    
    enum CodingKeys: String, CodingKey
    {
        case quote
        case authorName
//        case sessionStarttime
//        case sessionEndtime
//        case assignOn
//        case ctgryId
//        case agoraAccessToken
//        case agoraAppId
//        case chennelName
    }
    
}

