//
//  FavouritesViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 27/10/21.
//

import Foundation

protocol FavouritesViewModelDelegate {
    func didReceiveFavouriteDataResponse(favouriteDataResponse: FavouritesResponse?)
    func didReceiveFavouriteDataError(statusCode: String?)
}
protocol FavouritesListViewModelDelegate {
    func didReceiveFavouriteListDataResponse(favouriteListDataResponse: MeditationAudioResponse?)
    func didReceiveFavouriteListDataError(statusCode: String?)
}

struct FavouritesViewModel {
    var delegate: FavouritesViewModelDelegate?
    var favListDelegate : FavouritesListViewModelDelegate?
    
    //MARK: - Add to favourite Data
    func addToFavourite(favRequest: FavouritesRequest, token: String) {
        let favUrl = URL(string: Common.WebserviceAPI.addToFavourites)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(favRequest)
            httpUtility.postApiData(requestUrl: favUrl, httpMethod: ConstantHttpMethod.POST, requestBody: requestBody, token: token, resultType: FavouritesResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveFavouriteDataResponse(favouriteDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveFavouriteDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Delete from favourite Data
    func deleteFromFavourite(favRequest: FavouritesRequest, token: String) {
        let favUrl = URL(string: Common.WebserviceAPI.addToFavourites)!
        let httpUtility = HttpUtility()
        do {
            let requestBody = try JSONEncoder().encode(favRequest)
            httpUtility.postApiData(requestUrl: favUrl, httpMethod: ConstantHttpMethod.DELETE, requestBody: requestBody, token: token, resultType: FavouritesResponse.self) { result, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.delegate?.didReceiveFavouriteDataResponse(favouriteDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.delegate?.didReceiveFavouriteDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: ---- Favourites Get Listing
    func getFavouriteList(token: String) {
        let chakraLevel = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraLevel) as? Int ?? 1
        let urlString = Common.WebserviceAPI.favList + "\(chakraLevel)"
        guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlStrings)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: url, token: token, resultType: MeditationAudioResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.favListDelegate?.didReceiveFavouriteListDataResponse(favouriteListDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.favListDelegate?.didReceiveFavouriteListDataError(statusCode: error)
                }
            }
        }
    }
}
