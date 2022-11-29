//
//  ApiHandler.swift
//  WorkForce
//
//  Created by apple on 13/10/22.
//

import Foundation

class ApiHandler {

static public func uploadImage(apiName:String, dataArray:[PicData]?,  imageKey:[String], params: [String : Any]?, isImage:Bool = true, receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
    if IJReachability.isConnectedToNetwork() == true {
        HttpManager.uploadingMultipleTask(apiName, params: params!, isImage: isImage, dataArray:dataArray,  imageKey: imageKey) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                print(response)
                if(isSucceeded) {
                    if let status = response["status"] as? Int {
                        switch(status) {
                        case 1:
                            receivedResponse(true, response, data)
                        case API.statusCodes.INVALID_ACCESS_TOKEN:
                            print("Its wrong")
                            appDel.navigation()
                            receivedResponse(false, [:], nil)
                        default:
                            if let message = response["message"] as? String {
                                receivedResponse(false, ["statusCode":status, "message":message], nil)
                            } else {
                                receivedResponse(false, ["statusCode":status, "message":"Something went wrong"], nil)
                            }
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0,"message":"Something went wrong"], nil)
                    }
                } else {
                    receivedResponse(false, ["statusCode":0, "message":"Something went wrong"],nil)
                }
            }
        }
    } else {
        receivedResponse(false, ["statusCode":0, "message":"Something went wrong, please check your internet connection"], nil)
    }
}
}

class DataDecoder: NSObject {
    
    class func decodeData<T>(_ data: Data?, type: T.Type) -> T? where T : Decodable {
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(type.self, from: data)
            print("decodedData:-\(decodedData) **** \(data.count)")
            return decodedData
        } catch {
            print("error***** \(error)")
            return nil
        }
    }
}
