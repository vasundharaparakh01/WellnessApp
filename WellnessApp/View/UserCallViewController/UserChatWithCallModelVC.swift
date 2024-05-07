//
//  UserChatWithCallModelVC.swift
//  Luvo
//
//  Created by BEASiMAC on 24/02/23.
//

import Foundation
protocol UserChatWithCallModelDelegate
{
    func didReceiveUserchatWithCoachCallResponse(ChatcallResponse: UserchatWithCoachResponse?)
    func didReceiveUserchatWithCoachCallError(statusCallCode: String?)
}
struct UserChatWithCallModelVC
{
    var Chatcalldelegate: UserChatWithCallModelDelegate?
    func postChatCallJoinData(Chat: UserChatCallRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.callChatAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(Chat)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: UserchatWithCoachResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.Chatcalldelegate?.didReceiveUserchatWithCoachCallResponse(ChatcallResponse: result)
                    } else {
                        debugPrint(error!)
                        self.Chatcalldelegate?.didReceiveUserchatWithCoachCallError(statusCallCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
