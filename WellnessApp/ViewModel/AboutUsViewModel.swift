//
//  AboutUsViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

protocol AboutUsDelegate {
    func didReceiveAboutUsGetDataResponse(aboutUsGetDataResponse: AboutUsResponse?)
    func didReceiveAboutUsDataError(statusCode: String?)
}

struct AboutUsViewModel {
    
    var aboutUsDelegate : AboutUsDelegate?
    
    //MARK: - Get Goal Data
    func getAboutUs() {
        let url = URL(string: Common.WebserviceAPI.aboutUs)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: nil, resultType: AboutUsResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.aboutUsDelegate?.didReceiveAboutUsGetDataResponse(aboutUsGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.aboutUsDelegate?.didReceiveAboutUsDataError(statusCode: error)
                }
            }
        }
    }
}
