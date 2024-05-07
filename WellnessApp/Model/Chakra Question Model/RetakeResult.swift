//
//  RetakeResult.swift
//  Luvo
//
//  Created by BEASiMAC on 10/06/22.
//

import Foundation

struct RetakeResult: Decodable
{
    let status: String?
    let resultRetake: [RetakeResultdata]?

}

struct RetakeResultdata: Decodable {
    let _id: String?
    let chakraId: String?
    let questionId: String?
    let question: String?
    let options: [RetakeAnswer]?
    let userAnsId: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case chakraId
        case questionId
        case question
        case options
        case userAnsId
    }
}
