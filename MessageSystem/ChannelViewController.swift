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
    
    var user: String?

    //userName(input from previous view) and channelName(input from user on current view) are passed to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "channelToChat"){
            let destinationChatViewController = segue.destinationViewController as ChatViewController
            destinationChatViewController.channelName = channelTextField.text
            destinationChatViewController.userName = user

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
