//
//  stepWatchRespone.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 02/08/22.
//

import Foundation
struct stepWatchRespone: Decodable {
    let status: String?
    let message: String?
   
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
