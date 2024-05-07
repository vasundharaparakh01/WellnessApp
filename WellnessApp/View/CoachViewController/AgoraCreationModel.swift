//
//  AgoraCreationModel.swift
//  Luvo
//
//  Created by BEASiMAC on 11/04/23.
//

import Foundation

protocol AgoracreationModelDelegate
{
    
    func didReceiveAgoraCreationModelResponse(AgoraCreationResponse: AgoraCreationResponse?)
    func didReceiveAgoraCreationModelError(statusCode: String?)
}

struct AgoraCreationModel
{
    var AgoraCreationdelegate: AgoracreationModelDelegate?
    
    func AgoraCreationDetails(token: String, SessionId: String)
        {
            let url1 = Common.WebserviceAPI.AgoraCreationAPI + SessionId
            
            guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                   let homeUrl = URL(string: urlStrings)!
                   
                   let httpUtility = HttpUtility()
                   httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: AgoraCreationResponse.self) { result, error in
                       DispatchQueue.main.async {
                           if (error == nil) {
                               
                               self.AgoraCreationdelegate?.didReceiveAgoraCreationModelResponse(AgoraCreationResponse: result)
                                               } else {
                                                   debugPrint(error!)
                                                   self.AgoraCreationdelegate?.didReceiveAgoraCreationModelError(statusCode: error)
                                               }
                                           }
                                       }
                                   }
                               }
