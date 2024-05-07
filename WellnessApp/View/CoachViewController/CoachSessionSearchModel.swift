//
//  CoachSessionSearchModel.swift
//  Luvo
//
//  Created by BEASiMAC on 17/01/23.
//

import Foundation
protocol CoachSessionSearchModelModelDelegate
{
    
    func didReceiveCoachSessionSearchModelResponse(RecordedResponse: CoachSessionSearchModelResponse?)
    func didReceiveCoachSessionSearchModelError(statusCode: String?)
}

struct CoachSessionSearchModel
{
    var CoachSessionSearchdelegate: CoachSessionSearchModelModelDelegate?
    
    func getSessionDetails(token: String, sessionName:String)
        {
            let url1 = Common.WebserviceAPI.coachSessionSearch+"sessionName=\(sessionName)"
            
            guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                   let homeUrl = URL(string: urlStrings)!
                   
                   let httpUtility = HttpUtility()
                   httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachSessionSearchModelResponse.self) { result, error in
                       DispatchQueue.main.async {
                           if (error == nil) {
                               
                               self.CoachSessionSearchdelegate?.didReceiveCoachSessionSearchModelResponse(RecordedResponse: result)
                                               } else {
                                                   debugPrint(error!)
                                                   self.CoachSessionSearchdelegate?.didReceiveCoachSessionSearchModelError(statusCode: error)
                                               }
                                           }
                                       }
                                   }
                               }


        
