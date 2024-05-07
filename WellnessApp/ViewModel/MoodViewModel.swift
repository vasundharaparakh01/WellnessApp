//
//  MoodViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-31.
//

import Foundation

protocol MoodViewModelDelegate {
    func didReceiveMoodResponse(moodResponse: MoodResponse?)
    func didReceiveMoodError(statusCode: String?)
}

struct MoodViewModel {
    
    var delegate : MoodViewModelDelegate?
    
    func updateMood(token: String, moodRequest: MoodRequest) {
        let validationResult = MoodValidation().Validate(moodRequest: moodRequest)
        if (validationResult.success) {
            let resetUrl = URL(string: Common.WebserviceAPI.moodSetAPI)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(moodRequest)
                httpUtility.postApiData(requestUrl: resetUrl, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: MoodResponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveMoodResponse(moodResponse: result)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveMoodError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveMoodResponse(moodResponse: MoodResponse(status: nil, message: validationResult.error, detail: nil))
        }
    }
}
