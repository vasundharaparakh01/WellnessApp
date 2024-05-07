//
//  Welcom2RequestModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/09/21.
//

import Foundation

struct Welcome2AnswerRequest: Encodable {
    var questionId, answerId, answer: String?
}
