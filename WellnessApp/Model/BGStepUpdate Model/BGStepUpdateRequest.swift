//
//  BGStepUpdateRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/11/21.
//

import Foundation

struct BGStepUpdateRequest: Encodable {
//    let targetSteps: String?
    var targetTime: String?
    let completedTime: String?
    var type: String?
    let steps: String?
    let miles: String?
    let gpsDistance: String?
    let device_cat: String?
    let device_type: String?
}
