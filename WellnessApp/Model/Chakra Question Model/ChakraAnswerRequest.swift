//
//  ChakraAnswerRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 23/09/21.
//

import Foundation

struct ChakraAnswerRequest: Encodable {
    let user_id: String?
    let answers: [AnswerData]?
}

struct AnswerData: Encodable {
    let chakraId: String?
    let questionId: String?
    let answerId: String?
}
