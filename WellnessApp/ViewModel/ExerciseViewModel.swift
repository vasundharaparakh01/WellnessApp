//
//  ExerciseViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 10/11/21.
//

import Foundation

protocol GetGoalDelegate {
    func didReceiveGoalDataResponse(exerciseGoalDataResponse: ExerciseGoalResponse?)
    func didReceiveGoalDataError(statusCode: String?)
}

protocol StepFinishDelegate {
    func didReceiveStepFinishDataResponse(stepFinishDataResponse: ExerciseFinishResponse?)
    func didReceiveStepFinishDataError(statusCode: String?)
}

protocol ExerciseStatDelegate {
    func didReceiveExerciseStatDataResponse(exerciseStatDataResponse: ExerciseStatResponse?)
    func didReceiveExerciseStatDataError(statusCode: String?)
}

struct ExerciseViewModel {
    
    var getGoalDelegate : GetGoalDelegate?
    var stepFinishDelegate : StepFinishDelegate?
    var exerciseStatDelegate : ExerciseStatDelegate?
    
    //MARK: - Get Goal Data
    func getDailyGoal(token: String) {
        let url = URL(string: Common.WebserviceAPI.getDailyGoal)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: ExerciseGoalResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.getGoalDelegate?.didReceiveGoalDataResponse(exerciseGoalDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.getGoalDelegate?.didReceiveGoalDataError(statusCode: error)
                }
            }
        }
    }
    
    //MARK: - Set Goal Data
    func setDailyGoal(goalRequest: ExerciseGoalRequest, token: String) {
        let validationResult = ExerciseGoalValidation().Validate(goalRequest: goalRequest)
        if (validationResult.success) {
            let url = URL(string: Common.WebserviceAPI.putDailyGoal)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(goalRequest)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.PUT, requestBody: postBody, token: token, resultType: ExerciseGoalResponse.self) { (goalApiResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.getGoalDelegate?.didReceiveGoalDataResponse(exerciseGoalDataResponse: goalApiResponse)
                        } else {
                            debugPrint(error!)
                            self.getGoalDelegate?.didReceiveGoalDataError(statusCode: error)
                        }
                        
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.getGoalDelegate?.didReceiveGoalDataResponse(exerciseGoalDataResponse: ExerciseGoalResponse(status: nil, dailyGoal: nil, message: validationResult.error, todaySteps: nil))
        }
    }
    
    func postStepFinishUpdate(stepUpdateRequest: ExerciseFinishRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postStepUpdate)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(stepUpdateRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: ExerciseFinishResponse.self) { (exerciseFinishResponse, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        stepFinishDelegate?.didReceiveStepFinishDataResponse(stepFinishDataResponse: exerciseFinishResponse)
                    } else {
                        debugPrint(error!)
                        stepFinishDelegate?.didReceiveStepFinishDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func postGetExerciseStat(exerciseStatRequest: ExerciseStatRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postExerciseStat)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(exerciseStatRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: ExerciseStatResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        exerciseStatDelegate?.didReceiveExerciseStatDataResponse(exerciseStatDataResponse: response)
                    } else {
                        debugPrint(error!)
                        exerciseStatDelegate?.didReceiveExerciseStatDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
