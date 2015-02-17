//
//  MsgObj.swift
//  MessageSystem
//
//  Created by Michael Owens on 2/16/15.
//  Copyright (c) 2015 Michael Owens. All rights reserved.
//

import Foundation
import UIKit

var msgList: MsgObj = MsgObj()

struct message {
    var message = "nonmessage"
}

class MsgObj: NSObject {
    var user = "nonuser"
    var channel = "nonchannel"

    var Messages = [message]()
    func addMessage(name: String, desc: String){
        Messages.append(message(message: desc))
    }
    
}