//
//  AppDelegate.swift
//  OneSignalTestApp
//
//  Created by Пархоменко Алексей on 26.10.2020.
//

import UIKit
import OneSignal

let notificationOpened = Notification.Name("com.alexeyParkhomenko.notificationOpened")
let notificationReceived = Notification.Name("com.alexeyParkhomenko.notificationReceived")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("!!! application")
        //Remove this method to stop OneSignal Debugging
//        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            // Вызывается когда доходит сообщение
              print("Received Notification: \(notification!.payload)")
            
            NotificationCenter.default.post(name: notificationReceived, object: notification!.payload)
           }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
              // Вызывается когда приложение открывается от нажатия на пуш
              let payload: OSNotificationPayload = result!.notification.payload

              var fullMessage = payload.body
              print("Message = \(fullMessage)")

              if payload.additionalData != nil {
                 if payload.title != nil {
                    let messageTitle = payload.title
                       print("Message Title = \(messageTitle!)")
                 }

                 let additionalData = payload.additionalData
                 if additionalData?["actionSelected"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonID: \(additionalData!["actionSelected"])"
                 }
              }
            
            NotificationCenter.default.post(name: notificationOpened, object: payload)
           }
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

           OneSignal.initWithLaunchOptions(launchOptions,
              appId: "6c25e530-ca90-4e83-bcce-202a415cc6e7",
              handleNotificationReceived: notificationReceivedBlock,
              handleNotificationAction: notificationOpenedBlock,
              settings: onesignalInitSettings)
        
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}



