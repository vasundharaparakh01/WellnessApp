//
//  ExerciseStatRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 16/11/21.
//

import Foundation

struct ExerciseStatRequest: Encodable {
    let startDate: String?
    let endDate: String?
    let device_cat: String?
}
