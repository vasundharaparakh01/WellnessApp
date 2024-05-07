//
//  ExerciseFinishRequest.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 10/11/21.
//

import Foundation

struct ExerciseFinishRequest: Encodable {
//    let targetSteps: String?
    var targetTime: String?
    let completedTime: String?
    var type: String?
    let steps: String?
    let miles: String?
    let add_date: String?
    let gpsDistance: String?
    let device_cat: String?
}
