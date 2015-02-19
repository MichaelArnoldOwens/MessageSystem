//
//  ChatViewController.swift
//  MessageSystem
//
//  Created by Michael Owens on 2/17/15.
//  Copyright (c) 2015 Michael Owens. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var timer : NSTimer? //timer to be used to refresh table view for new messages

    var messages = [] as Array <MsgObj> //used to populate table view
    
    var channelName: String! //channel will not change unless going back to previous view
    var userName: String?   //user is set from first view
    
    let baseUrl = "http://tradecraftmessagehub.com/sample/" //base url

    @IBOutlet weak var userInputTextField: UITextField!
    
    @IBAction func sendButtonPushed(sender: AnyObject) {
        
        if(userInputTextField != nil) {
            var message = MsgObj(newChannel: channelName, newUser: userName!)
            message.text = userInputTextField.text
            self.messages.insert(message, atIndex: 0) //adds the message to the front of the messages array
           postMessage(userInputTextField.text) //POST to server
            chatTable.reloadData() //refresh the table
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //a timer that sends GET request every 0.2 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "getMessages", userInfo: nil, repeats: true)

    }

    //A UITableView called chatTable that will display messages
    @IBOutlet weak var chatTable: UITableView!
    
    
    //MARK: DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as UITableViewCell
        
        let message = self.messages[messages.count-(indexPath.row+1)] //displays newest messages in the table in descending order (newest==>oldest)
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
   
    //MARK: GET Methods
    
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
    
    
    //GET
    func getMessages() {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = "GET"
        
        request.URL = NSURL(string: "\(baseUrl)\(channelName)")
        
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
    
    //MARK: Post Methods
    
    //converts the dictionary that holds message data into NSData
    func bodyDataForMessageDictionary(messageDictionary: Dictionary<String,String>) -> NSData {
        var possibleSerializationErrorContainer: NSError?
        var data = NSJSONSerialization.dataWithJSONObject(messageDictionary, options: nil, error: &possibleSerializationErrorContainer)
        
        return data!
    }

    //returns the NSData to be used for body message
    func bodyForMessage(message: MsgObj) -> NSData {
        let messageAPIDictionary = dictionaryForMessage(message)
        let postBodyData = bodyDataForMessageDictionary(messageAPIDictionary)
        return postBodyData
    }
    
    //converts MsgObj into a dictionary <String,String> to be used to create JSON body
    func dictionaryForMessage(message: MsgObj) -> Dictionary<String,String> {
        
        let dictionary = [
        "user_name": "\(userName)",
        "message_text": userInputTextField.text!
        ]
        return dictionary
    }
    
    //POST
    func postMessage(messageText: String) {
        
        var session = NSURLSession.sharedSession()
        
        let newMessage = MsgObj(newText: messageText, newUser: self.userName!)
        let bodyData = self.bodyForMessage(newMessage)
        
        //building my POST request
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: "\(baseUrl)\(channelName)")
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
      
        var task = session.dataTaskWithRequest(request)
        task.resume()
    }
}
