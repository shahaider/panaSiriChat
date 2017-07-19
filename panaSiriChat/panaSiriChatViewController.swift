//
//  panaSiriChatViewController.swift
//  panaSiriChat
//
//  Created by Syed Shahrukh Haider on 18/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import Intents
import MMWormhole

class panaSiriChatViewController: UIViewController {
    @IBOutlet weak var recipientName: UITextField!
    @IBOutlet weak var messageForRecipient: UITextField!
   
    // APP GROUP VARIABLE
    let wormHole = MMWormhole(applicationGroupIdentifier: "group.perception.panasirichat", optionalDirectory: "panasirichat")

    
    // VC VARIABLE
    
    var To = ""
    var Content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // ENABLE SIRI FEATURE WITH THE APP
        INPreferences.requestSiriAuthorization { (Auth) in
            print("SUCCESSFUL")
        }
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // RECIPIENT NAME
        wormHole.listenForMessage(withIdentifier: "toMsg") { (result) in
            if let Whom = result{
            
            self.To = Whom as! String
            }
        }
        
        // CONTENT TEXT
        wormHole.listenForMessage(withIdentifier: "contentMsg") { (result) in
            if let Message = result{
            
            self.Content = Message as! String
            }
        }
        
    }
    
    
    // ACTION ON TOUCH SCREEN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recipientName.text = To
        messageForRecipient.text = Content
    }
    
    
    

    
  
}
