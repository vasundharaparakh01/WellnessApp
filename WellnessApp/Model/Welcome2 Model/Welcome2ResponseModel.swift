//
//  Welcome2ResponseModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/09/21.
//

import Foundation

struct Welcome2QuestionResponse: Decodable {
    let status: String?
    let result: [Welcome2Question]?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case result
        case error
    }
}

struct Welcome2Question: Decodable {
    let _id: String?
    let questionId: String?
    let question: String?
    let status: String?
    let anss: [Welcome2Answer]?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case questionId
        case question
        case status
        case anss
    }
}

struct Welcome2Answer: Decodable {
    let _id: String?
    let answerId: String?
    let questionId: String?
    let answer: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case answerId
        case questionId
        case answer
    }
}

//-----ANSWER
struct Welcome2AnswerResponse: Decodable {
    let status: String?
    let message: String?
    let Response: Response?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case Response
        case error
    }
}

struct Response: Decodable {
    let _id: String?
    let userId: String?
    let questionId: String?
    let answerId: String?
    let answer: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case userId
        case questionId
        case answerId
        case answer
    }
}
