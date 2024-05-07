//
//  LikesViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 24/12/21.
//

import Foundation

protocol LikesViewModelDelegate {
    func didReceiveLikesDataResponse(likesDataResponse: LikesResponse?)
    func didReceiveLikesDataError(statusCode: String?)
}

struct LikesViewModel {
    var delegate: LikesViewModelDelegate?
    
    //MARK: Add like Data--------------
    func addToLike(likeRequest: LikesRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.postLike)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(likeRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: LikesResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveLikesDataResponse(likesDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveLikesDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Delete from favourite Data
    func deleteFromLike(likeRequest: LikesRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.deleteLike)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(likeRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.DELETE, requestBody: requestBody, token: token, resultType: LikesResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveLikesDataResponse(likesDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveLikesDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
