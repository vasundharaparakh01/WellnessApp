//
//  CoachViewStatusModel.swift
//  Luvo
//
//  Created by BEASiMAC on 14/12/22.
//

import Foundation


protocol CoachViewStatusModelDelegate {
    
        func didReceiveCoachViewStatusModelResponse(coachResponse: CoachViewStatusResponse?)
        func didReceiveCoachViewStatusModelError(statusCode: String?)
    }

struct CoachViewStatusModel
{
    var coachstatDelegate : CoachViewStatusModelDelegate?
    
        func postCoachStatusData(Request: CoachViewStatusRequest, token: String) {
            let url = URL(string: Common.WebserviceAPI.CoachStatusAPI)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(Request)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.PUT, requestBody: postBody, token: token, resultType: CoachViewStatusResponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.coachstatDelegate?.didReceiveCoachViewStatusModelResponse(coachResponse: result)
                        } else {
                            debugPrint(error!)
                            self.coachstatDelegate?.didReceiveCoachViewStatusModelError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
}
