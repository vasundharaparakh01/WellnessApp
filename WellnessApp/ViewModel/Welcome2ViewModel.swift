//
//  Welcome2ViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/09/21.
//

import Foundation

protocol Welcome2ViewModelDelegate {
    func didReceiveWelcome2QuestionResponse(welcome2QuestionResponse: Welcome2QuestionResponse?)
    func didReceiveWelcome2QuestionError(statusCode: String?)
    
    func didReceiveWelcome2AnswerResponse(welcome2AnswerResponse: Welcome2AnswerResponse?)
    func didReceiveWelcome2AnswerError(statusCode: String?)
}

struct Welcome2ViewModel {
    
    var delegate: Welcome2ViewModelDelegate?
    
    func getQuestion(token: String) {
        let questionUrl = URL(string: Common.WebserviceAPI.singleQuestionAPI)!
        let httpUtility = HttpUtility()
        httpUtility.postApiData(requestUrl: questionUrl, httpMethod: ConstantHttpMethod.POST, requestBody: nil, token: token, resultType: Welcome2QuestionResponse.self) { (welcom2QuestionApiResponse, error) in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveWelcome2QuestionResponse(welcome2QuestionResponse: welcom2QuestionApiResponse)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveWelcome2QuestionError(statusCode: error)
                }
            }
        }
    }
    
    func saveAnswer(request: Welcome2AnswerRequest, token: String) {
        let saveAnswerUrl = URL(string: Common.WebserviceAPI.singleAnswerSaveAPI)!
        let httpUtility = HttpUtility()
        do {
            let answerRequestBody = try JSONEncoder().encode(request)
            httpUtility.postApiData(requestUrl: saveAnswerUrl, httpMethod: ConstantHttpMethod.POST, requestBody: answerRequestBody, token: token, resultType: Welcome2AnswerResponse.self) { (welcome2AnswerResponse, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveWelcome2AnswerResponse(welcome2AnswerResponse: welcome2AnswerResponse)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveWelcome2AnswerError(statusCode: error)
                    }
                }
            }
        } catch let error{
            debugPrint(error.localizedDescription)
        }
    }
}
