//
//  CoachRemoveUserModel.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 05/03/23.
//

import Foundation
protocol CoachCallUserRemoveDelegate {

        func didReceiveCoachCallUserRemoveResponse(removeResponse: CoachUserRemoveResponse?)
        func didReceiveCoachCallUserRemoveError(statusCode: String?)
    }

struct CoachRemoveUserModel
{
    var CoachRemoveDelegate : CoachCallUserRemoveDelegate?

        func postCoachRemoveData(Request: Coachuserremoverequest, token: String) {
            let url = URL(string: Common.WebserviceAPI.coachCallUserMute)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(Request)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: CoachUserRemoveResponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.CoachRemoveDelegate?.didReceiveCoachCallUserRemoveResponse(removeResponse: result)
                        } else {
                            debugPrint(error!)
                            self.CoachRemoveDelegate!.didReceiveCoachCallUserRemoveError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }

}
