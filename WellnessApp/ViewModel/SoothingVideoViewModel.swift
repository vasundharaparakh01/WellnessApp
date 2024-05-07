//
//  SoothingVideoViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 27/10/21.
//

import Foundation

protocol SoothingVideoViewModelDelegate {
    func didReceiveSoothingVideoListDataResponse(soothingVideoListDataResponse: SoothingVideosListResponse?)
    func didReceiveSoothingVideoDataError(statusCode: String?)
}

struct SoothingVideoViewModel {
    
    var delegate : SoothingVideoViewModelDelegate?
    
    //MARK: - Get Data
    func getSoothingVideoList(token: String) {
        let meditationURL = URL(string: Common.WebserviceAPI.getSoothingVideoList)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: meditationURL, token: token, resultType: SoothingVideosListResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveSoothingVideoListDataResponse(soothingVideoListDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveSoothingVideoDataError(statusCode: error)
                }
            }
        }
    }
}
