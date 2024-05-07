//
//  CoachCallUserListModel.swift
//  Luvo
//
//  Created by BEASiMAC on 10/01/23.
//


import Foundation
protocol CoachCallUserListModelDelegate {
    func didReceiveCoachCallUserListResponse(coachCallUserListResponse: CoachCallUserListResponse?)
    func didReceiveCoachCallUserListError(statusUserListCode: String?)
}

struct CoachCallUserListModel
{
    
    var coachcallUserListDelegate : CoachCallUserListModelDelegate?
    
    
    func getCoachCallUserListData(token: String, CallId: String) {

        let url1 = Common.WebserviceAPI.coachCallUserList+CallId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachCallUserListResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.coachcallUserListDelegate?.didReceiveCoachCallUserListResponse(coachCallUserListResponse: result)
                } else {
                    debugPrint(error!)
                    self.coachcallUserListDelegate?.didReceiveCoachCallUserListError(statusUserListCode: error)
                }
            }
        }
    }
}
