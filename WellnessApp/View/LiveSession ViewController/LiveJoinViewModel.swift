//
//  LiveJoinViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 10/12/22.
//

import Foundation

protocol LiveJoinViewModelDelegate {
    func didReceiveLiveJoinResponse(liveResponse: LiveJoinResponse?)
    func didReceiveLiveJoinError(statusCode: String?)
}

struct LiveJoinViewModel
{
    var Liveviewdelegate: LiveJoinViewModelDelegate?

    func postLiveJoinData(date: LiveJoinRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.GoLiveUserAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(date)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: LiveJoinResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.Liveviewdelegate?.didReceiveLiveJoinResponse(liveResponse: result)
                    } else {
                        debugPrint(error!)
                        self.Liveviewdelegate?.didReceiveLiveJoinError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}


//struct SignupViewModel {
//
//    var delegate : SignupViewModelDelegate?
//
//    func signupUser(signupRequest: SignupResquest) {
//        let validationResult = SignupValidation().Validate(signupRequest: signupRequest)
//        if (validationResult.success) {
//            let signupUrl = URL(string: Common.WebserviceAPI.signupAPI)!
//            let httpUtility = HttpUtility()
//            do {
//                let signupPostBody = try JSONEncoder().encode(signupRequest)
//                httpUtility.postApiData(requestUrl: signupUrl, httpMethod: ConstantHttpMethod.POST, requestBody: signupPostBody, token: nil, resultType: SignupResponse.self) { (signupApiResponse, error) in
//                    DispatchQueue.main.async {
//                        if (error == nil) {
//                            self.delegate?.didReceiveSignupResponse(signupResponse: signupApiResponse)
//                        } else {
//                            debugPrint(error!)
//                            self.delegate?.didReceiveSignupError(statusCode: error)
//                        }
//
//                    }
//                }
//            } catch let error {
//                debugPrint(error.localizedDescription)
//            }
//        } else {
//            self.delegate?.didReceiveSignupResponse(signupResponse: SignupResponse(status: nil, message: validationResult.error, userDetail: nil, tokenValidate: nil))
//        }
//
//    }
//}
