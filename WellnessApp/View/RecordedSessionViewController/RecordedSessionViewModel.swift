//
//  RecordedSessionViewModel.swift
//  Luvo
//
//  Created by BEASiMAC on 13/12/22.
//

import Foundation

protocol RecordedSessionViewModelDelegate
{
    
    func didReceiveRecordedSessionResponse(RecordedResponse: RecordedSessionResponse?)
    func didReceiveRecordedSessionError(statusCode: String?)
}


struct RecordedSessionViewModel

{
    var Recordeddelegate: RecordedSessionViewModelDelegate?
    
    func getRecordDetails(token: String, catagoryId:String, sessionName:String)
    {

        let url1 = Common.WebserviceAPI.RecoredeSessionList+"category_id=\(catagoryId)&sessionName=\(sessionName)"

       // let url1 = Common.WebserviceAPI.RecoredeSessionList+catagoryId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: RecordedSessionResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.Recordeddelegate?.didReceiveRecordedSessionResponse(RecordedResponse: result)
                } else {
                    debugPrint(error!)
                    self.Recordeddelegate?.didReceiveRecordedSessionError(statusCode: error)
                }
            }
        }
    }
}
