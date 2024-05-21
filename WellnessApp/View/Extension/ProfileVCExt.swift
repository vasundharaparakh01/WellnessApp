//
//  ProfileVCExt.swift
 
//
//  Created by BEASMACUSR02 on 06/10/21.
//

import Foundation

extension ProfileViewController: ProfileViewModelDelegate {
    func getProfileData() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            profileViewModel.getProfileDetails(token: token)
        }
    }
    
    func didReceiveProfileGetDataResponse(profileGetDataResponse: ProfileGetResponse?) {
        self.view.stopActivityIndicator()
        
        if(profileGetDataResponse?.status != nil && profileGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(profileGetDataResponse)
            
            if let bData = profileGetDataResponse?.user_badges {
                badgeData = bData
            }
            profileData = profileGetDataResponse?.result?[0]
            
            do {
                if let userData = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserDetails) {
                    var data = try JSONDecoder().decode(LoginUserDetails.self, from: userData as! Data)
                    
                    if let imgProfile = profileData?.location {
                        data.location = imgProfile
                    }
                    
                    if let username = profileData?.userName {
                        data.userName = username
                    }
                    
                    //Check Readme doc to extract data and Decode from userDefault
                    let dataEncode = try JSONEncoder().encode(data)
                    UserDefaults.standard.set(dataEncode, forKey: ConstantUserDefaultTag.udUserDetails)
//                    print("PROFILE VC Ext--------->",data)
                }
//                //-*-*-*-*-*-*-*-*-*-*-*-*-*-
//                if let userData = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserDetails) {
//                    let data = try JSONDecoder().decode(LoginUserDetails.self, from: userData as! Data)
//                    print("PROFILE VC Ext--------->",data)
//                }
            } catch let error {
                print(error.localizedDescription)
            }
            
            setupUserData()
                        
        } else {
            showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveProfileUpdateResponse(profileUpdateResponse: ProfileUpdateResponse?) {
        self.view.stopActivityIndicator()
        
        if(profileUpdateResponse?.status != nil && profileUpdateResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(profileUpdateResponse)
            
            boolEdit = false
            
            btnEditProfile.setTitle("Edit Profile", for: .normal)
            
            txtFirstName.isUserInteractionEnabled = false
            txtLastName.isUserInteractionEnabled = false
            txtPhone.isUserInteractionEnabled = false
            
            txtFirstName.textColor = .darkGray
            txtLastName.textColor = .darkGray
            txtPhone.textColor = .darkGray
            
            showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: ConstantAlertMessage.ProfileUpdateSuccessful)
            
            getProfileData()
                        
        } else {
            showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: profileUpdateResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveProfilePictureUploadResponse(profilePictureUploadResponse: ProfileImageResponse?) {
        self.view.stopActivityIndicator()
        
        if(profilePictureUploadResponse?.status != nil && profilePictureUploadResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(profilePictureUploadResponse)
                        
            showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: ConstantAlertMessage.ImageUploadSuccessful)
            getProfileData()
            
        } else {
            showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveProfileDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.app_nameAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
