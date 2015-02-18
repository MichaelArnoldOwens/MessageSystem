//
//  MsgObj.swift
//  MessageSystem
//
//  Created by Michael Owens on 2/16/15.
//  Copyright (c) 2015 Michael Owens. All rights reserved.
//

import Foundation
import UIKit



class MsgObj: NSObject {
    var channel = "nonchannel"
    var text = "nonmessage"
    var user = "nonuser"
    
    init(newChannel: String, newUser: String) {
        channel = newChannel
        user = newUser
    }
    
    init(newText: String, newUser: String) {
        text = newText
        user = newUser
    }
}