//
//  ResetPasswordViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 15/09/21.
//

import Foundation

protocol ResetPasswordViewModelDelegate {
    func didReceiveResetPasswordResponse(resetResponse: ResetPasswordResponse?)
    func didReceiveResetPasswordError(statusCode: String?)
}

struct ResetPasswordViewModel {
    
    var delegate : ResetPasswordViewModelDelegate?
    
    func resetPassword(resetPasswordRequest: ResetPasswordResquest) {
        let validationResult = ResetPasswordValidation().Validate(resetPasswordRequest: resetPasswordRequest)
        if (validationResult.success) {
            let resetUrl = URL(string: Common.WebserviceAPI.resetPasswordAPI)!
            let httpUtility = HttpUtility()
            do {
                let resetPostBody = try JSONEncoder().encode(resetPasswordRequest)
                httpUtility.postApiData(requestUrl: resetUrl, httpMethod: ConstantHttpMethod.PUT, requestBody: resetPostBody, token: nil, resultType: ResetPasswordResponse.self) { (resetApiResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveResetPasswordResponse(resetResponse: resetApiResponse)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveResetPasswordError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveResetPasswordResponse(resetResponse: ResetPasswordResponse(status: nil, message: nil, error: validationResult.error))
        }
    }
}
