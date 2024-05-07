//
//  MeditationAudioViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 23/10/21.
//

import Foundation

protocol MeditationAudioViewModelDelegate {
    func didReceiveMeditationAudioDataResponse(meditationAudioDataResponse: MeditationAudioResponse?)
    func didReceiveMeditationAudioDataError(statusCode: String?)
}
protocol MeditationAudioCompleteViewModelDelegate {
    func didReceiveAudioCompleteDataResponse(audioCompleteDataResponse: AudioListenCompletedResponse?)
    func didReceiveAudioCompleteDataError(statusCode: String?)
}
protocol MeditationAudioComplete5minViewModelDelegate {
    func didReceiveAudioComplete5minDataResponse(audioComplete5minDataResponse: AudioListen5minResponse?)
    func didReceiveAudioComplete5minDataError(statusCode: String?)
}

protocol MeditationAudioUnlockViewModelDelegate {
    func didReceiveAudioUnlockDataResponse(audioUnlockDataResponse: AudioUnlockResponse?)
    func didReceiveAudioUnlockDataError(statusCode: String?)
}

protocol MeditationAudioCheckViewModelDelegate {
    func didReceiveAudioCheckDataResponse(audioCheckDataResponse: MeditationAudioCheckResponse?)
    func didReceiveAudioCheckDataError(statusCode: String?)
}

struct MeditationAudioViewModel {
    
    var delegate : MeditationAudioViewModelDelegate?
    var delegateAudioComplete: MeditationAudioCompleteViewModelDelegate?
    var delegateAudioComplete5min: MeditationAudioComplete5minViewModelDelegate?
    var delegateAudioUnlock: MeditationAudioUnlockViewModelDelegate?
    var delegateAudioCheck: MeditationAudioCheckViewModelDelegate?
    
//    let urlString = Common.WebserviceAPI.searchAudioList + searchText + "&level=\(chakraLevel)"
//    guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//    let meditationURL = URL(string: urlStrings)
    
    //MARK: - Audio Check
    //MARK: - Get Data
    func getMeditationAudioCheck(meditationAudioRequest: MeditationAPIRequest, token: String) {
        let urlString = Common.WebserviceAPI.getExerciseCheck + "meditationId=\( meditationAudioRequest.meditationId ?? "")&chakraId=\(meditationAudioRequest.chakraId ?? "")&exerciseId=\(meditationAudioRequest.exerciseId ?? "")"
        guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let meditationURL = URL(string: urlStrings)
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: meditationURL!, token: token, resultType: MeditationAudioCheckResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegateAudioCheck?.didReceiveAudioCheckDataResponse(audioCheckDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegateAudioCheck?.didReceiveAudioCheckDataError(statusCode: error)
                }
            }
        }
    }
    
    //MARK: - Get Data
    func getMeditationAudioList(meditationAudioRequest: MeditationAPIRequest, token: String) {
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let urlString = Common.WebserviceAPI.getMeditationAudioAPI + "?meditationId=\( meditationAudioRequest.meditationId ?? "")&chakraId=\(meditationAudioRequest.chakraId ?? "")&exerciseId=\(meditationAudioRequest.exerciseId ?? "")&level=\(chakraLevel)"
        guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let meditationURL = URL(string: urlStrings)
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: meditationURL!, token: token, resultType: MeditationAudioResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveMeditationAudioDataResponse(meditationAudioDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveMeditationAudioDataError(statusCode: error)
                }
            }
        }
    }
    
    //MARK: - Audio Completed
    func postAudioComplete(audioCompleteRequest: AudioListenCompletedRequest, token: String) {
        let audioCompleteUrl = URL(string: Common.WebserviceAPI.postAudioCompleted)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(audioCompleteRequest)
            httpUtility.postApiData(requestUrl: audioCompleteUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: AudioListenCompletedResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegateAudioComplete?.didReceiveAudioCompleteDataResponse(audioCompleteDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegateAudioComplete?.didReceiveAudioCompleteDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Audio Completed 5 min
    func postAudioComplete5min(audioCompleteRequest: AudioListen5minRequest, token: String) {
        let audioCompleteUrl = URL(string: Common.WebserviceAPI.postListenAudioFiveMin)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(audioCompleteRequest)
            httpUtility.postApiData(requestUrl: audioCompleteUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: AudioListen5minResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegateAudioComplete5min?.didReceiveAudioComplete5minDataResponse(audioComplete5minDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegateAudioComplete5min?.didReceiveAudioComplete5minDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Audio Unlock
    func postAudioUnlock(audioUnlockRequest: AudioUnlockRequest, token: String) {
        let audioCompleteUrl = URL(string: Common.WebserviceAPI.postMusicUnlock)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(audioUnlockRequest)
            httpUtility.postApiData(requestUrl: audioCompleteUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: AudioUnlockResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegateAudioUnlock?.didReceiveAudioUnlockDataResponse(audioUnlockDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegateAudioUnlock?.didReceiveAudioUnlockDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
