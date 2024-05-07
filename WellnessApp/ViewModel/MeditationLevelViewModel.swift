//
//  MeditationLevelViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 19/10/21.
//

import Foundation

protocol MeditationLevelViewModelDelegate {
    func didReceiveMeditationLevelDataResponse(meditationLevelDataResponse: MeditationLevelResponse?)
    func didMeditationLevelDataError(statusCode: String?)
}

struct MeditationLevelViewModel {
    
    var delegate : MeditationLevelViewModelDelegate?
    
    //MARK: - Get Data
    func getMeditationLevelDetails(token: String) {
        let meditationURL = URL(string: Common.WebserviceAPI.getMeditationLevelAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: meditationURL, token: token, resultType: MeditationLevelResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveMeditationLevelDataResponse(meditationLevelDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didMeditationLevelDataError(statusCode: error)
                }
            }
        }
    }
}
