//
//  HowToEarnModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-25.
//

import Foundation

struct HowToEarnModel {
    let goal: String?
    let points: String?
    
    init(goal: String?, points: String?) {
        self.goal = goal
        self.points = points
    }
}
