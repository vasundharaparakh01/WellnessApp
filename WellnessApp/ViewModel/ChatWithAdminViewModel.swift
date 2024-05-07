//
//  ChatWithAdminViewModel.swift
//  Luvo
//
//  Created by Sahidul on 24/12/21.
//

import Foundation

protocol ChatWithAdminViewModelDelegate {
    func didReceiveMessagesDataResponse(chatDataResponse: ChatWithAdminResponse?)
    func didReceiveMessagesDataError(statusCode: String?)
    
    func disReceiveSendMessageResponse(profileUpdateResponse: ProfileUpdateResponse?)
}

struct DateFormats {
    static let dateFormatForChatTime = "h:mm a"
    static let dateFormatForChatDate = "dd MMM, yyyy"
}

struct Sections {
    var title: String
    var messageArray: [[Message]]?
}

struct ChatWithAdminViewModel {
    
    var delegate: ChatWithAdminViewModelDelegate?
    
    //MARK: - Get Data
    func getMessagesList(token: String) {
        let urlString = Common.WebserviceAPI.messageList
        let meditationURL = URL(string: urlString)
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: meditationURL!, token: token, resultType: ChatWithAdminResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveMessagesDataResponse(chatDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveMessagesDataError(statusCode: error)
                }
            }
        }
    }
    
    func sendMessageText(messageRequest: ChatSendRequest, token: String) {
        let validationResult = chatValidate(messageRequest: messageRequest)
        if (validationResult.success) {
            let messageUrl = URL(string: Common.WebserviceAPI.messageList)!
            let httpUtility = HttpUtility()
            do {
                let messagePostBody = try JSONEncoder().encode(messageRequest)
                httpUtility.postApiData(requestUrl: messageUrl, httpMethod: ConstantHttpMethod.POST, requestBody: messagePostBody, token: token, resultType: ProfileUpdateResponse.self) { (messageSendResponse, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.delegate?.disReceiveSendMessageResponse(profileUpdateResponse: messageSendResponse)
                        } else {
                            debugPrint(error!)
                            self.delegate?.didReceiveMessagesDataError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        } else {
            self.delegate?.disReceiveSendMessageResponse(profileUpdateResponse: ProfileUpdateResponse(status: nil, message: validationResult.error))
        }
    }
    
    func sendMessageImage(messageRequest: ChatSendRequest, token: String) {
        let profilePictureUrl = URL(string: Common.WebserviceAPI.messageList)!
        let requestBody = ImageUploadRequestModel(image: messageRequest.image!, fileName: ConstantUploadImage.fileName, parameterName: ConstantUploadImage.parameterName)
        let httpUtility = HttpUtility()
        httpUtility.uploadImageWithMultipartForm(requestUrl: profilePictureUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: ProfileUpdateResponse.self) { messageSendResponse, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.disReceiveSendMessageResponse(profileUpdateResponse: messageSendResponse)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveMessagesDataError(statusCode: error)
                }
                
            }
        }
    }
    
    func chatValidate(messageRequest: ChatSendRequest) -> ValidationResult {
        if (messageRequest.message!.isEmpty) {
            return ValidationResult(success: false, error: ConstantTextfieldAlertTitle.gratitudeOtherEmpty)
        }
        return ValidationResult(success: true, error: nil)
    }
    
    func convertDateToStringFormat(dateString: String, format: String) -> String {
        let date = Date().UTCFormatter(date: dateString)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.dateFormat = format
        return  dateFormatter2.string(from: date)
    }
    
    func convertCurrentDateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        let formatDate = dateFormatter.string(from: Date())
        return formatDate
    }
    
    func getChatWithSection(chatArray: [Message]) -> [[Message]]? {
        var prevInitial: String? = nil
        var result: [[Message]] = []
        for items in chatArray {
            let sendTime = items.addDate ?? "2021-12-21T09:22:10.000Z"
            let initial = convertDateToStringFormat(dateString: sendTime, format: DateFormats.dateFormatForChatDate)
            if initial != prevInitial {  // We're starting a new letter
                result.append([])
                prevInitial = initial
            }
            result[result.endIndex - 1].append(items)
        }
        return result
    }
}

