//
//  coachViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 22/11/22.
//

import Foundation
protocol CoachViewModelDelegate {
    func didReceiveCoachResponse(coachResponse: CoachResponse?)
    func didReceiveCoachError(statusCode: String?)
}

struct coachViewModel
{
    var delegate : CoachViewModelDelegate?
    
    
    func getCoachData(token: String, date: String) {

        let url1 = Common.WebserviceAPI.coachDashboardAPI+date
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: CoachResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveCoachResponse(coachResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveCoachError(statusCode: error)
                }
            }
        }
    }
    
//    func postCoachData(date: CoachRequest, token: String) {
//        let url = URL(string: Common.WebserviceAPI.getHomeDataAPI)!
//        let httpUtility = HttpUtility()
//        do {
//            let postBody = try JSONEncoder().encode(date)
//            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: CoachResponse.self) { (result, error) in
//                DispatchQueue.main.async {
//                    if (error == nil) {
//                        self.delegate?.didReceiveHomeResponse(coachResponse: result)
//                    } else {
//                        debugPrint(error!)
//                        self.delegate?.didReceiveHomeError(statusCode: error)
//                    }
//                }
//            }
//        } catch let error {
//            debugPrint(error.localizedDescription)
//        }
//    }
}
