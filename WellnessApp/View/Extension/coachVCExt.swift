//
//  coachVCExt.swift
//  Luvo
//
//  Created by BEASiMAC on 22/11/22.
//

import Foundation
import UIKit
import SDWebImage

extension CoachViewController
{
    
    
    func getData(dateSelected : String) {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            debugPrint("token--->",token)
            
            //Get previous date
            let previousDate = Date.yesterday
//            debugPrint("home previous date--->",previousDate)
//            let convertDateFormatter = DateFormatter()
//            convertDateFormatter.timeZone = TimeZone.current
//            convertDateFormatter.dateFormat = "yyyy-MM-dd"
//            let formatDate = convertDateFormatter.string(from: previousDate)
//            debugPrint("home formatDate--->",formatDate)
            
            let formatDate = Date().formatDate(date: previousDate)
         //   let request = CoachRequest(date: formatDate)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
          
            
            
//            let status = UserDefaults.standard.bool(forKey: "isFromWatch")
//            print(status)
//            if status==true
//            {
//            print("second phase")
            
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
            let todayDate = dateFormatter.string(from: selectedDate)
            
            print(dateSelected)
                
            CoachViewModel.getCoachData(token: token, date: dateSelected)
//            }
//            else
//            {
//               // homeViewModel.getHomeData(token: token, date: formatDate, device_cat: "?device_cat=mobile")
//            }
        }
    }
}
