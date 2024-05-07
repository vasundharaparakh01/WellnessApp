//
//  TermsViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-18.
//

import Foundation

protocol TermsDelegate {
    func didReceiveTermsGetDataResponse(termsGetDataResponse: TermsResponse?)
    func didReceiveTermsDataError(statusCode: String?)
}

struct TermsViewModel {
    
    var termsDelegate : TermsDelegate?
    
    //MARK: - Get Goal Data
    func getTerms() {
        let url = URL(string: Common.WebserviceAPI.termsAndServices)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: nil, resultType: TermsResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.termsDelegate?.didReceiveTermsGetDataResponse(termsGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.termsDelegate?.didReceiveTermsDataError(statusCode: error)
                }
            }
        }
    }
}
