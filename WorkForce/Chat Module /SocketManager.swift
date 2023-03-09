//
//  SocketManger.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 15/07/22.
//

import Foundation
import SocketIO

class SocketManger {
static let shared = SocketManger()
//http://161.97.132.85:3020/
//http://jaohar-uk.herokuapp.com:80
    let manager = SocketManager(socketURL: URL(string: "http://161.97.132.85:3020")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    init() {
        socket = manager.defaultSocket
    }
    func connect() {
        socket.connect()
    }
    func disconnect() {
        socket.disconnect()
    }
    func onConnect(handler: @escaping () -> Void) {
        socket.on("connect") { (_, _) in
            handler()
        }
    }
    
    func handleNewChatMessage(handler: @escaping (_ message: [String:Any]?,_ time:Int?) -> Void) {
        socket.on("newMessage") { (data, ack) in
            print("data------>",data[1])
            let dataDict = data[1] as? [String:Any] ?? [:]
            if dataDict.isEmpty == true{
                if let dict = data[1] as? String{
                    let ds = self.convertToDictionary(text: dict) ?? [:]
                    handler(ds,nil)
                }
                else{
                    let time = data[1] as? Int
                    handler(nil,time)
                }
            }else{
                let msg = data[1] as? [String:Any] ?? [:]
                handler(msg,nil)
            }
        }
    }
    
    
    func handleJoinedMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        socket.on("ChatStatus") { (data, ack) in
            print(data[1])
            let msg = data[1] as! [String: Any]
            handler(msg)
        }
    }
    
    func handleUserTyping(handler: @escaping (_ trueIndex: Int) -> Void) {
        socket.on("type") { (data, ack) in
            let trueIndex = data[1] as? Int
            handler(trueIndex!)
        }
    }
    func handleUserStopTyping(handler: @escaping () -> Void) {
        socket.on("userStopTyping") { (_, _) in
            handler()
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
