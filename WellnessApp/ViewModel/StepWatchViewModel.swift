//
//  StepWatchViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 28/07/22.
//

import Foundation
protocol StepWatchViewModelDelegate {
    func didReceiveStepWatchResponse(stepWatchResponse: stepWatchRespone?)
    func didReceiveStepWatchError(statusCode: String?)
    
}

struct StepWatchViewModel{
    
    var StepWatchdelegate : StepWatchViewModelDelegate?
    
    func saveStepWatch(request: stepWatchRequest, token: String) {
        
        let stepWatchUrl : URL
        stepWatchUrl = URL(string: Common.WebserviceAPI.addWatchStepDataPostAPI)!
        
        let httpUtility = HttpUtility()
        do {
            
            
            let requestBody = try JSONEncoder().encode(request)
            httpUtility.postApiData(requestUrl: stepWatchUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: stepWatchRespone.self) { response, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.StepWatchdelegate?.didReceiveStepWatchResponse(stepWatchResponse: response)
                    } else {
                        debugPrint(error!)
                        self.StepWatchdelegate?.didReceiveStepWatchError(statusCode: error)
                    }
                }
            }
        }catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
}
