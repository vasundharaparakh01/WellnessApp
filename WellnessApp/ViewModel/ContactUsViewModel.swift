//
//  ContactUsViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import Foundation

protocol ContactUsViewModelDelegate {
    func didReceiveContactUsResponse(contactUsResponse: ContactUsResponse?)
    func didReceiveContactUsError(statusCode: String?)
}

struct ContactUsViewModel {
    
    var delegate : ContactUsViewModelDelegate?
    
    func postContactUs(token: String, contactUsRequest: ContactUsRequest) {
        let Url = URL(string: Common.WebserviceAPI.contactUsAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(contactUsRequest)
            httpUtility.postApiData(requestUrl: Url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: ContactUsResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveContactUsResponse(contactUsResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveContactUsError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
