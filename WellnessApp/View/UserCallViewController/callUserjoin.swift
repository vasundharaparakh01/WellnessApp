//
//  callUserjoin.swift
//  Luvo
//
//  Created by BEASiMAC on 27/02/23.
//

import Foundation
protocol UserCallJoinViewModelDelegate {
    func didReceiveUserCallJoinResponse(liveResponse: LiveCallJoinResponse?)
    func didReceiveUserCallJoinError(statusCode: String?)
}

struct callUserjoin
{
    var calljoinUser : UserCallJoinViewModelDelegate?
    
    func postCallJoinData(date: LiveCallJoinRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.callUserjoinAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(date)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: LiveCallJoinResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.calljoinUser?.didReceiveUserCallJoinResponse(liveResponse: result)
                    } else {
                        debugPrint(error!)
                        self.calljoinUser?.didReceiveUserCallJoinError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
}
