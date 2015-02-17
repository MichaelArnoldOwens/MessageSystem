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
    
    @IBAction func mainToChannel(sender: AnyObject) {
        msgList.user = userNameField.text
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

