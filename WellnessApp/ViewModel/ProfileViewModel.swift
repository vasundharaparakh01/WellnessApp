//
//  ProfileViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 06/10/21.
//

import Foundation
import UIKit

protocol ProfileViewModelDelegate {
    func didReceiveProfileGetDataResponse(profileGetDataResponse: ProfileGetResponse?)
    func didReceiveProfileUpdateResponse(profileUpdateResponse: ProfileUpdateResponse?)
    func didReceiveProfilePictureUploadResponse(profilePictureUploadResponse: ProfileImageResponse?)
    func didReceiveProfileDataError(statusCode: String?)
}

struct ProfileViewModel {
    
    var delegate : ProfileViewModelDelegate?
    //MARK: - Get Profile Data
    func getProfileDetails(token: String) {
        let profileUrl = URL(string: Common.WebserviceAPI.getProfileAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: profileUrl, token: token, resultType: ProfileGetResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveProfileGetDataResponse(profileGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveProfileDataError(statusCode: error)
                }
            }
        }
    }
    //MARK: - Update Profile Data
    func postProfileUpdateData(profileRequest: ProfileUpdateRequest, token: String) {
        let validationResult = ProfileValidation().Validate(profileRequest: profileRequest)
        if (validationResult.success) {
            let profileUrl = URL(string: Common.WebserviceAPI.postProfileUpdateAPI)!
            let httpUtility = HttpUtility()
            do {
                let profilePostBody = try JSONEncoder().encode(profileRequest)
                httpUtility.postApiData(requestUrl: profileUrl, httpMethod: ConstantHttpMethod.PUT, requestBody: profilePostBody, token: token, resultType: ProfileUpdateResponse.self) { (profileApiResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.didReceiveProfileUpdateResponse(profileUpdateResponse: profileApiResponse)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveProfileDataError(statusCode: error)
                        }
                        
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.didReceiveProfileUpdateResponse(profileUpdateResponse: ProfileUpdateResponse(status: nil, message: validationResult.error))
        }
    }
    //MARK: - Upload Profile Image
    func uploadProfileImage(image: Data, token: String) {
        let profilePictureUrl = URL(string: Common.WebserviceAPI.uploadProfilePictureAPI)!
        let requestBody = ImageUploadRequestModel(image: image, fileName: ConstantUploadImage.fileName, parameterName: ConstantUploadImage.parameterName)
        let httpUtility = HttpUtility()
        httpUtility.uploadImageWithMultipartForm(requestUrl: profilePictureUrl, httpMethod: ConstantHttpMethod.PATCH, requestBody: requestBody, token: token, resultType: ProfileImageResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveProfilePictureUploadResponse(profilePictureUploadResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveProfileDataError(statusCode: error)
                }
                
            }
        }
    }
    
}
