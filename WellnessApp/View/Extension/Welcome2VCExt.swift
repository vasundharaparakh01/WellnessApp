//
//  Welcome2VCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/09/21.
//

import Foundation
import UIKit

extension Welcome2ViewController: Welcome2ViewModelDelegate {
    func getQuestionData() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            welcome2ViewModel.getQuestion(token: token)
        }
    }
    
    func saveAnswer() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            guard let ansID = tempAnswerModel?.answerId else { return }
            guard let quesID = tempAnswerModel?.questionId else { return }
            guard let ans = tempAnswerModel?.answer else { return }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            
            let request = Welcome2AnswerRequest(questionId: quesID, answerId: ansID, answer: ans)
            welcome2ViewModel.saveAnswer(request: request, token: token)
        }
    }
    
    func didReceiveWelcome2QuestionResponse(welcome2QuestionResponse: Welcome2QuestionResponse?) {
        self.view.stopActivityIndicator()
        
        if(welcome2QuestionResponse?.status != nil && welcome2QuestionResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(welcome2QuestionResponse)
            
            setupQuestionData(data: welcome2QuestionResponse)
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: welcome2QuestionResponse?.error ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveWelcome2QuestionError(statusCode: String?) {
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func didReceiveWelcome2AnswerResponse(welcome2AnswerResponse: Welcome2AnswerResponse?) {
        self.view.stopActivityIndicator()
        
        if(welcome2AnswerResponse?.status != nil && welcome2AnswerResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(welcome2AnswerResponse)
            
            self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                         message: welcome2AnswerResponse?.message ?? ConstantStatusAPI.success,
                                         alertStyle: .alert,
                                         actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                         actionStyles: [.default],
                                         actions: [
                                            {_ in
                                                let mythVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "WelcomeMythFactViewController") as! WelcomeMythFactViewController
                                                self.navigationController?.pushViewController(mythVC, animated: true)
                                            }
                                         ])
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: welcome2AnswerResponse?.error ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveWelcome2AnswerError(statusCode: String?) {
        self.view.stopActivityIndicator()
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
}
