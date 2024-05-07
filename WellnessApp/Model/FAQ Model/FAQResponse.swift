//
//  FAQResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import Foundation

struct FAQResponse: Decodable {
    let status: String?
    let faq: [FAQDetails]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case faq
    }
}

struct FAQDetails: Decodable {
    let status: String?
    let faqId: String?
    let question: String?
    let answer: String?
    let add_date: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case faqId
        case question
        case answer
        case add_date
    }
}
