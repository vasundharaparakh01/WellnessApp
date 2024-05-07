//
//  GratitudeCategoryResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/10/21.
//

import Foundation

struct GratitudeCategoryResponse: Decodable {
    let status: String?
    let categories: [CategoryList]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case categories
    }
}

struct CategoryList: Decodable {
    let _id: String?
    let categoryId: String?
    let categoryName: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case categoryId
        case categoryName
        case description
    }
}
