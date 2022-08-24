//
//  ChatModel.swift
//  CoWorkerUser
//
//  Created by Rakesh Kumar on 04/05/18.
//  Copyright © 2018 SevenSkyLander. All rights reserved.
//

import UIKit

class ChatAPIName: NSObject {    
    var chatId:String?
    var message_id:String?
    var page_size: Int = 20
}


class ChatModel: NSObject, Codable {
    var message: String?
    var data: Chats?
    var statusCode: Int?
}

class Chats: Codable {
    var chats:[MessageData]?
}

class MessageData: Codable {
    var message, message_id: String?
    var sender: String?
    var room_id, sent_date, status: String?

    init(message:String, chatId:String?, sender:String? ) {
        self.message = message
        self.room_id = chatId
        self.sender = sender
    }
}
