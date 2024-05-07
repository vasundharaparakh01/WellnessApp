//
//  ChakraAnswerResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 23/09/21.
//

import Foundation

struct ChakraAnswerResponse: Decodable {
    let status: String?
    let message: String?
    let chakra: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case chakra
    }
}
