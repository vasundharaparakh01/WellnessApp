//
//  NotificationViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-25.
//

import Foundation

protocol NotificationDelegate {
    func didReceiveNotificationGetDataResponse(notificationGetDataResponse: NotificationResponse?)
    func didReceiveNotificationDataError(statusCode: String?)
}

struct NotificationViewModel {
    var delegate : NotificationDelegate?
    
    //MARK: - Get Goal Data
    func getNotificationList(token: String) {
        let url = URL(string: Common.WebserviceAPI.notificationListAPI)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: NotificationResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveNotificationGetDataResponse(notificationGetDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveNotificationDataError(statusCode: error)
                }
            }
        }
    }
}
