//
//  TimeTrackingViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-22.
//

import Foundation

protocol TimeTrackingDelegate {
    func didReceiveTrackingResponse(trackingResponse: TimeTrackingResponse?)
    func didReceiveTrackingError(statusCode: String?)
}

struct TimeTrackingViewModel {
    
    var delegate : TimeTrackingDelegate?
    
    func postTimeTracking(token: String, trackingRequest: TimeTrackingRequest) {
        let Url = URL(string: Common.WebserviceAPI.timeTracking)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(trackingRequest)
            httpUtility.postApiData(requestUrl: Url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: TimeTrackingResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveTrackingResponse(trackingResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveTrackingError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
