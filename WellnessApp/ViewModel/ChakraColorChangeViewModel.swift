//
//  ChakraColorChangeViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 31/05/22.
//

import Foundation

protocol ChakraColorChangeViewModelDelegate {
    func didReceiveChakraColorChangeResponse(chakraColorChangeResponse: ChakraDisplayResponse?)
    func didReceiveChakraColorChangeError(statusCode: String?)
}

struct ChakraColorChangeViewModel {
    
    var delegate : ChakraColorChangeViewModelDelegate?
    
    func getChakraColorChangeDetails(token: String,chakravalue: Int) {
        //let category = String(chakravalue)
   // var url = URL(string: Common.WebserviceAPI.chakraColorChangeAPI)!
        let chakraUrl = URL(string: String(chakravalue), relativeTo: URL(string: Common.WebserviceAPI.chakraColorChangeAPI)!)!
        
        print(chakraUrl.absoluteString)
        
    let httpUtility = HttpUtility()
    httpUtility.getApiData(requestUrl: chakraUrl, token: token, resultType: ChakraDisplayResponse.self) { result, error in
        DispatchQueue.main.async {
            if (error == nil) {
                self.delegate?.didReceiveChakraColorChangeResponse(chakraColorChangeResponse: result)
            } else {
                debugPrint(error!)
                self.delegate?.didReceiveChakraColorChangeError(statusCode: error)
            }
        }
    }
}
}
