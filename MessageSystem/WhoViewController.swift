//
//  ViewController.swift
//  MessageSystem
//
//  Created by Michael Owens on 2/16/15.
//  Copyright (c) 2015 Michael Owens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {



  
    @IBOutlet weak var userNameField: UITextField!
    
    //input from user (user) is passed to the next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "whoToChannel"){
            let destinationChatViewController = segue.destinationViewController as ChannelViewController
            destinationChatViewController.userName = userNameField.text
        }
    }
}

