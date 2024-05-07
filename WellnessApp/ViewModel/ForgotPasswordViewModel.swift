//
//  ForgotPasswordViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

protocol ForgotPasswordViewModelDelegate {
    func didReceiveForgotPasswordResponse(forgotResponse: ForgotPasswordResponse?)
    func didReceiveForgotPasswordError(statusCode: String?)
}

struct ForgotPasswordViewModel {
    
    var delegate : ForgotPasswordViewModelDelegate?
    
    func forgotPassword(forgotPasswordRequest: ForgotPasswordResquest) {
        let validationResult = ForgotPasswordValidation().Validate(forgotPasswordRequest: forgotPasswordRequest)
        if (validationResult.success) {
            let forgotUrl = URL(string: Common.WebserviceAPI.forgotPasswordAPI)!
            let httpUtility = HttpUtility()
            do {
                let forgotPostBody = try JSONEncoder().encode(forgotPasswordRequest)
                httpUtility.postApiData(requestUrl: forgotUrl, httpMethod: ConstantHttpMethod.PUT, requestBody: forgotPostBody, token: nil, resultType: ForgotPasswordResponse.self) { (forgotApiResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveForgotPasswordResponse(forgotResponse: forgotApiResponse)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveForgotPasswordError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveForgotPasswordResponse(forgotResponse: ForgotPasswordResponse(status: nil, message: nil, token: nil, error: validationResult.error))
        }
        
    }
}
