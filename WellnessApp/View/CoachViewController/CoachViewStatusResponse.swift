//
//  CoachViewStatusResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 14/12/22.
//

import Foundation


struct CoachViewStatusResponse: Decodable

{
    let status : String?
    let results : DataResults?
   
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case results
       
    }
}

struct DataResults: Decodable
{
    let agoraSId : String?
    let agoraResourceId : String?
    let sessionStatus : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case agoraSId
        case agoraResourceId
        case sessionStatus
        
    }
}
