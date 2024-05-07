//
//  CoachCallUserMute.swift
//  Luvo
//
//  Created by BEASiMAC on 11/01/23.
//

import Foundation
protocol CoachCallUserMuteModelDelegate {
    
        func didReceiveCoachCallUserMuteModelResponse(muteResponse: coachCallUserMuteResponse?)
        func didReceiveCoachCallUserMuteModelError(statusCode: String?)
    }

struct CoachCallUserMute
{
    var CoachCallUserMuteDelegate : CoachCallUserMuteModelDelegate?
    
        func postCoachCallUserMuteData(Request: coachCallUserMuteRequest, token: String) {
            let url = URL(string: Common.WebserviceAPI.coachCallUserMute)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(Request)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: coachCallUserMuteResponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.CoachCallUserMuteDelegate?.didReceiveCoachCallUserMuteModelResponse(muteResponse: result)
                        } else {
                            debugPrint(error!)
                            self.CoachCallUserMuteDelegate!.didReceiveCoachCallUserMuteModelError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
}
