//
//  FAQViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-20.
//

import Foundation

protocol FAQDelegate {
    func didReceiveFAQGetDataResponse(faqGetDataResponse: FAQResponse?)
    func didReceiveFAQDataError(statusCode: String?)
}

struct FAQViewModel {
    
    var faqDelegate : FAQDelegate?
    
    //MARK: - Get Goal Data
    func getFAQ() {
        let url = URL(string: Common.WebserviceAPI.faqAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: nil, resultType: FAQResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.faqDelegate?.didReceiveFAQGetDataResponse(faqGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.faqDelegate?.didReceiveFAQDataError(statusCode: error)
                }
            }
        }
    }
}
