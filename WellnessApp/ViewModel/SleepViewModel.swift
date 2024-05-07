//
//  SleepViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/02/22.
//

import Foundation

protocol SleepViewModelDelegate {
    func didReceiveSleepDataUploadResponse(sleepDataUploadResponse: SleepResponse?)
    func didReceiveSleepDataError(statusCode: String?)
}

protocol SleepAudioListDelegate {
    func didReceiveSleepAudioListResponse(sleepAudioListResponse: MeditationAudioResponse?)
    func didReceiveSleepAudioListError(statusCode: String?)
}

protocol SleepStatDelegate {
    func didReceiveSleepStatDataResponse(sleepStatDataResponse: SleepStatResponse?)
    func didReceiveSleepStatDataError(statusCode: String?)
}

protocol SleepWatchStatDelegate {
    func didReceiveSleepWatchStatDataResponse(sleepWatchStatDataResponse: SleepWatchStatResponse?)
    func didReceiveSleepWatchStatDataError(statusCode: String?)
}

protocol SleepDeleteDataDelegate {
    func didReceiveSleepDeleteDataResponse(sleepDeleteDataResponse: SleepDataDeleteResponse?)
    func didReceiveSleepDeleteDataError(statusCode: String?)
}

struct SleepViewModel {
    
    var delegate: SleepViewModelDelegate?
    var sleepAudioListDelegate: SleepAudioListDelegate?
    var sleepStatDelegate: SleepStatDelegate?
    var sleepDataDeleteDelegate: SleepDeleteDataDelegate?
    var sleepWatchStatDelegate: SleepWatchStatDelegate?
    
    //MARK: - Upload Profile Image
   // func uploadSleepData(mediaData: AudioUploadRequest, sleepData: SleepUploadRequest, formParam: [String: Data], token: String) {
        func uploadSleepData(mediaData: AudioUploadRequest, sleepData: SleepUploadRequest, formParam: [String: Data], token: String) {
        
  //      func uploadSleepData(sleepData: SleepUploadRequest, formParam: [String: Data], token: String) {
        let url = URL(string: Common.WebserviceAPI.addSleepAPI)!
        let httpUtility = HttpUtility()
        httpUtility.uploadMediaWithDataMultipartForm(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestMediaBody: mediaData, requestSleepBody: sleepData, formParam: formParam, token: token, resultType: SleepResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveSleepDataUploadResponse(sleepDataUploadResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveSleepDataError(statusCode: error)
                }
                
            }
        }
    }
    
    //MARK: - Get Sleep Audio List
    func getSleepAudioList(token: String) {
        let url = URL(string: Common.WebserviceAPI.getSleepAudioAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: MeditationAudioResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.sleepAudioListDelegate?.didReceiveSleepAudioListResponse(sleepAudioListResponse: result)
                } else {
                    debugPrint(error!)
                    self.sleepAudioListDelegate?.didReceiveSleepAudioListError(statusCode: error)
                }
            }
        }
    }
    
    //Sleep Intake Stat
    func postGetSleepStat(sleepStatRequest: SleepStatRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postSleepStatAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(sleepStatRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: SleepStatResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        sleepStatDelegate?.didReceiveSleepStatDataResponse(sleepStatDataResponse: response)
                    } else {
                        debugPrint(error!)
                        sleepStatDelegate?.didReceiveSleepStatDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    
    //SleepDataForWatch
    
    func postSleepWatchData(sleepWatchStatRequest: SleepWatchStatRequest,token: String)
    {
        let url = URL(string: Common.WebserviceAPI.addSleepDataPostAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(sleepWatchStatRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: SleepWatchStatResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                       
                        sleepWatchStatDelegate?.didReceiveSleepWatchStatDataResponse(sleepWatchStatDataResponse: response)
                      //  sleepStatDelegate?.didReceiveSleepStatDataResponse(sleepStatDataResponse: response)
                    } else {
                        debugPrint(error!)
                        sleepWatchStatDelegate?.didReceiveSleepWatchStatDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    
    //Delete existing sleep data
    func deleteSleepData(token: String) {
        let url = URL(string: Common.WebserviceAPI.deleteSleepDataAPI)!
        let httpUtility = HttpUtility()
        httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.DELETE, requestBody: nil, token: token, resultType: SleepDataDeleteResponse.self) { (response, error) in
            DispatchQueue.main.async {
                if (error == nil) {
                    sleepDataDeleteDelegate?.didReceiveSleepDeleteDataResponse(sleepDeleteDataResponse: response)
                } else {
                    debugPrint(error!)
                    sleepDataDeleteDelegate?.didReceiveSleepDeleteDataError(statusCode: error)
                }
            }
        }
    }
}
