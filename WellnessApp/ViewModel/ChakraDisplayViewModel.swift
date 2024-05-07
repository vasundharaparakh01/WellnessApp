//
//  ChakraDisplayViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/09/21.
//

import Foundation

protocol ChakraDisplayViewModelDelegate {
    func didReceiveChakraDisplayResponse(chakraDisplayResponse: ChakraDisplayResponse?)
    func didReceiveChakraDisplayError(statusCode: String?)
}

struct ChakraDisplayViewModel {
    
    var delegate : ChakraDisplayViewModelDelegate?
    
    func getChakraDisplayDetails(token: String) {
        let chakraUrl = URL(string: Common.WebserviceAPI.getChakraLevelDisplayAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: chakraUrl, token: token, resultType: ChakraDisplayResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveChakraDisplayResponse(chakraDisplayResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveChakraDisplayError(statusCode: error)
                }
            }
        }
    }
}
