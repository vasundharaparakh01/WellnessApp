//
//  HttpUtility.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

struct HttpUtility {
    //MARK: - GET API Data
    func getApiData<T: Decodable> (requestUrl: URL, token: String?, resultType: T.Type, completionHandler: @escaping(_ result: T?, _ error: String?) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = ConstantHttpMethod.GET
        
        if (token != nil) {
            urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
            if error != nil { //Has error for request
//                if error?._code == -1001 {
                    //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
                _ = completionHandler(nil, "Status: \(error?.localizedDescription ?? ConstantStatusAPI.timeout)")
//                }
            } else {
                let httpResponse = httpUrlResponse as! HTTPURLResponse
                if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    if (error == nil && responseData != nil && responseData?.count != 0) {
                        do {
                            responseData?.printJSON()   ///Print data as JSON format
                            let result = try JSONDecoder().decode(T.self, from: responseData!)
                            _ = completionHandler(result, nil)
                        } catch let error {
                            debugPrint("Error occured while decoding GET - \(error)")
                            _ = completionHandler(nil, "Status: \(error)")
                        }
                    } else if let error = error {
                        debugPrint("HTTP Request Failed \(error)")
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode)")
                    }
                } else {
                    var messageString = ConstantAlertTitle.ErrorAlertTitle
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any] {
                            if let message = json["message"] as? String {
                                messageString = message
                                debugPrint(message)
                            }
                        }
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    } catch {
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    }
                }
            }
        }.resume()
    }
    //----------------------------------------------------------------------------------------------------------------------------
    //MARK: - POST API Data
    func postApiData<T: Decodable>(requestUrl: URL, httpMethod: String, requestBody: Data?, token: String?, resultType: T.Type, completionHandler: @escaping(_ result: T? , _ error: String?) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        if (requestBody != nil) {
            urlRequest.httpBody = requestBody
        }
        if (token != nil) {
            urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if error != nil { //Has error for request
//                if error?._code == -1001 {
                    //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
                _ = completionHandler(nil, "Status: \(error?.localizedDescription ?? ConstantStatusAPI.timeout)")
//                }
            } else {
                let httpResponse = httpUrlResponse as! HTTPURLResponse
                if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    if (data != nil && data?.count != 0) {
                        do {
                            ///dump("API JSON RESPONSE-------\(response)")
                             data?.printJSON()
                            ///Print data as JSON format
                            ///
                            
                            let response = try JSONDecoder().decode(T.self, from: data!)
                            _ = completionHandler(response,nil)
                        } catch let error {
                            debugPrint("Error occured while decoding POST - \(error)")
                            _ = completionHandler(nil, "Status: \(error)")
                        }
                    } else if let error = error {
                        debugPrint("HTTP Request Failed \(error)")
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode)")
                    }
                } else {
                    var messageString = ConstantAlertTitle.ErrorAlertTitle
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let message = json["message"] as? String {
                                messageString = message
                                debugPrint(message)
                            }
                        }
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    } catch {
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    }
                }
            }
        }.resume()
    }
    
    //-----------------------------------------------------------------------------------------------------------------
    //MARK: - Upload image
    func uploadImageWithMultipartForm<T:Decodable>(requestUrl: URL, httpMethod: String, requestBody: ImageUploadRequestModel, token: String?, resultType: T.Type, completionHandler: @escaping(_ result: T? , _ error: String?) -> Void) {
        let boundary = "---------------------------------\(UUID().uuidString)"
        let mimetype = "image/*"
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod
        
        if (token != nil) {
            urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-
        var requestData = Data()

        requestData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        requestData.append("Content-Disposition: form-data; name=\"\(requestBody.parameterName)\"; filename=\"\(requestBody.fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        requestData.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        requestData.append(requestBody.image)
        requestData.append("\r\n".data(using: String.Encoding.utf8)!)
        requestData.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        //-=-=-=-=-=-=-=-=-=-=-=-=-=-
        
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData

//        let multipartStr = String(decoding: requestData, as: UTF8.self) //to view the multipart form string

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if error != nil { //Has error for request
//                if error?._code == -1001 {
                    //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
                _ = completionHandler(nil, "Status: \(error?.localizedDescription ?? ConstantStatusAPI.timeout)")
//                }
            } else {
                let httpResponse = httpUrlResponse as! HTTPURLResponse
                if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    if (data != nil && data?.count != 0) {
                        do {
                            ///dump("API JSON RESPONSE-------\(response)")
                            data?.printJSON()   ///Print data as JSON format
                            let response = try JSONDecoder().decode(T.self, from: data!)
                            _ = completionHandler(response,nil)
                        } catch let error {
                            debugPrint("Error occured while decoding POST - \(error.localizedDescription)")
                            _ = completionHandler(nil, "Status: \(error.localizedDescription)")
                        }
                    } else if let error = error {
                        debugPrint("HTTP Request Failed \(error)")
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode)")
                    }
                } else {
                    var messageString = ConstantAlertTitle.ErrorAlertTitle
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let message = json["message"] as? String {
                                messageString = message
                                debugPrint(message)
                            }
                        }
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    } catch {
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    }
                }
            }
        }.resume()

    }
    
    
    //MARK: Media Upload with Parameters
    func uploadMediaWithDataMultipartForm<T:Decodable>(requestUrl: URL, httpMethod: String, requestMediaBody: AudioUploadRequest, requestSleepBody: SleepUploadRequest,  formParam: [String: Data]?, token: String?, resultType: T.Type, completionHandler: @escaping(_ result: T? , _ error: String?) -> Void) {
        let mimeTypeAudio = "audio/*"
        let mimeTypeText = "text/*"
        let boundary = generateBoundary()
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        if (token != nil) {
            request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
//        var parameters = [String : Data]()
//        if let sleepData = requestMediaBody.sleep_data, let sleep = requestMediaBody.sleep {
//            parameters = ["sleep_data": sleepData, "sleep": sleep]
//        }

        guard let mediaAudio = Media(withMedia: requestMediaBody.audio!,
                                     paramName: requestMediaBody.parameterName!,
                                     mimeType: mimeTypeAudio,
                                     fileType: requestMediaBody.fileType!) else { return }
        
        guard let sleepFile = Media(withMedia: requestSleepBody.sleepData!,
                                     paramName: requestSleepBody.parameterName!,
                                     mimeType: mimeTypeText,
                                     fileType: requestSleepBody.fileType!) else { return }
        

        let dataBody = createDataBody(withParameters: formParam, media: [sleepFile], boundary: boundary)
        
        request.httpBody = dataBody

        let session = URLSession.shared
        session.uploadTask(with: request, from: dataBody, completionHandler: { (data, httpUrlResponse, error) in
            if error != nil { //Has error for request
//                if error?._code == -1001 {
                    //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
                _ = completionHandler(nil, "Status: \(error?.localizedDescription ?? ConstantStatusAPI.timeout)")
//                }
            } else {
                let httpResponse = httpUrlResponse as! HTTPURLResponse
                if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    if (data != nil && data?.count != 0) {
                        do {
                            ///dump("API JSON RESPONSE-------\(response)")
                            data?.printJSON()   ///Print data as JSON format
                            let response = try JSONDecoder().decode(T.self, from: data!)
                            _ = completionHandler(response,nil)
                        } catch let error {
                            debugPrint("Error occured while decoding POST - \(error.localizedDescription)")
                            _ = completionHandler(nil, "Status: \(error.localizedDescription)")
                        }
                    } else if let error = error {
                        debugPrint("HTTP Request Failed \(error)")
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode)")
                    }
                } else {
                    var messageString = ConstantAlertTitle.ErrorAlertTitle
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let message = json["message"] as? String {
                                messageString = message
                                debugPrint(message)
                            }
                        }
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    } catch {
                        _ = completionHandler(nil, "Status: \(httpResponse.statusCode). \(messageString)")
                    }
                }
            }
        }).resume()
    }
    func generateBoundary() -> String {
        return "----------\(UUID().uuidString)"
    }

    func createDataBody(withParameters params: [String: Data]?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.appendString("\(lineBreak)--\(boundary + lineBreak)")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append(value)
            }
        }
        
        if let media = media {
            for assets in media {
                body.appendString("\(lineBreak)--\(boundary + lineBreak)")
                body.appendString("Content-Disposition: form-data; name=\"\(assets.paramName)\"; filename=\"\(assets.fileName)\"\(lineBreak)")
                body.appendString("Content-Type: \(assets.mimeType + lineBreak + lineBreak)")
                body.append(assets.mediaData)
            }
        }

        body.appendString("\(lineBreak)--\(boundary)--\(lineBreak)")

//        let multipartStr = String(decoding: body, as: UTF8.self) //to view the multipart form string
//        print(multipartStr)

        return body
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct Media {
    let paramName: String
    let fileName: String
    let mediaData: Data
    let mimeType: String

    init?(withMedia media: Data, paramName key: String, mimeType: String, fileType: String) {
        self.paramName = key
        self.mimeType = mimeType
        self.fileName = "\(arc4random()).\(fileType)"
        self.mediaData = media
    }
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/*
    func uploadMediaWithDataMultipartForm<T:Decodable>(requestUrl: URL, httpMethod: String, requestMediaBody: SleepRequest, token: String?, resultType: T.Type, completionHandler: @escaping(_ result: T? , _ error: String?) -> Void) { //requestNativeImageUpload(image: UIImage, orderExtId: String) {

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        print("\n\ncomplete Url :-------------- ",requestUrl)
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod

        if (token != nil) {
            request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }

        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")

        var data = Data()

        if let sleepData = requestMediaBody.sleep_data {
            // Add the reqtype field and its value to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"sleep_data\"\r\n\r\n".data(using: .utf8)!)
            data.append(sleepData)
        }

        if let sleep = requestMediaBody.sleep {
            // Add the reqtype field and its value to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"sleep\"\r\n\r\n".data(using: .utf8)!)
            data.append(sleep)
        }

        if let music = requestMediaBody.music {
            // Add the media data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(music.parameterName)\"; filename=\"\(music.fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: audio/*\r\n\r\n".data(using: .utf8)!)
            data.append(music.audio)
        }

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        let multipartStr = String(decoding: data, as: UTF8.self) //to view the multipart form string
        print(multipartStr)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in

            if let response = response {
                print(response)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }).resume()
    }
}

extension Data {
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
*/*/
