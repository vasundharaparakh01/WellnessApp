//
//  ImageUploadRequestModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 07/10/21.
//

import Foundation

struct ImageUploadRequestModel: Encodable {
    let image: Data
    let fileName: String
    let parameterName: String
}
