//
//  UpcomingSesionModel.swift
//  Luvo
//
//  Created by BEASiMAC on 10/02/23.
//

import Foundation
protocol CoachUpcomingModelDelegate {
    func didReceiveCoachupComingSessionResponse(coachUpcomingSession: CoachResponse?)
    func didReceiveCoachupComingSessionError(statusCode: String?)
}
struct UpcomingSesionModel
{
    var upcomingsessiondelegate: CoachUpcomingModelDelegate?
    
    func getCoachUpcomingSessionData(token: String, text: String) {
       
        
        let url1 = Common.WebserviceAPI.sessionList+text
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.upcomingsessiondelegate?.didReceiveCoachupComingSessionResponse(coachUpcomingSession: result)
                } else {
                    debugPrint(error!)
                    self.upcomingsessiondelegate?.didReceiveCoachupComingSessionError(statusCode: error)
                }
            }
        }

    }
    
}
