//
//  ChangePasswordViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

protocol ChangePasswordViewModelDelegate {
    func didReceiveChanngePasswordResponse(changePasswordResponse: ChangePasswordResponse?)
    func didReceiveChangePasswordError(statusCode: String?)
}

struct ChangePasswordViewModel {
    
    var delegate : ChangePasswordViewModelDelegate?
    
    func changePassword(token: String, changePasswordRequest: ChangePasswordRequest) {
        let validationResult = ChangePasswordValidation().Validate(changePasswordRequest: changePasswordRequest)
        if (validationResult.success) {
            let resetUrl = URL(string: Common.WebserviceAPI.changePassword)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(changePasswordRequest)
                httpUtility.postApiData(requestUrl: resetUrl, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: ChangePasswordResponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveChanngePasswordResponse(changePasswordResponse: result)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveChangePasswordError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveChanngePasswordResponse(changePasswordResponse: ChangePasswordResponse(status: nil, message: validationResult.error, error: validationResult.error))
        }
    }
}
