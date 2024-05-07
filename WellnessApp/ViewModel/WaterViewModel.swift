//
//  WaterViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 22/11/21.
//

import Foundation

protocol GetWaterGoalDelegate {
    func didReceiveWaterGoalDataResponse(waterGoalDataResponse: WaterGoalResponse?)
    func didReceiveWaterGoalDataError(statusCode: String?)
}

protocol WaterStatDelegate {
    func didReceiveWaterStatDataResponse(waterStatDataResponse: WaterStatResponse?)
    func didReceiveWaterStatDataError(statusCode: String?)
}

protocol WaterCupDelegate {
    func didReceiveWaterCupDataResponse(waterCupDataResponse: WaterCupSizeResponse?)
    func didReceiveWaterCupDataError(statusCode: String?)
}

protocol WaterCupPostDelegate {
    func didReceiveWaterCupPostDataResponse(waterCupPostDataResponse: WaterCupSizePostResponse?)
    func didReceiveWaterCupPostDataError(statusCode: String?)
}

protocol WaterReminderDelegate {
    func didReceiveWaterReminderGetDataResponse(waterReminderGetDataResponse: WaterReminderGetResponse?)
    func didReceiveWaterReminderSetDataResponse(waterReminderSetDataResponse: WaterReminderSetResponse?)
    func didReceiveWaterReminderDataError(statusCode: String?)
}

struct WaterViewModel {    
    var getWaterGoalDelegate: GetWaterGoalDelegate?
    var waterStatDelegate : WaterStatDelegate?
    var waterCupDelegate: WaterCupDelegate?
    var waterCupSizePostDelegate: WaterCupPostDelegate?
    var waterReminderDelegate: WaterReminderDelegate?
    
    //MARK: - Get Goal Data
    func getDailyWaterGoal(token: String) {
        let url = URL(string: Common.WebserviceAPI.getDailyWaterGoal)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: WaterGoalResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.getWaterGoalDelegate?.didReceiveWaterGoalDataResponse(waterGoalDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.getWaterGoalDelegate?.didReceiveWaterGoalDataError(statusCode: error)
                }
            }
        }
    }
    
    func setDailyWaterGoal(goalRequest: WaterGoalRequest, token: String) {
        let validationResult = WaterGoalValidation().Validate(goalRequest: goalRequest)
        if (validationResult.success) {
            let url = URL(string: Common.WebserviceAPI.putDailyWaterGoal)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(goalRequest)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.PUT, requestBody: postBody, token: token, resultType: WaterGoalResponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.getWaterGoalDelegate?.didReceiveWaterGoalDataResponse(waterGoalDataResponse: result)
                        } else {
                            debugPrint(error!)
                            self.getWaterGoalDelegate?.didReceiveWaterGoalDataError(statusCode: error)
                        }
                        
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.getWaterGoalDelegate?.didReceiveWaterGoalDataResponse(waterGoalDataResponse: WaterGoalResponse(status: nil, dailyWater: nil, message: validationResult.error))
        }
    }
    //Water Intake Stat
    func postGetWaterStat(waterStatRequest: WaterStatRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postWaterStat)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(waterStatRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: WaterStatResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        waterStatDelegate?.didReceiveWaterStatDataResponse(waterStatDataResponse: response)
                    } else {
                        debugPrint(error!)
                        waterStatDelegate?.didReceiveWaterStatDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Water Cup Size
    func getWaterCupSize() {
        let url = URL(string: Common.WebserviceAPI.getWaterCupSize)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: nil, resultType: WaterCupSizeResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.waterCupDelegate?.didReceiveWaterCupDataResponse(waterCupDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.waterCupDelegate?.didReceiveWaterCupDataError(statusCode: error)
                }
            }
        }
    }
    
    func postWaterCupSize(waterCupRequest: WaterCupSizePostRequest, token: String) {
        let validationResult = WaterCupSizeValidation().ValidateCupSize(waterCupSizePostRequest: waterCupRequest)
        if (validationResult.success) {
            let url = URL(string: Common.WebserviceAPI.postWaterCupSize)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(waterCupRequest)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: WaterCupSizePostResponse.self) { (response, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            waterCupSizePostDelegate?.didReceiveWaterCupPostDataResponse(waterCupPostDataResponse: response)
                        } else {
                            debugPrint(error!)
                            waterCupSizePostDelegate?.didReceiveWaterCupPostDataError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            waterCupSizePostDelegate?.didReceiveWaterCupPostDataResponse(waterCupPostDataResponse: WaterCupSizePostResponse(status: nil, message: validationResult.error))
        }
    }
    
    //MARK: - Weter Reminder
    func getWaterReminder(token: String) {
        let url = URL(string: Common.WebserviceAPI.getWaterReminder)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: WaterReminderGetResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.waterReminderDelegate?.didReceiveWaterReminderGetDataResponse(waterReminderGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.waterReminderDelegate?.didReceiveWaterReminderDataError(statusCode: error)
                }
            }
        }
    }
    
    func postWaterReminder(waterReminderRequest: WaterReminderSetRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postWaterReminder)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(waterReminderRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.PUT, requestBody: postBody, token: token, resultType: WaterReminderSetResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        waterReminderDelegate?.didReceiveWaterReminderSetDataResponse(waterReminderSetDataResponse: response)
                    } else {
                        debugPrint(error!)
                        waterReminderDelegate?.didReceiveWaterReminderDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
