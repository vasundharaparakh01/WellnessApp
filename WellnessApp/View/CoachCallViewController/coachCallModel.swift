//
//  coachCallModel.swift
//  Luvo
//
//  Created by BEASiMAC on 03/01/23.
//

import Foundation
protocol CoachCallModelDelegate {
    func didReceiveCoachCallResponse(coachCallResponse: CoachCallResponse?)
    func didReceiveCoachCallError(statusCode: String?)
}

struct coachCallModel
{
    
    var coachcallDelegate : CoachCallModelDelegate?
    
    
    func getCoachCallData(token: String, SessionId: String, status: String, agoraUid: String) {

        let url1 = Common.WebserviceAPI.coachCallAPI+SessionId+status+agoraUid
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachCallResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.coachcallDelegate?.didReceiveCoachCallResponse(coachCallResponse: result)
                } else {
                    debugPrint(error!)
                    self.coachcallDelegate?.didReceiveCoachCallError(statusCode: error)
                }
            }
        }
    }
}
