//
//  HeartViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/12/21.
//

import Foundation

protocol HeartDataPostDelegate {
    func didReceiveHeartPostDataResponse(heartPostDataResponse: HeartRateResponse?)
    func didReceiveHeartPostDataError(statusCode: String?)
}

protocol WatchHeartDataPostDelegate {
    func didReceiveWatchHeartPostDataResponse(WatchheartPostDataResponse: HeartRateResponse?)
    func didReceiveWatchHeartPostDataError(statusCode: String?)
}

protocol HeartStatDelegate {
    func didReceiveHeartStatDataResponse(heartStatDataResponse: HeartRateStatResponse?)
    func didReceiveHeartStatDataError(statusCode: String?)
}

protocol WatchHeartStatDelegate {
    func didReceiveWatchHeartStatDataResponse(watchheartStatDataResponse: HeartRateStatResponse?)
    func didReceiveWatchHeartStatDataError(statusCode: String?)
}

struct HeartViewModel {
    
    var delegateHeartPostData: HeartDataPostDelegate?
    var delegateHeartStat: HeartStatDelegate?
    
    
    var delegateWatchHeartPostData: WatchHeartDataPostDelegate?
    var delegateWatchHeartStat: WatchHeartStatDelegate?
    
    //MARK: - Heart Post Data
    func postHeartRateData(heartDataRequest: HeartRateRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postHeartData)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(heartDataRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: HeartRateResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegateHeartPostData?.didReceiveHeartPostDataResponse(heartPostDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegateHeartPostData?.didReceiveHeartPostDataError(statusCode: error)
                    }
                    
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Watch Heart Post Data
    
    func postWatchHeartRateData(heartDataRequest: HeartRateWatchStatRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.addWatchHeartRatePostAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(heartDataRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: HeartRateResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegateWatchHeartPostData?.didReceiveWatchHeartPostDataResponse(WatchheartPostDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegateWatchHeartPostData?.didReceiveWatchHeartPostDataError(statusCode: error)
                    }
                    
                }
            }
                
            } catch let error {
                debugPrint(error.localizedDescription)
            }
    }
    
    
    
    //MARK: - Water Intake Stat
    func postGetHeartStat(heartStatRequest: HeartRateStatRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postHeartStatData)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(heartStatRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: HeartRateStatResponse.self) { (response, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        delegateHeartStat?.didReceiveHeartStatDataResponse(heartStatDataResponse: response)
                    } else {
                        debugPrint(error!)
                        delegateHeartStat?.didReceiveHeartStatDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
