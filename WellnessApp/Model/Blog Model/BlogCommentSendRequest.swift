//
//  BlogCommentSendRequest.swift
 
//
//  Created by BEASMACUSR02 on 25/12/21.
//

import Foundation

struct BlogCommentSendRequest: Encodable {
    let blogId: String?
    let comments: String?
}
