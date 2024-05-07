//
//  BackgroundStepUpdateViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/11/21.
//

import Foundation
import UIKit

struct BackgroundStepUpdateViewModel {
    func postBGStepUpdate(BGStepUpdateRequest: BGStepUpdateRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postBGStepUpdate)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(BGStepUpdateRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: BGStepUpdateResponse.self) { (BGStepApiResponse, error) in
                
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
                }
                
//                DispatchQueue.main.async {
//                    if (error == nil) {
////                        steps = 0
////                        totalSteps = 0
////                        distance = 0.0
////                        totalDistance = 0.0
////                        globalStepCounter = 0
//
//                        (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
//
//                    } else {
//                        debugPrint(error!)
//                        (UIApplication.shared.delegate as? AppDelegate)?.startTracking()
//                    }
//                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
