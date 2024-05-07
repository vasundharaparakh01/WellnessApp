//
//  ChakraQuestionResponseModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/09/21.
//

import Foundation

struct ChakraQuestionResponse: Decodable {
    let status: String?
    let result: [ChakraResult]?
   
    
    enum CodingKeys: String, CodingKey {
        case status
        case result
    }
}

struct ChakraResult: Decodable {
    let _id: String?
    let chakraId: String?
    let questionId: String?
    let question: String?
    let options: [ChakraAnswer]?
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




struct ChakraAnswer: Decodable {
    let _id: String?
    let answerId: String?
    let questionId: String?
    let answer: String?
    let userAnsId: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case answerId
        case questionId
        case answer
        case userAnsId
        
    }
}

struct RetakeAnswer: Decodable {
    let _id: String?
    let answerId: String?
    let questionId: String?
    let answer: String?
    let userAnsId: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case answerId
        case questionId
        case answer
        case userAnsId
        
    }
}
