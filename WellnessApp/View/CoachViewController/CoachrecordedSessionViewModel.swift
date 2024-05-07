//
//  CoachrecordedSessionViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 06/02/23.
//

import Foundation
protocol CoachRecordedSessionViewModelDelegate
{
    
    func didReceiveCoachRecordedSessionResponse(CoachRecordedResponse: CoachRecordedSessionResponse?)
    func didReceiveCoachRecordedSessionError(statusCode: String?)
}

struct CoachrecordedSessionViewModel
{
    var CoachRecordeddelegate: CoachRecordedSessionViewModelDelegate?
    
    func getRecordDetails(token: String, sessionName:String)
    {
        let url1 = Common.WebserviceAPI.CoachRecordedsessionApi+"?sessionName=\(sessionName)"
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachRecordedSessionResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.CoachRecordeddelegate?.didReceiveCoachRecordedSessionResponse(CoachRecordedResponse: result)
                } else {
                    debugPrint(error!)
                    self.CoachRecordeddelegate?.didReceiveCoachRecordedSessionError(statusCode: error)
                }
            }
        }
    }
    
}
