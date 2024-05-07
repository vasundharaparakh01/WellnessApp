//
//  SettingsViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-17.
//

import Foundation

protocol SettingNotificationDelegate {
    func didReceiveSettingNotificationGetDataResponse(settingGetDataResponse: SettingNotificationGetResponse?)
    func didReceiveSettingNotificationSetDataResponse(settingSetDataResponse: SettingNotificationSetResponse?)
    func didReceiveSettingDataError(statusCode: String?)
}

struct SettingsViewModel {
    
    var settingNotificationDelegate : SettingNotificationDelegate?
    
    //MARK: - Get Goal Data
    func getSettingNotification(token: String) {
        let url = URL(string: Common.WebserviceAPI.getSettingNotification)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: SettingNotificationGetResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.settingNotificationDelegate?.didReceiveSettingNotificationGetDataResponse(settingGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.settingNotificationDelegate?.didReceiveSettingDataError(statusCode: error)
                }
            }
        }
    }
    
    //MARK: - Set Goal Data
    func setSettingNotification(token: String, Url: String) {
        let url = URL(string: Url)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: SettingNotificationSetResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.settingNotificationDelegate?.didReceiveSettingNotificationSetDataResponse(settingSetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.settingNotificationDelegate?.didReceiveSettingDataError(statusCode: error)
                }
            }
        }
    }
}
