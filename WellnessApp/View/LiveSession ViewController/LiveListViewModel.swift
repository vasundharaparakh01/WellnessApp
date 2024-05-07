//
//  LiveListViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 09/12/22.
//

import Foundation

protocol LiveListViewModelDelegate
{
    
    func didReceiveLiveListResponse(ListResponse: LiveListViewResponse?)
    func didReceiveLiveListError(statusCode: String?)
}

struct LiveListViewModel
{
    
    var ListLivedelegate: LiveListViewModelDelegate?
    
    func getLiveDetails(token: String, catagoryId:String, sessionName:String)
    {
        let url1 = Common.WebserviceAPI.GetliveSessiondetailsAPI+"catId=\(catagoryId)&sessionName=\(sessionName)"
       // let url1 = Common.WebserviceAPI.GetliveSessiondetailsAPI+catagoryId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: LiveListViewResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.ListLivedelegate?.didReceiveLiveListResponse(ListResponse: result)
                } else {
                    debugPrint(error!)
                    self.ListLivedelegate?.didReceiveLiveListError(statusCode: error)
                }
            }
        }
    }
}
