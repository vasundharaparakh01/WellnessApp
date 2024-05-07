//
//  LoginViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

protocol LoginViewModelDelegate {
    func didReceiveLoginResponse(loginResponse: LoginResponse?)
    func didReceiveLoginError(statusCode: String?)
    
    func didReceiveSocialLoginResponse(loginResponse: LoginResponse?)
    func didReceiveSocialLoginError(statusCode: String?)
}

struct LoginViewModel {
    
    var delegate : LoginViewModelDelegate?
    
    func loginUser(loginRequest: LoginRequest) {
        let validationResult = LoginValidation().Validate(loginRequest: loginRequest)
        if (validationResult.success) {
            let loginUrl = URL(string: Common.WebserviceAPI.loginAPI)!
            let httpUtility = HttpUtility()
            do {
                let loginPostBody = try JSONEncoder().encode(loginRequest)
                httpUtility.postApiData(requestUrl: loginUrl, httpMethod: ConstantHttpMethod.POST, requestBody: loginPostBody, token: nil, resultType: LoginResponse.self) { (loginApiResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveLoginResponse(loginResponse: loginApiResponse)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveLoginError(statusCode: error)
                        }
                        
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveLoginResponse(loginResponse: LoginResponse(status: nil, message: validationResult.error, userDetail: nil, tokenValidate: nil))
        }
    }
    
    func socialLoginUser(loginRequest: SocialLoginRequest) {
        let loginUrl = URL(string: Common.WebserviceAPI.socialLoginAPI)!
        let httpUtility = HttpUtility()
        do {
            let loginPostBody = try JSONEncoder().encode(loginRequest)
            httpUtility.postApiData(requestUrl: loginUrl, httpMethod: ConstantHttpMethod.POST, requestBody: loginPostBody, token: nil, resultType: LoginResponse.self) { (loginApiResponse, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveSocialLoginResponse(loginResponse: loginApiResponse)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveSocialLoginError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
}
