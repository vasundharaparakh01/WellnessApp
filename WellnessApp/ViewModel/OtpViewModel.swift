//
//  OtpViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 14/09/21.
//

import Foundation

protocol OtpViewModelDelegate {
    func didReceiveOtpResendResponse(otpResendResponse: OtpResendResponse?)
    func didReceiveOtpResendError(statusCode: String?)
    
    func didReceiveValidateOtpResponse(validateOtpResponse: ValidateOtpResponse?)
    func didReceiveValidateOtpError(statusCode: String?)
}

struct OtpViewModel {
    var delegate : OtpViewModelDelegate?
    
    func resendOtp(token: String) {
        let resendOtpUrl = URL(string: Common.WebserviceAPI.resendOtpAPI)!
        let httpUtility = HttpUtility()
        
        httpUtility.postApiData(requestUrl: resendOtpUrl, httpMethod: ConstantHttpMethod.PATCH, requestBody: nil, token: token, resultType: OtpResendResponse.self) { (resendOtpApiResponse, error) in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveOtpResendResponse(otpResendResponse: resendOtpApiResponse)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveOtpResendError(statusCode: error)
                }
            }
        }
    }
    
    func validateOtp(validateOtpRequest: ValidateOtpRequest, token: String) {
        let validateOtpUrl = URL(string: Common.WebserviceAPI.validateOtpAPI)!
        let httpUtility = HttpUtility()
        do {
            let validateOtpPostBody = try JSONEncoder().encode(validateOtpRequest)
            httpUtility.postApiData(requestUrl: validateOtpUrl, httpMethod: ConstantHttpMethod.PUT, requestBody: validateOtpPostBody, token: token, resultType: ValidateOtpResponse.self) { (validateOtpApiResponse, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveValidateOtpResponse(validateOtpResponse: validateOtpApiResponse)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveValidateOtpError(statusCode: error)
                    }
                    
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
