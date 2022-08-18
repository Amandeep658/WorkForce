//
//  ChatVM.swift
//
//  Created by apple on 21/04/22.
//

import Foundation


class ChatVM: NSObject {

    static func getAllMessages()-> [MessageData] {
////        let my = UserData()
//            my.name = "Archana"
//        my.photo = ""
//        my.user_id = "123"
//
////        let other = UserData()
//        other.name = "Naina"
//        other.photo = "img1"
        
        
        let messege:[MessageData] = [
            MessageData(message: "Hello", chatId: "chat_id", sender: "other", type: .text),
            MessageData(message: "Hi archana", chatId: "chat_id", sender: "my", type: .text),
            MessageData(message: "Hii naina", chatId: "chat_id", sender: "other", type: .text),
            MessageData(message: "how are you ", chatId: "chat_id", sender: "my", type: .text),
            MessageData(message: "fine and hows you", chatId: "chat_id", sender: "other", type: .text),
            MessageData(message: "i also fine", chatId: "chat_id", sender: "my", type: .text),
            MessageData(message: "what are you doing? thtrhrt thrthtrhy gfhtrhtr fghrth grty thrt", chatId: "chat_id", sender: "other", type: .text),
            MessageData(message: "nothing", chatId: "chat_id", sender: "my", type: .text)
        ]
        
        return messege
    }
    
}
