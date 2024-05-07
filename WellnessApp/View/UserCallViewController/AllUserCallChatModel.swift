//
//  AllUserCallChatModel.swift
//  Luvo
//
//  Created by BEASiMAC on 24/02/23.
//

import Foundation
protocol AllUserCallChatModelDelegate {
    func didReceiveAllUserCallChatResponse(ChatAllResponse: AllUserChatResponse?)
    func didReceiveAllUserCallChatModelError(statusCode: String?)
}

struct AllUserCallChatModel
{
    var AllUserChatCalldelegate: AllUserCallChatModelDelegate?
    func getChatCallDetails(token: String, CallId:String)
    {
        
        let url1 = Common.WebserviceAPI.callAllChatAPI+CallId

       // let url1 = Common.WebserviceAPI.RecoredeSessionList+catagoryId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: AllUserChatResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.AllUserChatCalldelegate?.didReceiveAllUserCallChatResponse(ChatAllResponse: result)
                } else {
                    debugPrint(error!)
                    self.AllUserChatCalldelegate?.didReceiveAllUserCallChatModelError(statusCode: error)
                }
            }
        }
    }
    
    
}
