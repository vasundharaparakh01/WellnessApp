//
//  ChakraQuestionViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/09/21.
//

import Foundation

protocol ChakraQuestionViewModelDelegate {
    func didReceiveChakraQuestionResponse(chakraResponse: ChakraQuestionResponse?)
    func didReceiveChakraQuestionError(statusCode: String?)
    
    func didReceiveChakraAnswerResponse(chakraAnswerResponse: ChakraAnswerResponse?)
    func didReceiveChakraAnswerError(statusCode: String?)
    
    func didReceiveRetakeAnswerResponse(retakeAnswerResponse: RetakeResult?)
    func didReceiveRetakeAnswerError(statusCode: String?)
}

struct ChakraQuestionViewModel {
    
    var delegate : ChakraQuestionViewModelDelegate?
    
    func getChakraQuestion(token: String) {
        
        let status = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromsideMenu)
        print(status)
        let chakraUrl:URL
        
        if status == true
        {
            chakraUrl = URL(string: Common.WebserviceAPI.retakeAPI)!
        }
        else
        {
            chakraUrl = URL(string: Common.WebserviceAPI.getChakraQuestionAPI)!
        }
        //let chakraUrl = URL(string: Common.WebserviceAPI.getChakraQuestionAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: chakraUrl, token: token, resultType: ChakraQuestionResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveChakraQuestionResponse(chakraResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveChakraQuestionError(statusCode: error)
                }
            }
        }
    }
    
    
    func getRetake(token: String)
    {
        let chakraUrl:URL
        chakraUrl = URL(string: Common.WebserviceAPI.retakeAPI)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: chakraUrl, token: token, resultType: RetakeResult.self) { resultRetke, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveRetakeAnswerResponse(retakeAnswerResponse: resultRetke)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveRetakeAnswerError(statusCode: error)
                }
            }
        }
    }
    
    func saveChakraAnswer(request: ChakraAnswerRequest, token: String) {
        
//        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        
      //  let status = UserDefaults.standard.bool(forKey: “userlogin”) ?? false
        
        let chakraUrl : URL
        
        let status = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromsideMenu)
        print(status)
        if status == false
        {
           chakraUrl = URL(string: Common.WebserviceAPI.saveChakraAnswerAPI)!
        }
        else
        {
            chakraUrl = URL(string: Common.WebserviceAPI.retakePostAPI)!
        }
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(request)
            httpUtility.postApiData(requestUrl: chakraUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: ChakraAnswerResponse.self) { response, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveChakraAnswerResponse(chakraAnswerResponse: response)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveChakraAnswerError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
