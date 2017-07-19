//
//  IntentHandler.swift
//  panaSiri
//
//  Created by Syed Shahrukh Haider on 18/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import Intents
import Foundation
import MMWormhole



class IntentHandler: INExtension,INSendMessageIntentHandling  {

    
      let wormHole = MMWormhole(applicationGroupIdentifier: "group.perception.panasirichat", optionalDirectory: "panasirichat")
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
    
    
    /*
     
     PHASE 1 : Resolve
     
     
     
     */
    
    
    // ***************** STEP 1 *********************
    
    
    // Retrieving RECIPIENT

    
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        
        
        // Checking Siri understand  User Desire Recipient Name
        if let recipients  = intent.recipients{
            
            
            // IF "CANNOT" UNDERSTAND RECIPIENT NAME
            if recipients.count == 0{
            
            completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            // IF SIRI RETRIEVE SOME DETAIL
            var resolutionResult = [INPersonResolutionResult]()

            for recipient in recipients{
            
                let matchContacts = [recipient]
                
                switch matchContacts.count {
                    
                    // DISAMBIGUATION (MULTI RESULT)
                case 2 ... Int.max:
                resolutionResult = [INPersonResolutionResult.disambiguation(with: matchContacts)]
                    
                    // ABLE TO GET SINGLE RESULT
                case 1:
                    resolutionResult = [INPersonResolutionResult.success(with: recipient)]
                    // UNSUPPORTED
                case 0:
                    resolutionResult = [INPersonResolutionResult.unsupported()]
                default:
                    break
                }
            
            }
            
            completion(resolutionResult)
            
        }
    }
    
    
    // ***************** STEP 2 *********************

    
    // Retrieving CONTENT
    
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
        
        completion(INStringResolutionResult.success(with: text))
        }
        else{
        
        completion(INStringResolutionResult.needsValue())
        }
    }
    
    
    /*
     
     PHASE 2 : CONFIRM  (CHECK USER AUTHENTICATION STATUS)
     
     */
    
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        
        let userAct = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userAct)
        completion(response)
    }
    
    /*
     
     Handle

     */
    
    
    
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        if intent.recipients != nil && intent.content != nil
    // SEND MESSAGE
        {
        
let userAct = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
            
let response = INSendMessageIntentResponse(code: .success, userActivity: userAct)
            
            
            // FORWARD RESPONSE TO CHAT VC : TEXTFIELD
            if let msgContent = intent.content{
                if let msgTo = intent.recipients{
                    let toMsg = msgTo.first?.displayName
                    wormHole.passMessageObject("\(toMsg)" as NSString, identifier: "toMsg")
                    wormHole.passMessageObject("\(msgContent)" as NSString, identifier: "contentMsg")
                
                }
            }
            
            
completion(response)
        
        
        }
    }
    
    
//    
//    // MARK: - INSearchForMessagesIntentHandling
//    
//    func handle(searchForMessages intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
//        // Implement your application logic to find a message that matches the information in the intent.
//        
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
//        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
//        // Initialize with found message's attributes
//        response.messages = [INMessage(
//            identifier: "identifier",
//            content: "I am so excited about SiriKit!",
//            dateSent: Date(),
//            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
//            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
//            )]
//        completion(response)
//    }
    
    // MARK: - INSetMessageAttributeIntentHandling
//    
//    func handle(setMessageAttribute intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
//        // Implement your application logic to set the message attribute here.
//        
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
//        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
//        completion(response)
//    }
}

