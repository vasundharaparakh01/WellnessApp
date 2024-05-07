//
//  SignupViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

protocol SignupViewModelDelegate {
    func didReceiveSignupResponse(signupResponse: SignupResponse?)
    func didReceiveSignupError(statusCode: String?)
}

struct SignupViewModel {
    
    var delegate : SignupViewModelDelegate?
    
    func signupUser(signupRequest: SignupResquest) {
        let validationResult = SignupValidation().Validate(signupRequest: signupRequest)
        if (validationResult.success) {
            let signupUrl = URL(string: Common.WebserviceAPI.signupAPI)!
            let httpUtility = HttpUtility()
            do {
                let signupPostBody = try JSONEncoder().encode(signupRequest)
                httpUtility.postApiData(requestUrl: signupUrl, httpMethod: ConstantHttpMethod.POST, requestBody: signupPostBody, token: nil, resultType: SignupResponse.self) { (signupApiResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveSignupResponse(signupResponse: signupApiResponse)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveSignupError(statusCode: error)
                        }
                        
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveSignupResponse(signupResponse: SignupResponse(status: nil, message: validationResult.error, userDetail: nil, tokenValidate: nil))
        }
        
    }
}
    
