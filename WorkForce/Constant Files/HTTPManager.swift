//
//  HTTPManager.swift
//  WorkForce
//
//  Created by apple on 13/10/22.
//

import Foundation

class HttpManager: HTTPURLResponse {
    static public func requestToServer(_ url: String, params: [String:Any], httpMethod: API.HttpMethod, isZipped:Bool, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any],_ data:Data?) -> ()){
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: API.baseUrl + urlString!)!)
        print(request.url?.absoluteString ?? "")
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = 20
        let accessToken = AppDefaults.token ?? ""
        print("accessToken:-  \(accessToken)")
        if accessToken.count > 0 {
            request.setValue("\(accessToken)", forHTTPHeaderField: "Token")
            print("accessToken:- \(accessToken)")
        }
        let body:NSMutableData = NSMutableData()
        let boundary:NSString = "----WebKitFormBoundarycC4YiaUFwM44F6rT"
        if(httpMethod == API.HttpMethod.POST
            || httpMethod == API.HttpMethod.PUT
            || httpMethod == API.HttpMethod.DELETE) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let paramsArray = params.keys
            for item in paramsArray {
                debugPrint("items are ** \(item)")
                body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Disposition: form-data; name=\"\(item)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("\(params[item]!)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
            
            if isZipped == false {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Encoding: gzip")
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        
        request.httpBody = body as Data
        
       
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                
                print("print response is \(response)")
                
                if(response != nil && data != nil) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                            receivedResponse(true, json, data)
                        } else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)    // No error thrown, but not NSDictionary
                            print("Error could not parse JSON: \(jsonStr ?? "")")
                            receivedResponse(false, [:], nil)
                        }
                    } catch let parseError {
                        print(parseError)                                        // Log the error thrown by `JSONObjectWithData`
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr ?? "")'")
                        receivedResponse(false, [:], nil)
                    }
                } else {
                    receivedResponse(false, [:], nil)
                }
            }
        }
        task.resume()
    }

    static public func serverCall(_ url: String, params: [String:Any], httpMethod: API.HttpMethod, isZipped:Bool, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any],_ statusCode:Int) -> ()) {
        
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.requestToServer(url, params: params, httpMethod: httpMethod, isZipped: isZipped) { (success, response, data) in
                if success == true {
                    if let status = response["statusCode"] as? Int {
                        switch(status) {
                        case API.statusCodes.SHOW_DATA:
                            receivedResponse(true, response, status)
                        case API.statusCodes.INVALID_ACCESS_TOKEN:
                            if let message = response["customMessage"] as? String {
                                receivedResponse(true, ["statusCode":status, "customMessage":message], status)
                            } else {
                                receivedResponse(true, ["statusCode":status, "customMessage":"Invaild token"], status)
                            }
//                        case STATUS_CODES.SHOW_MESSAGE:
//                            if let message = response["message"] as? String {
//                                receivedResponse(false, ["statusCode":status, "message":message], status)
//                            } else {
//                                receivedResponse(false, ["statusCode":status, "message":ERROR_MESSAGE.SERVER_NOT_RESPONDING], status)
//                            }
                        default:
                            if let message = response["message"] as? String {
                                receivedResponse(false, ["statusCode":status, "message":message], status)
                            } else {
                                receivedResponse(false, ["statusCode":status, "message":"Something went wrong, please check internet connection."], status)
                            }
                        }
                    } else {
                         receivedResponse(false, ["statusCode":0, "message":"Something went wrong, please check internet connection."], 0)
                    }
                } else {
                    receivedResponse(false, ["statusCode":0, "message":"Something went wrong, please check internet connection."], 0)
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":"Please check your internet connection."], 0)
        }
    }
    
    
    
    static public func uploadingMultipleTask(_ url:String, params: [String:Any], isImage:Bool, dataArray:[PicData]?, imageKey: [String], receivedResponse: @escaping(_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        let boundary:NSString = "----WebKitFormBoundarycC4YiaUFwM44F6rT"
        let body: NSMutableData = NSMutableData()
        let paramsArray = params.keys
        for item in paramsArray {
            body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Disposition: form-data; name=\"\(item)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("\(params[item]!)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        if(isImage) {
            dataArray?.enumerated().forEach({ (index, data) in
                body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Disposition: form-data; name=\"chat_images[\(index)]\"; filename=\"\(data.fileName?.lowercased() ?? "file_name.jpg")\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Type: chat_images/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                
                if data.type == .image {
                    if let data1 = data.image?.jpegData(compressionQuality: 0.5) {
                        body.append(data1)
                        print("data 1 ******  \(data.fileName)", data1.count)
                    } else if let data1 = data.data {
                        body.append(data1)
                        print("data 2 ******  \(data.fileName)", data1.count)
                    }
                } else {
                    if let data1 = data.data {
                        body.append(data1)
                        print("data 3 ******  \(data.fileName)", data1.count)
//                        print("video image uploaded \(data1.count)")
                    }
                }
                body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//                print("Multipart:- ******** \(data.fileName) ********* \(data.data?.count) **** \(imageKey)")
//                if data.type == .video {
//                    body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//                    body.append("Content-Disposition: form-data; name=\"video_thumbnail\"; filename=\"\("thumb_file_name.jpg")\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//                    if let data1 = data.image?.jpegData(compressionQuality: 0.5) {
//                        print("image image uploaded \(data1.count)")
//                        body.append(data1)
//                    }
//                    print("thumb image uploaded")
//                    body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//                }
            })
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request   = URLRequest(url: URL(string: API.imageHost + urlString!)!)
        print(request.url)
        request.httpMethod = "POST"
        request.httpBody = body as Data
        request.timeoutInterval = 60
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let authToken  = AppDefaults.token ?? ""
        if  let accessToken = AppDefaults.token, accessToken.count > 0 {
            request.setValue(accessToken, forHTTPHeaderField: "Token")
            print("access Token ** \(accessToken)")
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if(response != nil) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String:Any] {
                        receivedResponse(true, json, data)
                    } else {
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        // No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(jsonStr ?? "")")
                        receivedResponse(false, [:], nil)
                    }
                } catch let parseError {
                    print(parseError)
                    // Log the error thrown by `JSONObjectWithData`
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: \(jsonStr ?? "")")
                    receivedResponse(false, [:], nil)
                }
            } else {
                receivedResponse(false, [:], nil)
            }
        })
        task.resume()
    }
    
}
