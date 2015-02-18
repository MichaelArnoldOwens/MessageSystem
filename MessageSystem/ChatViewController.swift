//
//  ChatViewController.swift
//  MessageSystem
//
//  Created by Michael Owens on 2/17/15.
//  Copyright (c) 2015 Michael Owens. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var messages = [] as Array <MsgObj>
    var channelName: String!
    var userName: String?

    @IBOutlet weak var userInputTextField: UITextField!
    
    @IBAction func sendButton(sender: AnyObject) {
        var message = MsgObj(newChannel: channelName, newUser: userName!)
        message.text = userInputTextField.text
        messages.append(message)
        chatTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMessages()

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
    
    @IBOutlet weak var chatTable: UITableView!
    
    
    //MARK: DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as UITableViewCell
        
        let message = self.messages[indexPath.row]
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = "\(channelName)/<\(message.user)> :\(message.text)"

        return cell
    }
    
    //MARK: Networking
    
    
    //alert if not connected/server issue/bad info
    func alertWithError(error : NSError) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
    //Response data from server and gives messages in form of Array
    func messagesFromNetworkResponseData(responseData : NSData) -> Array<MsgObj>? {
        var serializationError : NSError?
        let messageAPIDictionaries = NSJSONSerialization.JSONObjectWithData(
            responseData,
            options: nil,
            error: &serializationError
            ) as Array<Dictionary<String, String>>
        
        if let serializationError = serializationError {
            alertWithError(serializationError)
            return nil
        }
        
        var messages = messageAPIDictionaries.map({ (messageAPIDictionary) -> MsgObj in
            
            let messageText = messageAPIDictionary["message_text"]!
            let userName = messageAPIDictionary["user_name"]!
            return MsgObj(newText: messageText, newUser: userName)
        })
        
        return messages
    }
    
    func getMessages() {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = "GET"
        
        request.URL = NSURL(string: "http://tradecraftmessagehub.com/sample/\(channelName)")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                if let error = error {
                    self.alertWithError(error)
                } else if let messages = self.messagesFromNetworkResponseData(data) {
                    self.messages = messages
                    self.chatTable.reloadData()
                }
            }
        })
        
        task.resume()
    }
    



}
