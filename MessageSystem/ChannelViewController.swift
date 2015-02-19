//
//  ChannelViewController.swift
//  MessageSystem
//
//  Created by Michael Owens on 2/17/15.
//  Copyright (c) 2015 Michael Owens. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var channelTextField: UITextField!
    
    var userName: String?

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         //userName(input from previous view) and channelName(input from user on current view) are passed to next view
        if(segue.identifier == "channelToChat"){
            let destinationChatViewController = segue.destinationViewController as ChatViewController
            destinationChatViewController.channelName = channelTextField.text
            destinationChatViewController.userName = userName

        }
    }
    
    //unwind from ChatViewController
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue){
    }

}
