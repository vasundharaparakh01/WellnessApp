//
//  BreathingExerciseViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/10/21.
//

import Foundation

protocol BreathingExerciseViewModelDelegate {
    func didReceiveBreathingExerciseListDataResponse(breathingExerciseListDataResponse: BreathExerciseListResponse?)
    func didReceiveBreathingExerciseListDataError(statusCode: String?)
}

struct BreathingExerciseViewModel {
    
    var delegate : BreathingExerciseViewModelDelegate?
    
    //MARK: - Get Data
    func getBreathExerciseList(token: String) {
        let blogListURL = URL(string: Common.WebserviceAPI.getBreathExeciseListAPI)!
        let httpUtility = HttpUtility()
        httpUtility.postApiData(requestUrl: blogListURL, httpMethod: ConstantHttpMethod.PUT, requestBody: nil, token: token, resultType: BreathExerciseListResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveBreathingExerciseListDataResponse(breathingExerciseListDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveBreathingExerciseListDataError(statusCode: error)
                }
            }
        }
    }
}
