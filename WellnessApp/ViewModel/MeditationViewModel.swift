//
//  MeditationViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-24.
//

import Foundation

protocol MeditationBadgeDelegate {
    func didReceiveMeditationBadgeDataResponse(meditationBadgeDataResponse: MeditationBadgeResponse?)
    func didReceiveMeditationBadgeDataError(statusCode: String?)
}

struct MeditationViewModel {
    
    var meditationBadgeDelegate: MeditationBadgeDelegate?
    
    //Water Intake Stat
    func getMeditationBadge(meditationBadgeRequest: MeditationBadgeRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.meditationBadgeAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(meditationBadgeRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: MeditationBadgeResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        meditationBadgeDelegate?.didReceiveMeditationBadgeDataResponse(meditationBadgeDataResponse: response)
                    } else {
                        debugPrint(error!)
                        meditationBadgeDelegate?.didReceiveMeditationBadgeDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
