//
//  GratitudeViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 11/10/21.
//

import Foundation
import UIKit

protocol GratitudeViewModelDelegate {
    func didReceiveGratitudeDataError(statusCode: String?)
}

protocol GratitudeListDelegate: GratitudeViewModelDelegate {
    func didReceiveGratitudePreviousListResponse(gratitudeGetDataResponse: GratutudeGetListResponse?)
}

protocol GratitudeAddDelegate: GratitudeViewModelDelegate {
    func didReceiveGratitudeCategoryListResponse(gratitudeCategoryResponse: GratitudeCategoryResponse?)
}

protocol GratitudeSaveDelegate: GratitudeViewModelDelegate {
    func didReceiveGratitudeSaveResponse(gratitudeAddResponse: GratitudeAddResponse?)
}

struct GratitudeViewModel {
    var listDelegate: GratitudeListDelegate?
    var addDelegate: GratitudeAddDelegate?
    var saveDelegate: GratitudeSaveDelegate?
    
    //MARK: - Get Gratitude Data
    func getGratitudePreviousDetails(gratitudeRequest: GratitudeGetListRequestModel, token: String) {
        let gratitudeUrl = URL(string: Common.WebserviceAPI.gratitudeDateList)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(gratitudeRequest)
            httpUtility.postApiData(requestUrl: gratitudeUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: GratutudeGetListResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.listDelegate?.didReceiveGratitudePreviousListResponse(gratitudeGetDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.listDelegate?.didReceiveGratitudeDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    //MARK: - Get Add Gratitude Category List
    func getGratitudeCategoryList(token: String) {
        let gratitudeURL = URL(string: Common.WebserviceAPI.gratitudeCategoryListAPI)!
        let httpUtility = HttpUtility()
        httpUtility.postApiData(requestUrl: gratitudeURL, httpMethod: ConstantHttpMethod.PUT, requestBody: nil, token: token, resultType: GratitudeCategoryResponse.self) { (gratitudeCategoryApiResponse, error) in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.addDelegate?.didReceiveGratitudeCategoryListResponse(gratitudeCategoryResponse: gratitudeCategoryApiResponse)
                } else {
                    debugPrint(error!)
                    self.addDelegate?.didReceiveGratitudeDataError(statusCode: error)
                }
                
            }
        }
    }
    
    func saveGratitudeCategory(addGratitudeRequest: GratitudeAddRequest, token: String) {
        let gratitudeURL = URL(string: Common.WebserviceAPI.gratitudeAddNewAPI)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(addGratitudeRequest)
            httpUtility.postApiData(requestUrl: gratitudeURL, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: GratitudeAddResponse.self) { (gratitudeAddApiResponse, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.saveDelegate?.didReceiveGratitudeSaveResponse(gratitudeAddResponse: gratitudeAddApiResponse)
                    } else {
                        debugPrint(error!)
                        self.saveDelegate?.didReceiveGratitudeDataError(statusCode: error)
                    }
                    
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
//    //MARK: - Upload Profile Image
//    func uploadProfileImage(image: Data, token: String) {
//        let profilePictureUrl = URL(string: Common.WebserviceAPI.uploadProfilePictureAPI)!
//        let requestBody = ImageUploadRequestModel(image: image, fileName: ConstantUploadImage.fileName, parameterName: ConstantUploadImage.parameterName)
//        let httpUtility = HttpUtility()
//        httpUtility.uploadImageWithMultipartForm(requestUrl: profilePictureUrl, httpMethod: ConstantHttpMethod.PATCH, requestBody: requestBody, token: token, resultType: ProfileImageResponse.self) { result, error in
//            DispatchQueue.main.async {
//                if (error == nil) {
//                    self.delegate?.didReceiveProfilePictureUploadResponse(profilePictureUploadResponse: result)
//                } else {
//                    debugPrint(error!)
//                    self.delegate?.didReceiveProfileDataError(statusCode: error)
//                }
//
//            }
//        }
//    }
    
}
