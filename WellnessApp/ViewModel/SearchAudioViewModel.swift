//
//  SearchViewModel.swift
//  Luvo
//
//  Created by Sahidul on 13/12/21.
//

import Foundation

protocol SearchAudioViewModelDelegate {
    func didReceiveMeditationAudioDataResponse(meditationAudioDataResponse: MeditationAudioResponse?)
    func didReceiveMeditationAudioDataError(statusCode: String?)
}

struct SearchAudioViewModel {
    
    var delegate: SearchAudioViewModelDelegate?
    
    //MARK: - Get Data
    func getSearchAudioList(token: String, searchText: String) {
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let urlString = Common.WebserviceAPI.searchAudioList + searchText + "&level=\(chakraLevel)"
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
    
}
