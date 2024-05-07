//
//  UserCallListModel.swift
//  Luvo
//
//  Created by BEASiMAC on 05/01/23.
//

import Foundation
protocol UserCallListModelDelegate {
    func didReceiveUserCallListResponse(UserCallList: UserCallListResponse?)
    func didReceiveUserCallListError(statusCode: String?)
}
struct UserCallListModel
{
    
    var UserCallListDelegate : UserCallListModelDelegate?
    
    
    func getUserCallListData(token: String, SearchText: String) {

        let url1 = Common.WebserviceAPI.UserCallListAPI+SearchText
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: UserCallListResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.UserCallListDelegate?.didReceiveUserCallListResponse(UserCallList: result)
                } else {
                    debugPrint(error!)
                    self.UserCallListDelegate?.didReceiveUserCallListError(statusCode: error)
                }
            }
        }
    }
}
