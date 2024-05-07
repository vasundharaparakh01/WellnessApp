//
//  CoachCallUserHandRaiseModel.swift
//  Luvo
//
//  Created by BEASiMAC on 12/01/23.  CoachCallUserHandRaise
//

import Foundation


protocol CoachCallUserHandRaiseModelDelegate {
    func didReceiveCoachCallUserHandRaiseResponse(CoachCallUserHandRaiseResponse: CoachHandRaiseResponse?)
    func didReceiveCoachCallUserHandRaiseError(statusUserListCode: String?)
}


struct CoachCallUserHandRaiseModel
{
    var CoachCallUserHandRaiseDelegate : CoachCallUserHandRaiseModelDelegate?
    
    func getCoachCallUserHandRaise(token: String, CallId: String) {

        let url1 = Common.WebserviceAPI.coachCallUserHandRaise+CallId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachHandRaiseResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.CoachCallUserHandRaiseDelegate?.didReceiveCoachCallUserHandRaiseResponse(CoachCallUserHandRaiseResponse: result)
                } else {
                    debugPrint(error!)
                    self.CoachCallUserHandRaiseDelegate?.didReceiveCoachCallUserHandRaiseError(statusUserListCode: error)
                }
            }
        }
    }
}
