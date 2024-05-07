//
//  HandRaiseModel.swift
//  Luvo
//
//  Created by BEASiMAC on 27/02/23.
//

import Foundation
protocol HandRaiseModelDelegate {
    func didReceiveHandRaiseResponse(HandRaiseResponse: AllUserHandRaiseResponse?)
    func didReceiveHandRaiseError(statusCode: String?)
}
struct HandRaiseModel
{
    var handRaisedelegate: HandRaiseModelDelegate?
    func postChatCallJoinData(Chat: AllUserhandRaiseRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.HandRaiseAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(Chat)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: AllUserHandRaiseResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.handRaisedelegate?.didReceiveHandRaiseResponse(HandRaiseResponse: result)
                    } else {
                        debugPrint(error!)
                        self.handRaisedelegate?.didReceiveHandRaiseError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
