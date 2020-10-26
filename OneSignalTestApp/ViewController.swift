//
//  ViewController.swift
//  OneSignalTestApp
//
//  Created by Пархоменко Алексей on 26.10.2020.
//

import UIKit
import OneSignal



class ViewController: UIViewController {
    
    var object: Any?
    
    @IBOutlet weak var myTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
//        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
//        let userID = status.subscriptionStatus.userId
//        print("userID = \(userID)")
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViewWithPushBodyByAction), name: notificationOpened, object: nil)
        
        
    }
    
    @objc func updateTextViewWithPushBodyByAction(notification: Notification) {
        
        if let payload: OSNotificationPayload = (notification.object as? OSNotificationPayload) {
            if let abc = payload.additionalData["abc"] {
                myTextView.text = "Action: \(abc)"
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("1")
        OneSignal.postNotification([
                                    "contents": ["en": "\(myTextView.text)"],
                                    "data": ["abc": "123", "foo": "bar"],
                                    "include_player_ids": ["a6ad3f9b-50d3-40ea-9e1c-7e4b49ee5990"]])
    }
    
}

