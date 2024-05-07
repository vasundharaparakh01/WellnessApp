//
//  BlogViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 19/10/21.
//

import Foundation

protocol BlogViewModelDelegate {
    func didReceiveBlogListDataResponse(blogListDataResponse: BlogListResponse?)
    func didReceiveBlogListDataError(statusCode: String?)
}
protocol BlogCommentsViewModelDelegate {
    func didReceiveBlogGetCommentDataResponse(blogGetCommentDataResponse: BlogCommentGetResponse?)
    func didReceiveBlogCommentSendDataResponse(blogCommentSendDataResponse: BlogCommentSendResponse?)
    func didReceiveBlogGetCommentDataError(statusCode: String?)
}

struct BlogViewModel {
    
    var delegate : BlogViewModelDelegate?
    var blogCommentDelegate: BlogCommentsViewModelDelegate?
    
    //MARK: - Get Data
    func getBlogList(token: String) {
        let blogListURL = URL(string: Common.WebserviceAPI.getBlogListAPI)!
        let httpUtility = HttpUtility()
        httpUtility.postApiData(requestUrl: blogListURL, httpMethod: ConstantHttpMethod.PUT, requestBody: nil, token: token, resultType: BlogListResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveBlogListDataResponse(blogListDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveBlogListDataError(statusCode: error)
                }
            }
        }
    }
    
    func getSearchBlogList(token: String, searchText: String) {
        let urlString = Common.WebserviceAPI.searchBlogList + searchText
        guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let meditationURL = URL(string: urlStrings)
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: meditationURL!, token: token, resultType: BlogListResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveBlogListDataResponse(blogListDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveBlogListDataError(statusCode: error)
                }
            }
        }
    }
    
    //MARK: Blog Comments------------
    func getBlogComments(token: String, blogId: String) {
        let urlString = Common.WebserviceAPI.getBlogComments + blogId
        guard let urlStrings = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let URL = URL(string: urlStrings)
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: URL!, token: token, resultType: BlogCommentGetResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.blogCommentDelegate?.didReceiveBlogGetCommentDataResponse(blogGetCommentDataResponse: result)
                } else {
                    debugPrint(error!)
                    self.blogCommentDelegate?.didReceiveBlogGetCommentDataError(statusCode: error)
                }
            }
        }
    }
    
    func sendBlogComment(token: String, commentRequest: BlogCommentSendRequest) {
        let URL = URL(string: Common.WebserviceAPI.postBlogComments)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(commentRequest)
            httpUtility.postApiData(requestUrl: URL, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: BlogCommentSendResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.blogCommentDelegate?.didReceiveBlogCommentSendDataResponse(blogCommentSendDataResponse: result)
                    } else {
                        debugPrint(error!)
                        self.blogCommentDelegate?.didReceiveBlogGetCommentDataError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
